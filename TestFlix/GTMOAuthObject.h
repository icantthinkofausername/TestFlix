//
//  GTMOAuthObject.h
//  TestFlix
//
//  Created by Joshua Palermo on 1/12/13.
//  Copyright (c) 2013 Joshua Palermo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTMOAuthAuthentication.h"

@interface GTMOAuthObject : NSObject

+ (GTMOAuthAuthentication *)sharedSingleton;

@end
