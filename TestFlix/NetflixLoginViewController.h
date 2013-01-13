//
//  NetflixLoginViewController.h
//  TestFlix
//
//  Created by Joshua Palermo on 12/30/12.
//  Copyright (c) 2012 Joshua Palermo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetflixLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *loginWebView;
@property NSString *oauthToken;
@property NSString *applicationName;
@end
