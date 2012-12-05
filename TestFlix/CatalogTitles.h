//
//  NetflixCatalogTitles.h
//  TestFlix
//
//  Created by Joshua Palermo on 9/23/12.
//  Copyright (c) 2012 Joshua Palermo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CatalogTitles : NSObject

@property (nonatomic, retain) NSNumber *numberOfResults;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger resultsPerPage;
@property (nonatomic, retain) NSMutableArray *catalogTitle;
@property (nonatomic, retain) NSMutableString *searchUrl;

@end
