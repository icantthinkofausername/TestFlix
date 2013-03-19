//
//  GTMOAuthObject.m
//  TestFlix
//
//  Created by Joshua Palermo on 1/12/13.
//  Copyright (c) 2013 Joshua Palermo. All rights reserved.
//

#import "OAuthStore.h"

@implementation OAuthStore

static OAuthStore *sharedSingleton;
static NSString *const kServiceName = @"Netflix";

+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedSingleton];
}

+ (OAuthStore *)sharedSingleton
{
    static OAuthStore *sharedSingleton = nil;
    if(!sharedSingleton) {
        sharedSingleton = [[super allocWithZone: NULL] init];
    }
    
    return sharedSingleton;
}

- (id) init
{
    self = [super init];
    if(self) {
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"OAuthSettings" ofType:@"plist"];
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                              propertyListFromData:plistXML
                                              mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                              format:&format
                                              errorDescription:&errorDesc];
        if (!temp) {
            NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
        }
        
        [self setBaseURL: [temp objectForKey: @"baseUrl"]];
        [self setConsumerKey: [temp objectForKey: @"consumerKey"]];
        [self setConsumerSecret: [temp objectForKey: @"consumerSecret"]];
        [self setAccessURL: [temp objectForKey: @"accessUrl"]];
        [self setRequestURL: [temp objectForKey: @"requestUrl"]];
        [self setAuthorizeURL: [temp objectForKey: @"authorizeUrl"]];
        
        GTMOAuthAuthentication *auth = [[GTMOAuthAuthentication alloc] initWithSignatureMethod:kGTMOAuthSignatureMethodHMAC_SHA1
                                                                                   consumerKey:[self consumerKey]
                                                                                    privateKey:[self consumerSecret]];
        // setting the service name lets us inspect the auth object later to know
        // what service it is for
        [auth setServiceProvider: kServiceName];
        [self setGtmoAuthAuthentication:auth];
        
    }
    
    return self;
}

/*+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        NSString *myConsumerKey = @"e5n3a73uemxpyephhfw9p4uq";    // pre-registered with service
        NSString *myConsumerSecret = @"eD2P37bSYG"; // pre-assigned by service
        
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
}*/


@end
