//
//  EditProfile.h
//  Yapster
//
//  Created by Abu-Bakar Bah on 5/3/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import "GlobalVars.h"
#import "Reachability.h"
#import "CropPhotoForYap.h"
#import <AWSRuntime/AWSRuntime.h>
#import "AmazonClientManager.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "KeychainItemWrapper.h"

@class UserProfile;

@interface EditProfile : UIViewController <UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate, FBLoginViewDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
    IBOutlet UITextField *retypePassword;
    IBOutlet UITextField *currentPassword;
    IBOutlet UIView *retypePasswordView;
    IBOutlet UIView *currentPasswordView;
    
    IBOutlet UITextField *firstName;
    IBOutlet UITextField *lastName;
    IBOutlet UITextField *email;
    IBOutlet UITextField *DOB;
    IBOutlet UITextField *city;
    IBOutlet UITextField *state;
    IBOutlet UITextField *zipcode;
    IBOutlet UITextField *country;
    IBOutlet UITextField *phone;
    IBOutlet UITextField *description;
    IBOutlet UIButton *termsLink;
    IBOutlet UIButton *privacyLink;
    IBOutlet UIButton *SignUpButton;
    IBOutlet UIButton *userPhotoBtn;
    IBOutlet UIButton *saveBtn;
    IBOutlet UIButton *facebookLoginBtn;
    IBOutlet UILabel *remainingCharactersForDesc;
    
    IBOutlet UISwitch *switchPostsArePrivate;
    
    UIImagePickerController *image_picker;
    UIImagePickerController *image_picker2;
    
    IBOutlet UIActivityIndicatorView *loading;
    IBOutlet UIActivityIndicatorView *saving;
    
    //IBOutlet UIPickerView *CountryPickerField;
    
    int currentUserAge;
    
    BOOL firstname_edited;
    BOOL lastname_edited;
    BOOL country_edited;
    BOOL city_edited;
    BOOL state_edited;
    BOOL zipcode_edited;
    BOOL phone_edited;
    BOOL description_edited;
    BOOL username_edited;
    BOOL password_edited;
    BOOL email_edited;
    
    KeychainItemWrapper *keychain;
    
    NSString *current_password;
}

@property (strong, nonatomic) IBOutlet FBLoginView *facebookLoginView;
@property BOOL has_state;
@property int user_country_id;
@property int user_us_states_id;
@property int user_us_zip_code;
@property (nonatomic, strong)CropPhotoForYap *cropPhotoForYapVC;
@property (nonatomic, strong)UserProfile *UserProfileVC;
@property(retain, nonatomic)NSDictionary *json;
@property(retain, nonatomic)NSURLConnection *connection1;
@property(retain, nonatomic)NSURLConnection *connection2;
@property(retain, nonatomic)NSURLConnection *connection3;
@property(retain, nonatomic)NSURLConnection *connection4;
@property(retain, nonatomic)NSURLConnection *connection5;
@property(retain, nonatomic)NSURLConnection *connection6;
@property(retain, nonatomic)NSURLConnection *connection7;
@property(retain, nonatomic)NSURLConnection *connection8;
@property(retain, nonatomic)NSMutableArray *countriesList;
@property(retain, nonatomic)NSMutableArray *countriesArray;
@property(retain, nonatomic)NSMutableArray *onlyCountriesArray;
@property(retain, nonatomic)NSMutableArray *citiesList;
@property(retain, nonatomic)NSMutableArray *citiesArray;
@property(retain, nonatomic)NSMutableArray *statesList;
@property(retain, nonatomic)NSMutableArray *statesArray;
@property(retain, nonatomic)NSString *userProfileResponseBody;
@property(retain, nonatomic)NSString *responseBodyStates;
@property(retain, nonatomic)NSString *responseBodyCountries;
@property(retain, nonatomic)NSString *responseBodyCities;
@property(retain, nonatomic)UIPickerView *CountryPickerField;
@property(retain, nonatomic)UIPickerView *CityPickerField;
@property(retain, nonatomic)UIPickerView *StatePickerField;
@property(retain, nonatomic)NSString *bigPicturePath;
@property(retain, nonatomic)NSString *smallPicturePath;

-(void)validateFields;
-(IBAction)setPostsArePrivate:(id)sender;
-(IBAction)saveInfo:(id)sender;
-(IBAction)goBack:(id)sender;
-(IBAction)firstnameEdited:(id)sender;
-(IBAction)lastnameEdited:(id)sender;
-(IBAction)countryEdited:(id)sender;
-(IBAction)cityEdited:(id)sender;
-(IBAction)stateEdited:(id)sender;
-(IBAction)zipcodeEdited:(id)sender;
-(IBAction)phoneEdited:(id)sender;
-(IBAction)descriptionEdited:(id)sender;
-(IBAction)emailEdited:(id)sender;
-(IBAction)usernameEdited:(id)sender;
-(IBAction)passwordEdited:(id)sender;
-(IBAction)choosePhotoFromAlbum:(id)sender;
-(IBAction)takePhotoFromCamera:(id)sender;
-(IBAction)recropPhoto:(id)sender;
-(IBAction)facebookConnect:(id)sender;
-(void)getFacebookUserInfo;

@end
