//
//  EditProfile.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 5/3/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "EditProfile.h"
#import "UserProfile.h"

@interface EditProfile ()

@end

@implementation EditProfile

@synthesize facebookLoginView;
@synthesize has_state;
@synthesize user_country_id;
@synthesize user_us_states_id;
@synthesize cropPhotoForYapVC;
@synthesize UserProfileVC;
@synthesize json;
@synthesize connection1;
@synthesize connection2;
@synthesize connection3;
@synthesize connection4;
@synthesize connection5;
@synthesize connection6;
@synthesize connection7;
@synthesize connection8;
@synthesize countriesList;
@synthesize countriesArray;
@synthesize onlyCountriesArray;
@synthesize citiesList;
@synthesize citiesArray;
@synthesize statesList;
@synthesize statesArray;
@synthesize responseBodyCountries;
@synthesize responseBodyCities;
@synthesize responseBodyStates;
@synthesize userProfileResponseBody;
@synthesize CountryPickerField;
@synthesize CityPickerField;
@synthesize StatePickerField;
@synthesize bigPicturePath;
@synthesize smallPicturePath;

#define ACCEPTABLE_USERNAME_CHARACTERS @"abcdefghijklmnopqrstuvwxyz0123456789_."

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    scrollView.hidden = YES;
	
    [scrollView setScrollEnabled:YES];
    
    [scrollView setContentSize:CGSizeMake(320,640)];
    
    [self registerForKeyboardNotifications];
    
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    cameFromCropImageScreen = false;
    
    retypePasswordView.hidden = YES;
    currentPasswordView.hidden = YES;
    
    keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"AppLoginData" accessGroup:nil];
    
    DLog(@"current password: %@", [keychain objectForKey:(__bridge id)kSecValueData]);
    
    current_password = [keychain objectForKey:(__bridge id)kSecValueData];
    
    for (id obj in facebookLoginView.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
            
        {
            UIButton * loginButton = obj;
            
            UIImage *loginImage;
            
            UIImage *login;
            
            loginImage = [UIImage imageNamed:@"bttn_facebook.png"];
            
            login = [UIImage imageNamed:@"bttn_facebook.png"];
            
            [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
            
            [loginButton setBackgroundImage:login forState:UIControlStateHighlighted];
            // [loginButton setBackgroundImage:nil forState:UIControlStateSelected];.
            
            loginButton.frame = facebookLoginBtn.frame;
            
            //[loginButton sizeToFit];
        }
        
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel = obj;
            
            loginLabel.text = @"";
            
            [loginLabel removeFromSuperview];
            // loginLabel.textAlignment = UITextAlignmentCenter;.
            // loginLabel.frame = CGRectMake(0, 0, 271, 37);.
        }
    }
    
    UIView *rightFieldDescBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 0)];
    
    description.rightViewMode = UITextFieldViewModeAlways;
    description.rightView    = rightFieldDescBox;
    
    //populate abbreviated countries list (for use later with validation)
    countriesArray = [[NSMutableArray alloc] initWithArray:nil];
    onlyCountriesArray = [[NSMutableArray alloc] initWithArray:nil];
    
    //check for screen height, and adjust controls as appropriate
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        scrollView.frame = CGRectMake(0, 126, scrollView.frame.size.width, 450);
    }
    else {
        scrollView.frame = CGRectMake(0, 126, scrollView.frame.size.width, 540);
    }
    
    loading.hidden = YES;
    
    username.delegate = self;
    password.delegate = self;
    retypePassword.delegate = self;
    currentPassword.delegate = self;
    firstName.delegate = self;
    lastName.delegate = self;
    email.delegate = self;
    city.delegate = self;
    zipcode.delegate = self;
    phone.delegate = self;
    description.delegate = self;
    email.delegate = self;
    
    UIDatePicker *DOBPicker = [[UIDatePicker alloc]init];
    
    UIColor *white = [UIColor whiteColor];
    
    [DOBPicker setBackgroundColor:white];
    
    [DOBPicker setDate:[NSDate date]];
    
    [DOBPicker setDatePickerMode:UIDatePickerModeDate];
    
    [DOBPicker addTarget:self action:@selector(DOBDidBeginEditing:) forControlEvents:UIControlEventValueChanged];
    [DOB setInputView:DOBPicker];
}

- (void)viewWillAppear:(BOOL)animated {
    if (sessionCroppedPhoto != nil) {
        [userPhotoBtn.layer setBorderColor:[UIColor clearColor].CGColor];
        [userPhotoBtn.layer masksToBounds];
        
        CALayer *imageLayer = userPhotoBtn.layer;
        [imageLayer setCornerRadius:userPhotoBtn.frame.size.width/2];
        [imageLayer setBorderWidth:0.0];
        [imageLayer setMasksToBounds:YES];
        
        [userPhotoBtn setBackgroundImage:sessionCroppedPhoto forState:UIControlStateNormal];
    }
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    if (!cameFromCropImageScreen) {
        NSError *error;
        
        //load user settings
        NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
        NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
        
        NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        tempSessionUserID, @"user_id",
                                        tempSessionID, @"session_id",
                                        nil];
        
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
        
        NSURL *the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/users/profile/load/"];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:the_url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPBody:jsonData];
        
        NSHTTPURLResponse* urlResponse = nil;
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
        
        userProfileResponseBody = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        if (!jsonData) {
            DLog(@"JSON error: %@", error);
        }
        
        connection1 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        [connection1 start];
        
        if (connection1) {
            
        }
        else {
            //Error
        }
        
        //get countries
        NSString *getDataUrl2 = @"http://api.yapster.co/api/0.0.1/location/countries/load/";
        
        NSURLRequest *request2 = [NSURLRequest requestWithURL:[NSURL URLWithString:getDataUrl2] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
        
        NSHTTPURLResponse* urlResponse2 = nil;
        
        NSData *returnData2 = [NSURLConnection sendSynchronousRequest: request2 returningResponse: &urlResponse2 error: &error];
        
        responseBodyCountries = [[NSString alloc] initWithData:returnData2 encoding:NSUTF8StringEncoding];
        
        connection2 = [[NSURLConnection alloc] initWithRequest:request2 delegate:self];
        
        [connection2 start];
        
        if (connection2) {
            loading.hidden = NO;
            
            [loading startAnimating];
        }
        else {
            //Error
        }
    }
}

-(IBAction)facebookConnect:(id)sender {
    // First, check whether the Facebook Session is open or not
    
    if (FBSession.activeSession.isOpen) {
        
        // Yes, we are open, so lets make a request for user details so we can get the user name.
        
        [self getFacebookUserInfo];// a custom method - see below:
        
        
        
    } else {
        
        // We don't have an active session in this app, so lets open a new
        // facebook session with the appropriate permissions!
        
        // Firstly, construct a permission array.
        // you can find more "permissions strings" at http://developers.facebook.com/docs/authentication/permissions/
        // In this example, we will just request a publish_stream which is required to publish status or photos.
        
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"email", @"user_birthday", @"user_friends",
                                nil];
        
        // OPEN Session!
        
        [FBSession openActiveSessionWithPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session,
                                                      FBSessionState status,
                                                      NSError *error) {
                                      // if login fails for any reason, we alert
                                      if (error) {
                                          
                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Could not connect to Facebook." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                                          [alert show];
                                          
                                      } else if (FB_ISSESSIONOPENWITHSTATE(status)) {
                                          
                                          // no error, so we proceed with requesting user details of current facebook session.
                                          
                                          [self getFacebookUserInfo];
                                      }
                                  }];
    }
}

-(void)getFacebookUserInfo {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
         if (!error) {
             DLog(@"user dic: %@", user);
             
             NSString *facebookID = [user objectForKey:@"id"];
             
             NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
             
             UIImage *fb_profile_image = [UIImage imageWithData:[NSData dataWithContentsOfURL:pictureURL]];
             
             cropPhotoForYapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CropPhotoForYapVC"];
             
             self.cropPhotoForYapVC = cropPhotoForYapVC;
             cropPhotoForYapVC.fullImage = fb_profile_image;
             
             [self.navigationController pushViewController:cropPhotoForYapVC animated:YES];
             
             firstName.text = [user objectForKey:@"first_name"];
             lastName.text = [user objectForKey:@"last_name"];
             email.text = [user objectForKey:@"email"];
             
             NSString *full_birthday = [[user objectForKey:@"birthday"] stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
             
             NSString *birthday_month = [full_birthday substringWithRange:NSMakeRange(0, 2)];
             NSString *birthday_day = [full_birthday substringWithRange:NSMakeRange(3, 2)];
             NSString *birthday_year = [full_birthday substringWithRange:NSMakeRange(6, 4)];
             
             DOB.text = [NSString stringWithFormat:@"%@-%@-%@", birthday_year, birthday_month, birthday_day];
             
             //facebook users need to be 13 years or older anyway so no need to calculate user's age
             currentUserAge = 13;
             
             //get user's friends
             //send request to Facebook
             FBRequest *request = [FBRequest requestForMyFriends];
             [request startWithCompletionHandler:^(FBRequestConnection *connection,
                                                   NSDictionary *results,
                                                   NSError *error) {
                 // handle response
                 if (!error) {
                     // Parse the data received
                     NSDictionary *userData = (NSDictionary *)results;
                     
                     DLog(@"friends: %@", userData);
                 } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                             isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
                     DLog(@"The facebook session was invalidated");
                     
                 } else {
                     DLog(@"Some other error: %@", error);
                 }
             }];
             
         }
         
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
     }];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger the_count = 1;
    
    if (pickerView == CountryPickerField) {
        the_count = [self.countriesList count];
    }
    else if (pickerView == StatePickerField) {
        the_count = [self.statesList count];
    }
    
    return the_count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *the_title = @"title";
    
    if (pickerView == CountryPickerField) {
        the_title = self.countriesList[row][@"country_name"];
    }
    else if (pickerView == StatePickerField) {
        the_title = self.statesList[row][@"us_state_name"];
    }
    
    return the_title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (pickerView == CountryPickerField) {
        //DLog(@"%@", [[countriesList objectAtIndex:row] objectForKey:@"country_id"]);
        
        country.text = [[countriesList objectAtIndex:row] objectForKey:@"country_name"];
        country_edited = true;
        
        if (![[[countriesList objectAtIndex:row] objectForKey:@"country_name"] isEqualToString:@"United States"]) {
            state.hidden = YES;
            state.text = @"";
            state_edited = true;
            state.userInteractionEnabled = NO;
            
            zipcode_edited = true;
            zipcode.text = @"";
            zipcode.hidden = YES;
            
            city.text = @"";
            city_edited = true;
            city.placeholder = @"City";
            city.userInteractionEnabled = YES;
        }
        else {
            city.text = @"";
            city_edited = true;
            city.placeholder = @"Select a state";
            city.userInteractionEnabled = NO;
            
            zipcode_edited = true;
            zipcode.text = @"";
            zipcode.hidden = YES;
            
            state.text = @"";
            
            state_edited = true;
            
            state.hidden = NO;
            state.userInteractionEnabled = YES;
            
            int country_id = [[[countriesList objectAtIndex:row] objectForKey:@"country_id"] intValue];
            
            NSNumber *tempCountryId = [[NSNumber alloc] initWithInt:country_id];
            NSNumber *tempSessionUserId = [[NSNumber alloc] initWithInt:sessionUserID];
            NSNumber *tempSessionId = [[NSNumber alloc] initWithInt:sessionID];
            
            NSError *error;
            
            NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                            tempSessionUserId, @"user_id",
                                            tempSessionId, @"session_id",
                                            tempCountryId, @"country_id",
                                            nil];
            
            //convert object to data
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
            
            
            NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/location/us_states/load/"];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:the_url];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setHTTPBody:jsonData];
            
            NSHTTPURLResponse* urlResponse = nil;
            
            NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
            
            responseBodyStates = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            
            if (!jsonData) {
                DLog(@"JSON error: %@", error);
            }
            
            connection4 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            [connection4 start];
            
            if (connection4) {
                
            }
            else {
                //Error
            }
        }
    }
    else if (pickerView == StatePickerField) {
        state.text = [[statesList objectAtIndex:row] objectForKey:@"us_state_abbreviation"];
        
        zipcode.hidden = NO;
        
        zipcode_edited = true;
        zipcode.text = @"";
        
        zipcode.placeholder = @"Zip";
        zipcode.userInteractionEnabled = YES;
        
        city.text = @"";
        city_edited = true;
        city.placeholder = @"Enter a zipcode";
        city.userInteractionEnabled = NO;
    }
}

-(IBAction)firstnameEdited:(id)sender {
    firstname_edited = true;
}

-(IBAction)lastnameEdited:(id)sender {
    lastname_edited = true;
}

-(IBAction)countryEdited:(id)sender {
    country_edited = true;
}

-(IBAction)cityEdited:(id)sender {
    city_edited = true;
}

-(IBAction)stateEdited:(id)sender {
    state_edited = true;
}

-(IBAction)phoneEdited:(id)sender {
    phone_edited = true;
}

-(IBAction)descriptionEdited:(id)sender {
    description_edited = true;
}

-(IBAction)emailEdited:(id)sender {
    email_edited = true;
}

-(IBAction)usernameEdited:(id)sender {
    username_edited = true;
}

-(IBAction)passwordEdited:(id)sender {
    [UIView transitionWithView:retypePasswordView
                      duration:0.2
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    
    [UIView transitionWithView:currentPasswordView
                      duration:0.2
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    
    retypePasswordView.hidden = NO;
    currentPasswordView.hidden = NO;
    
    password_edited = true;
}

-(IBAction)zipcodeEdited:(id)sender {
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    NSString *trimmedZipcode = [zipcode.text stringByTrimmingCharactersInSet:whitespace];
    
    if (![trimmedZipcode isEqualToString:@""] && [trimmedZipcode length] == 5) {
        city.text = @"";
        city.placeholder = @"City";
        city.userInteractionEnabled = YES;
    }
    else {
        city.text = @"";
        city.placeholder = @"Enter a zipcode";
        city.userInteractionEnabled = NO;
    }
    
    zipcode_edited = true;
}

-(IBAction)setPostsArePrivate:(id)sender {
    //change setting
    NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
    NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
    NSNumber *tempPostsArePrivate;
    
    NSDictionary *newDatasetInfo;
    NSData* jsonData;
    NSURL *the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/users/profile/edit/"];
    
    NSError *error;
    
    if (switchPostsArePrivate.on) {
        tempPostsArePrivate = [[NSNumber alloc] initWithBool:1];
    }
    else {
        tempPostsArePrivate = [[NSNumber alloc] initWithBool:0];
    }
    
    newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                      tempSessionUserID, @"user_id",
                      tempSessionID, @"session_id",
                      tempPostsArePrivate, @"posts_are_private",
                      nil];
    
    //convert object to data
    jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:the_url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    
    if (!jsonData) {
        DLog(@"JSON error: %@", error);
    }
    else {
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        DLog(@"JSON OUTPUT: %@", JSONString);
    }
    
    connection8 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [connection8 start];
    
    if (connection8) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    /*if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
     CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
     [scrollView setContentOffset:scrollPoint animated:YES];
     }*/
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

-(void)DOBDidBeginEditing:(UITextField*)textField
{
    [textField resignFirstResponder];
    
    UIDatePicker *picker = (UIDatePicker*)DOB.inputView;
    
    NSString *calDate = [NSString stringWithFormat:@"%@", picker.date];
    
    //calculate current user age
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    
    NSDate *today = [NSDate date];
    
    NSString *dateStringToday = [formatter stringFromDate:today];
    NSString *dateStringDOB = [formatter stringFromDate:picker.date];
    
    NSDate *startDate = [formatter dateFromString:dateStringDOB];
    NSDate *endDate = [formatter dateFromString:dateStringToday];
    
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit
                                       fromDate:startDate
                                       toDate:endDate
                                       options:0];
    
    
    
    currentUserAge = [ageComponents year];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    
    NSDate *date = [dateFormatter dateFromString: calDate];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *convertedString = [dateFormatter stringFromDate:date];
    
    DOB.text = [NSString stringWithFormat:@"%@",convertedString];
}

-(void)CountriesDidBeginEditing:(UITextField*)textField
{
    [textField resignFirstResponder];
    
    UIPickerView *picker = (UIPickerView*)country.inputView;
    
    NSInteger row;
    NSArray *repeatPickerData;
    
    row = [picker selectedRowInComponent:0];
    country.text = [repeatPickerData objectAtIndex:row];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goBack:(id)sender {
    sessionUnCroppedPhoto = nil;
    sessionCroppedPhoto = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)choosePhotoFromAlbum:(id)sender {
    image_picker = [[UIImagePickerController alloc] init];
    image_picker.delegate = self;
    [image_picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:image_picker animated:YES completion:NULL];
}

-(IBAction)takePhotoFromCamera:(id)sender {
    image_picker2 = [[UIImagePickerController alloc] init];
    image_picker2.delegate = self;
    [image_picker2 setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:image_picker2 animated:YES completion:NULL];
}

-(IBAction)recropPhoto:(id)sender {
    cropPhotoForYapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CropPhotoForYapVC"];
    
    self.cropPhotoForYapVC = cropPhotoForYapVC;
    cropPhotoForYapVC.fullImage = sessionUnCroppedPhoto;
    
    [self.navigationController pushViewController:cropPhotoForYapVC animated:YES];
}

-(void) imagePickerController:(UIImagePickerController *) picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //mainBG.image = image;
    
    cropPhotoForYapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CropPhotoForYapVC"];
    
    self.cropPhotoForYapVC = cropPhotoForYapVC;
    cropPhotoForYapVC.fullImage = image;
    
    //Push to User Settings controller
    [self.navigationController pushViewController:cropPhotoForYapVC animated:YES];
}

-(IBAction)showPhotoOptions:(id)sender {
    UIActionSheet *popup;
    
    if (sessionUnCroppedPhoto == nil) {
        popup = [[UIActionSheet alloc] initWithTitle:@"Select Profile Photo option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Choose photo from album",
                            @"Take photo from camera",
                            nil];
    }
    else {
        popup = [[UIActionSheet alloc] initWithTitle:@"Select Profile Photo option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                 @"Choose photo from album",
                 @"Take photo from camera",
                 @"Recrop current photo",
                 nil];
    }
    
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self choosePhotoFromAlbum:(popup)];
                    break;
                case 1:
                    [self takePhotoFromCamera:(popup)];
                    break;
                case 2:
                    [self recropPhoto:(popup)];
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    [scrollView setContentSize:CGSizeMake(320,640)];
    
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == username) {
        if ([string isEqualToString:@" "]){
            return NO;
        }
        else {
            NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_USERNAME_CHARACTERS] invertedSet];
            
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            
            return [string isEqualToString:filtered];
        }
    }
    
    if (textField == password || textField == retypePassword || textField == currentPassword) {
        if ([string isEqualToString:@" "]){
            return NO;
        }
        else {
            return YES;
        }
    }
    
    if (textField == firstName || textField == lastName) {
        if ([textField.text length] == 0) {
            textField.text = [textField.text stringByReplacingCharactersInRange:range
                                                                     withString:[string uppercaseStringWithLocale:[NSLocale currentLocale]]];
            return NO;
        }
        else {
            return YES;
        }
        
    }
    
    if (textField == description) {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        NSInteger currentCharacterCount = newLength;
        NSInteger remainingCharacters;
        
        remainingCharacters = 100 - currentCharacterCount;
        
        if (remainingCharacters >= 0) {
            remainingCharactersForDesc.text = [NSString stringWithFormat:@"%li", (long)remainingCharacters];
        }
        
        return (newLength > 100) ? NO : YES;
    }
    
    return YES;
}

-(IBAction)saveInfo:(id)sender {
    [self validateFields];
}

-(void)connection:(NSURLConnection *) connection didReceiveData:(NSData *)data {
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

-(void)connectionDidFinishLoading:(NSURLConnection *) connection {
    if (connection == connection1) {
        NSData *data = [userProfileResponseBody dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *json_user_info = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        //DLog(@"%@", json_user_info);
        
        NSDictionary *user = [json_user_info objectForKey:@"user"];
        NSDictionary *user_city = [json_user_info objectForKey:@"user_city"];
        NSDictionary *user_country = [json_user_info objectForKey:@"user_country"];
        NSDictionary *user_state = [json_user_info objectForKey:@"user_us_state"];
        NSDictionary *user_zip_code = [json_user_info objectForKey:@"user_us_zip_code"];
        
        //NSString *date_of_birth = [json_user_info objectForKey:@"date_of_birth"];
        NSString *user_description = [json_user_info objectForKey:@"description"];
        NSString *phone_number = [json_user_info objectForKey:@"phone_number"];
        BOOL profile_picture_cropped_flag = [[json_user_info objectForKey:@"profile_picture_cropped_flag"] boolValue];
        NSString *profile_picture_cropped_path = [json_user_info objectForKey:@"profile_picture_cropped_path"];
        BOOL profile_picture_flag = [[json_user_info objectForKey:@"profile_picture_flag"] boolValue];
        NSString *profile_picture_path = [json_user_info objectForKey:@"profile_picture_path"];
        NSString *first_name = [user objectForKey:@"first_name"];
        NSString *user_email = [user objectForKey:@"email"];
        
        first_name = [[[first_name substringToIndex:1] uppercaseString] stringByAppendingString:[first_name substringFromIndex:1]];
        
        NSString *last_name = [user objectForKey:@"last_name"];
        
        last_name = [[[last_name substringToIndex:1] uppercaseString] stringByAppendingString:[last_name substringFromIndex:1]];
        
        BOOL posts_are_private = [[json_user_info objectForKey:@"posts_are_private"] boolValue];
        
        firstName.text = first_name;
        lastName.text = last_name;
        
        email.text = user_email;
        
        username.text = sessionUsername;
        
        if (![user_description isEqualToString:@""]) {
            description.text = user_description;
            
            remainingCharactersForDesc.text = [NSString stringWithFormat:@"%u", (100 - [description.text length])];
        }
        
        if (![phone_number isEqualToString:@""]) {
            phone.text = phone_number;
        }
        
        if (profile_picture_cropped_flag) {
            smallPicturePath = profile_picture_cropped_path;
        }
        
        if (profile_picture_flag) {
            bigPicturePath = profile_picture_path;
        }
        
        if (![user_country isKindOfClass:[NSNull class]]) {
            user_country_id = [[user_country objectForKey:@"country_id"] intValue];
            country.text = [user_country objectForKey:@"country_name"];
        }
        
        if (![user_country isKindOfClass:[NSNull class]]) {
            if (![[user_country objectForKey:@"country_name"] isEqualToString:@"United States"]) {
                state.hidden = YES;
                state.text = @"";
                state.userInteractionEnabled = NO;
                
                zipcode.text = @"";
                zipcode.hidden = YES;
                
                city.text = @"";
                city.placeholder = @"City";
                city.userInteractionEnabled = YES;
            }
            else {
                city.text = @"";
                city.placeholder = @"Select a state";
                city.userInteractionEnabled = NO;
                
                zipcode.text = @"";
                zipcode.hidden = YES;
                
                state.hidden = NO;
                state.userInteractionEnabled = YES;
                
                //int country_id = user_country_id;
                
                /*
                NSNumber *tempCountryId = [[NSNumber alloc] initWithInt:country_id];
                NSNumber *tempSessionUserId = [[NSNumber alloc] initWithInt:sessionUserID];
                NSNumber *tempSessionId = [[NSNumber alloc] initWithInt:sessionID];
                
                NSError *error;
                
                NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                tempSessionUserId, @"user_id",
                                                tempSessionId, @"session_id",
                                                tempCountryId, @"country_id",
                                                nil];
                
                //convert object to data
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
                
                
                NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/location/us_states/load/"];
                
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                [request setURL:the_url];
                [request setHTTPMethod:@"POST"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setHTTPBody:jsonData];
                
                NSHTTPURLResponse* urlResponse = nil;
                
                NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
                
                responseBodyStates = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                
                if (!jsonData) {
                    DLog(@"JSON error: %@", error);
                }
                
                connection4 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                
                [connection4 start];
                
                if (connection4) {
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                }
                else {
                    //Error
                }*/
                
                if (![user_state isKindOfClass:[NSNull class]]) {
                    NSNumber *tempCountryId = [[NSNumber alloc] initWithInt:user_country_id];
                    NSNumber *tempSessionUserId = [[NSNumber alloc] initWithInt:sessionUserID];
                    NSNumber *tempSessionId = [[NSNumber alloc] initWithInt:sessionID];
                    
                    NSError *error;
                    
                    NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                    tempSessionUserId, @"user_id",
                                                    tempSessionId, @"session_id",
                                                    tempCountryId, @"country_id",
                                                    nil];
                    
                    //convert object to data
                    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
                    
                    
                    NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/location/us_states/load/"];
                    
                    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                    [request setURL:the_url];
                    [request setHTTPMethod:@"POST"];
                    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                    [request setHTTPBody:jsonData];
                    
                    NSHTTPURLResponse* urlResponse = nil;
                    
                    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
                    
                    responseBodyStates = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                    
                    if (!jsonData) {
                        DLog(@"JSON error: %@", error);
                    }
                    
                    connection4 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                    
                    [connection4 start];
                    
                    if (connection4) {
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                        
                        user_us_states_id = [[user_state objectForKey:@"us_states_id"] intValue];
                        state.text = [user_state objectForKey:@"us_state_abbreviation"];
                        state.placeholder = @"State";
                        state.hidden = NO;
                        state.userInteractionEnabled = YES;
                    }
                    else {
                        //Error
                    }
                }
            }
            
            if (![user_city isKindOfClass:[NSNull class]]) {
                city.text = [user_city objectForKey:@"city_name"];
                city.placeholder = @"City";
                city.userInteractionEnabled = YES;
            }
            
            if (![user_zip_code isKindOfClass:[NSNull class]]) {
                zipcode.text = [user_zip_code objectForKey:@"us_zip_code"];
                zipcode.hidden = NO;
                zipcode.userInteractionEnabled = YES;
            }
        }
        
        if (posts_are_private) {
            switchPostsArePrivate.on = YES;
        }
        else {
            switchPostsArePrivate.on = NO;
        }
        
        if (profile_picture_flag) {
            NSString *bucket = @"yapsterapp";
            S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                });
                
                //get cropped profile photo
                S3GetPreSignedURLRequest *gpsur_cropped_photo = [[S3GetPreSignedURLRequest alloc] init];
                gpsur_cropped_photo.key     = smallPicturePath;
                gpsur_cropped_photo.bucket  = bucket;
                gpsur_cropped_photo.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];
                gpsur_cropped_photo.responseHeaderOverrides = override;
                
                NSURL *url_cropped_photo = [[AmazonClientManager s3] getPreSignedURL:gpsur_cropped_photo];
                
                NSData *data_cropped_photo = [NSData dataWithContentsOfURL:url_cropped_photo];
                
                UIImage *cropped_photo = [UIImage imageWithData:data_cropped_photo];
                
                sessionCroppedPhoto = cropped_photo;
                
                S3GetPreSignedURLRequest *gpsur_big_photo = [[S3GetPreSignedURLRequest alloc] init];
                gpsur_big_photo.key     = bigPicturePath;
                gpsur_big_photo.bucket  = bucket;
                gpsur_big_photo.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];
                gpsur_big_photo.responseHeaderOverrides = override;
                
                NSURL *url_big_photo = [[AmazonClientManager s3] getPreSignedURL:gpsur_big_photo];
                
                NSData *data_big_photo = [NSData dataWithContentsOfURL:url_big_photo];
                
                UIImage *big_photo = [UIImage imageWithData:data_big_photo];
                
                sessionUnCroppedPhoto = big_photo;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [userPhotoBtn.layer setBorderColor:[UIColor clearColor].CGColor];
                    [userPhotoBtn.layer masksToBounds];
                    
                    CALayer *imageLayer = userPhotoBtn.layer;
                    [imageLayer setCornerRadius:userPhotoBtn.frame.size.width/2];
                    [imageLayer setBorderWidth:0.0];
                    [imageLayer setMasksToBounds:YES];
                    
                    [userPhotoBtn setBackgroundImage:cropped_photo forState:UIControlStateNormal];
                    
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    
                    [loading stopAnimating];
                    
                    scrollView.hidden = NO;
                });
            });
        }
        else {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        
        /*
        "user_city" = "<null>";
        "user_country" = "<null>";
        "user_us_state" = "<null>";
        "user_us_zip_code" = "<null>";*/
    }
    else if (connection == connection7) {
        DLog(@"%@", json);
        
        BOOL valid = [[json objectForKey:@"valid"] boolValue];
        
        if (!valid) {
            NSString *errorMessage = [json objectForKey:@"message"];
         
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:errorMessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            
            self.view.userInteractionEnabled = YES;
            
            [saving stopAnimating];
            saving.hidden = YES;
            
            saveBtn.hidden = NO;
        }
        else {
            if (username_edited)
                sessionUsername = username.text;
            
            if (password_edited)
                [keychain setObject:[password text] forKey:(__bridge id)kSecValueData];
            
            sessionFirstName = firstName.text;
            
            sessionLastName = lastName.text;
            
            if (country_edited)
                sessionCountry = country.text;
            
            if (sessionUnCroppedPhoto != nil) {
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(queue, ^{
                    
                    NSString *bucketName = [NSString stringWithFormat:@"yapsterapp"];
                    
                    NSData *data;
                    NSData *data2;
                    
                    //first store big profile photo
                    
                    if (sessionUnCroppedPhoto != nil) {
                        float actualHeight = sessionUnCroppedPhoto.size.height;
                        float actualWidth = sessionUnCroppedPhoto.size.width;
                        float imgRatio = actualWidth/actualHeight;
                        float maxRatio = 320.0/480.0;
                        
                        if(imgRatio!=maxRatio){
                            if(imgRatio < maxRatio){
                                imgRatio = 480.0 / actualHeight;
                                actualWidth = round(imgRatio * actualWidth);
                                actualHeight = 480.0;
                            }
                            else{
                                imgRatio = 320.0 / actualWidth;
                                actualHeight = round(imgRatio * actualHeight);
                                actualWidth = 320.0;
                            }
                        }
                        CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
                        UIGraphicsBeginImageContext(rect.size);
                        [sessionUnCroppedPhoto drawInRect:rect];
                        UIImage *big_img = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        
                        data = [NSData dataWithData:UIImageJPEGRepresentation(big_img, 0.8)];
                    }
                    else {
                        data = [NSData dataWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"placer holder_profile photo Large.png"], 0.8)];
                    }
                    
                    S3PutObjectRequest *request_big_photo = [[S3PutObjectRequest alloc] initWithKey:bigPicturePath inBucket:bucketName];
                    
                    request_big_photo.contentType = @"image/jpeg";
                    
                    request_big_photo.data = data;
                    
                    S3PutObjectResponse *response = [[AmazonClientManager s3] putObject:request_big_photo];
                    
                    if (response.error != nil) {
                        DLog(@"Error: %@", response.error);
                    }
                    
                    //then store cropped profile photo
                    
                    if (sessionCroppedPhoto != nil) {
                        float actualHeight = sessionCroppedPhoto.size.height;
                        float actualWidth = sessionCroppedPhoto.size.width;
                        float imgRatio = actualWidth/actualHeight;
                        float maxRatio = 320.0/480.0;
                        
                        if(imgRatio!=maxRatio){
                            if(imgRatio < maxRatio){
                                imgRatio = 480.0 / actualHeight;
                                actualWidth = round(imgRatio * actualWidth);
                                actualHeight = 480.0;
                            }
                            else{
                                imgRatio = 320.0 / actualWidth;
                                actualHeight = round(imgRatio * actualHeight);
                                actualWidth = 320.0;
                            }
                        }
                        CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
                        UIGraphicsBeginImageContext(rect.size);
                        [sessionCroppedPhoto drawInRect:rect];
                        UIImage *cropped_img = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        
                        data2 = [NSData dataWithData:UIImageJPEGRepresentation(cropped_img, 0.8)];
                    }
                    else {
                        data2 = [NSData dataWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"placer holder_profile photo Large.png"], 0.8)];
                    }
                    
                    S3PutObjectRequest *request_small_photo = [[S3PutObjectRequest alloc] initWithKey:smallPicturePath inBucket:bucketName];
                    
                    request_small_photo.contentType = @"image/jpeg";
                    
                    request_small_photo.data = data2;
                    
                    S3PutObjectResponse *response2 = [[AmazonClientManager s3] putObject:request_small_photo];
                    
                    if (response2.error != nil) {
                        DLog(@"Error: %@", response2.error);
                    }
                    else {
                        sessionUserCroppedPhoto = sessionCroppedPhoto;
                        sessionUserUncroppedPhoto = sessionUnCroppedPhoto;
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSNumber *tempSessionUserId = [[NSNumber alloc] initWithInt:sessionUserID];
                        NSNumber *tempSessionId = [[NSNumber alloc] initWithInt:sessionID];
                        NSNumber *profile_picture_flag = [[NSNumber alloc] initWithBool:true];
                        NSNumber *profile_picture_cropped_flag = [[NSNumber alloc] initWithBool:true];
                        
                        //build an info object and convert to json
                        NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                        tempSessionUserId, @"user_id",
                                                        tempSessionId, @"session_id",
                                                        profile_picture_flag, @"profile_picture_flag",
                                                        profile_picture_cropped_flag, @"profile_picture_cropped_flag",
                                                        bigPicturePath, @"profile_picture_path",
                                                        smallPicturePath, @"profile_picture_cropped_path",
                                                        nil];
                        NSError *error;
                        
                        //convert object to data
                        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
                        
                        NSURL *the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/users/profile/edit_profile_picture/"];
                        
                        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                        [request setURL:the_url];
                        [request setHTTPMethod:@"POST"];
                        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                        [request setHTTPBody:jsonData];
                        
                        if (!jsonData) {
                            DLog(@"JSON error: %@", error);
                        }
                        
                        connection5 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                        
                        [connection5 start];
                        
                        if (connection5) {
                            
                        }
                        else {
                            //Error
                        }
                    });
                });
            }
            else {
                UserProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileVC"];
                
                UserProfileVC.userToView = sessionUserID;
                UserProfileVC.cameFromMenu = YES;
                
                //Push to controller
                [self.navigationController pushViewController:UserProfileVC animated:YES];
            }
        }
    }
    else if (connection == connection2) {
        NSData *data = [responseBodyCountries dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableArray *json_countries = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        self.countriesList = [NSMutableArray arrayWithArray:json_countries];
        
        //DLog(@"%@", self.countriesList);
        
        NSString *the_country;
        NSString *the_country2;
        
        for (int i = 0; i < countriesList.count; i++) {
            the_country = [countriesList objectAtIndex:i];
            the_country2 = [[countriesList objectAtIndex:i] objectForKey:@"country_name"];
            
            [countriesArray addObject:the_country];
            [onlyCountriesArray addObject:the_country2];
        }
        
        //DLog(@"%@", self.countriesList);
        
        UIColor *white = [UIColor whiteColor];
        
        CountryPickerField = [[UIPickerView alloc]init];
        
        //[CountryPickerField setDataSource:[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Countries" ofType:@"plist"]]];
        
        [CountryPickerField setBackgroundColor:white];
        
        [country setInputView:CountryPickerField];
        
        CountryPickerField.delegate = self;
        CountryPickerField.dataSource = self;
        
        if (user_country_id) {
            [CountryPickerField selectRow:user_country_id-1 inComponent:0 animated:NO];
        }
        
        [CountryPickerField reloadAllComponents];
        
        loading.hidden = YES;
        
        [loading stopAnimating];
        
        scrollView.hidden = NO;
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    else if (connection == connection4) {
        NSData *data = [responseBodyStates dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableArray *json_states = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        self.statesList = [NSMutableArray arrayWithArray:json_states];
        
        NSString *the_state;
        NSString *the_state2;
        
        for (int i = 0; i < statesList.count; i++) {
            the_state = [statesList objectAtIndex:i];
            the_state2 = [[statesList objectAtIndex:i] objectForKey:@"us_state_abbreviation"];
            
            [statesArray addObject:the_state];
        }
        
        UIColor *white = [UIColor whiteColor];
        
        StatePickerField = [[UIPickerView alloc]init];
        
        //[CountryPickerField setDataSource:[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Countries" ofType:@"plist"]]];
        
        [StatePickerField setBackgroundColor:white];
        
        [state setInputView:StatePickerField];
        
        StatePickerField.delegate = self;
        StatePickerField.dataSource = self;
        
        if (user_us_states_id) {
            [StatePickerField selectRow:user_us_states_id-1 inComponent:0 animated:NO];
        }
        
        [StatePickerField reloadAllComponents];
        
        loading.hidden = YES;
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    else if (connection == connection5) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        UserProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileVC"];
        
        UserProfileVC.userToView = sessionUserID;
        UserProfileVC.cameFromMenu = YES;
        
        //Push to controller
        [self.navigationController pushViewController:UserProfileVC animated:YES];
    }
    else if (connection == connection8) {
        //DLog(@"%@", json);
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

-(void)validateFields {
    [username resignFirstResponder];
    [password resignFirstResponder];
    [retypePassword resignFirstResponder];
    [firstName resignFirstResponder];
    [lastName resignFirstResponder];
    [email resignFirstResponder];
    [DOB resignFirstResponder];
    [city resignFirstResponder];
    [zipcode resignFirstResponder];
    [phone resignFirstResponder];
    [description resignFirstResponder];
    
    email.backgroundColor = [UIColor whiteColor];
    username.backgroundColor = [UIColor whiteColor];
    password.backgroundColor = [UIColor whiteColor];
    retypePassword.backgroundColor = [UIColor whiteColor];
    firstName.backgroundColor = [UIColor whiteColor];
    lastName.backgroundColor = [UIColor whiteColor];
    DOB.backgroundColor = [UIColor whiteColor];
    
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedEmail = [email.text stringByTrimmingCharactersInSet:whitespace];
    NSString *trimmedUsername = [username.text stringByTrimmingCharactersInSet:whitespace];
    NSString *trimmedPassword = [password.text stringByTrimmingCharactersInSet:whitespace];
    NSString *trimmedReTypePassword = [retypePassword.text stringByTrimmingCharactersInSet:whitespace];
    NSString *trimmedCurrentPassword = [currentPassword.text stringByTrimmingCharactersInSet:whitespace];
    NSString *trimmedCity = [city.text stringByTrimmingCharactersInSet:whitespace];
    NSString *trimmedState = [state.text stringByTrimmingCharactersInSet:whitespace];
    NSString *trimmedCountry = [country.text stringByTrimmingCharactersInSet:whitespace];
    NSString *trimmedZipcode = [zipcode.text stringByTrimmingCharactersInSet:whitespace];
    NSString *trimmedPhone = [phone.text stringByTrimmingCharactersInSet:whitespace];
    NSString *trimmedDescription = [description.text stringByTrimmingCharactersInSet:whitespace];
    
    NSUInteger trimmedZipcodeLength = [trimmedZipcode length];
    
    NSString *trimmedFirstName = [firstName.text stringByTrimmingCharactersInSet:whitespace];
    
    if (![trimmedFirstName isEqualToString:@""]) {
        trimmedFirstName = [[[trimmedFirstName substringToIndex:1] uppercaseString] stringByAppendingString:[trimmedFirstName substringFromIndex:1]];
    }
    
    NSUInteger firstNameLength = [trimmedFirstName length];
    
    NSString *trimmedLastName = [lastName.text stringByTrimmingCharactersInSet:whitespace];
    
    if (![trimmedLastName isEqualToString:@""]) {
        trimmedLastName = [[[trimmedLastName substringToIndex:1] uppercaseString] stringByAppendingString:[trimmedLastName substringFromIndex:1]];
    }
    
    NSUInteger lastNameLength = [trimmedLastName length];
    
    NSUInteger descriptionLength = [trimmedDescription length];
    
    NSUInteger countryLength = [trimmedCountry length];
    
    NSUInteger cityLength = [trimmedCity length];
    
    NSUInteger usernameLength = [trimmedUsername length];
    
    NSUInteger passwordLength = [trimmedPassword length];
    NSUInteger retypePasswordLength = [trimmedReTypePassword length];
    
    NSRange upperCaseRange;
    NSCharacterSet *upperCaseSet = [NSCharacterSet uppercaseLetterCharacterSet];
    
    upperCaseRange = [trimmedPassword rangeOfCharacterFromSet: upperCaseSet];
    
    NSRange upperCaseRangeForUsername;
    NSCharacterSet *upperCaseSetForUsername = [NSCharacterSet uppercaseLetterCharacterSet];
    
    upperCaseRangeForUsername = [trimmedUsername rangeOfCharacterFromSet: upperCaseSetForUsername];
    
    NSRange lowerCaseRange;
    NSCharacterSet *lowerCaseSet = [NSCharacterSet lowercaseLetterCharacterSet];
    
    lowerCaseRange = [trimmedPassword rangeOfCharacterFromSet: lowerCaseSet];
    
    //validate email
    NSString *emailValue = email.text;
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValidEmail = [emailTest evaluateWithObject:emailValue];
    
    //validate username
    if (username_edited && usernameLength < 1) { //min length
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Please enter a username." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else if (username_edited && usernameLength > 30) { //max length
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Your username cannot be longer than 30 characters." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else if (username_edited && upperCaseRangeForUsername.location != NSNotFound) { //do not allow uppercase in username
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"No uppercase letters allowed in username." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else if (firstNameLength < 1) { //validate first name
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Please enter your first name." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else if (lastNameLength < 1) { //validate last name
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Please enter your last name." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else if (!isValidEmail) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Please enter a valid email address." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else if (password_edited && passwordLength > 30) { //max length
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Your password cannot be longer than 30 characters." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else if (password_edited && [trimmedPassword rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location == NSNotFound) { //at least one number
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Password must contain at least one number." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else if (password_edited && upperCaseRange.location == NSNotFound) { //at least one uppercase
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Password must contain at least one uppercase letter." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else if (password_edited && lowerCaseRange.location == NSNotFound) { //at least one lowercase
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Password must contain at least one lowercase letter." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else if (password_edited && retypePasswordLength < 1) { //retype password length
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Please re-enter your password." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else if (password_edited && ![trimmedPassword isEqualToString:trimmedReTypePassword]) { //retype password match
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Password and re-type passwords do not match." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else if (password_edited && [trimmedCurrentPassword length] == 0) { //no current password
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Please enter your current password." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else if (password_edited && ![trimmedCurrentPassword isEqualToString:current_password]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Current password is incorrect." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else if (countryLength > 0 && ![self.onlyCountriesArray containsObject:trimmedCountry]) { //validate country
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Please select a valid country from the list." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else {
        //validate zipcode
        if (trimmedZipcodeLength > 0) {
            NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
            if (trimmedZipcodeLength < 5 || [trimmedZipcode rangeOfCharacterFromSet:notDigits].location != NSNotFound) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Please enter a valid zipcode." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
                
                return;
            }
            else if (trimmedZipcodeLength > 5) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Please enter a valid zipcode." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
                
                return;
            }
        }
        
        //save user info
        
        NSString *lowercaseCountry = trimmedCountry.lowercaseString;
        
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        
        if (networkStatus == NotReachable) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"There seems to be no internet connection on your device." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
        else {
            //build an info object and convert to json
            NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
            NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
            
            NSMutableDictionary *newDatasetInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                   tempSessionUserID, @"user_id",
                                                   tempSessionID, @"session_id",
                                                   trimmedFirstName, @"first_name",
                                                   trimmedLastName, @"last_name",
                                                   nil];
            
            if (username_edited) {
                [newDatasetInfo setValue:username.text forKey:@"username"];
            }
            
            if (password_edited) {
                [newDatasetInfo setValue:password.text forKey:@"new_password"];
                [newDatasetInfo setValue:currentPassword.text forKey:@"current_password"];
            }
            
            if (email_edited)
                [newDatasetInfo setValue:email.text forKey:@"email"];
            
            if (description_edited)
                [newDatasetInfo setValue:description.text forKey:@"description"];
            
            if (phone_edited)
                [newDatasetInfo setValue:trimmedPhone forKey:@"phone_number"];
            
            if (country_edited) {
                if ([trimmedCountry length] > 0) {
                    NSNumber *country_id = [[NSNumber alloc] initWithInt:[[[countriesList objectAtIndex:[CountryPickerField selectedRowInComponent:0]] objectForKey:@"country_id"] intValue]];
                    
                    [newDatasetInfo setValue:country_id forKey:@"user_country_id"];
                }
                else {
                    [newDatasetInfo setValue:@"" forKey:@"user_country_id"];
                }
            }
            
            if (state_edited && [country.text isEqualToString:@"United States"]) {
                if ([trimmedState length] > 0) {
                    NSNumber *state_id = [[NSNumber alloc] initWithInt:[[[statesList objectAtIndex:[StatePickerField selectedRowInComponent:0]] objectForKey:@"us_states_id"] intValue]];
                    
                    [newDatasetInfo setValue:state_id forKey:@"user_us_state_id"];
                }
                else {
                    [newDatasetInfo setValue:@"" forKey:@"user_us_state_id"];
                }
            }
            
            if (city_edited)
                [newDatasetInfo setValue:trimmedCity forKey:@"user_city_name"];
            
            if (zipcode_edited && [country.text isEqualToString:@"United States"])
                [newDatasetInfo setValue:trimmedZipcode forKey:@"user_us_zip_code"];
            
            bigPicturePath = [NSString stringWithFormat:@"yapsterusers/uid/%0.0f/profile_pictures/%0.0f-big.jpg", sessionUserID, sessionUserID];
            smallPicturePath = [NSString stringWithFormat:@"yapsterusers/uid/%0.0f/profile_pictures/%0.0f-cropped.jpg", sessionUserID, sessionUserID];
            
            if (sessionUnCroppedPhoto != nil) {
                NSNumber *profile_picture_flag = [[NSNumber alloc] initWithBool:true];
                
                [newDatasetInfo setValue:profile_picture_flag forKey:@"profile_picture_flag"];
                [newDatasetInfo setValue:bigPicturePath forKey:@"profile_picture_path"];
            }
            
            if (sessionCroppedPhoto != nil) {
                NSNumber *profile_picture_cropped_flag = [[NSNumber alloc] initWithBool:true];
                
                [newDatasetInfo setValue:profile_picture_cropped_flag forKey:@"profile_picture_cropped_flag"];
                [newDatasetInfo setValue:smallPicturePath forKey:@"profile_picture_cropped_path"];
            }
            
            NSError *error;
            
            //convert object to data
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
            
            NSURL *the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/users/profile/edit/"];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:the_url];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setHTTPBody:jsonData];
            
            if (!jsonData) {
                DLog(@"JSON error: %@", error);
            }
            else {
                NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                DLog(@"JSON OUTPUT: %@", JSONString);
            }
            
            connection7 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            [connection7 start];
            
            if (connection7) {
                self.view.userInteractionEnabled = NO;
                
                saveBtn.hidden = YES;
                
                [saving startAnimating];
                saving.hidden = NO;
            }
            else {
                //Error
            }
        }
    }
}

@end
