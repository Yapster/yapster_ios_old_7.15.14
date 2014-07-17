//
//  UserNotificationsTableCell.h
//  Yapster
//
//  Created by Abu-Bakar Bah on 5/9/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserNotificationsTableCell : UITableViewCell {
    
}

@property(retain, nonatomic)IBOutlet UIButton *btnUserProfilePhoto;
@property(retain, nonatomic)IBOutlet UILabel *date_label;
@property(retain, nonatomic)IBOutlet UIImageView *notification_type_follow;
@property(retain, nonatomic)IBOutlet UIImageView *notification_type_like;
@property(retain, nonatomic)IBOutlet UIImageView *notification_type_reyap;
@property(retain, nonatomic)IBOutlet UIImageView *notification_type_listen;
@property (nonatomic, strong) IBOutlet UIButton *acting_user_btn;
@property (nonatomic, strong) IBOutlet UILabel *and_label;
@property (nonatomic, strong) IBOutlet UILabel *other_users;

@end
