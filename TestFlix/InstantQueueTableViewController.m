//
//  InstantQueueTableViewController.m
//  TestFlix
//
//  Created by Joshua Palermo on 5/22/13.
//  Copyright (c) 2013 Joshua Palermo. All rights reserved.
//

#import "InstantQueueTableViewController.h"
#import "OAuthViewControllerTouch.h"
#import <RestKit/RestKit.h>
#import "OAuthStore.h"
#import "OAuthViewControllerTouch.h"


@interface InstantQueueTableViewController () <RKRequestDelegate, RKObjectLoaderDelegate>

@end

@implementation InstantQueueTableViewController

@synthesize oauthViewControllerTouch = _oauthViewControllerTouch;

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
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Encountered an error: %@", error);

}

-(void) loadQueue
{
    

    
    if([[self oauthViewControllerTouch] checkAuthorizationForOperation:@selector(loadQueue:) forOperationController: self withNavController: [self navigationController]]) {
        NSString *currentUserStr = [[self oauthViewControllerTouch] getCurrentUser];
        NSMutableString *queueStrUrl = [[NSMutableString alloc] initWithString:@"/users/"];
        [queueStrUrl appendString:currentUserStr];
        [queueStrUrl appendString:@"/queues/instant"];
        
        RKObjectManager *objectManager = [RKObjectManager sharedManager];
        [objectManager loadObjectsAtResourcePath:queueStrUrl delegate:self];
    }

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([self oauthViewControllerTouch] == nil) {
        [self setOauthViewControllerTouch: [[OAuthViewControllerTouch alloc] init]];
    }
    
    [[self oauthViewControllerTouch] awakeFromNib];
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
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
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
