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

@interface QueueTableViewController : UITableViewController <ViewControllerSelected>
@property (nonatomic, strong) OAuthViewControllerTouch *oauthViewControllerTouch;
@property (nonatomic, strong) NSString *queueType;
@property (nonatomic, strong) CatalogTitles *catalogTitles;
@property (nonatomic, strong) MovieDetailViewController *mdvc;
- (void) viewWasClicked;
- (id) initWithQueueType: (NSString *)queueType;
@end
