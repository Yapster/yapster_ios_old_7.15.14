//
//  UserNotificationsTableCell.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 5/9/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "UserNotificationsTableCell.h"

@implementation UserNotificationsTableCell


@synthesize btnUserProfilePhoto;
@synthesize date_label;
@synthesize notification_type_follow;
@synthesize notification_type_like;
@synthesize notification_type_reyap;
@synthesize notification_type_listen;
@synthesize acting_user_btn;
@synthesize and_label;
@synthesize other_users;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
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
