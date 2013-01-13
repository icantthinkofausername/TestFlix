//
//  GTMOAuthObject.m
//  TestFlix
//
//  Created by Joshua Palermo on 1/12/13.
//  Copyright (c) 2013 Joshua Palermo. All rights reserved.
//

#import "GTMOAuthObject.h"
#import "GTMOAuthAuthentication.h"

@implementation GTMOAuthObject

static GTMOAuthAuthentication *sharedSingleton;
static NSString *const kServiceName = @"Netflix";

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        NSString *myConsumerKey = @"62q3pac4cjd25uybzk2ym88n";    // pre-registered with service
        NSString *myConsumerSecret = @"RNJyuPbYze"; // pre-assigned by service
        
        if ([myConsumerKey length] == 0 || [myConsumerSecret length] == 0) {
            sharedSingleton = nil;
        }
        else {    
            sharedSingleton = [[GTMOAuthAuthentication alloc] initWithSignatureMethod:kGTMOAuthSignatureMethodHMAC_SHA1
                                                               consumerKey:myConsumerKey
                                                              privateKey:myConsumerSecret];
        
            // setting the service name lets us inspect the auth object later to know
            // what service it is for
            sharedSingleton.serviceProvider = kServiceName;
        }
    }
}

+ (GTMOAuthAuthentication *)sharedSingleton
{
    return sharedSingleton;
}

@end
