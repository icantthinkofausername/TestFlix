//
//  SearchResultsTableViewController.h
//  TestFlix
//
//  Created by Joshua Palermo on 9/23/12.
//  Copyright (c) 2012 Joshua Palermo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CatalogTitles.h"
#import "MovieDetailViewController.h"

@interface SearchResultsTableViewController : UITableViewController

@property (nonatomic, strong) CatalogTitles *catalogTitles;
@property (nonatomic, strong) MovieDetailViewController *mdvc;

@end
