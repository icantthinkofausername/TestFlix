//
//  NetflixLoginViewController.m
//  TestFlix
//
//  Created by Joshua Palermo on 12/30/12.
//  Copyright (c) 2012 Joshua Palermo. All rights reserved.
//

#import "NetflixLoginViewController.h"
#import <RestKit/RestKit.h>

@interface NetflixLoginViewController ()
@end

@implementation NetflixLoginViewController
@synthesize oauthToken = _oauthToken;
@synthesize applicationName = _applicationName;
@synthesize loginWebView = _loginWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    NSMutableString *searchUrl = [[NSMutableString alloc] initWithString:@"/oauth/request_token"];
    [objectManager loadObjectsAtResourcePath:searchUrl  delegate:self];
    self.loginWebView.delegate = self;
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{
    if ([request isGET]) {
        // Handling GET /foo.xml
        
        if ([response isOK]) {
            // Success! Let's take a look at the data
            NSLog(@"Retrieved XML: %@", [response bodyAsString]);
            NSMutableDictionary *queryParams = [[NSMutableDictionary alloc] init];
            NSArray *components = [[response bodyAsString] componentsSeparatedByString:@"&"];
            
            for (NSString *component in components) {
                NSArray *pair = [component componentsSeparatedByString:@"="];
                
                [queryParams setObject:[[pair objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding: NSMacOSRomanStringEncoding]
                                forKey:[pair objectAtIndex:0]];
            }
            
            self.oauthToken = [queryParams objectForKey:@"oauth_token"];
            self.applicationName = [queryParams objectForKey:@"application_name"];
            NSMutableString *loginUrlString = [[NSMutableString alloc] initWithString:@"https://api-user.netflix.com/oauth/login?application_name="];
            [loginUrlString appendString: self.applicationName];
            [loginUrlString appendString: @"&oauth_callback=testflix%3A%2F%2FgoBack"];
            [loginUrlString appendString: @"&oauth_consumer_key="];
            [loginUrlString appendString: [RKObjectManager sharedManager].client.OAuth1ConsumerKey];
            [loginUrlString appendString: @"&oauth_token="];
            [loginUrlString appendString: self.oauthToken];
            
            NSLog(@"Login URL String: %@", loginUrlString);
            
            //Create a URL object.
            NSURL *url = [NSURL URLWithString:loginUrlString];
            
            //URL Requst Object
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
            
            //Load the request in the UIWebView.
            [self.loginWebView loadRequest:requestObj];
        }
        
    } else if ([request isPOST]) {
        
        // Handling POST /other.json
        if ([response isJSON]) {
            NSLog(@"Got a JSON response back from our POST!");
        }
        
    } else if ([request isDELETE]) {
        
        // Handling DELETE /missing_resource.txt
        if ([response isNotFound]) {
            NSLog(@"The resource path '%@' was not found.", [request resourcePath]);
        }
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects
{
    RKLogInfo(@"Load collection of Articles: %@", objects);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Encountered an error: %@", error);
    
    // should display an alert here, but have to ignore that plain text parsing error
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLoginWebView:nil];
    [super viewDidUnload];
}

#pragma mark - Web view delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.scheme isEqualToString:@"testflix"]) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    return YES;
}
@end
