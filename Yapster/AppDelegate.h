//
//  AppDelegate.h
//  Yapster
//
//  Created by Abu-Bakar Bah on 3/28/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVars.h"
#import "MyManager.h"
#import "ImageZoomController.h"
#import "UserProfile.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(strong, nonatomic)UIWindow *window;
@property(strong, nonatomic)MyManager *sharedManager;
@property(retain, nonatomic)UserProfile *UserProfileVC;
@property(retain, nonatomic)NSDictionary *json;
@property(retain, nonatomic)NSURLConnection *connection1;

-(void)goToUserProfile:(double)user_id;

@end
