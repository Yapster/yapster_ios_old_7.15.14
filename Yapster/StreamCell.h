//
//  StreamCell.h
//  Yapster
//
//  Created by Abu-Bakar Bah on 3/31/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface StreamCell : SWTableViewCell {
    
}

@property(retain, nonatomic)IBOutlet UIImageView *reyapUserImageView;
@property(retain, nonatomic)IBOutlet UIImageView *userPhoto;
@property(retain, nonatomic)IBOutlet UILabel *name;
@property(retain, nonatomic)IBOutlet UIButton *username;
@property(retain, nonatomic)IBOutlet UILabel *yapTitle;
@property(retain, nonatomic)IBOutlet UILabel *yapDate;
@property(retain, nonatomic)IBOutlet UIButton *btnReyapUser;
@property(retain, nonatomic)IBOutlet UIButton *btnUserPhoto;
@property(retain, nonatomic)IBOutlet UIButton *btnPlay;
@property(retain, nonatomic)IBOutlet UIButton *btnReyap;
@property(retain, nonatomic)IBOutlet UIButton *btnLike;
@property(retain, nonatomic)IBOutlet UILabel *yapPlays;
@property(retain, nonatomic)IBOutlet UILabel *yapReyaps;
@property(retain, nonatomic)IBOutlet UILabel *yapLikes;
@property(retain, nonatomic)IBOutlet UILabel *yapLength;
@property (retain, nonatomic) IBOutlet UIScrollView *hashtags_scroll;
@property (retain, nonatomic) IBOutlet UIScrollView *usertags_scroll;
@property (retain, nonatomic) IBOutlet UIButton *web_link_btn;

@end
