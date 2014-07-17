//
//  UserSettings.h
//  Yapster
//
//  Created by Abu-Bakar Bah on 4/21/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVars.h"
#import "AppDelegate.h"
#import "UserSettingsTableCell.h"
#import "UserSettingsNotifications.h"
#import "ViewController.h"
#import "AboutYapster.h"
#import "TermsOfService.h"
#import "PrivacyPolicy.h"
#import "ContactYapster.h"

@interface UserSettings : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *userSettingsLabels;
    NSArray *userSettingsValues;
    
    IBOutlet UITableView *table;
    IBOutlet UILabel *score;
    IBOutlet UIActivityIndicatorView *loading;
    
    NSInteger cellCount;
}

@property(retain, nonatomic)AboutYapster *AboutYapsterVC;
@property(retain, nonatomic)TermsOfService *TermsOfServiceVC;
@property(retain, nonatomic)PrivacyPolicy *PrivacyPolicyVC;
@property(retain, nonatomic)ContactYapster *ContactYapsterVC;
@property (strong, nonatomic) NSDictionary *menuItems;
@property (strong, nonatomic) NSArray *menuKeys;

-(IBAction)goBack:(id)sender;

@end
