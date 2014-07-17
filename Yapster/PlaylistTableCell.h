//
//  PlaylistTableCell.h
//  Yapster
//
//  Created by Abu-Bakar Bah on 6/1/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface PlaylistTableCell : SWTableViewCell
{
    
}

@property (retain, nonatomic) IBOutlet UIImageView *reyap_icon;
@property (retain, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (retain, nonatomic) IBOutlet UILabel *list_count;
@property (retain, nonatomic) IBOutlet UILabel *yap_title;
@property (retain, nonatomic) IBOutlet UILabel *full_name;
@property (retain, nonatomic) IBOutlet UILabel *yap_date;
@property (retain, nonatomic) IBOutlet UIScrollView *hashtags_scroll;
@property (retain, nonatomic) IBOutlet UIScrollView *usertags_scroll;
@property (retain, nonatomic) IBOutlet UIButton *web_link_btn;

@end
