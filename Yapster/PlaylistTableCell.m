//
//  PlaylistTableCell.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 6/1/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "PlaylistTableCell.h"

@implementation PlaylistTableCell

@synthesize reyap_icon;
@synthesize profilePhoto;
@synthesize list_count;
@synthesize yap_title;
@synthesize full_name;
@synthesize yap_date;
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

@end
