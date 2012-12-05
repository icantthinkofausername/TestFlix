//
//  SearchResultsTableViewController.m
//  TestFlix
//
//  Created by Joshua Palermo on 9/23/12.
//  Copyright (c) 2012 Joshua Palermo. All rights reserved.
//

#import "SearchResultsTableViewController.h"
#import "CatalogTitle.h"
#import "MovieDetailViewController.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import <RestKit/RestKit.h>

#define NUMBER_OF_ROWS 25

@interface SearchResultsTableViewController () <RKRequestDelegate, RKObjectLoaderDelegate>

@end

@implementation SearchResultsTableViewController

@synthesize catalogTitles = _catalogTitles;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setup infinite scrolling
    id loadObjectsDelegate = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.tableView beginUpdates];
            
            NSString *startIndex = [NSString stringWithFormat:@"%d",self.catalogTitles.startIndex + NUMBER_OF_ROWS]; //%d or %i both is ok.
            RKObjectManager *objectManager = [RKObjectManager sharedManager];
            NSMutableString *searchUrl = [[NSMutableString alloc] initWithString:self.catalogTitles.searchUrl];
            [searchUrl appendString:@"&start_index="];
            [searchUrl appendString:startIndex];
            [objectManager loadObjectsAtResourcePath: searchUrl delegate:loadObjectsDelegate];
            //[mutableCatalogTitles addObject:[mutableCatalogTitles lastObject]];
            //[self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:mutableCatalogTitles.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            //self.catalogTitles.catalogTitle = [NSArray arrayWithArray:mutableCatalogTitles];
            
            [self.tableView endUpdates];            
            [self.tableView.infiniteScrollingView stopAnimating];
        });
    }];

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
    // #warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // #warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.catalogTitles.catalogTitle.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CatalogTitleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    
    // Configure the cell...
    cell.textLabel.text = [[self.catalogTitles.catalogTitle objectAtIndex:indexPath.row] regularTitle];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"MovieDetailViewControllerSegue"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CatalogTitle *catalogTitle = [self.catalogTitles.catalogTitle objectAtIndex:indexPath.row];
        MovieDetailViewController *mdvc = (MovieDetailViewController *)[segue destinationViewController];
        mdvc.catalogTitle = catalogTitle;
        catalogTitle.synopsis;
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects
{
    RKLogInfo(@"Load collection of Articles: %@", objects);
    
    
    //mutableCatalogTitles addObject:[mutableCatalogTitles lastObject]];
    //[self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:mutableCatalogTitles.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    //self.catalogTitles.catalogTitle = [NSArray arrayWithArray:mutableCatalogTitles];
    
    //NSMutableArray *mutableCatalogTitles;
    if(objects.count > 0) {
        CatalogTitles *catalogTitles = [objects objectAtIndex:0];
        NSArray *catalogTitle = catalogTitles.catalogTitle;
        for(int i = 0; i < catalogTitle.count; i++) {
            [self.catalogTitles.catalogTitle addObject: [catalogTitle objectAtIndex:i]];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow: self.catalogTitles.catalogTitle.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        }
        self.catalogTitles.startIndex += NUMBER_OF_ROWS;
        NSLog(@"Number of results is %d", catalogTitles.catalogTitle.count);
    }
    //NSLog(@"Number of results is %d", [mutableCatalogTitles.numberOfResults integerValue]);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Encountered an error: %@", error);
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
