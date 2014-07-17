//
//  UserProfileHeaderCell.h
//  Yapster
//
//  Created by Abu-Bakar Bah on 7/7/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileHeaderCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel* title;
@property (nonatomic, weak) IBOutlet UILabel* subtitle;
@property (nonatomic, weak) IBOutlet UIImageView* image;

@end
