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

@interface MovieDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *movieBoxArtImageView;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *movieSynopsisTextView;
@property (weak, nonatomic) IBOutlet UIWebView *movieSynopsisWebView;
@property (weak, nonatomic) IBOutlet UIButton *removeDvdButton;
@property (weak, nonatomic) IBOutlet UIButton *addDvdButton;
@property (weak, nonatomic) IBOutlet UIButton *removeInstantButton;
@property (weak, nonatomic) IBOutlet UIButton *addInstantButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet OAuthViewControllerTouch *oauthViewControllerTouch;

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


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSString *) stripTagsFrom:(NSString *)aString
{
    NSRange r;
    while ((r = [aString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        aString = [aString stringByReplacingCharactersInRange:r withString:@""];
    return aString;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.movieTitleLabel.numberOfLines = 0;
    self.movieTitleLabel.text = self.catalogTitle.regularTitle;
    [self.movieTitleLabel sizeToFit];
    
    self.movieSynopsisTextView.text = self.catalogTitle.synopsis;
    [self.movieSynopsisTextView sizeToFit];
    [self.movieSynopsisWebView loadHTMLString: [self stripTagsFrom: self.catalogTitle.synopsis] baseURL:nil];


   // [self.movieSynopsisWebView loadHTMLString:synopsisText baseURL: nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, NULL), ^{
        NSData *imageData = [NSData dataWithContentsOfURL: self.catalogTitle.largeBoxArtUrl];
        dispatch_async(dispatch_get_main_queue(), ^{
            //Maybe correct the frame too
            //[self.view addSubview:imageView];
            UIImage *image = [UIImage imageWithData:imageData];
            self.movieBoxArtImageView.image = image;
        });
    });
    
    self.movieSynopsisWebView.delegate = self;
    
    [self.addInstantButton setHidden: ![self.catalogTitle.instantFormat boolValue]];
    [self.removeInstantButton setHidden: ![self.catalogTitle.instantFormat boolValue]];
    [self.playButton setHidden: ![self.catalogTitle.instantFormat boolValue]];
    
    //listen for clicks
    [self.addDvdButton addTarget:self action:@selector(addDvdButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.removeDvdButton addTarget:self action:@selector(removeDvdButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.addInstantButton addTarget:self action:@selector(addInstantButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.removeInstantButton addTarget:self action:@selector(removeInstantButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.playButton addTarget:self action:@selector(playButtonPressed) forControlEvents:UIControlEventTouchUpInside];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"NetflixLoginViewControllerSegue"]){
        
        NetflixLoginViewController *nlvc = (NetflixLoginViewController *)[segue destinationViewController];
        
        // delegate stuff?
    }
}

-(void)checkAuthorization
{
    self.oauthViewControllerTouch.navController = self.navigationController;
    [self.oauthViewControllerTouch signIn];
   /* if(self.subscriberId == nil)
    {        
        GTMOAuthAuthentication *auth = [GTMOAuthObject sharedSingleton];
        NSURL *requestURL = [NSURL URLWithString:@"http://api-public.netflix.com/oauth/request_token"];
        NSURL *accessURL = [NSURL URLWithString:@"http://api-public.netflix.com/oauth/access_token"];
        NSURL *authorizeURL = [NSURL URLWithString:@"http://api-user.netflix.com/oauth/login"];
        NSString *scope = @"http://api-public.netflix.com";
        
        
        // set the callback URL to which the site should redirect, and for which
        // the OAuth controller should look to determine when sign-in has
        // finished or been canceled
        //
        // This URL does not need to be for an actual web page
        [auth setCallback:@"testflix://goBack"];
        
        // Display the autentication view
        GTMOAuthViewControllerTouch *viewController;
        viewController = [[GTMOAuthViewControllerTouch alloc] initWithScope:scope
                                                                   language:nil
                                                            requestTokenURL:requestURL
                                                          authorizeTokenURL:authorizeURL
                                                             accessTokenURL:accessURL
                                                             authentication:auth
                                                             appServiceName:@"My App: Custom Service"
                                                                   delegate:self
                                                           finishedSelector:@selector(viewController:finishedWithAuth:error:)];
        
        
        [self.navigationController pushViewController:viewController animated:YES];
       // [self performSegueWithIdentifier: @"NetflixLoginViewControllerSegue" sender: self];
    }*/
}

-(void)addDvdButtonPressed:(id)sender
{
    NSLog(@"addDvdButtonPressed Pressed!");
    [self checkAuthorization];
}

-(void)removeDvdButtonPressed:(id)sender
{
    NSLog(@"removeDvdButtonPressed Pressed!");
}

-(void)addInstantButtonPressed:(id)sender
{
    NSLog(@"addInstantButtonPressed Pressed!");
}

-(void)removeInstantButtonPressed:(id)sender
{
    NSLog(@"removeInstantButton Pressed!");
}


-(void)playButtonPressed:(id)sender {
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
    [self setOauthViewControllerTouch:nil];
    [super viewDidUnload];
}
@end
