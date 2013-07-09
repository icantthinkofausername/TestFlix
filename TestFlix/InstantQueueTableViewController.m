//
//  InstantQueueTableViewController.m
//  TestFlix
//
//  Created by Joshua Palermo on 5/22/13.
//  Copyright (c) 2013 Joshua Palermo. All rights reserved.
//

#import "CatalogTitles.h"
#import "CatalogTitle.h"
#import "InstantQueueTableViewController.h"
#import "MovieDetailViewController.h"
#import "OAuthViewControllerTouch.h"
#import <RestKit/RestKit.h>
#import "OAuthStore.h"
#import "OAuthViewControllerTouch.h"
#import "Queue.h"
#import "QueueItem.h"



@interface InstantQueueTableViewController () <RKRequestDelegate, RKObjectLoaderDelegate>

@end

@implementation InstantQueueTableViewController

@synthesize oauthViewControllerTouch = _oauthViewControllerTouch;
@synthesize queue = _queue;
@synthesize catalogTitles = _catalogTitles;
@synthesize mdvc = _mdvc;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects
{
    RKLogInfo(@"Load collection of Articles: %@", objects);
    if([objects count] > 0) {
        CatalogTitles *catalogTitles = [objects objectAtIndex:0];
        NSArray *catalogTitle = [catalogTitles catalogTitle];
        for(int i = 0; i < [catalogTitle count]; i++) {
            [[[self catalogTitles] catalogTitle] addObject: [catalogTitle objectAtIndex:i]];
            
            //  the @ sign is an array literal
           // [[self tableView] insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow: [[[self catalogTitles] catalogTitle] count] -1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        }
        NSLog(@"Number of results is %d", [[catalogTitles catalogTitle] count]);
    }
    
    [[self tableView] reloadData];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Encountered an error: %@", error);

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

-(void) loadQueue
{
    if([[self oauthViewControllerTouch] checkAuthorizationForOperation:@selector(loadQueue) forOperationController: self withNavController: [self navigationController]]) {
        NSString *currentUserStr = [[self oauthViewControllerTouch] getCurrentUser];
        NSMutableString *queueStrUrl = [[NSMutableString alloc] initWithString:@"/users/"];
        [queueStrUrl appendString:currentUserStr];
        [queueStrUrl appendString:@"/queues/instant?expand=synopsis,formats"];
        
        RKObjectManager *objectManager = [RKObjectManager sharedManager];
        [objectManager loadObjectsAtResourcePath:queueStrUrl delegate:self];
    }

}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self setCatalogTitles: [[CatalogTitles alloc] init]];
    [[self catalogTitles] setCatalogTitle: [[NSMutableArray alloc] init]];
    
    [self setQueue: [[Queue alloc] init]];
    [[self queue] setQueueItem: [[NSMutableArray alloc] init]];
    
    if([self oauthViewControllerTouch] == nil) {
        [self setOauthViewControllerTouch: [[OAuthViewControllerTouch alloc] init]];
        [[self oauthViewControllerTouch] awakeFromNib];
    }    
}

- (void) viewControllerWasSelected
{
    if([self oauthViewControllerTouch] == nil) {
        [self setOauthViewControllerTouch: [[OAuthViewControllerTouch alloc] init]];
        [[self oauthViewControllerTouch] awakeFromNib];
    } 
    [self loadQueue];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if([self catalogTitles]) {
        return [[[self catalogTitles]catalogTitle]count];
    }
    else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
  //  [[cell textLabel] setText: [[[[self catalogTitles] catalogTitle] objectAtIndex:[indexPath row]] regularTitle]];

    [[cell textLabel] setText: [[[[self catalogTitles] catalogTitle] objectAtIndex:[indexPath row]] regularTitle]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    //MovieDetailViewController *mdvc = [[MovieDetailViewController alloc] init];
    if([self mdvc] == nil) {
        [self setMdvc: [[MovieDetailViewController alloc] init]];
    }
    CatalogTitle *catalogTitle = [[[self catalogTitles] catalogTitle] objectAtIndex:[indexPath row]];
    [[self mdvc] setCatalogTitle: catalogTitle];
    [[self navigationController] pushViewController:[self mdvc] animated:YES];
}

@end
