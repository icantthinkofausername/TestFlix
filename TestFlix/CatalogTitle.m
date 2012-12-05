//
//  CatalogTitle.m
//  TestFlix
//
//  Created by Joshua Palermo on 10/1/12.
//  Copyright (c) 2012 Joshua Palermo. All rights reserved.
//

#import "CatalogTitle.h"
#import "Link.h"
#import "Category.h"

@implementation CatalogTitle

@synthesize regularTitle = _regularTitle;
@synthesize smallBoxArtUrl = _smallBoxArtUrl;
@synthesize mediumBoxArtUrl = _mediumBoxArtUrl;
@synthesize largeBoxArtUrl = _largeBoxArtUrl;
@synthesize titleIdUrl = _titleIdUrl;
@synthesize link = _link;
@synthesize releaseYear = _releaseYear;
@synthesize category = _category;
@synthesize averageRating = _averageRating;
@synthesize mpaaRating = _mpaaRating;
@synthesize synopsis = _synopsis;

-(NSString*) mpaaRating
{
    if(! _mpaaRating) {
        for(Category * category in self.category) {
            if([category.scheme.absoluteString rangeOfString:@"mpaa_ratings"].location != NSNotFound) {
                _mpaaRating = category.label;
            }
        }
    } 
    return _mpaaRating;
}

-(NSString*) synopsis
{
    if(! _synopsis) {
        for(Link *link in self.link) {
            if([link.title rangeOfString:@"synopsis"].location != NSNotFound) {
                _synopsis = link.synopsis;
            }
        }
    }
    return _synopsis;
}

@end