//
//  CatalogTitle.h
//  TestFlix
//
//  Created by Joshua Palermo on 10/1/12.
//  Copyright (c) 2012 Joshua Palermo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CatalogTitle : NSObject

@property (nonatomic, retain) NSString *regularTitle;
@property (nonatomic, retain) NSString *synopsis;
@property (nonatomic, retain) NSString *mpaaRating;
@property (nonatomic, retain) NSURL *smallBoxArtUrl;
@property (nonatomic, retain) NSURL *mediumBoxArtUrl;
@property (nonatomic, retain) NSURL *largeBoxArtUrl;
@property (nonatomic, retain) NSURL *titleIdUrl;
@property (nonatomic, retain) NSString *releaseYear;
@property (nonatomic, retain) NSString *averageRating;
@property (nonatomic, retain) NSMutableArray  *category;
@property (nonatomic, retain) NSMutableArray *link;
@property (nonatomic, retain) NSNumber *instantFormat;
@property (nonatomic, retain) NSNumber *dvdFormat;
@end
