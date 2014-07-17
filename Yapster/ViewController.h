//
//  ViewController.h
//  Yapster
//
//  Created by Abu-Bakar Bah on 3/28/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "GlobalVars.h"
#import "MyManager.h"
#import "Reachability.h"
#import "User.h"
#import "Stream.h"
#import "SignUp.h"
#import "ForgotPassword.h"
#import <sqlite3.h>
#import "KeychainItemWrapper.h"
#import "UserProfile.h"

@class PlayerScreen;

@interface ViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UITextField *emailOrUsername;
    IBOutlet UITextField *password;
    IBOutlet UIImageView *userIcon;
    IBOutlet UIImageView *passwordIcon;
    IBOutlet UIImageView *border;
    IBOutlet UIView *launch_screen;
    IBOutlet UIButton *startBtn;
    IBOutlet UIImageView *launch_screen_image;
    IBOutlet UIView *secondary_splash_screen;
    IBOutlet UIImageView *image_secondary_splash_screen;
    IBOutlet UIButton *signIn;
    IBOutlet UIButton *signUp;
    IBOutlet UIButton *forgotPassword;
    IBOutlet UILabel *copy;
    IBOutlet UIView *background;
    IBOutlet UIImageView *logo;
    
    IBOutlet UIActivityIndicatorView *loading;
    
    sqlite3 *user_db;
    NSString *dbPathString;
    
    KeychainItemWrapper *keychain;
}

@property BOOL table_ok, db_open_status;
@property id token;
@property(retain, nonatomic)User *UserInfo;
@property(retain, nonatomic)Stream *stream;
@property(retain, nonatomic)SignUp *registerVC;
@property(retain, nonatomic)ForgotPassword *forgotPasswordVC;
@property(retain, nonatomic)UserProfile *UserProfileVC;
@property(retain, nonatomic)PlayerScreen *playerScreenVC;
@property(retain, nonatomic)NSString *userDataPath;
@property(retain, nonatomic)NSDictionary *json;
@property(retain, nonatomic)NSString *response;
@property(retain, nonatomic)NSString *responseBody;
@property(retain, nonatomic)NSString *responseBodyAutoSignIn;
@property(retain, nonatomic)NSString *responseBodyNotification;
@property(retain, nonatomic)NSMutableArray *userInfoArray;
@property(retain, nonatomic)NSMutableArray *sqliteDbArray;
@property(retain, nonatomic)NSMutableArray *userFeed;
@property(retain, nonatomic)NSArray *column_names;
@property(retain, nonatomic)NSString *databaseName;
@property(retain, nonatomic)NSString *tableName;
@property(retain, nonatomic)NSURLConnection *connection1;
@property(retain, nonatomic)NSURLConnection *connection2;
@property(retain, nonatomic)NSURLConnection *connection3;
@property(retain, nonatomic)NSURLConnection *connection4;
@property(retain, nonatomic)NSURLConnection *connection5;
@property (strong, nonatomic)MyManager *sharedManager;

-(IBAction)touchBackground:(id)sender;
-(IBAction)editFields:(id)sender;
-(IBAction)login:(id)sender;
-(IBAction)goToSignUp:(id)sender;
-(IBAction)goToForgotPassword:(id)sender;

//sqlite stuff
-(void)createOrOpenDB;
-(void)addItemsToTable;
-(void)closeDB;
-(IBAction)start;
-(void)userProfilePushNotification:(NSNotification *)notification;
-(void)playerScreenPushNotification:(NSNotification *)notification;
-(void)doAutomaticLogin;
-(void)getYapNotificationInfo;

@end
