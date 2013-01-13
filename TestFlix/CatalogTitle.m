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
@synthesize instantFormat = _instantFormat;
@synthesize dvdFormat = _dvdFormat;

-(NSString*) mpaaRating
{
    if(! _mpaaRating) {
        for(Category * category in self.category) {
            if([category.scheme.absoluteString rangeOfString:@"mpaa_ratings"].location != NSNotFound) {
                _mpaaRating = category.label;
                break;
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
                break;
            }
        }
    }
    return _synopsis;
}

-(NSNumber*) instantFormat
{
    // there has got to be a better way...
    if(! _instantFormat) {
        for(Link *link in self.link) {
            if([link.title rangeOfString:@"formats"].location != NSNotFound) {
                if([[link.deliveryFormats objectForKey:@"availability"] isKindOfClass: [NSMutableDictionary class]]){
                    NSMutableDictionary *availabilityDict = [link.deliveryFormats objectForKey:@"availability"];
                    if([[[availabilityDict objectForKey:@"category" ] objectForKey:@"label"] rangeOfString:@"instant"].location != NSNotFound) {
                        _instantFormat = [[NSNumber alloc] initWithBool:YES];
                    }
                }
                else {
                    for(NSMutableDictionary *availabilityDict in [link.deliveryFormats objectForKey:@"availability" ]) {
                        if([[[availabilityDict objectForKey:@"category" ] objectForKey:@"label"] rangeOfString:@"instant"].location != NSNotFound) {
                            _instantFormat = [[NSNumber alloc] initWithBool:YES];
                            break;
                        }
                    }
                }
            }
            
            if(_instantFormat) {
                break;
            }
        }
    }
    
    if(! _instantFormat) {
        _instantFormat = [[NSNumber alloc] initWithBool:NO];
    }
    return _instantFormat;
}

-(NSNumber*) dvdFormat
{
    // there has got to be a better way...
    if(! _dvdFormat) {
        for(Link *link in self.link) {
            if([link.title rangeOfString:@"formats"].location != NSNotFound) {
                if([[link.deliveryFormats objectForKey:@"availability"] isKindOfClass: [NSMutableDictionary class]]){
                    NSMutableDictionary *availabilityDict = [link.deliveryFormats objectForKey:@"availability"];
                    if([[[availabilityDict objectForKey:@"category" ] objectForKey:@"label"] rangeOfString:@"DVD"].location != NSNotFound) {
                        _dvdFormat = [[NSNumber alloc] initWithBool:YES];
                    }
                }
                else
                {
                    for(NSMutableDictionary *availabilityDict in [link.deliveryFormats objectForKey:@"availability" ]) {
                        if([[[availabilityDict objectForKey:@"category" ] objectForKey:@"label"] rangeOfString:@"DVD"].location != NSNotFound) {
                            _dvdFormat = [[NSNumber alloc] initWithBool:YES];
                            break;
                        }
                    }
                }
            }
            
            if(_dvdFormat) {
                break;
            }
        }
    }
    
    if(! _dvdFormat) {
        _dvdFormat = [[NSNumber alloc] initWithBool:NO];
    }
    return _dvdFormat;
}

@end