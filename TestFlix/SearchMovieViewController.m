//
//  ViewController.m
//  TestFlix
//
//  Created by Joshua Palermo on 9/9/12.
//  Copyright (c) 2012 Joshua Palermo. All rights reserved.
//

#import "SearchMovieViewController.h"
#import "SearchResultsTableViewController.h"
#import "CatalogTitles.h"
#import "CatalogTitle.h"
#import <RestKit/RestKit.h>


@interface SearchMovieViewController () <RKRequestDelegate, RKObjectLoaderDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property NSString *responseBody;
@property CatalogTitles *catalogTitles;
@property NSMutableString *searchUrl;

@end

@implementation SearchMovieViewController

@synthesize searchField = _searchField;
@synthesize responseBody = _responseBody;
@synthesize catalogTitles = _catalogTitles;
@synthesize searchUrl = _searchUrl;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setSearchField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{
    if ([request isGET]) {
        // Handling GET /foo.xml
        
        if ([response isOK]) {
            // Success! Let's take a look at the data
            NSLog(@"Retrieved XML: %@", [response bodyAsString]);
            self.responseBody = [response bodyAsString];
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
    [self setCatalogTitles: objects];
    RKLogInfo(@"Load collection of Articles: %@", objects);
    
    if([objects count] > 0) {
        [self setCatalogTitles: [objects objectAtIndex:0]];
        [[self catalogTitles] setSearchUrl: [self searchUrl]];
        NSLog(@"Number of results is %d", [[[self catalogTitles] numberOfResults] integerValue]);
        
        SearchResultsTableViewController *tableViewController = [[SearchResultsTableViewController alloc] init];
        [tableViewController setCatalogTitles: [self catalogTitles]];
        [[self navigationController] pushViewController:tableViewController animated:YES];
    }
    else {
        [self setCatalogTitles: nil];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                        message:@"This search returned no results!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
    
    [[self searchField] resignFirstResponder];
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //[[self searchField] resignFirstResponder];
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [self setSearchUrl: [[NSMutableString alloc] initWithString:@"/catalog/titles?expand=synopsis,formats&term="]];
    [[self searchUrl] appendString: [self.searchField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [objectManager loadObjectsAtResourcePath:self.searchUrl  delegate:self];
    return YES;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"SearchMovieViewControllerSegue"]) {
        if([[[self searchField] text] length] != 0) {
            return YES;
        }
    }
    return NO;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"SearchMovieViewControllerSegue"]){
        SearchResultsTableViewController *srvc = (SearchResultsTableViewController *)[segue destinationViewController];
        srvc.catalogTitles = self.catalogTitles;
        // cvc.delegate = self;
    }
}

-(IBAction)backgroundTouched:(id)sender
{
    self.searchField.text = @""; // this is a quick hack, but I'm doing this to tell whether the user clicked the background or not for the segue check
    [self.searchField resignFirstResponder];
}

@end
