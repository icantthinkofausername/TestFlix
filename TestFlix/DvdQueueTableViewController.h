//
//  DvdQueueTableViewController.h
//  TestFlix
//
//  Created by Joshua Palermo on 5/22/13.
//  Copyright (c) 2013 Joshua Palermo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OauthViewControllerTouch.h"
#import "ViewControllerSelected.h"
#import "Queue.h"

@interface DvdQueueTableViewController : UITableViewController <ViewControllerSelected>
@property (nonatomic, strong) OAuthViewControllerTouch *oauthViewControllerTouch;
@property (nonatomic, strong) Queue *queue;
- (void) viewWasClicked;
@end