//
//  StreamCell.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 3/31/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "StreamCell.h"

@implementation StreamCell

@synthesize reyapUserImageView;
@synthesize userPhoto;
@synthesize name;
@synthesize username;
@synthesize yapTitle;
@synthesize yapDate;
@synthesize btnReyapUser;
@synthesize btnUserPhoto;
@synthesize btnPlay;
@synthesize btnReyap;
@synthesize btnLike;
@synthesize yapPlays;
@synthesize yapReyaps;
@synthesize yapLikes;
@synthesize yapLength;
@synthesize hashtags_scroll;
@synthesize usertags_scroll;
@synthesize web_link_btn;

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

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) {
        self.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

@end
