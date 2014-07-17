//
//  UsersTableCell.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 5/6/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "UsersTableCell.h"

@implementation UsersTableCell

@synthesize user_photo;
@synthesize btn_username;
@synthesize  addOrRemoveBtn;
@synthesize label_name;
@synthesize label_username;

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
