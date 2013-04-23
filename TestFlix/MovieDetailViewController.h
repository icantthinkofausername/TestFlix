//
//  MovieDetailViewController.h
//  TestFlix
//
//  Created by Joshua Palermo on 10/9/12.
//  Copyright (c) 2012 Joshua Palermo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CatalogTitle.h"
#import "OauthViewControllerTouch.h"
#import <RestKit/RestKit.h>

@interface MovieDetailViewController : UIViewController<RKRequestDelegate, RKObjectLoaderDelegate, UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *movieBoxArtImageView;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *movieSynopsisTextView;
@property (weak, nonatomic) IBOutlet UIWebView *movieSynopsisWebView;
@property (weak, nonatomic) IBOutlet UIButton *removeDvdButton;
@property (weak, nonatomic) IBOutlet UIButton *addDvdButton;
@property (weak, nonatomic) IBOutlet UIButton *removeInstantButton;
@property (weak, nonatomic) IBOutlet UIButton *addInstantButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) CatalogTitle *catalogTitle;
@property (nonatomic, strong) OAuthViewControllerTouch *oauthViewControllerTouch;

@end
