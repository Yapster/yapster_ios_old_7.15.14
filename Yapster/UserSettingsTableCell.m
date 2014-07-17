//
//  UserSettingsTableCell.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 4/21/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "UserSettingsTableCell.h"

@implementation UserSettingsTableCell

@synthesize label1;
@synthesize label2;

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
