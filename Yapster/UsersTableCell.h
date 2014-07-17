//
//  UsersTableCell.h
//  Yapster
//
//  Created by Abu-Bakar Bah on 5/6/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UsersTableCell : UITableViewCell
{
    
}

@property(retain, nonatomic)IBOutlet UIButton *user_photo;
@property(retain, nonatomic)IBOutlet UIButton *btn_username;
@property(retain, nonatomic)IBOutlet UIButton *addOrRemoveBtn;
@property(retain, nonatomic)IBOutlet UILabel *label_name;
@property(retain, nonatomic)IBOutlet UILabel *label_username;

@end
