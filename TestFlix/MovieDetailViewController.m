//
//  MovieDetailViewController.m
//  TestFlix
//
//  Created by Joshua Palermo on 10/9/12.
//  Copyright (c) 2012 Joshua Palermo. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "NetflixLoginViewController.h"
#import <RestKit/RestKit.h>
#import "OAuthViewControllerTouch.h"
#import "Constants.h"
#import "OAuthStore.h"

@interface MovieDetailViewController ()

@end

@implementation MovieDetailViewController

@synthesize movieBoxArtImageView = _movieBoxArtImageView;
@synthesize movieTitleLabel = _movieTitleLabel;
@synthesize movieSynopsisTextView = _movieSynopsisTextView;
@synthesize movieSynopsisWebView = _movieSynopsisWebView;
@synthesize catalogTitle = _catalogTitle;
@synthesize removeDvdButton = _removeDvdButton;
@synthesize addDvdButton = _addDvdButton;
@synthesize removeInstantButton = _removeInstantButton;
@synthesize addInstantButton = _addInstantButton;
@synthesize playButton = _playButton;
@synthesize oauthViewControllerTouch = _oauthViewControllerTouch;
@synthesize activityIndicator = _activityIndicator;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oAuthAuthenticationSucceeded:) name:OAuthAuthenticationSucceededNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkActivityStarted:) name:AsynchronousAuthenticatedAPIFetchStartedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkActivityStopped:) name:AsynchronousAuthenticatedAPIFetchStoppedNotification object:nil];

    }
    return self;
}

- (void)networkActivityStarted:(NSNotification *)notify {
    [[self activityIndicator] startAnimating];
}

- (void)networkActivityStopped:(NSNotification *)notify {
    [[self activityIndicator] stopAnimating];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void) oAuthAuthenticationSucceeded:(NSNotification *) notification
{
    NSDictionary* userInfo = [notification userInfo];
    SEL operation = [[userInfo objectForKey: OPERATION_KEY] pointerValue];
    NSLog (@"Successfully received the auth notification!");
    
    if([self respondsToSelector:operation]) {
        //[self performSelector:operation withObject: nil];
    }
}

-(NSString *) stripTagsFrom:(NSString *)aString
{
    NSRange r;
    while ((r = [aString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        aString = [aString stringByReplacingCharactersInRange:r withString:@""];
    return aString;
}

- (void)viewDidAppear:(BOOL)animated
{
    // TODO: Nil check the synopsis and formats!
    
    [super viewDidAppear:animated];

    if([self oauthViewControllerTouch] == nil) {
        [self setOauthViewControllerTouch: [[OAuthViewControllerTouch alloc] init]];
        [[self oauthViewControllerTouch] awakeFromNib];
    }

    [[self movieTitleLabel] setNumberOfLines: 0];
    [[self movieTitleLabel] setText:[[self catalogTitle] regularTitle]];
    [self.movieTitleLabel sizeToFit];

    [[self movieSynopsisTextView] setText:[[self catalogTitle] synopsis]];
    [self.movieSynopsisTextView sizeToFit];
    [self.movieSynopsisWebView loadHTMLString: [self stripTagsFrom: self.catalogTitle.synopsis] baseURL:nil];
    UIImageView *movieBoxArtImageView = [self movieBoxArtImageView];
    

   // [self.movieSynopsisWebView loadHTMLString:synopsisText baseURL: nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, NULL), ^{
        NSData *imageData = [NSData dataWithContentsOfURL: self.catalogTitle.largeBoxArtUrl];
        dispatch_async(dispatch_get_main_queue(), ^{
            //Maybe correct the frame too
            //[self.view addSubview:imageView];
            UIImage *image = [UIImage imageWithData:imageData];
            [movieBoxArtImageView setImage: image];
        });
    });
    
    [[self movieSynopsisWebView] setDelegate: self];
    
    [[self addInstantButton] setHidden: ![[[self catalogTitle] instantFormat] boolValue]];
    [[self removeInstantButton] setHidden: ![[[self catalogTitle] instantFormat] boolValue]];
    [[self playButton] setHidden: ![[[self catalogTitle] instantFormat] boolValue]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"NetflixLoginViewControllerSegue"]){
        
        NetflixLoginViewController *nlvc = (NetflixLoginViewController *)[segue destinationViewController];
        
        // delegate stuff?
    }
}

-(IBAction)addDvdButtonPressed:(id)sender
{
    NSLog(@"addDvdButtonPressed Pressed!");
    if([[self oauthViewControllerTouch]checkAuthorizationForOperation:@selector(addDvdButtonPressed:) forOperationController: self withNavController:[self navigationController]]) {

        NSString *currentUserStr = [[self oauthViewControllerTouch ]getCurrentUser];
        NSMutableString *queueStrUrl = [[NSMutableString alloc] initWithString:@"http://api-public.netflix.com/users/"];
        [queueStrUrl appendString:currentUserStr];
        [queueStrUrl appendString:@"/queues/disc?title_ref="];
        [queueStrUrl appendString: [[[[self catalogTitle] titleIdUrl] absoluteString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ];

        [[self oauthViewControllerTouch] doAsynchronousAuthenticatedAPIFetchAt:[NSURL URLWithString: queueStrUrl] withHTTPMethod: @"POST"];
    }
}

-(IBAction)removeDvdButtonPressed:(id)sender
{
    NSLog(@"removeDvdButtonPressed Pressed!");
    if([[self oauthViewControllerTouch ]checkAuthorizationForOperation:@selector(removeDvdButtonPressed:) forOperationController: self withNavController: [self navigationController]]) {
        
        NSString *currentUserStr = [[self oauthViewControllerTouch]getCurrentUser];
        NSMutableString *queueStrUrl = [[NSMutableString alloc] initWithString:@"http://api-public.netflix.com/users/"];
        [queueStrUrl appendString:currentUserStr];
        [queueStrUrl appendString:@"/queues/disc/available/"];
        [queueStrUrl appendString: [[[[self catalogTitle] titleIdUrl] lastPathComponent] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ];
        
        [[self oauthViewControllerTouch] doAsynchronousAuthenticatedAPIFetchAt:[NSURL URLWithString: queueStrUrl] withHTTPMethod: @"DELETE"];
    }
}

-(IBAction)addInstantButtonPressed:(id)sender
{
    NSLog(@"addInstantButtonPressed Pressed!");
    if([[self oauthViewControllerTouch] checkAuthorizationForOperation:@selector(addInstantButtonPressed:) forOperationController: self withNavController: [self navigationController]]) {
        
        NSString *currentUserStr = [[self oauthViewControllerTouch] getCurrentUser];
        NSMutableString *queueStrUrl = [[NSMutableString alloc] initWithString:@"http://api-public.netflix.com/users/"];
        [queueStrUrl appendString:currentUserStr];
        [queueStrUrl appendString:@"/queues/instant?title_ref="];
        [queueStrUrl appendString: [[[[self catalogTitle] titleIdUrl] absoluteString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ];
        
        [[self oauthViewControllerTouch] doAsynchronousAuthenticatedAPIFetchAt:[NSURL URLWithString: queueStrUrl] withHTTPMethod: @"POST"];
    }
}

-(IBAction)removeInstantButtonPressed:(id)sender
{
    NSLog(@"removeInstantButton Pressed!");
    if([[self oauthViewControllerTouch] checkAuthorizationForOperation:@selector(removeInstantButtonPressed:) forOperationController: self withNavController:[self navigationController]]) {
        
        NSString *currentUserStr = [[self oauthViewControllerTouch] getCurrentUser];
        NSMutableString *queueStrUrl = [[NSMutableString alloc] initWithString:@"http://api-public.netflix.com/users/"];
        [queueStrUrl appendString:currentUserStr];
        [queueStrUrl appendString:@"/queues/instant/available/"];
        [queueStrUrl appendString: [[[[self catalogTitle] titleIdUrl] lastPathComponent] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ];
        
        [[self oauthViewControllerTouch] doAsynchronousAuthenticatedAPIFetchAt:[NSURL URLWithString: queueStrUrl] withHTTPMethod: @"DELETE"];
    }
}


-(IBAction)playButtonPressed:(id)sender {
    NSLog(@"playButton Pressed!");
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{
    if ([request isGET]) {
        // Handling GET /foo.xml
        
        if ([response isOK]) {
            // Success! Let's take a look at the data
            NSLog(@"Retrieved XML: %@", [response bodyAsString]);
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
    /* open an alert with an OK button */
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"There seems to be a problem connecting to netflix!"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setMovieBoxArtImageView:nil];
    [self setMovieTitleLabel:nil];
    [self setRemoveDvdButton:nil];
    [self setAddDvdButton:nil];
    [self setRemoveInstantButton:nil];
    [self setAddInstantButton:nil];
    [self setPlayButton:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}
@end
