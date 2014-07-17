//
//  UserSettingsNotifications.h
//  Yapster
//
//  Created by Abu-Bakar Bah on 4/21/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVars.h"
#import "AppDelegate.h"
#import "UserSettingsNotificationsTableCell.h"
#import "ViewController.h"

@interface UserSettingsNotifications : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *table;
    
    NSArray *labels;
}

@property(retain, nonatomic)NSMutableDictionary *jsonFetch;
@property(retain, nonatomic)NSArray *json;
@property(retain, nonatomic)NSURLConnection *connection1;
@property(retain, nonatomic)NSURLConnection *connection2;
@property(retain, nonatomic)NSURLConnection *connection3;
@property(retain, nonatomic)NSString *settingsResponseBody;
@property BOOL notify_for_mentions;
@property BOOL notify_for_reyaps;
@property BOOL notify_for_likes;
@property BOOL notify_for_new_followers;
@property BOOL notify_for_yapster;

-(IBAction)goBack:(id)sender;
-(IBAction)updateSwitch:(id)sender;

@end
