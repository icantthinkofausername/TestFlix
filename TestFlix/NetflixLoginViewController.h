//
//  NetflixLoginViewController.h
//  TestFlix
//
//  Created by Joshua Palermo on 12/30/12.
//  Copyright (c) 2012 Joshua Palermo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface NetflixLoginViewController : UIViewController<RKRequestDelegate, RKObjectLoaderDelegate, UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *loginWebView;
@property NSString *oauthToken;
@property NSString *applicationName;
@end
