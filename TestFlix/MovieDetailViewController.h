//
//  MovieDetailViewController.h
//  TestFlix
//
//  Created by Joshua Palermo on 10/9/12.
//  Copyright (c) 2012 Joshua Palermo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CatalogTitle.h"
#import <RestKit/RestKit.h>

@interface MovieDetailViewController : UIViewController<RKRequestDelegate, RKObjectLoaderDelegate, UIWebViewDelegate>

@property (nonatomic, strong) CatalogTitle *catalogTitle;

@end
