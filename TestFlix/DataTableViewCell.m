//
//  DataTableViewCell.m
//  TestFlix
//
//  Created by Joshua Palermo on 10/19/12.
//  Copyright (c) 2012 Joshua Palermo. All rights reserved.
//

#import "DataTableViewCell.h"

@implementation DataTableViewCell

@synthesize dataObject = _dataObject;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
