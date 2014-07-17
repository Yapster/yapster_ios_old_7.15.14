//
//  ViewController.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 3/28/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "ViewController.h"
#import "PlayerScreen.h"

@interface ViewController ()

@end

@implementation ViewController

double sessionUserID = 0;
double sessionID = 0;
BOOL cameFromWebScreen = false;
BOOL cameFromPlaylist = false;
BOOL cameFromSearchResults = false;
BOOL yapWasNotPlayed = true;
BOOL yapFinishedLoading = false;
BOOL cameFromCropImageScreen = false;
BOOL exploreScreenFirstLoaded = false;
BOOL playlistScreenFirstLoaded = false;
BOOL yapScreenFirstLoaded = false;
BOOL cameFromPlayerScreen = false;
BOOL cameFromProfileScreen = false;
NSString *sessionEmail = nil;
NSString *sessionUsername = nil;
NSString *sessionFirstName;
NSString *sessionLastName;
NSString *sessionPassword = nil;
NSString *sessionPhone = nil;
NSString *sessionCountry = nil;
UIImage *sessionUnCroppedPhoto = nil;
UIImage *sessionCroppedPhoto = nil;
UIImage *sessionUserCroppedPhoto = nil;
UIImage *sessionUserUncroppedPhoto = nil;

@synthesize userDataPath;
@synthesize stream;
@synthesize UserInfo;
@synthesize forgotPasswordVC;
@synthesize UserProfileVC;
@synthesize playerScreenVC;
@synthesize json;
@synthesize response;
@synthesize responseBody;
@synthesize responseBodyAutoSignIn;
@synthesize responseBodyNotification;
@synthesize registerVC;
@synthesize connection1;
@synthesize connection2;
@synthesize connection3;
@synthesize connection4;
@synthesize connection5;

@synthesize token;
@synthesize userInfoArray;
@synthesize userFeed;
@synthesize sqliteDbArray;
@synthesize table_ok, db_open_status;
@synthesize column_names;
@synthesize databaseName;
@synthesize tableName;
@synthesize sharedManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sessionUserID = 0;
    sessionID = 0;
    cameFromWebScreen = false;
    cameFromPlaylist = false;
    cameFromSearchResults = false;
    yapWasNotPlayed = true;
    yapFinishedLoading = false;
    cameFromCropImageScreen = false;
    cameFromPlayerScreen = false;
    cameFromProfileScreen = false;
    exploreScreenFirstLoaded = false;
    playlistScreenFirstLoaded = false;
    yapScreenFirstLoaded = false;
    sessionEmail = nil;
    sessionUsername = nil;
    sessionFirstName = nil;
    sessionLastName = nil;
    sessionPassword = nil;
    sessionPhone = nil;
    sessionCountry = nil;
    sessionUnCroppedPhoto = nil;
    sessionCroppedPhoto = nil;
    sessionUserCroppedPhoto = nil;
    sessionUserUncroppedPhoto = nil;
    
    sharedManager = [MyManager sharedManager];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userProfilePushNotification:) name:@"userProfilePushNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerScreenPushNotification:) name:@"playerScreenPushNotification" object:nil];
    
    if (sharedManager.appLaunchedWithNotification) {
        if ([sharedManager.notificationType isEqualToString:@"profile"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userProfilePushNotification" object:nil userInfo:sharedManager.userInfo];
        }
        else if ([sharedManager.notificationType isEqualToString:@"player"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"playerScreenPushNotification" object:nil userInfo:sharedManager.userInfo];
        }
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"AppLoginData" accessGroup:nil];
    
    secondary_splash_screen.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height);
    
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        if ([UIScreen mainScreen].scale == 2.0) {
            image_secondary_splash_screen.image = [UIImage imageNamed:@"splash-screen-4_@2x.png"];
        }
        else {
            image_secondary_splash_screen.image = [UIImage imageNamed:@"splash-screen-4.png"];
        }
    }
    else {
        image_secondary_splash_screen.image = [UIImage imageNamed:@"splash-screen-5_@2x.png"];
    }
    
    loading.hidden = YES;
    signIn.hidden = YES;
    
    //remove notification icons on startup
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    //padding for username and password text fields
    UIView *fieldEmailOrUsername = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 10)];
    UIView *fieldPassword = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 10)];
    
    emailOrUsername.leftViewMode = UITextFieldViewModeAlways;
    emailOrUsername.leftView     = fieldEmailOrUsername;
    
    [emailOrUsername setBorderStyle:UITextBorderStyleNone];
    emailOrUsername.layer.cornerRadius = 5;
    
    password.leftViewMode = UITextFieldViewModeAlways;
    password.leftView     = fieldPassword;
    
    [password setBorderStyle:UITextBorderStyleNone];
    password.layer.cornerRadius = 5;
    
    [emailOrUsername setBackgroundColor:[UIColor whiteColor]];
    [password setBackgroundColor:[UIColor whiteColor]];
    
    [signIn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [signUp setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    emailOrUsername.delegate = self;
    password.delegate = self;
    
    //if first launch, show the welcome screen
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *booleansDataPath = [documentsDirectory stringByAppendingPathComponent:@"booleans.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: booleansDataPath])
    {
        DLog(@"FIRST");
        
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"booleans" ofType:@"plist"];
        
        [fileManager copyItemAtPath:bundle toPath: booleansDataPath error:&error];
    }
    
    NSMutableDictionary *booleans = [[NSMutableDictionary alloc] initWithContentsOfFile: booleansDataPath];
    
    BOOL is_first_launch = [[booleans objectForKey:@"first_launch"] boolValue];
    
    if (is_first_launch) {
        emailOrUsername.hidden = YES;
        password.hidden = YES;
        userIcon.hidden = YES;
        passwordIcon.hidden = YES;
        border.hidden = YES;
        signIn.hidden = YES;
        signUp.hidden = YES;
        forgotPassword.hidden = YES;
        copy.hidden = YES;
        background.hidden = YES;
        logo.hidden = YES;
        loading.hidden = YES;
        
        launch_screen.backgroundColor = [UIColor colorWithRed:21.0/255.0 green:212.0/255.0 blue:0.0 alpha:1.0];
        launch_screen.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height);
        launch_screen_image.frame = launch_screen.frame;
        
        if ([[UIScreen mainScreen] bounds].size.height != 480) {
            startBtn.frame = CGRectMake(startBtn.frame.origin.x, startBtn.frame.origin.y+60, startBtn.frame.size.width, startBtn.frame.size.height);
        }
        
        launch_screen.hidden = NO;
    }
    else {
        [self start];
    }
}

-(IBAction)start {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *booleansDataPath = [documentsDirectory stringByAppendingPathComponent:@"booleans.plist"];
    
    NSMutableDictionary *booleanData = [[NSMutableDictionary alloc] initWithContentsOfFile:booleansDataPath];
    
    NSNumber *is_first_launch = [[NSNumber alloc] initWithBool:false];
    
    [booleanData setObject:is_first_launch forKey:@"first_launch"];
    
    DLog(@"%@", booleanData);
    
    [booleanData writeToFile:booleansDataPath atomically:YES];
    
    [UIView animateWithDuration:0.3 animations:^() {
        launch_screen.alpha = 0.0;
    }];
    
    emailOrUsername.hidden = NO;
    password.hidden = NO;
    userIcon.hidden = NO;
    passwordIcon.hidden = NO;
    border.hidden = NO;
    signUp.hidden = NO;
    forgotPassword.hidden = NO;
    copy.hidden = NO;
    background.hidden = NO;
    logo.hidden = NO;
    
    //check for screen height, and adjust controls as appropriate
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        logo.frame = CGRectMake(logo.frame.origin.x, 50, logo.frame.size.width, logo.frame.size.height);
        emailOrUsername.frame = CGRectMake(emailOrUsername.frame.origin.x, emailOrUsername.frame.origin.y-35, emailOrUsername.frame.size.width, emailOrUsername.frame.size.height);
        password.frame = CGRectMake(password.frame.origin.x, password.frame.origin.y-35, password.frame.size.width, password.frame.size.height);
        userIcon.frame = CGRectMake(userIcon.frame.origin.x, userIcon.frame.origin.y-35, userIcon.frame.size.width, userIcon.frame.size.height);
        passwordIcon.frame = CGRectMake(passwordIcon.frame.origin.x, passwordIcon.frame.origin.y-35, passwordIcon.frame.size.width, passwordIcon.frame.size.height);
        border.frame = CGRectMake(border.frame.origin.x, border.frame.origin.y-35, border.frame.size.width, border.frame.size.height);
        signIn.frame = CGRectMake(signIn.frame.origin.x, signIn.frame.origin.y-35, signIn.frame.size.width, signIn.frame.size.height);
        signUp.frame = CGRectMake(signUp.frame.origin.x, signUp.frame.origin.y-35, signUp.frame.size.width, signUp.frame.size.height);
        loading.frame = CGRectMake(loading.frame.origin.x, loading.frame.origin.y-35, loading.frame.size.width, loading.frame.size.height);
        forgotPassword.frame = CGRectMake(forgotPassword.frame.origin.x, forgotPassword.frame.origin.y-35, forgotPassword.frame.size.width, forgotPassword.frame.size.height);
        copy.frame = CGRectMake(copy.frame.origin.x, copy.frame.origin.y-70, copy.frame.size.width, copy.frame.size.height);
    }
    else {
        
    }
    
    //give username field focus on startup
    //emailOrUsername.becomeFirstResponder;
    
    //[self createOrOpenDB];
    
    [self doAutomaticLogin];
}

-(void)doAutomaticLogin {
    //AUTOMATIC LOGIN
    //check if user had manually logged out; if not, automatically log in
    token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    if (token) {
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        
        if (networkStatus == NotReachable) {
            
        }
        else {
            //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSError *error;
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            userDataPath = [documentsDirectory stringByAppendingPathComponent:@"userinfo.plist"];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            if (![fileManager fileExistsAtPath: userDataPath])
            {
                DLog(@"FIRST");
                
                NSString *bundle = [[NSBundle mainBundle] pathForResource:@"userinfo" ofType:@"plist"];
                
                [fileManager copyItemAtPath:bundle toPath: userDataPath error:&error];
            }
            
            //read user info data
            NSMutableArray *savedStock = [[NSMutableArray alloc] initWithContentsOfFile: userDataPath];
            
            //NSString *user_id;
            //user_id = [savedStock objectForKey:@"value"];
            
            if (savedStock != nil) {
                if ([savedStock lastObject] != nil) {
                    //do automatic sign up
                    
                    double user_id = [[[savedStock lastObject] valueForKey:@"user_id"] doubleValue];
                    double session_id = [[[savedStock lastObject] valueForKey:@"session_id"] doubleValue];
                    NSString *device_token = [NSString stringWithFormat:@"%@", [[savedStock lastObject] valueForKey:@"device_token"]];
                    
                    if (![device_token isEqualToString:@""]) {
                        NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:user_id];
                        NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:session_id];
                        
                        NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                        tempSessionUserID, @"user_id",
                                                        tempSessionID, @"session_id",
                                                        device_token, @"session_device_token",
                                                        nil];
                        
                        NSError *error;
                        
                        //convert object to data
                        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
                        
                        NSMutableURLRequest *request = [ NSMutableURLRequest requestWithURL: [NSURL URLWithString:@"http://api.yapster.co/api/0.0.1/users/automatic_sign_in/"] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 60.0];
                        
                        [request setHTTPMethod:@"POST"];
                        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                        [request setHTTPBody:jsonData];
                        
                        if (!jsonData) {
                            DLog(@"JSON error: %@", error);
                        } else {
                            NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                            DLog(@"JSON OUTPUT: %@", JSONString);
                            
                        }
                        
                        NSHTTPURLResponse* urlResponse = nil;
                        
                        NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
                        
                        responseBodyAutoSignIn = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                        
                        connection3 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                        
                        [connection3 start];
                        
                        if (connection3) {
                            secondary_splash_screen.hidden = NO;
                            
                            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                            
                            //dispatch_async(dispatch_get_main_queue(), ^(void){
                            [emailOrUsername resignFirstResponder];
                            [password resignFirstResponder];
                            
                            signIn.hidden = YES;
                            signUp.hidden = YES;
                            
                            loading.hidden = NO;
                            
                            [loading startAnimating];
                            
                            //});
                        }
                        else {
                            //Error
                        }
                        
                        DLog(@"%@", savedStock);
                    }
                    else {
                        secondary_splash_screen.hidden = YES;
                        loading.hidden = YES;
                    }
                }
            }
            
            /*
             //check for user in local table
             sqlite3_stmt *statement;
             
             //if (sqlite3_open([dbPathString UTF8String], &user_db) == SQLITE_OK) {
             NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM USERS WHERE DEVICE_TOKEN='%@'", token];
             
             const char *query_sql = [querySql UTF8String];
             
             DLog(@"%@", querySql);
             
             if (sqlite3_prepare(user_db, query_sql, -1, &statement, NULL) == SQLITE_OK) {
             
             int rows = 0;
             
             if (sqlite3_step(statement) == SQLITE_ERROR) {
             NSAssert1(0,@"Error when counting rows  %s",sqlite3_errmsg(user_db));
             }
             else {
             rows = sqlite3_column_int(statement, 0);
             
             DLog(@"SQLite Rows: %i", rows);
             
             if (rows > 0) {
             NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
             NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
             
             //build an info object and convert to json
             NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
             tempSessionUserID, @"user_id",
             tempSessionID, @"session_id",
             token, @"session_device_token",
             nil];
             
             NSError *error;
             
             //convert object to data
             NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
             
             NSMutableURLRequest *request = [ NSMutableURLRequest requestWithURL: [NSURL URLWithString:@"http://api.yapster.co/api/0.0.1/users/sign_in/"] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 60.0];
             
             [request setHTTPMethod:@"POST"];
             [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
             [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
             [request setHTTPBody:jsonData];
             
             if (!jsonData) {
             DLog(@"JSON error: %@", error);
             } else {
             NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
             DLog(@"JSON OUTPUT: %@", JSONString);
             
             }
             
             NSHTTPURLResponse* urlResponse = nil;
             
             NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
             
             responseBody = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
             
             connection3 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
             
             [connection3 start];
             
             if (connection1) {
             [emailOrUsername resignFirstResponder];
             [password resignFirstResponder];
             
             signIn.hidden = YES;
             signUp.hidden = YES;
             
             loading.hidden = NO;
             
             [loading startAnimating];
             }
             else {
             //Error
             }
             }
             }
             }
             else {
             printf( "could not prepare statemnt: %s\n", sqlite3_errmsg(user_db) );
             }
             // }*/
            
            //});
            
        }
    }
}

-(void)createOrOpenDB {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    
    dbPathString = [docPath stringByAppendingPathComponent:@"userdatabase.db"];
    
    const char *dbPath = [dbPathString UTF8String];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dbPathString]) {
        NSData *dataDB = [NSData dataWithContentsOfFile:dbPathString];
        
        [fileManager createFileAtPath:dbPathString contents:dataDB attributes:nil];
        
        if (sqlite3_open(dbPath, &user_db) == SQLITE_OK) {
            DLog(@"DB OPENED 1");
        }
    }
    else {
        if (sqlite3_open(dbPath, &user_db) == SQLITE_OK) {
            DLog(@"DB OPENED 2");
        }
    }
}

-(void)addItemsToTable {
    char *error;
    
    if (sqlite3_open([dbPathString UTF8String], &user_db) == SQLITE_OK) {
        NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO USERS(USER_ID, SESSION_ID, DEVICE_TOKEN) values ('%f', '%f', '%@')", sessionUserID, sessionID, token];
        
        const char *insert_stmt = [insertStmt UTF8String];
        
        if (sqlite3_exec(user_db, insert_stmt, NULL, NULL, &error) == SQLITE_OK) {
            DLog(@"USER ADDED");
        }
        
        sqlite3_close(user_db);
    }
}

-(void)closeDB {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) touchBackground:(id)sender {
    [emailOrUsername resignFirstResponder];
    [password resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return NO;
}

-(IBAction)editFields:(id)sender {
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    NSString *trimmedEmailOrUsername = [emailOrUsername.text stringByTrimmingCharactersInSet:whitespace];
    NSString *trimmedPassword = [password.text stringByTrimmingCharactersInSet:whitespace];
    
    NSUInteger emailOrUsernameLength = [trimmedEmailOrUsername length];
    NSUInteger passwordLength = [trimmedPassword length];
    
    //signIn.layer.shouldRasterize = YES;
    
    [UIView transitionWithView:signIn
                      duration:0.2
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    
    if (emailOrUsernameLength > 0 && passwordLength > 0) {
        signIn.hidden = NO;
    }
    else {
        signIn.hidden = YES;
    }
}

-(void)userProfilePushNotification:(NSNotification *)notification {
    DLog(@"userProfilePushNotification: %@", sharedManager.userInfo);
    
    NSString *notification_type = [sharedManager.userInfo objectForKey:@"notification_type"];
    double user_id = [[sharedManager.userInfo objectForKey:@"profile_user_id"] doubleValue];
    
    UserProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileVC"];
    
    UserProfileVC.userToView = user_id;
    UserProfileVC.cameFromPushNotifications = YES;
    
    if ([notification_type isEqualToString:@"follower_requested"]) {
        UserProfileVC.cameFromNotifications = true;
        UserProfileVC.notification_name = @"follower_requested";
    }
    
    if (sessionUserID == 0) {
        [self doAutomaticLogin];
    }
    else {
        [self.navigationController pushViewController:UserProfileVC animated:YES];
    }
    
}

-(void)playerScreenPushNotification:(NSNotification *)notification {
    DLog(@"playerScreenPushNotification: %@", sharedManager.userInfo);
    
    if (sessionUserID == 0) {
        [self doAutomaticLogin];
    }
    else {
        [self getYapNotificationInfo];
    }
}

-(void)getYapNotificationInfo {
    //get yap notification info
    NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
    NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
    NSNumber *tempObj = [[NSNumber alloc] initWithDouble:[[sharedManager.userInfo objectForKey:@"obj"] doubleValue]];
    
    NSString *obj_type = [sharedManager.userInfo objectForKey:@"obj_type"];
    
    NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    tempSessionUserID, @"user_id",
                                    tempSessionID, @"session_id",
                                    tempObj, @"obj",
                                    obj_type, @"obj_type",
                                    nil];
    
    NSError *error;
    
    //convert object to data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&error];
    
    NSURL *the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/yap/push_notification_object_call/"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:the_url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    
    NSHTTPURLResponse* urlResponse = nil;
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
    
    responseBodyNotification = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    //int responseCode = [urlResponse statusCode];
    
    if (!jsonData) {
        DLog(@"JSON error: %@", error);
    }
    else {
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        DLog(@"JSON: %@", JSONString);
    }
    
    connection5 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [connection5 start];
    
    if (connection5) {
        
    }
    else {
        //Error
    }
}

-(IBAction)login:(id)sender {
    //authenticate user log in
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    NSString *trimmedEmailOrUsername = [emailOrUsername.text stringByTrimmingCharactersInSet:whitespace];
    NSString *trimmedPassword = [password.text stringByTrimmingCharactersInSet:whitespace];
    NSString *device_token = [NSString stringWithFormat:@"%@", token];
    
    //check if username or email
    BOOL isEmail;
    
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if  ([emailTest evaluateWithObject:trimmedEmailOrUsername] != YES && [trimmedEmailOrUsername length]!=0)
    {
        isEmail = NO;
    }
    else {
        isEmail = YES;
    }
    
    NSString *option_type;
    
    if (isEmail) {
        option_type = @"email";
    }
    else {
        option_type = @"username";
    }
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"There seems to be no internet connection on your device." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert
         show];
    } else {
        //build an info object and convert to json
        NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        trimmedEmailOrUsername, @"option",
                                        option_type, @"option_type",
                                        trimmedPassword, @"password",
                                        device_token, @"session_device_token",
                                        nil];
        
        //NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:trimmedEmailOrUsername, @"option", option_type, @"option_type", trimmedPassword, @"password", nil];
        
        NSError *error;
        
        //convert object to data
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
        
        //NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/users/signin/"];
        
        NSMutableURLRequest *request = [ NSMutableURLRequest requestWithURL: [NSURL URLWithString:@"http://api.yapster.co/api/0.0.1/users/sign_in/"] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 60.0];
        
        //[request setTimeoutInterval:20.0];
        //[request setURL:the_url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPBody:jsonData];
        
        if (!jsonData) {
            DLog(@"JSON error: %@", error);
        } else {       
            NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
            DLog(@"JSON OUTPUT: %@", JSONString);
            
        }
        
        NSHTTPURLResponse* urlResponse = nil;
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
        
        responseBody = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        connection1 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        [connection1 start];
        
        //NSString *getDataUrl = [NSString stringWithFormat:@"http://api.yapster.co/api/0.0.1/users/signin/?option=%@&option_type=%@&password=%@", trimmedEmailOrUsername, option_type, trimmedPassword];
        
        //DLog(@"%@", getDataUrl);
        
        //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:getDataUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
        
        
        /*NSString *getDataUrl = [NSString stringWithFormat:@"http://api.yapster.co/api/0.0.1/users/signin/?option=%@&option_type=%@&password=%@", trimmedEmailOrUsername, option_type, trimmedPassword];
        
        NSURL *the_url = [[NSURL alloc] initWithString:getDataUrl];
        
        dispatch_async(kBgQueue, ^{
            NSData* data = [NSData dataWithContentsOfURL:
                            the_url];
            DLog(@"%@", data);
            [self performSelectorOnMainThread:@selector(fetchedData:)
                                   withObject:data waitUntilDone:YES];
        });
        */
        
        //option=ryan&option_type=username&password=some_sha1_hashed_password
        
        if (connection1) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            
            [emailOrUsername resignFirstResponder];
            [password resignFirstResponder];
            
            signIn.hidden = YES;
            signUp.hidden = YES;
            
            loading.hidden = NO;
            
            [loading startAnimating];
        }
        else {
            //Error
        }
    }
}

-(void)connection:(NSURLConnection *) connection didReceiveData:(NSData *)data {
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

-(void)connectionDidFinishLoading:(NSURLConnection *) connection {
    if (connection == connection1) {
        userInfoArray = [[NSMutableArray alloc] init];
        
        NSData *data = [responseBody dataUsingEncoding:NSUTF8StringEncoding];
        
        json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if (json.count > 0) {
            BOOL valid = [[json objectForKey:@"valid"] doubleValue];
            int uID = [[json objectForKey:@"user_id"] intValue];
            int session_id = [[json objectForKey:@"session_id"] intValue];
            
            if (valid) {
                sessionUserID = uID;
                sessionID = session_id;
                
                NSNumber *tempSessionUserId = [[NSNumber alloc] initWithInt:sessionUserID];
                NSNumber *tempSessionId = [[NSNumber alloc] initWithInt:sessionID];
                
                [keychain setObject:[emailOrUsername text] forKey:(__bridge id)kSecAttrAccount];
                [keychain setObject:[password text] forKey:(__bridge id)kSecValueData];
                
                //DLog(@"%f", sessionID);
                
                //get user profile info
                //build an info object and convert to json
                NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                tempSessionUserId, @"user_id",
                                                tempSessionUserId, @"profile_user_id",
                                                tempSessionId, @"session_id",
                                                nil];
                
                NSError *error;
                
                //convert object to data
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
                
                NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/users/profile/info/"];
                
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                [request setURL:the_url];
                [request setHTTPMethod:@"POST"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setHTTPBody:jsonData];
                
                if (!jsonData) {
                    DLog(@"JSON error: %@", error);
                } else {
                    NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                    DLog(@"JSON OUTPUT: %@", JSONString);
                }
                
                NSHTTPURLResponse* urlResponse = nil;
                
                NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
                
                responseBody = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                
                connection2 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                
                [connection2 start];
                
                if (connection2) {
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                }
                else {
                    //Error
                }
            }
            else {
                secondary_splash_screen.hidden = YES;
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Username/password is invalid. Please try again." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
                
                loading.hidden = YES;
                signIn.hidden = NO;
                signUp.hidden = NO;
            }
        }
        else {
            secondary_splash_screen.hidden = YES;
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Username/password is invalid. Please try again." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            
            loading.hidden = YES;
            [loading stopAnimating];
            
            signIn.hidden = NO;
            signUp.hidden = NO;
            
            [emailOrUsername resignFirstResponder];
            [password resignFirstResponder];
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    else if (connection == connection2) {
        NSDictionary *user;
        NSDictionary *user_country;
        
        NSData *data = [responseBody dataUsingEncoding:NSUTF8StringEncoding];
        
        json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        user = [json objectForKey:@"user"];
        user_country = [json objectForKey:@"user_country"];
        
        NSString *first_name = [user objectForKey:@"first_name"];
        NSString *last_name = [user objectForKey:@"last_name"];
        NSString *username = [user objectForKey:@"username"];
        NSString *country;
        BOOL profile_picture_cropped_flag = [[json objectForKey:@"profile_picture_cropped_flag"] boolValue];
        NSString *profile_picture_cropped_path = [json objectForKey:@"profile_picture_cropped_path"];
        BOOL profile_picture_flag = [[json objectForKey:@"profile_picture_flag"] boolValue];
        NSString *profile_picture_path = [json objectForKey:@"profile_picture_path"];
        
        if (![user_country isKindOfClass:[NSNull class]]) {
            country = [user_country objectForKey:@"country_name"];
        }
        
        sessionFirstName = first_name;
        sessionLastName = last_name;
        sessionUsername = username;
        sessionCountry = country;
        
        DLog(@"%@", sessionFirstName);
        DLog(@"%@", sessionLastName);
        
        if (profile_picture_cropped_flag) {
            //get cropped user profile photo
            NSString *bucket = @"yapsterapp";
            S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
            
            //dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            //dispatch_async(queue, ^{
                
                //get profile photo
                S3GetPreSignedURLRequest *gpsur_cropped_photo = [[S3GetPreSignedURLRequest alloc] init];
                gpsur_cropped_photo.key     = profile_picture_cropped_path;
                gpsur_cropped_photo.bucket  = bucket;
                gpsur_cropped_photo.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];
                gpsur_cropped_photo.responseHeaderOverrides = override;
                
                NSURL *url_cropped_photo = [[AmazonClientManager s3] getPreSignedURL:gpsur_cropped_photo];
                
                NSData *data_cropped_photo = [NSData dataWithContentsOfURL:url_cropped_photo];
                
                UIImage *cropped_photo = [UIImage imageWithData:data_cropped_photo];
                
                //dispatch_async(dispatch_get_main_queue(), ^{
                    sessionUserCroppedPhoto = cropped_photo;
                //});
            //});
        }
            
        if (profile_picture_flag) {
            //get big user profile photo
            NSString *bucket = @"yapsterapp";
            S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
            
            //dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            //dispatch_async(queue, ^{
                
                //get profile photo
                S3GetPreSignedURLRequest *gpsur_uncropped_photo = [[S3GetPreSignedURLRequest alloc] init];
                gpsur_uncropped_photo.key     = profile_picture_path;
                gpsur_uncropped_photo.bucket  = bucket;
                gpsur_uncropped_photo.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];
                gpsur_uncropped_photo.responseHeaderOverrides = override;
                
                NSURL *url_uncropped_photo = [[AmazonClientManager s3] getPreSignedURL:gpsur_uncropped_photo];
                
                NSData *data_uncropped_photo = [NSData dataWithContentsOfURL:url_uncropped_photo];
                
                UIImage *uncropped_photo = [UIImage imageWithData:data_uncropped_photo];
                
                //dispatch_async(dispatch_get_main_queue(), ^{
                    sessionUserUncroppedPhoto = uncropped_photo;
            
                    //UIImageWriteToSavedPhotosAlbum(sessionUserUncroppedPhoto, nil, nil, nil);
                    //UIImageWriteToSavedPhotosAlbum(sessionUserCroppedPhoto, nil, nil, nil);
                //});
            //});
        }
        
        //save data to userinfo.plist (for use later with automatic login)
        NSDictionary *innerDict;
        
        innerDict = [[NSDictionary alloc] init];
        
        NSMutableArray *plistData = [[NSMutableArray alloc] init];
        
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
        
        NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
        NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
        
        [userInfo setObject:tempSessionUserID forKey:@"user_id"];
        [userInfo setObject:tempSessionID forKey:@"session_id"];
        [userInfo setObject:token forKey:@"device_token"];
        
        [plistData addObject:userInfo];
        
        DLog(@"%@", plistData);
        
        [plistData writeToFile:userDataPath atomically:YES];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (!sharedManager.appLaunchedWithNotification) {
            stream = [self.storyboard instantiateViewControllerWithIdentifier:@"Stream"];
        
            //self.stream = streamFeed;
            
            //Push to next view controller
            [self.navigationController pushViewController:stream animated:YES];
        }
        else {
            if ([sharedManager.notificationType isEqualToString:@"profile"]) {
                NSString *notification_type = [sharedManager.userInfo objectForKey:@"notification_type"];
                double user_id = [[sharedManager.userInfo objectForKey:@"profile_user_id"] doubleValue];
                
                UserProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileVC"];
                
                UserProfileVC.userToView = user_id;
                UserProfileVC.cameFromPushNotifications = YES;
                
                if ([notification_type isEqualToString:@"follower_requested"]) {
                    UserProfileVC.cameFromNotifications = true;
                    UserProfileVC.notification_name = @"follower_requested";
                }
                
                [self.navigationController pushViewController:UserProfileVC animated:YES];
            }
            else if ([sharedManager.notificationType isEqualToString:@"player"]) {
                [self getYapNotificationInfo];
            }
        }
    }
    else if (connection == connection3) {
        userInfoArray = [[NSMutableArray alloc] init];
        
        NSData *data = [responseBodyAutoSignIn dataUsingEncoding:NSUTF8StringEncoding];
        
        json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        DLog(@"%@", json);
        
        if (json.count > 0) {
            BOOL valid = [[json objectForKey:@"valid"] doubleValue];
            int uID = [[json objectForKey:@"user_id"] intValue];
            int session_id = [[json objectForKey:@"session_id"] intValue];
            
            if (valid) {
                sessionUserID = uID;
                sessionID = session_id;
                
                NSNumber *tempSessionUserId = [[NSNumber alloc] initWithInt:sessionUserID];
                NSNumber *tempSessionId = [[NSNumber alloc] initWithInt:sessionID];
                
                //DLog(@"%f", sessionID);
                
                //get user profile info
                //build an info object and convert to json
                NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                tempSessionUserId, @"user_id",
                                                tempSessionUserId, @"profile_user_id",
                                                tempSessionId, @"session_id",
                                                nil];
                
                NSError *error;
                
                //convert object to data
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
                
                NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/users/profile/info/"];
                
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                [request setURL:the_url];
                [request setHTTPMethod:@"POST"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setHTTPBody:jsonData];
                
                if (!jsonData) {
                    DLog(@"JSON error: %@", error);
                } else {
                    NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                    DLog(@"JSON OUTPUT: %@", JSONString);
                }
                
                NSHTTPURLResponse* urlResponse = nil;
                
                NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
                
                responseBody = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                
                connection2 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                
                [connection2 start];
                
                if (connection2) {
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                }
                else {
                    //Error
                }
            }
            else {
                /*
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Session expired. Please sign in again." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
                
                loading.hidden = YES;
                [loading stopAnimating];
                
                signIn.hidden = NO;
                signUp.hidden = NO;
                
                [emailOrUsername resignFirstResponder];
                [password resignFirstResponder];*/
                
                //get new session_id by signing in
                NSString *username = [keychain objectForKey:(__bridge id)kSecAttrAccount];
                NSString *password2 = [keychain objectForKey:(__bridge id)kSecValueData];
                NSString *device_token = [NSString stringWithFormat:@"%@", token];
                
                //build an info object and convert to json
                NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                username, @"option",
                                                @"username", @"option_type",
                                                password2, @"password",
                                                device_token, @"session_device_token",
                                                nil];
                
                //NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:trimmedEmailOrUsername, @"option", option_type, @"option_type", trimmedPassword, @"password", nil];
                
                NSError *error;
                
                //convert object to data
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
                
                //NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/users/signin/"];
                
                NSMutableURLRequest *request = [ NSMutableURLRequest requestWithURL: [NSURL URLWithString:@"http://api.yapster.co/api/0.0.1/users/sign_in/"] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 60.0];
                
                //[request setTimeoutInterval:20.0];
                //[request setURL:the_url];
                [request setHTTPMethod:@"POST"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setHTTPBody:jsonData];
                
                if (!jsonData) {
                    DLog(@"JSON error: %@", error);
                } else {
                    NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                    DLog(@"JSON OUTPUT: %@", JSONString);
                    
                }
                
                NSHTTPURLResponse* urlResponse = nil;
                
                NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
                
                responseBodyAutoSignIn = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                
                connection4 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                
                [connection4 start];
            }
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Session expired. Please sign in again." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            
            secondary_splash_screen.hidden = YES;
            
            loading.hidden = YES;
            [loading stopAnimating];
            
            signIn.hidden = YES;
            signUp.hidden = NO;
            
            [emailOrUsername resignFirstResponder];
            [password resignFirstResponder];
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    else if (connection == connection4) {
        userInfoArray = [[NSMutableArray alloc] init];
        
        NSData *data = [responseBodyAutoSignIn dataUsingEncoding:NSUTF8StringEncoding];
        
        json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        DLog(@"%@", json);
        
        if (json.count > 0) {
            BOOL valid = [[json objectForKey:@"valid"] doubleValue];
            int uID = [[json objectForKey:@"user_id"] intValue];
            int session_id = [[json objectForKey:@"session_id"] intValue];
            
            if (valid) {
                sessionUserID = uID;
                sessionID = session_id;
                
                NSNumber *tempSessionUserId = [[NSNumber alloc] initWithInt:sessionUserID];
                NSNumber *tempSessionId = [[NSNumber alloc] initWithInt:sessionID];
                
                //DLog(@"%f", sessionID);
                
                //get user profile info
                //build an info object and convert to json
                NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                tempSessionUserId, @"user_id",
                                                tempSessionUserId, @"profile_user_id",
                                                tempSessionId, @"session_id",
                                                nil];
                
                NSError *error;
                
                //convert object to data
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
                
                NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/users/profile/info/"];
                
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                [request setURL:the_url];
                [request setHTTPMethod:@"POST"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setHTTPBody:jsonData];
                
                if (!jsonData) {
                    DLog(@"JSON error: %@", error);
                } else {
                    NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                    DLog(@"JSON OUTPUT: %@", JSONString);
                }
                
                NSHTTPURLResponse* urlResponse = nil;
                
                NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
                
                responseBody = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                
                connection2 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                
                [connection2 start];
                
                if (connection2) {
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                }
                else {
                    //Error
                }
            }
            else {
                secondary_splash_screen.hidden = YES;
                
                loading.hidden = YES;
                [loading stopAnimating];
                
                signIn.hidden = YES;
                signUp.hidden = NO;
                
                [emailOrUsername resignFirstResponder];
                [password resignFirstResponder];
            }
        }
        else {
            secondary_splash_screen.hidden = YES;
            
            loading.hidden = YES;
            [loading stopAnimating];
            
            signIn.hidden = NO;
            signUp.hidden = NO;
            
            [emailOrUsername resignFirstResponder];
            [password resignFirstResponder];
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    else if (connection == connection5) {
        NSData *data = [responseBodyNotification dataUsingEncoding:NSUTF8StringEncoding];
        
        json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSDictionary *object_info;
        NSDictionary *yap_info;
        NSDictionary *user;
        NSDictionary *channel;
        NSDictionary *reyap_user_dic;
        //NSDictionary *actual_value;

        if (json.count > 0) {
            object_info = [json objectForKey:@"object_info"];
            yap_info = [json objectForKey:@"yap_info"];
            user = [yap_info objectForKey:@"user"];
            reyap_user_dic = [object_info objectForKey:@"reyap_user"];
            
            //create feed object
            BOOL liked_by_viewer = [[object_info objectForKey:@"liked_by_viewer"] boolValue];
            double user_post_id = [[json objectForKey:@"user_post_id"] doubleValue];
            //DLog(@"after: %d", user_post_id);
            int like_count = [[yap_info objectForKey:@"like_count"] intValue];
            int reyap_count = [[yap_info objectForKey:@"reyap_count"] intValue];
            NSArray *group;
            if (![[yap_info objectForKey:@"channel"] isKindOfClass:[NSNull class]]) {
                channel = [yap_info objectForKey:@"channel"];
                group = [[NSArray alloc] initWithObjects:channel, nil];
            }
            double google_plus_account_id = 0;
            if (![[yap_info objectForKey:@"google_plus_account_id"] isKindOfClass:[NSNull class]]) {
                google_plus_account_id = [[yap_info objectForKey:@"google_plus_account_id"]
                                          doubleValue];
            }
            double facebook_account_id = 0;
            if (![[yap_info objectForKey:@"facebook_account_id"] isKindOfClass:[NSNull class]]) {
                facebook_account_id = [[yap_info objectForKey:@"facebook_account_id"] doubleValue];
            }
            double twitter_account_id = 0;
            if (![[yap_info objectForKey:@"twitter_account_id"] isKindOfClass:[NSNull class]]) {
                twitter_account_id = [[yap_info objectForKey:@"twitter_account_id"] doubleValue];
            }
            double linkedin_account_id = 0;
            if (![[yap_info objectForKey:@"linkedin_account_id"] isKindOfClass:[NSNull class]]) {
                linkedin_account_id = [[yap_info objectForKey:@"linkedin_account_id"] doubleValue];
            }
            
            BOOL reyapped_by_viewer = [[object_info objectForKey:@"reyapped_by_viewer"] boolValue];
            BOOL group_flag = [[yap_info objectForKey:@"channel_flag"] boolValue];
            BOOL listened_by_viewer = [[object_info objectForKey:@"listened_by_viewer"] boolValue];
            BOOL hashtags_flag = [[yap_info objectForKey:@"hashtags_flag"] boolValue];
            BOOL is_deleted = [[yap_info objectForKey:@"is_deleted"] boolValue];
            BOOL linkedin_shared_flag = [[yap_info objectForKey:@"linkedin_shared_flag"] boolValue];
            BOOL facebook_shared_flag = [[yap_info objectForKey:@"facebook_shared_flag"] boolValue];
            BOOL twitter_shared_flag = [[yap_info objectForKey:@"twitter_shared_flag"] boolValue];
            BOOL google_plus_shared_flag = [[yap_info objectForKey:@"google_plus_shared_flag"] boolValue];
            BOOL user_tags_flag = [[yap_info objectForKey:@"user_tags_flag"] boolValue];
            BOOL web_link_flag = [[yap_info objectForKey:@"web_link_flag"] boolValue];
            BOOL picture_flag = [[yap_info objectForKey:@"picture_flag"] boolValue];
            BOOL picture_cropped_flag = [[yap_info objectForKey:@"picture_cropped_flag"] boolValue];
            BOOL is_active = [[yap_info objectForKey:@"is_active"] boolValue];
            int listen_count = [[yap_info objectForKey:@"listen_count"] intValue];
            NSString *reyap_user;
            
            if (![reyap_user_dic isKindOfClass:[NSNull class]]) {
                reyap_user = [reyap_user_dic objectForKey:@"username"];
            }
            else {
                reyap_user = @"";
            }
            
            NSString *latitude = [yap_info objectForKey:@"latitude"];
            NSString *longitude = [yap_info objectForKey:@"longitude"];
            NSString *yap_longitude = [yap_info objectForKey:@"longitude"];
            NSString *username = [user objectForKey:@"username"];
            NSString *first_name = [user objectForKey:@"first_name"];
            NSString *last_name = [user objectForKey:@"last_name"];
            NSString *picture_path = [yap_info objectForKey:@"picture_path"];
            NSString *picture_cropped_path = [yap_info objectForKey:@"picture_cropped_path"];
            NSString *profile_picture_path = [user objectForKey:@"profile_picture_path"];
            NSString *profile_cropped_picture_path = [user objectForKey:@"profile_cropped_picture_path"];
            NSString *web_link = [yap_info objectForKey:@"web_link"];
            NSString *yap_length = [yap_info objectForKey:@"length"];
            double user_id = [[user objectForKey:@"id"] doubleValue];
            double reyap_user_id = 0;
            double yap_id = [[yap_info objectForKey:@"yap_id"] doubleValue];
            double reyap_id = 0;
            
            if (![reyap_user isEqualToString:@""]) {
                reyap_id = [[object_info objectForKey:@"reyap_id"] doubleValue];
                reyap_user_id = [[reyap_user_dic objectForKey:@"id"] doubleValue];
            }
            
            NSString *yap_title = [yap_info objectForKey:@"title"];
            NSString *audio_path = [yap_info objectForKey:@"audio_path"];
            NSArray *user_tags = [yap_info objectForKey:@"user_tags"];
            NSArray *hashtags = [yap_info objectForKey:@"hashtags"];
            NSDate *post_date_created = [object_info objectForKey:@"date_created"];
            NSDate *yap_date_created = [yap_info objectForKey:@"date_created"];
            
            Feed *UserActualFeedObject = [[Feed alloc] initWithYapId: (int) yap_id andReyapId: (double) reyap_id andUserPostId: (double) user_post_id andLikedByViewer: (BOOL) liked_by_viewer andReyapUser: (NSString *) reyap_user andLikeCount: (int) like_count andReyapCount: (int) reyap_count andGroup: (NSArray *) group andGooglePlusAccountId: (double) google_plus_account_id andFacebookAccountId: (double) facebook_account_id andTwitterAccountId: (double) twitter_account_id andLinkedinAccountId: (double) linkedin_account_id andReyappedByViewer: (BOOL) reyapped_by_viewer andListenedByViewer: (BOOL) listened_by_viewer andHashtagsFlag: (BOOL) hashtags_flag andLinkedinSharedFlag: (BOOL) linkedin_shared_flag andFacebookSharedFlag: (BOOL) facebook_shared_flag andTwitterSharedFlag: (BOOL) twitter_shared_flag andGooglePlusSharedFlag: (BOOL) google_plus_shared_flag andUserTagsFlag: (BOOL) user_tags_flag andWebLinkFlag: (BOOL) web_link_flag andPictureFlag: (BOOL) picture_flag andPictureCroppedFlag: (BOOL) picture_cropped_flag andIsActive: (BOOL) is_active andGroupFlag: (BOOL) group_flag andIsDeleted: (BOOL) is_deleted andListenCount: (int) listen_count andLatitude: (NSString *) latitude andLongitude: (NSString *) longitude andYapLongitude: (NSString *) yap_longitude andUsername: (NSString *) username andFirstName: (NSString *) first_name andLastName: (NSString *) last_name andPicturePath: (NSString *) picture_path andPictureCroppedPath: (NSString *) picture_cropped_path andProfilePicturePath: (NSString *) profile_picture_path andProfileCroppedPicturePath: (NSString *) profile_cropped_picture_path andWebLink: (NSString *) web_link andYapLength: (NSString *) yap_length andUserId: (double) user_id andReyapUserId: (double) reyap_user_id andYapTitle: (NSString *) yap_title andAudioPath: (NSString *) audio_path andUserTags: (NSArray *) user_tags andHashtags: (NSArray *) hashtags andPostDateCreated: (NSDate *) post_date_created andYapDateCreated: (NSDate *) yap_date_created];
            
            playerScreenVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayerScreenVC"];
            
            Feed *userFeedData = UserActualFeedObject;
            
            NSString *dateString;
            
            dateString = [NSString stringWithFormat:@"%@", userFeedData.yap_date_created];
            
            if ([dateString rangeOfString:@"T"].location != NSNotFound) {
                dateString = [dateString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            }
            
            if ([dateString rangeOfString:@"."].location != NSNotFound) {
                NSRange range = [dateString rangeOfString:@"."];
                
                dateString = [dateString substringToIndex:range.location];
            }
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //// here set format of date which is in your output date (means above str with format)
            
            NSDate *date = [dateFormatter dateFromString: dateString]; // here you can fetch date from string with define format
            
            NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
            //NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            [formatter setTimeZone:sourceTimeZone];
            
            NSDate* sourceDate = [NSDate date];
            
            NSString *timeStamp = [formatter stringFromDate:sourceDate];
            
            NSDate *destinationDateToday = [formatter dateFromString:timeStamp];
            
            NSDate *destinationDatePost = [formatter dateFromString:dateString];
            
            NSString *dateStringToday = [formatter stringFromDate:destinationDateToday];
            NSString *dateStringThen =  [formatter stringFromDate:destinationDatePost];
            
            NSDate *startDate = [formatter dateFromString:dateStringThen];
            NSDate *endDate = [formatter dateFromString:dateStringToday];
            
            NSDateComponents *minutesComponent = [[NSCalendar currentCalendar]
                                                  components:NSMinuteCalendarUnit
                                                  fromDate:startDate
                                                  toDate:endDate
                                                  options:0];
            NSDateComponents *hoursComponent = [[NSCalendar currentCalendar]
                                                components:NSHourCalendarUnit
                                                fromDate:startDate
                                                toDate:endDate
                                                options:0];
            NSDateComponents *daysComponent = [[NSCalendar currentCalendar]
                                               components:NSDayCalendarUnit
                                               fromDate:startDate
                                               toDate:endDate
                                               options:0];
            
            
            long timeDiffMins = [minutesComponent minute];
            long timeDiffHours = [hoursComponent hour];
            long timeDiffDays = [daysComponent day];
            
            NSString *convertedString;
            
            if (timeDiffDays >= 1) {
                dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"M/d/yyyy"];// here set format which you want...
                
                convertedString = [dateFormatter stringFromDate:date];
            }
            else if (timeDiffHours >= 1 && timeDiffDays < 1) {
                if (timeDiffHours > 1) {
                    convertedString = [NSString stringWithFormat:@"%li hrs ago", timeDiffHours];
                }
                else if (timeDiffHours == 1) {
                    convertedString = [NSString stringWithFormat:@"%li hr ago", timeDiffHours];
                }
            }
            else if (timeDiffMins >= 1 && timeDiffHours < 1) {
                if (timeDiffMins > 1) {
                    convertedString = [NSString stringWithFormat:@"%li mins ago", timeDiffMins];
                }
                else if (timeDiffMins == 1) {
                    convertedString = [NSString stringWithFormat:@"%li min ago", timeDiffMins];
                }
            }
            else if (timeDiffMins < 1) {
                convertedString = @"Just now";
            }
            
            playerScreenVC.yap_to_play = userFeedData.yap_id;
            
            if ([userFeedData.reyap_user isEqualToString:@""]) {
                playerScreenVC.object_type = @"yap";
                playerScreenVC.reyap_username_value = @"";
            }
            else {
                playerScreenVC.object_type = @"reyap";
                playerScreenVC.isReyap = YES;
                playerScreenVC.reyap_username_value = [NSString stringWithFormat:@"%@", userFeedData.reyap_user];
                playerScreenVC.reyap_user_id = userFeedData.reyap_user_id;
                playerScreenVC.reyap_id = userFeedData.reyap_id;
            }
            
            if (userFeedData.liked_by_viewer) {
                playerScreenVC.likedByViewer = YES;
            }
            
            playerScreenVC.cameFrom = @"user_notifications";
            playerScreenVC.reyappedByViewer = userFeedData.reyapped_by_viewer;
            playerScreenVC.user_id = userFeedData.user_id;
            playerScreenVC.yap_audio_path = userFeedData.audio_path;
            playerScreenVC.yap_picture_flag = userFeedData.picture_flag;
            playerScreenVC.yap_picture_path = userFeedData.picture_path;
            playerScreenVC.yap_picture_cropped_flag = userFeedData.picture_cropped_flag;
            playerScreenVC.yap_picture_cropped_path = userFeedData.picture_cropped_path;
            
            if (![userFeedData.profile_cropped_picture_path isEqualToString:@""]) {
                playerScreenVC.user_profile_picture_cropped_path = userFeedData.profile_cropped_picture_path;
            }
            
            playerScreenVC.web_link_flag = userFeedData.web_link_flag;
            playerScreenVC.web_link = userFeedData.web_link;
            playerScreenVC.name_value = [NSString stringWithFormat:@"%@ %@", userFeedData.first_name, userFeedData.last_name];
            playerScreenVC.username_value = [NSString stringWithFormat:@"%@", userFeedData.username];
            playerScreenVC.yap_title_value = [NSString stringWithFormat:@"%@", userFeedData.title];
            playerScreenVC.hashtags_flag = userFeedData.hashtags_flag;
            playerScreenVC.hashtags_array = userFeedData.hashtags;
            playerScreenVC.user_tags_flag = userFeedData.user_tags_flag;
            playerScreenVC.userstag_array = userFeedData.user_tags;
            playerScreenVC.yap_date_value = convertedString;
            playerScreenVC.yap_plays_value = userFeedData.listen_count+1;
            playerScreenVC.yap_reyaps_value = userFeedData.reyap_count;
            playerScreenVC.yap_likes_value = userFeedData.like_count;
            playerScreenVC.yap_length_value = [userFeedData.yap_length intValue];
            
            playerScreenVC.isSingleYap = true;
            playerScreenVC.cameFromPushNotifications = true;
            
            //Push to controller
            [self.navigationController pushViewController:playerScreenVC animated:YES];
        }
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Failed to connect." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    secondary_splash_screen.hidden = YES;
    
    loading.hidden = YES;
    [loading stopAnimating];
    
    signIn.hidden = YES;
    signUp.hidden = NO;
    
    [emailOrUsername resignFirstResponder];
    [password resignFirstResponder];
}

-(IBAction)goToSignUp:(id)sender {
    SignUp *registerScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpVC"];
    
    self.registerVC = registerScreen;
    
    //Push to User Settings controller
    [self.navigationController pushViewController:registerScreen animated:YES];
}

-(IBAction)goToForgotPassword:(id)sender {
    ForgotPassword *forgotPasswordScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordVC"];
    
    self.forgotPasswordVC = forgotPasswordScreen;
    
    //Push to User Settings controller
    [self.navigationController pushViewController:forgotPasswordScreen animated:YES];
}

@end
