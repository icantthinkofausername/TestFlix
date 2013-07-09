//
//  InstantQueueTableViewController.h
//  TestFlix
//
//  Created by Joshua Palermo on 5/22/13.
//  Copyright (c) 2013 Joshua Palermo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CatalogTitles.h"
#import "CatalogTitle.h"
#import "MovieDetailViewController.h"
#import "OauthViewControllerTouch.h"
#import "ViewControllerSelected.h"
#import "Queue.h"

@interface InstantQueueTableViewController : UITableViewController <ViewControllerSelected>
@property (nonatomic, strong) OAuthViewControllerTouch *oauthViewControllerTouch;
@property (nonatomic, strong) Queue *queue;
@property (nonatomic, strong) CatalogTitles *catalogTitles;
@property (nonatomic, strong) MovieDetailViewController *mdvc;
- (void) viewWasClicked;
@end
