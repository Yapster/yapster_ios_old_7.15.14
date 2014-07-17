//
//  UserProfileHeaderCell.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 7/7/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "UserProfileHeaderCell.h"

@implementation UserProfileHeaderCell

@synthesize title;
@synthesize subtitle;
@synthesize image;

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
