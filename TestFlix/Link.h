//
//  Link.h
//  TestFlix
//
//  Created by Joshua Palermo on 11/20/12.
//  Copyright (c) 2012 Joshua Palermo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Link : NSObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *synopsis;
@property (nonatomic, retain) NSURL *href;
@property (nonatomic, retain) NSURL *rel;
@property (nonatomic, retain) NSMutableDictionary *deliveryFormats;
@end
