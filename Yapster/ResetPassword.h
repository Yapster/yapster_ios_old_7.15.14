//
//  ResetPassword.h
//  Yapster
//
//  Created by Abu-Bakar Bah on 6/16/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface ResetPassword : UIViewController <UITextFieldDelegate, UIAlertViewDelegate> {
    IBOutlet UITextField *emailOrUserHandle;
    IBOutlet UITextField *securityCode;
    IBOutlet UITextField *newPassword;
    IBOutlet UITextField *newPasswordRetype;
}

@property(retain, nonatomic)UIAlertView *alertViewPasswordReset;
@property(retain, nonatomic)NSDictionary *json;
@property(retain, nonatomic)NSString *responseBody;
@property(retain, nonatomic)NSURLConnection *connection1;

-(IBAction)goBack:(id)sender;
-(IBAction)resetPassword:(id)sender;

@end
