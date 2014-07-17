//
//  UserProfileTableCell.h
//  Yapster
//
//  Created by Abu-Bakar Bah on 4/23/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileTableCell : UITableViewCell
{
    
}

@property(retain, nonatomic)IBOutlet UIImageView *reyapUserImageView;
@property(retain, nonatomic)IBOutlet UILabel *name;
@property(retain, nonatomic)IBOutlet UIButton *username;
@property(retain, nonatomic)IBOutlet UILabel *yapTitle;
@property(retain, nonatomic)IBOutlet UILabel *yapDate;
@property(retain, nonatomic)IBOutlet UILabel *labelReyapUser;
@property(retain, nonatomic)IBOutlet UIButton *btnUserPhoto;
@property(retain, nonatomic)IBOutlet UIButton *btnPlay;
@property(retain, nonatomic)IBOutlet UIButton *btnReyap;
@property(retain, nonatomic)IBOutlet UIButton *btnLike;
@property(retain, nonatomic)IBOutlet UILabel *yapPlays;
@property(retain, nonatomic)IBOutlet UILabel *yapReyaps;
@property(retain, nonatomic)IBOutlet UILabel *yapLikes;
@property(retain, nonatomic)IBOutlet UILabel *yapLength;

@end
