/* Copyright (c) 2010 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "OAuthViewControllerTouch.h"
#import "OAuthStore.h"
#import "GTMOAuthAuthentication.h"
#import "GTMOAuthViewControllerTouch.h"
#import "Constants.h"
#import <RestKit/RestKit.h>

static NSString *const kShouldSaveInKeychainKey = @"shouldSaveInKeychain";
static NSString *const kKeychainItemName = @"Testflix";


@interface OAuthViewControllerTouch()
- (void)viewController:(GTMOAuthViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuthAuthentication *)auth
                 error:(NSError *)error;
- (void)incrementNetworkActivity:(NSNotification *)notify;
- (void)decrementNetworkActivity:(NSNotification *)notify;
- (void)signInNetworkLostOrFound:(NSNotification *)notify;
- (void)doAnAuthenticatedAPIFetch;
- (BOOL)shouldSaveInKeychain;
@end

@implementation OAuthViewControllerTouch

@synthesize serviceSegments = mServiceSegments;
@synthesize shouldSaveInKeychainSwitch = mShouldSaveInKeychainSwitch;
@synthesize signInOutButton = mSignInOutButton;
@synthesize emailField = mEmailField;
@synthesize tokenField = mTokenField;
@synthesize navController = _navController;
@synthesize mCurrentOperation = _mCurrentOperation;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)awakeFromNib {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(incrementNetworkActivity:) name:kGTMOAuthFetchStarted object:nil];
    [nc addObserver:self selector:@selector(decrementNetworkActivity:) name:kGTMOAuthFetchStopped object:nil];
    [nc addObserver:self selector:@selector(signInNetworkLostOrFound:) name:kGTMOAuthNetworkLost  object:nil];
    [nc addObserver:self selector:@selector(signInNetworkLostOrFound:) name:kGTMOAuthNetworkFound object:nil];
    
    // Get the saved authentication, if any, from the keychain.
    //
    // The view controller supports methods for saving and restoring
    // authentication under arbitrary keychain item names; see the
    // "keychainForName" methods in the interface.  The keychain item
    // names are up to the application, and may reflect multiple accounts for
    // one or more services.
    //
    
    // Perhaps we have a saved authorization; try getting
    // that from the keychain
    GTMOAuthAuthentication *auth = [[OAuthStore sharedSingleton] gtmoAuthAuthentication];
    if (auth) {
        BOOL didAuth = [GTMOAuthViewControllerTouch authorizeFromKeychainForName:kKeychainItemName
                                                                  authentication:auth];
        if (didAuth) {
            // Select the index
            [mServiceSegments setSelectedSegmentIndex:1];
        }
    }
    
    // save the authentication object, which holds the auth tokens
    [self setAuthentication:auth];
    
    BOOL isRemembering = [self shouldSaveInKeychain];
    [mShouldSaveInKeychainSwitch setOn:isRemembering];
    [self updateUI];
}

- (void)dealloc {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
    [mSignInOutButton release];
    [mShouldSaveInKeychainSwitch release];
    [mServiceSegments release];
    [mEmailField release];
    [mTokenField release];
    [mAuth release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
    // Returns non-zero on iPad, but backward compatible to SDKs earlier than 3.2.
    if (UI_USER_INTERFACE_IDIOM()) {
        return YES;
    }
    return [super shouldAutorotateToInterfaceOrientation:orientation];
}

- (BOOL)isSignedIn {
    BOOL isSignedIn = [mAuth canAuthorize];
    return isSignedIn;
}

- (IBAction)signInOutClicked:(id)sender {
    if (![self isSignedIn]) {
        // sign in
        [self signIn];
    } else {
        // sign out
        [self signOut];
    }
    [self updateUI];
}

// UISwitch does the toggling for us. We just need to read the state.
- (IBAction)toggleShouldSaveInKeychain:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:[sender isOn]
                                            forKey:kShouldSaveInKeychainKey];
}

- (void)signOut {
    // remove the stored  authentication from the keychain, if any
    [GTMOAuthViewControllerTouch removeParamsFromKeychainForName:kKeychainItemName];
    
    // Discard our retained authentication object.
    [self setAuthentication:nil];
    
    [self updateUI];
}

- (void)signInForOperation:(SEL)theOperation {
    [self setMCurrentOperation:theOperation];
    [self signIn];
}

- (void)signIn {
    
    [self signOut];
    
    NSURL *requestURL = [NSURL URLWithString:[[OAuthStore sharedSingleton] requestURL]];
    NSURL *accessURL = [NSURL URLWithString:[[OAuthStore sharedSingleton] accessURL]];
    NSURL *authorizeURL = [NSURL URLWithString:[[OAuthStore sharedSingleton] authorizeURL]];
    NSString *scope = [[OAuthStore sharedSingleton] baseURL];  
    
    GTMOAuthAuthentication *auth = [[OAuthStore sharedSingleton] gtmoAuthAuthentication];
    if (auth == nil) {
        // perhaps display something friendlier in the UI?
        NSAssert(NO, @"A valid consumer key and consumer secret are required for signing in.");
    }
    
    // set the callback URL to which the site should redirect, and for which
    // the OAuth controller should look to determine when sign-in has
    // finished or been canceled
    //
    // This URL does not need to be for an actual web page; it will not be
    // loaded
    [auth setCallback:@"testflix://goBack"];
    
    NSString *keychainItemName = nil;
    if ([self shouldSaveInKeychain]) {
        keychainItemName = kKeychainItemName;
    }
    
    // Display the authentication view.
    GTMOAuthViewControllerTouch *viewController;
    viewController = [[[GTMOAuthViewControllerTouch alloc] initWithScope:scope
                                                                language:nil
                                                         requestTokenURL:requestURL
                                                       authorizeTokenURL:authorizeURL
                                                          accessTokenURL:accessURL
                                                          authentication:auth
                                                          appServiceName:keychainItemName
                                                                delegate:self
                                                        finishedSelector:@selector(viewController:finishedWithAuth:error:)] autorelease];
    
    // We can set a URL for deleting the cookies after sign-in so the next time
    // the user signs in, the browser does not assume the user is already signed
    // in
    [viewController setBrowserCookiesURL:[NSURL URLWithString: scope]];
    
    // You can set the title of the navigationItem of the controller here, if you want.
    [[self navController] pushViewController:viewController animated:YES];
    [self setNavController: nil];
    //[[self navigationController] pushViewController:viewController animated:YES];
}

- (void)viewController:(GTMOAuthViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuthAuthentication *)auth
                 error:(NSError *)error {
    if (error != nil) {
        // Authentication failed (perhaps the user denied access, or closed the
        // window before granting access)
        NSLog(@"Authentication error: %@", error);
        NSData *responseData = [[error userInfo] objectForKey:@"data"]; // kGTMHTTPFetcherStatusDataKey
        if ([responseData length] > 0) {
            // show the body of the server's authentication failure response
            NSString *str = [[[NSString alloc] initWithData:responseData
                                                   encoding:NSUTF8StringEncoding] autorelease];
            NSLog(@"%@", str);
        }
        
        [self setAuthentication:nil];
    } else {
        // Authentication succeeded
        //
        // At this point, we either use the authentication object to explicitly
        // authorize requests, like
        //
        //   [auth authorizeRequest:myNSURLMutableRequest]
        //
        // or store the authentication object into a GTM service object like
        //
        //   [[self contactService] setAuthorizer:auth];
        
        // save the authentication object
        [self setAuthentication:auth];
        
        // Just to prove we're signed in, we'll attempt an authenticated fetch for the
        // signed-in user
        //[self doAnAuthenticatedAPIFetch];
        
        RKObjectManager *objectManager = [RKObjectManager sharedManager];
        objectManager.client.OAuth1AccessToken= auth.accessToken;
        objectManager.client.OAuth1AccessTokenSecret = auth.tokenSecret;
        
        NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
        [userInfo setObject: [NSValue valueWithPointer:[self mCurrentOperation]] forKey:OPERATION_KEY];
        
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:OAuthAuthenticationSucceededNotification object:self userInfo:userInfo];
        
    }
    
    [self updateUI];
}

- (void)doAnAuthenticatedAPIFetch {
    //  status feed
    NSString *urlStr = @"http://api-public.netflix.com/catalog/titles";
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [mAuth authorizeRequest:request];
    
    GTMHTTPFetcher* myFetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    [myFetcher beginFetchWithDelegate:self
                    didFinishSelector:@selector(authenticatedFetcher:finishedWithData:error:)];
    
    // Note that for a request with a body, such as a POST or PUT request, the
    // library will include the body data when signing only if the request has
    // the proper content type header:
    //
    //   [request setValue:@"application/x-www-form-urlencoded"
    //  forHTTPHeaderField:@"Content-Type"];
    
    // Synchronous fetches like this are a really bad idea in Cocoa applications
    //
    // For a very easy async alternative, we could use GTMHTTPFetcher
    /*NSError *error = nil;
    NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];*/

}

- (void)authenticatedFetcher:(GTMHTTPFetcher *)fetcher
 finishedWithData:(NSData *)retrievedData
            error:(NSError *)error {
    // if error is not nil, the fetch succeeded
    if (retrievedData) {
        // API fetch succeeded
        NSString *str = [[[NSString alloc] initWithData:retrievedData
                                               encoding:NSUTF8StringEncoding] autorelease];
        NSLog(@"API response: %@", str);
    } else {
        // fetch failed
        NSLog(@"API fetch error: %@", error);
    }
}

#pragma mark -

- (void)incrementNetworkActivity:(NSNotification *)notify {
    ++mNetworkActivityCounter;
    if (1 == mNetworkActivityCounter) {
        UIApplication *app = [UIApplication sharedApplication];
        [app setNetworkActivityIndicatorVisible:YES];
    }
}

- (void)decrementNetworkActivity:(NSNotification *)notify {
    --mNetworkActivityCounter;
    if (0 == mNetworkActivityCounter) {
        UIApplication *app = [UIApplication sharedApplication];
        [app setNetworkActivityIndicatorVisible:NO];
    }
}

- (void)signInNetworkLostOrFound:(NSNotification *)notify {
    if ([[notify name] isEqual:kGTMOAuthNetworkLost]) {
        // network connection was lost; alert the user, or dismiss
        // the sign-in view with
        //   [[[notify object] delegate] cancelSigningIn];
    } else {
        // network connection was found again
    }
}

#pragma mark -

- (void)updateUI {
    // update the text showing the signed-in state and the button title
    // A real program would use NSLocalizedString() for strings shown to the user.
    if ([self isSignedIn]) {
        // signed in
        NSString *email = [mAuth userEmail];
        NSString *token = [mAuth token];
        
        [mEmailField setText:email];
        [mTokenField setText:token];
        [mSignInOutButton setTitle:@"Sign Out"];
    } else {
        // signed out
        [mEmailField setText:@"Not signed in"];
        [mTokenField setText:@"No authorization token"];
        [mSignInOutButton setTitle:@"Sign In..."];
    }
    BOOL isRemembering = [self shouldSaveInKeychain];
    [mShouldSaveInKeychainSwitch setOn:isRemembering];
}

- (void)setAuthentication:(GTMOAuthAuthentication *)auth {
    [mAuth autorelease];
    mAuth = [auth retain];
}

- (BOOL)shouldSaveInKeychain {
    //return [[NSUserDefaults standardUserDefaults] boolForKey:kShouldSaveInKeychainKey];
    return NO;
}

@end

