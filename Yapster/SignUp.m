//
//  SignUp.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 3/31/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "SignUp.h"

@interface SignUp ()

@end

@implementation SignUp

@synthesize facebookLoginView;
@synthesize token;
@synthesize cropPhotoForYapVC;
@synthesize TermsOfServiceVC;
@synthesize PrivacyPolicyVC;
@synthesize GetRecommendedUsersVC;
@synthesize json;
@synthesize connection1;
@synthesize connection2;
@synthesize connection3;
@synthesize connection4;
@synthesize connection5;
@synthesize connection6;
@synthesize connection7;
@synthesize countriesList;
@synthesize countriesArray;
@synthesize onlyCountriesArray;
@synthesize citiesList;
@synthesize citiesArray;
@synthesize statesList;
@synthesize statesArray;
@synthesize genderArray;
@synthesize responseBodyCountries;
@synthesize responseBodyCities;
@synthesize responseBodyStates;
@synthesize responseBodyUserprofile;
@synthesize userDataPath;
@synthesize CountryPickerField;
@synthesize CityPickerField;
@synthesize StatePickerField;
@synthesize GenderPickerField;
@synthesize bigPicturePath;
@synthesize smallPicturePath;

#define ACCEPTABLE_CHARACTERS @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_."
#define ACCEPTABLE_USERNAME_CHARACTERS @"abcdefghijklmnopqrstuvwxyz0123456789_."

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.facebookLoginView = [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile", @"email", @"user_friends", @"username", @"user_birthday"]];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    requirementsLabel.text = @"Please fill in the required (*) fields.";
    
    sessionCroppedPhoto = nil;
    sessionUnCroppedPhoto = nil;
    
    [scrollView setScrollEnabled:YES];
    
    [scrollView setContentSize:CGSizeMake(320,640)];
    
    keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"AppLoginData" accessGroup:nil];
    
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
    
    //self.facebookLoginView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    
    UIView *rightFieldDescBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 0)];
    
    description.rightViewMode = UITextFieldViewModeAlways;
    description.rightView    = rightFieldDescBox;
    
    //populate abbreviated countries list (for use later with validation)
    countriesArray = [[NSMutableArray alloc] initWithArray:nil];
    onlyCountriesArray = [[NSMutableArray alloc] initWithArray:nil];
    
    genderArray = [[NSMutableArray alloc] init];
    
    [genderArray addObject:@"Female"];
    [genderArray addObject:@"Male"];
    [genderArray addObject:@"Other"];
    
    UIColor *white = [UIColor whiteColor];
    
    GenderPickerField = [[UIPickerView alloc]init];
    
    //[CountryPickerField setDataSource:[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Countries" ofType:@"plist"]]];
    
    [GenderPickerField setBackgroundColor:white];
    
    [gender setInputView:GenderPickerField];
    
    GenderPickerField.delegate = self;
    GenderPickerField.dataSource = self;
    [GenderPickerField reloadAllComponents];
    
    NSError *error;
    
    //get countries
    NSString *getDataUrl = @"http://api.yapster.co/api/0.0.1/location/countries/load/";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:getDataUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    
    NSHTTPURLResponse* urlResponse = nil;
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
    
    responseBodyCountries = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    connection2 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [connection2 start];
    
    if (connection2) {
        
    }
    else {
        //Error
    }
    
    //check for screen height, and adjust controls as appropriate
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        scrollView.frame = CGRectMake(0, 126, scrollView.frame.size.width, 471);
    }
    else {
        scrollView.frame = CGRectMake(0, 126, scrollView.frame.size.width, 565);
    }
    
    loading.hidden = YES;
    
    username.delegate = self;
    password.delegate = self;
    retypePassword.delegate = self;
    firstName.delegate = self;
    lastName.delegate = self;
    email.delegate = self;
    city.delegate = self;
    zipcode.delegate = self;
    phone.delegate = self;
    description.delegate = self;
    
    [self registerForKeyboardNotifications];
    
    UIDatePicker *DOBPicker = [[UIDatePicker alloc]init];
    
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
             gender.text = [user objectForKey:@"gender"];
             gender.text = [[[gender.text substringToIndex:1] uppercaseString] stringByAppendingString:[gender.text substringFromIndex:1]];
             
             if ([[gender.text lowercaseString] isEqualToString:@"male"]) {
                 [GenderPickerField selectRow:0 inComponent:0 animated:NO];
             }
             else if ([[gender.text lowercaseString] isEqualToString:@"female"]) {
                 [GenderPickerField selectRow:1 inComponent:0 animated:NO];
             }
             else {
                 [GenderPickerField selectRow:2 inComponent:0 animated:NO];
             }
             
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

-(IBAction)showPhotoOptions:(id)sender {
    [username resignFirstResponder];
    [password resignFirstResponder];
    [retypePassword resignFirstResponder];
    [firstName resignFirstResponder];
    [lastName resignFirstResponder];
    [email resignFirstResponder];
    [DOB resignFirstResponder];
    [gender resignFirstResponder];
    [city resignFirstResponder];
    [zipcode resignFirstResponder];
    [phone resignFirstResponder];
    [description resignFirstResponder];
    
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
    
    if (sessionUnCroppedPhoto == nil) {
        switch (popup.tag) {
            case 1: {
                switch (buttonIndex) {
                    case 0:
                        [self choosePhotoFromAlbum:(popup)];
                        break;
                    case 1:
                        [self takePhotoFromCamera:(popup)];
                        break;
                    default:
                        break;
                }
                break;
            }
            default:
                break;
        }
    }
    else {
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
                        break;
                    default:
                        break;
                }
                break;
            }
            default:
                break;
        }
    }
}

-(IBAction)choosePhotoFromAlbum:(id)sender {
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:picker animated:YES completion:NULL];
}

-(IBAction)takePhotoFromCamera:(id)sender {
    picker2 = [[UIImagePickerController alloc] init];
    picker2.delegate = self;
    [picker2 setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:picker2 animated:YES completion:NULL];
}

-(IBAction)recropPhoto:(id)sender {
    cropPhotoForYapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CropPhotoForYapVC"];
    
    self.cropPhotoForYapVC = cropPhotoForYapVC;
    cropPhotoForYapVC.fullImage = sessionUnCroppedPhoto;
    
    [self.navigationController pushViewController:cropPhotoForYapVC animated:YES];
}

-(IBAction)userhandleClicked:(id)sender {
    requirementsLabel.text = @"Please enter a username.";
}

-(IBAction)passwordClicked:(id)sender {
    requirementsLabel.text = @"Enter a combination of uppercase & lowercase letters and numbers.";
}

-(IBAction)firstnameClicked:(id)sender {
    requirementsLabel.text = @"Enter your first name.";
}

-(IBAction)lastnameClicked:(id)sender {
    requirementsLabel.text = @"Enter your last name.";
}

-(IBAction)emailClicked:(id)sender {
    requirementsLabel.text = @"Please enter your email address.";
}

-(IBAction)dobClicked:(id)sender {
    requirementsLabel.text = @"Please select your date of birth.";
}

-(IBAction)genderClicked:(id)sender {
    requirementsLabel.text = @"Please select your gender from the list.";
}

-(IBAction)countryClicked:(id)sender {
    requirementsLabel.text = @"Select your country from the list.";
}

-(IBAction)stateClicked:(id)sender {
    requirementsLabel.text = @"Select your US State from the list.";
}

-(IBAction)cityClicked:(id)sender {
    requirementsLabel.text = @"Enter your city.";
}

-(IBAction)zipcodeClicked:(id)sender {
    requirementsLabel.text = @"Enter your zipcode.";
}

-(IBAction)phoneClicked:(id)sender {
    requirementsLabel.text = @"Enter your phone number.";
}

-(IBAction)descriptionClicked:(id)sender {
    requirementsLabel.text = @"Enter a brief description about yourself.";
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
    else if (pickerView == GenderPickerField) {
        the_count = 3;
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
    else if (pickerView == GenderPickerField) {
        the_title = self.genderArray[row];
    }
    
    return the_title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (pickerView == CountryPickerField) {
        //DLog(@"%@", [[countriesList objectAtIndex:row] objectForKey:@"country_id"]);
        
        country.text = [[countriesList objectAtIndex:row] objectForKey:@"country_name"];
        
        if (![[[countriesList objectAtIndex:row] objectForKey:@"country_name"] isEqualToString:@"United States"]) {
            state.hidden = YES;
            state.text = @"";
            state.userInteractionEnabled = NO;
            
            zipcode.hidden = YES;
            
            city.text = @"";
            city.placeholder = @"City";
            city.userInteractionEnabled = YES;
        }
        else {
            city.text = @"";
            city.placeholder = @"Select a state";
            city.userInteractionEnabled = NO;
            
            zipcode.hidden = YES;
            
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
        zipcode.text = @"";
        zipcode.placeholder = @"Zip";
        zipcode.userInteractionEnabled = YES;
        
        city.text = @"";
        city.placeholder = @"Enter a zipcode";
        city.userInteractionEnabled = NO;
    }
    else if (pickerView == GenderPickerField) {
        gender.text = [genderArray objectAtIndex:row];
    }
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
    
    UIPickerView *picker3 = (UIPickerView*)country.inputView;
    
    NSInteger row;
    NSArray *repeatPickerData;
    
    row = [picker3 selectedRowInComponent:0];
    country.text = [repeatPickerData objectAtIndex:row];
}

-(void)GenderDidBeginEditing:(UITextField*)textField
{
    [textField resignFirstResponder];
    
    UIPickerView *picker3 = (UIPickerView*)gender.inputView;
    
    NSInteger row;
    NSArray *repeatPickerData;
    
    row = [picker3 selectedRowInComponent:0];
    gender.text = [repeatPickerData objectAtIndex:row];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    /*
    if ((![username.text isEqualToString:@""] || ![password.text isEqualToString:@""] || ![retypePassword.text isEqualToString:@""] || ![firstName.text isEqualToString:@""] || ![lastName.text isEqualToString:@""] || ![email.text isEqualToString:@""] || ![DOB.text isEqualToString:@""] || ![gender.text isEqualToString:@""] || ![city.text isEqualToString:@""] || ![zipcode.text isEqualToString:@""] || ![phone.text isEqualToString:@""] || ![description.text isEqualToString:@""]) && sessionUnCroppedPhoto == nil) {
        
        requirementsLabel.text = @"Click on the image below to add a profile picture.";
    }
    else {
        requirementsLabel.text = @"Please fill in the required (*) fields.";
    }
     */
    
    [textField resignFirstResponder];
    
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
    
    if (textField == password || textField == retypePassword) {
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
            remainingCharactersForDesc.text = [NSString stringWithFormat:@"%lu", (long)remainingCharacters];
        }
        
        return (newLength > 100) ? NO : YES;
    }
    
    return YES;
}

-(IBAction)viewTerms:(id)sender {
    TermsOfService *termsScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsOfServiceVC"];
    
    self.TermsOfServiceVC = termsScreen;
    
    //Push to User Settings controller
    [self.navigationController pushViewController:termsScreen animated:YES];
}
-(IBAction)viewPrivacy:(id)sender {
    PrivacyPolicy *privacyScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"PrivacyPolicyVC"];
    
    self.PrivacyPolicyVC = privacyScreen;
    
    //Push to User Settings controller
    [self.navigationController pushViewController:privacyScreen animated:YES];
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    firstName.text = user.first_name;
    lastName.text = user.last_name;
    //email.text = user.email;
    username.text = user.birthday;
}

// You need to override loginView:handleError in order to handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures since that happen outside of the app.
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        DLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        DLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

-(IBAction)signUp:(id)sender {
    [self validateFields];
}


-(void)validateFields {
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

    NSUInteger usernameLength = [trimmedUsername length];
    
    NSUInteger countryLength = [trimmedCountry length];
    
    NSUInteger cityLength = [trimmedCity length];

    NSString *trimmedReTypePassword = [retypePassword.text stringByTrimmingCharactersInSet:whitespace];
    
    NSString *trimmedDOB = [DOB.text stringByTrimmingCharactersInSet:whitespace];
    
    NSUInteger DOBLength = [trimmedDOB length];

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
    if (usernameLength < 1) { //min length
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Please enter a username." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        
        [username resignFirstResponder];
        [password resignFirstResponder];
        [retypePassword resignFirstResponder];
        [firstName resignFirstResponder];
        [lastName resignFirstResponder];
        [email resignFirstResponder];
        [DOB resignFirstResponder];
        [gender resignFirstResponder];
        [city resignFirstResponder];
        [zipcode resignFirstResponder];
        [phone resignFirstResponder];
        [description resignFirstResponder];
    }
    else if (usernameLength > 30) { //max length
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Your username cannot be longer than 30 characters." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        
        [username resignFirstResponder];
        [password resignFirstResponder];
        [retypePassword resignFirstResponder];
        [firstName resignFirstResponder];
        [lastName resignFirstResponder];
        [email resignFirstResponder];
        [DOB resignFirstResponder];
        [gender resignFirstResponder];
        [city resignFirstResponder];
        [zipcode resignFirstResponder];
        [phone resignFirstResponder];
        [description resignFirstResponder];
    }
    else if (upperCaseRangeForUsername.location != NSNotFound) { //do not allow uppercase in username
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"No uppercase letters allowed in username." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        
        [username resignFirstResponder];
        [password resignFirstResponder];
        [retypePassword resignFirstResponder];
        [firstName resignFirstResponder];
        [lastName resignFirstResponder];
        [email resignFirstResponder];
        [DOB resignFirstResponder];
        [gender resignFirstResponder];
        [city resignFirstResponder];
        [zipcode resignFirstResponder];
        [phone resignFirstResponder];
        [description resignFirstResponder];
    }
    //validate password
    else if (passwordLength < 1) { //min length
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Please enter a password." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        
        [username resignFirstResponder];
        [password resignFirstResponder];
        [retypePassword resignFirstResponder];
        [firstName resignFirstResponder];
        [lastName resignFirstResponder];
        [email resignFirstResponder];
        [DOB resignFirstResponder];
        [gender resignFirstResponder];
        [city resignFirstResponder];
        [zipcode resignFirstResponder];
        [phone resignFirstResponder];
        [description resignFirstResponder];
    }
    else if (passwordLength > 30) { //max length
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Your password cannot be longer than 30 characters." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        
        [username resignFirstResponder];
        [password resignFirstResponder];
        [retypePassword resignFirstResponder];
        [firstName resignFirstResponder];
        [lastName resignFirstResponder];
        [email resignFirstResponder];
        [DOB resignFirstResponder];
        [gender resignFirstResponder];
        [city resignFirstResponder];
        [zipcode resignFirstResponder];
        [phone resignFirstResponder];
        [description resignFirstResponder];
    }
    else if ([trimmedPassword rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location == NSNotFound) { //at least one number
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Password must contain at least one number." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        
        [username resignFirstResponder];
        [password resignFirstResponder];
        [retypePassword resignFirstResponder];
        [firstName resignFirstResponder];
        [lastName resignFirstResponder];
        [email resignFirstResponder];
        [DOB resignFirstResponder];
        [gender resignFirstResponder];
        [city resignFirstResponder];
        [zipcode resignFirstResponder];
        [phone resignFirstResponder];
        [description resignFirstResponder];
    }
    else if (upperCaseRange.location == NSNotFound) { //at least one uppercase
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Password must contain at least one uppercase letter." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        
        [username resignFirstResponder];
        [password resignFirstResponder];
        [retypePassword resignFirstResponder];
        [firstName resignFirstResponder];
        [lastName resignFirstResponder];
        [email resignFirstResponder];
        [DOB resignFirstResponder];
        [gender resignFirstResponder];
        [city resignFirstResponder];
        [zipcode resignFirstResponder];
        [phone resignFirstResponder];
        [description resignFirstResponder];
    }
    else if (lowerCaseRange.location == NSNotFound) { //at least one lowercase
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Password must contain at least one lowercase letter." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        
        [username resignFirstResponder];
        [password resignFirstResponder];
        [retypePassword resignFirstResponder];
        [firstName resignFirstResponder];
        [lastName resignFirstResponder];
        [email resignFirstResponder];
        [DOB resignFirstResponder];
        [gender resignFirstResponder];
        [city resignFirstResponder];
        [zipcode resignFirstResponder];
        [phone resignFirstResponder];
        [description resignFirstResponder];
    }
    else if (retypePasswordLength < 1) { //retype password length
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Please re-enter your password." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        
        [username resignFirstResponder];
        [password resignFirstResponder];
        [retypePassword resignFirstResponder];
        [firstName resignFirstResponder];
        [lastName resignFirstResponder];
        [email resignFirstResponder];
        [DOB resignFirstResponder];
        [gender resignFirstResponder];
        [city resignFirstResponder];
        [zipcode resignFirstResponder];
        [phone resignFirstResponder];
        [description resignFirstResponder];
    }
    else if (![trimmedPassword isEqualToString:trimmedReTypePassword]) { //retype password match
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Password and re-type passwords do not match." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        
        [username resignFirstResponder];
        [password resignFirstResponder];
        [retypePassword resignFirstResponder];
        [firstName resignFirstResponder];
        [lastName resignFirstResponder];
        [email resignFirstResponder];
        [DOB resignFirstResponder];
        [gender resignFirstResponder];
        [city resignFirstResponder];
        [zipcode resignFirstResponder];
        [phone resignFirstResponder];
        [description resignFirstResponder];
    }
    else if (firstNameLength < 1) { //validate first name
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Please enter your first name." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        
        [username resignFirstResponder];
        [password resignFirstResponder];
        [retypePassword resignFirstResponder];
        [firstName resignFirstResponder];
        [lastName resignFirstResponder];
        [email resignFirstResponder];
        [DOB resignFirstResponder];
        [gender resignFirstResponder];
        [city resignFirstResponder];
        [zipcode resignFirstResponder];
        [phone resignFirstResponder];
        [description resignFirstResponder];
    }
    else if (lastNameLength < 1) { //validate last name
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Please enter your last name." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        
        [username resignFirstResponder];
        [password resignFirstResponder];
        [retypePassword resignFirstResponder];
        [firstName resignFirstResponder];
        [lastName resignFirstResponder];
        [email resignFirstResponder];
        [DOB resignFirstResponder];
        [gender resignFirstResponder];
        [city resignFirstResponder];
        [zipcode resignFirstResponder];
        [phone resignFirstResponder];
        [description resignFirstResponder];
    }
    else if (!isValidEmail) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Please enter a valid email address." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        
        [username resignFirstResponder];
        [password resignFirstResponder];
        [retypePassword resignFirstResponder];
        [firstName resignFirstResponder];
        [lastName resignFirstResponder];
        [email resignFirstResponder];
        [DOB resignFirstResponder];
        [gender resignFirstResponder];
        [city resignFirstResponder];
        [zipcode resignFirstResponder];
        [phone resignFirstResponder];
        [description resignFirstResponder];
    }
    //validate age
    else if (DOBLength < 1) { //no age
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Please enter your Date of Birth." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        
        [username resignFirstResponder];
        [password resignFirstResponder];
        [retypePassword resignFirstResponder];
        [firstName resignFirstResponder];
        [lastName resignFirstResponder];
        [email resignFirstResponder];
        [DOB resignFirstResponder];
        [gender resignFirstResponder];
        [city resignFirstResponder];
        [zipcode resignFirstResponder];
        [phone resignFirstResponder];
        [description resignFirstResponder];
    }
    else if (currentUserAge < 13) { //younger than 13
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You're too young..." message:@"You must be at least 13 years of age to create a Yapster account. Sorry!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        
        [username resignFirstResponder];
        [password resignFirstResponder];
        [retypePassword resignFirstResponder];
        [firstName resignFirstResponder];
        [lastName resignFirstResponder];
        [email resignFirstResponder];
        [DOB resignFirstResponder];
        [gender resignFirstResponder];
        [city resignFirstResponder];
        [zipcode resignFirstResponder];
        [phone resignFirstResponder];
        [description resignFirstResponder];
    }
    else if (currentUserAge > 120) { //older than 120
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You're too old..." message:@"You must be at least 13 years of age and no older than 120 years of age to create a Yapster account. Sorry!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        
        [username resignFirstResponder];
        [password resignFirstResponder];
        [retypePassword resignFirstResponder];
        [firstName resignFirstResponder];
        [lastName resignFirstResponder];
        [email resignFirstResponder];
        [DOB resignFirstResponder];
        [gender resignFirstResponder];
        [city resignFirstResponder];
        [zipcode resignFirstResponder];
        [phone resignFirstResponder];
        [description resignFirstResponder];
    }
    else if ([[gender.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Please select your gender." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        
        [username resignFirstResponder];
        [password resignFirstResponder];
        [retypePassword resignFirstResponder];
        [firstName resignFirstResponder];
        [lastName resignFirstResponder];
        [email resignFirstResponder];
        [DOB resignFirstResponder];
        [gender resignFirstResponder];
        [city resignFirstResponder];
        [zipcode resignFirstResponder];
        [phone resignFirstResponder];
        [description resignFirstResponder];
    }
    else if (![[gender.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"Female"] && ![[gender.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"Male"] && ![[gender.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"Other"]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Please select a valid gender from the list." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        
        [username resignFirstResponder];
        [password resignFirstResponder];
        [retypePassword resignFirstResponder];
        [firstName resignFirstResponder];
        [lastName resignFirstResponder];
        [email resignFirstResponder];
        [DOB resignFirstResponder];
        [gender resignFirstResponder];
        [city resignFirstResponder];
        [zipcode resignFirstResponder];
        [phone resignFirstResponder];
        [description resignFirstResponder];
    }
    else if (countryLength > 0 && ![self.onlyCountriesArray containsObject:trimmedCountry]) { //validate country
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Please select a valid country from the list." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        
        [username resignFirstResponder];
        [password resignFirstResponder];
        [retypePassword resignFirstResponder];
        [firstName resignFirstResponder];
        [lastName resignFirstResponder];
        [email resignFirstResponder];
        [DOB resignFirstResponder];
        [gender resignFirstResponder];
        [city resignFirstResponder];
        [zipcode resignFirstResponder];
        [phone resignFirstResponder];
        [description resignFirstResponder];
    }
    /*else if (countryLength > 0 && ![trimmedCountry isEqualToString:@"United States"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"We're sorry, but our app is currently only supported in the United States." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
         [alert show];
    }*/
    else {
        //validate zipcode
        if (trimmedZipcodeLength > 0) {
            NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
            if (trimmedZipcodeLength < 5 || [trimmedZipcode rangeOfCharacterFromSet:notDigits].location != NSNotFound) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Please enter a valid zipcode." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
                
                [username resignFirstResponder];
                [password resignFirstResponder];
                [retypePassword resignFirstResponder];
                [firstName resignFirstResponder];
                [lastName resignFirstResponder];
                [email resignFirstResponder];
                [DOB resignFirstResponder];
                [gender resignFirstResponder];
                [city resignFirstResponder];
                [zipcode resignFirstResponder];
                [phone resignFirstResponder];
                [description resignFirstResponder];
                
                return;
            }
            else if (trimmedZipcodeLength > 5) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Please enter a valid zipcode." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
                
                [username resignFirstResponder];
                [password resignFirstResponder];
                [retypePassword resignFirstResponder];
                [firstName resignFirstResponder];
                [lastName resignFirstResponder];
                [email resignFirstResponder];
                [DOB resignFirstResponder];
                [gender resignFirstResponder];
                [city resignFirstResponder];
                [zipcode resignFirstResponder];
                [phone resignFirstResponder];
                [description resignFirstResponder];
                
                return;
            }
        }
        
        //register user
    
        NSString *lowercaseCountry = trimmedCountry.lowercaseString;
    
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        
        if (networkStatus == NotReachable) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"There seems to be no internet connection on your device" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
        else {
            //convert to lowercase
            //trimmedFirstName = [trimmedFirstName lowercaseString];
            //trimmedLastName = [trimmedLastName lowercaseString];
            
            //password SHA1 encryption
            //trimmedPassword = [self sha1:trimmedPassword];
            
            NSString *device_token = [NSString stringWithFormat:@"%@", token];
            
            //build an info object and convert to json
            NSMutableDictionary *newDatasetInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                            trimmedUsername, @"username",
                                            trimmedEmail, @"email",
                                            trimmedFirstName, @"first_name",
                                            trimmedLastName, @"last_name",
                                            trimmedPassword, @"password",
                                            trimmedDOB, @"date_of_birth",
                                            [gender.text substringToIndex:1], @"gender",
                                            device_token, @"session_device_token",
                                            nil];
            
            if (descriptionLength > 0) {
                [newDatasetInfo setValue:description.text forKey:@"description"];
            }
            
            if (![trimmedPhone isEqualToString:@""]) {
                [newDatasetInfo setValue:trimmedPhone forKey:@"phone_number"];
            }
            
            if (![trimmedCountry isEqualToString:@""]) {
                NSNumber *country_id = [[NSNumber alloc] initWithInt:[[[countriesList objectAtIndex:[CountryPickerField selectedRowInComponent:0]] objectForKey:@"country_id"] intValue]];
                
                [newDatasetInfo setValue:country_id forKey:@"user_country_id"];
            }
            
            if (![trimmedState isEqualToString:@""]) {
                NSNumber *state_id = [[NSNumber alloc] initWithInt:[[[statesList objectAtIndex:[StatePickerField selectedRowInComponent:0]] objectForKey:@"us_states_id"] intValue]];
                
                [newDatasetInfo setValue:state_id forKey:@"user_us_state_id"];
            }
            
            if (![trimmedCity isEqualToString:@""]) {
                [newDatasetInfo setValue:trimmedCity forKey:@"user_city_name"];
            }
            
            if (![trimmedZipcode isEqualToString:@""]) {
                [newDatasetInfo setValue:trimmedZipcode forKey:@"user_us_zip_code"];
            }
            
            /*
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
             */
            
            NSError *error;
            
            //convert object to data
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
            
            NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/users/sign_up/"];
            
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
            
            connection1 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            [connection1 start];
            
            if (connection1) {
                SignUpButton.hidden = YES;
                self.view.userInteractionEnabled = NO;
                self.view.alpha = 0.5f;
                
                loading.hidden = NO;
                
                [loading startAnimating];
            }
            else {
                //Error
            }
        }
    }
}

-(NSString*) sha1:(NSString*)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}

-(void)connection:(NSURLConnection *) connection didReceiveData:(NSData *)data {
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

-(void)connectionDidFinishLoading:(NSURLConnection *) connection {
    if (connection == connection1) {
        DLog(@"%@", json);
        
        if (json.count > 0) {
            BOOL valid = [[json objectForKey:@"valid"] boolValue];
            int uID = [[json objectForKey:@"user_id"] intValue];
            int sessID = [[json objectForKey:@"session_id"] intValue];
            
            DLog(@"%@", json);
            
            if (valid) {
                sessionUserID = uID;
                sessionID = sessID;
                
                if (sessionUnCroppedPhoto != nil) {
                    /*dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    dispatch_async(queue, ^{
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                        });*/
                    
                    
                        bigPicturePath = [NSString stringWithFormat:@"yapsterusers/uid/%0.0f/profile_pictures/%0.0f-big.jpg", sessionUserID, sessionUserID];
                        smallPicturePath = [NSString stringWithFormat:@"yapsterusers/uid/%0.0f/profile_pictures/%0.0f-cropped.jpg", sessionUserID, sessionUserID];
                        
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
                    
                        sessionUserUncroppedPhoto = sessionUnCroppedPhoto;
                        
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
                    
                        sessionUserCroppedPhoto = sessionCroppedPhoto;
                    
                        //dispatch_async(dispatch_get_main_queue(), ^{
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
                        //});
                    //});
                }
                else {
                    NSNumber *tempSessionUserId = [[NSNumber alloc] initWithInt:sessionUserID];
                    NSNumber *tempSessionId = [[NSNumber alloc] initWithInt:sessionID];
                    
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
                    
                    responseBodyUserprofile = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                    
                    connection6 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                    
                    [connection6 start];
                    
                    if (connection6) {
                        
                    }
                    else {
                        //Error
                    }
                }
            }
            else {
                NSString *errorMessage = [json objectForKey:@"message"];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:errorMessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
                
                loading.hidden = YES;
                
                SignUpButton.hidden = NO;
                
                self.view.userInteractionEnabled = YES;
                self.view.alpha = 1.0f;
                
                [username resignFirstResponder];
                [password resignFirstResponder];
                [retypePassword resignFirstResponder];
                [firstName resignFirstResponder];
                [lastName resignFirstResponder];
                [email resignFirstResponder];
                [DOB resignFirstResponder];
                [city resignFirstResponder];
                [zipcode resignFirstResponder];
                [country resignFirstResponder];
                [phone resignFirstResponder];
                [description resignFirstResponder];
                
            }
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Could not authenticate login." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            
            loading.hidden = YES;
            
            SignUpButton.hidden = NO;
            
            self.view.userInteractionEnabled = YES;
            self.view.alpha = 1.0f;
            
            [username resignFirstResponder];
            [password resignFirstResponder];
            [retypePassword resignFirstResponder];
            [firstName resignFirstResponder];
            [lastName resignFirstResponder];
            [email resignFirstResponder];
            [DOB resignFirstResponder];
            [city resignFirstResponder];
            [zipcode resignFirstResponder];
            [country resignFirstResponder];
            [phone resignFirstResponder];
            [description resignFirstResponder];
        }
    }
    else if (connection == connection2) {
        NSData *data = [responseBodyCountries dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableArray *json_countries = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        self.countriesList = [NSMutableArray arrayWithArray:json_countries];
        
        DLog(@"%@", self.countriesList);
        
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
        [CountryPickerField reloadAllComponents];
        
        loading.hidden = YES;
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
        [StatePickerField reloadAllComponents];
        
        loading.hidden = YES;
    }
    else if (connection == connection5) {
        NSNumber *tempSessionUserId = [[NSNumber alloc] initWithInt:sessionUserID];
        NSNumber *tempSessionId = [[NSNumber alloc] initWithInt:sessionID];
        
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
        
        responseBodyUserprofile = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        connection6 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        [connection6 start];
        
        if (connection6) {
            
        }
        else {
            //Error
        }
    }
    else if (connection == connection6) {
        //parse user profile info
        NSDictionary *user;
        NSDictionary *user_country;
        
        NSData *data = [responseBodyUserprofile dataUsingEncoding:NSUTF8StringEncoding];
        
        json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        user = [json objectForKey:@"user"];
        user_country = [json objectForKey:@"user_country"];
        
        NSString *first_name = [user objectForKey:@"first_name"];
        NSString *last_name = [user objectForKey:@"last_name"];
        NSString *the_username = [user objectForKey:@"username"];
        NSString *the_country;
        
        if (![user_country isKindOfClass:[NSNull class]]) {
            the_country = [user_country objectForKey:@"country"];
        }
        
        sessionFirstName = first_name;
        sessionLastName = last_name;
        sessionUsername = the_username;
        sessionCountry = the_country;
        
        DLog(@"%@", sessionFirstName);
        DLog(@"%@", sessionLastName);
        
        [keychain setObject:[username text] forKey:(__bridge id)kSecAttrAccount];
        [keychain setObject:[password text] forKey:(__bridge id)kSecValueData];
        
        NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        NSString *trimmedUsername = [sessionUsername stringByTrimmingCharactersInSet:whitespace];
        NSString *trimmedPassword = [password.text stringByTrimmingCharactersInSet:whitespace];
        NSString *device_token = [NSString stringWithFormat:@"%@", token];
        
        NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        trimmedUsername, @"option",
                                        @"username", @"option_type",
                                        trimmedPassword, @"password",
                                        device_token, @"session_device_token",
                                        nil];
        
        NSError *error;
        
        //convert object to data
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
        
        NSMutableURLRequest *request = [ NSMutableURLRequest requestWithURL: [NSURL URLWithString:@"http://api.yapster.co/api/0.0.1/users/sign_in/"] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 60.0];
        
        //[request setTimeoutInterval:20.0];
        //[request setURL:the_url];
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
            
        }
        else {
            //Error
        }
    }
    else if (connection == connection7) {
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
        
        DLog(@"plistData: %@", plistData);
        
        [plistData writeToFile:userDataPath atomically:YES];
        
        GetRecommendedUsers *GetRecommendedUsersController = [self.storyboard instantiateViewControllerWithIdentifier:@"GetRecommendedUsersVC"];
        
        self.GetRecommendedUsersVC = GetRecommendedUsersController;
        
        exploreScreenFirstLoaded = true;
        playlistScreenFirstLoaded = true;
        yapScreenFirstLoaded = true;
        
        //Push to next view controller
        [self.navigationController pushViewController:GetRecommendedUsersController animated:YES];
        
        [loading stopAnimating];
        loading.hidden = YES;
    }
}

@end
