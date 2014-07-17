//
//  SignUp.h
//  Yapster
//
//  Created by Abu-Bakar Bah on 3/31/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import "GlobalVars.h"
#import "TermsOfService.h"
#import "PrivacyPolicy.h"
#import "Reachability.h"
#import "CropPhotoForYap.h"
#import "TTTAttributedLabel.h"
#import "GetRecommendedUsers.h"
#import <AWSRuntime/AWSRuntime.h>
#import "AmazonClientManager.h"
#import "KeychainItemWrapper.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

@interface SignUp : UIViewController <UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate, FBLoginViewDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
    IBOutlet UITextField *retypePassword;
    
    IBOutlet UITextField *firstName;
    IBOutlet UITextField *lastName;
    IBOutlet UITextField *email;
    IBOutlet UITextField *DOB;
    IBOutlet UITextField *gender;
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
    IBOutlet UIButton *facebookLoginBtn;
    IBOutlet UILabel *remainingCharactersForDesc;
    IBOutlet UILabel *requirementsLabel;
    
    UIImagePickerController *picker;
    UIImagePickerController *picker2;
    
    IBOutlet UIActivityIndicatorView *loading;
    
    //IBOutlet UIPickerView *CountryPickerField;
    
    int currentUserAge;
    
    KeychainItemWrapper *keychain;
}

@property (strong, nonatomic) IBOutlet FBLoginView *facebookLoginView;
@property id token;
@property (nonatomic, strong) CropPhotoForYap *cropPhotoForYapVC;
@property(retain, nonatomic)TermsOfService *TermsOfServiceVC;
@property(retain, nonatomic)PrivacyPolicy *PrivacyPolicyVC;
@property(retain, nonatomic)GetRecommendedUsers *GetRecommendedUsersVC;
@property(retain, nonatomic)NSDictionary *json;
@property(retain, nonatomic)NSURLConnection *connection1;
@property(retain, nonatomic)NSURLConnection *connection2;
@property(retain, nonatomic)NSURLConnection *connection3;
@property(retain, nonatomic)NSURLConnection *connection4;
@property(retain, nonatomic)NSURLConnection *connection5;
@property(retain, nonatomic)NSURLConnection *connection6;
@property(retain, nonatomic)NSURLConnection *connection7;
@property(retain, nonatomic)NSMutableArray *countriesList;
@property(retain, nonatomic)NSMutableArray *countriesArray;
@property(retain, nonatomic)NSMutableArray *onlyCountriesArray;
@property(retain, nonatomic)NSMutableArray *citiesList;
@property(retain, nonatomic)NSMutableArray *citiesArray;
@property(retain, nonatomic)NSMutableArray *statesList;
@property(retain, nonatomic)NSMutableArray *statesArray;
@property(retain, nonatomic)NSMutableArray *genderArray;
@property(retain, nonatomic)NSString *responseBodyCountries;
@property(retain, nonatomic)NSString *responseBodyCities;
@property(retain, nonatomic)NSString *responseBodyStates;
@property(retain, nonatomic)NSString *responseBodyUserprofile;
@property(retain, nonatomic)NSString *userDataPath;
@property(retain, nonatomic)UIPickerView *CountryPickerField;
@property(retain, nonatomic)UIPickerView *CityPickerField;
@property(retain, nonatomic)UIPickerView *StatePickerField;
@property(retain, nonatomic)UIPickerView *GenderPickerField;
@property(retain, nonatomic)NSString *bigPicturePath;
@property(retain, nonatomic)NSString *smallPicturePath;

-(IBAction)goBack:(id)sender;
-(IBAction)signUp:(id)sender;
-(IBAction)viewTerms:(id)sender;
-(IBAction)viewPrivacy:(id)sender;
-(IBAction)showPhotoOptions:(id)sender;
-(IBAction)zipcodeEdited:(id)sender;
-(void)validateFields;
-(IBAction)facebookConnect:(id)sender;
-(void)getFacebookUserInfo;
-(IBAction)choosePhotoFromAlbum:(id)sender;
-(IBAction)takePhotoFromCamera:(id)sender;
-(IBAction)recropPhoto:(id)sender;
-(IBAction)userhandleClicked:(id)sender;
-(IBAction)passwordClicked:(id)sender;
-(IBAction)firstnameClicked:(id)sender;
-(IBAction)lastnameClicked:(id)sender;
-(IBAction)emailClicked:(id)sender;
-(IBAction)dobClicked:(id)sender;
-(IBAction)genderClicked:(id)sender;
-(IBAction)countryClicked:(id)sender;
-(IBAction)stateClicked:(id)sender;
-(IBAction)cityClicked:(id)sender;
-(IBAction)zipcodeClicked:(id)sender;
-(IBAction)phoneClicked:(id)sender;
-(IBAction)descriptionClicked:(id)sender;

@end
