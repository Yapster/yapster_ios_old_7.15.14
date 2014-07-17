//
//  AppDelegate.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 3/28/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "AppDelegate.h"
#import "AWSiOSDemoTVMViewController.h"
#import <AWSRuntime/AWSRuntime.h>
#import <FacebookSDK/FacebookSDK.h>

@implementation AppDelegate

@synthesize sharedManager;
@synthesize UserProfileVC;
@synthesize json;
@synthesize connection1;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    sharedManager = [MyManager sharedManager];
    
    NSDictionary *userInfo =
    [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (userInfo != nil) {
        sharedManager.appLaunchedWithNotification = YES;
        
        sharedManager.userInfo = userInfo;
        
        NSString *notification_type = [userInfo objectForKey:@"notification_type"];
        //double user_id = [[userInfo objectForKey:@"profile_user_id"] doubleValue];
        
        if ([notification_type isEqualToString:@"like_created"] || [notification_type isEqualToString:@"reyap_created"] || [notification_type isEqualToString:@"user_tag"]) {
            sharedManager.notificationType = @"player";
        }
        else {
            sharedManager.notificationType = @"profile";
        }
    }
    
    /*UINavigationController *container = [UINavigationController new];
    container.navigationBar.translucent = NO;
    AWSiOSDemoTVMViewController *viewController = [[AWSiOSDemoTVMViewController alloc] initWithNibName:@"AWSiOSDemoTVMViewController" bundle:nil];
    [container pushViewController:viewController animated:NO];
    
    self.window.rootViewController = container;*/
    
    // Logging Control - Do NOT use logging for non-development builds.
#ifdef DEBUG
    [AmazonLogger verboseLogging];
#else
    [AmazonLogger turnLoggingOff];
#endif
    
    [AmazonErrorHandler shouldNotThrowExceptions];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void) application:(UIApplication *) application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *deviceTokenString = [NSString stringWithFormat:@"%@", deviceToken];
    
    if(deviceToken){
        [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        sharedManager.userDeviceToken = deviceTokenString;
    }
    
    NSLog(@"%@", sharedManager.userDeviceToken);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    NSLog(@"userInfo: %@", userInfo);
    
    sharedManager.userInfo = userInfo;
    
    sharedManager.appLaunchedWithNotification = YES;
    
    NSString *notification_type = [userInfo objectForKey:@"notification_type"];
    //double user_id = [[userInfo objectForKey:@"profile_user_id"] doubleValue];
    
    if ([notification_type isEqualToString:@"like_created"] || [notification_type isEqualToString:@"reyap_created"] || [notification_type isEqualToString:@"user_tag"]) {
        sharedManager.notificationType = @"player";
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"playerScreenPushNotification" object:nil userInfo:userInfo];
    }
    else {
        sharedManager.notificationType = @"profile";
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userProfilePushNotification" object:nil userInfo:userInfo];
    }
}

-(void)goToUserProfile:(double)user_id {
    
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didEnterBackground" object:self];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [FBSession.activeSession close];  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"willTerminate" object:self];
}

// In order to process the response you get from interacting with the Facebook login process,
// you need to override application:openURL:sourceApplication:annotation:
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
}

@end
