//
//  GTMOAuthObject.h
//  TestFlix
//
//  Created by Joshua Palermo on 1/12/13.
//  Copyright (c) 2013 Joshua Palermo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTMOAuthAuthentication.h"

@interface OAuthStore : NSObject

@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong) NSString *consumerKey;
@property (nonatomic, strong) NSString *consumerSecret;
@property (nonatomic, strong) NSString *accessURL;
@property (nonatomic, strong) NSString *requestURL;
@property (nonatomic, strong) NSString *authorizeURL;
@property (nonatomic, strong) GTMOAuthAuthentication *gtmoAuthAuthentication;

+ (OAuthStore *)sharedSingleton;

@end
