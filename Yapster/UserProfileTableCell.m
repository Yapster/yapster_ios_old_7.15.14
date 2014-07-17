//
//  UserProfileTableCell.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 4/23/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "UserProfileTableCell.h"

@implementation UserProfileTableCell

@synthesize reyapUserImageView;
@synthesize name;
@synthesize username;
@synthesize yapTitle;
@synthesize yapDate;
@synthesize labelReyapUser;
@synthesize btnUserPhoto;
@synthesize btnPlay;
@synthesize btnReyap;
@synthesize btnLike;
@synthesize yapPlays;
@synthesize yapReyaps;
@synthesize yapLikes;
@synthesize yapLength;

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
