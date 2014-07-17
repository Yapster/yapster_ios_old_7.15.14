//
//  ResetPassword.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 6/16/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "ResetPassword.h"
#import "ViewController.h"

@interface ResetPassword ()

@end

@implementation ResetPassword

@synthesize alertViewPasswordReset;
@synthesize json;
@synthesize responseBody;
@synthesize connection1;

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
	
    //padding for username and password text fields
    UIView *fieldEmail = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    UIView *fieldSecurityCode = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    UIView *fieldNewPassword = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    
    emailOrUserHandle.leftViewMode = UITextFieldViewModeAlways;
    emailOrUserHandle.leftView     = fieldEmail;
    
    securityCode.leftViewMode = UITextFieldViewModeAlways;
    securityCode.leftView     = fieldSecurityCode;
    
    newPassword.leftViewMode = UITextFieldViewModeAlways;
    newPassword.leftView     = fieldNewPassword;
    
    [emailOrUserHandle setBorderStyle:UITextBorderStyleNone];
    emailOrUserHandle.layer.cornerRadius = 5;
    
    [securityCode setBorderStyle:UITextBorderStyleNone];
    securityCode.layer.cornerRadius = 5;
    
    [newPassword setBorderStyle:UITextBorderStyleNone];
    newPassword.layer.cornerRadius = 5;
    
    [emailOrUserHandle setBackgroundColor:[UIColor whiteColor]];
    [securityCode setBackgroundColor:[UIColor whiteColor]];
    [newPassword setBackgroundColor:[UIColor whiteColor]];
    
    emailOrUserHandle.delegate = self;
    securityCode.delegate = self;
    newPassword.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return NO;
}

-(IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)resetPassword:(id)sender {
    NSString *trimmed_email_or_user_handle = [emailOrUserHandle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *trimmed_sec_code = [securityCode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *trimmed_new_password = [newPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *trimmed_new_password_retype = [newPasswordRetype.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSRange upperCaseRange;
    NSCharacterSet *upperCaseSet = [NSCharacterSet uppercaseLetterCharacterSet];
    
    upperCaseRange = [trimmed_new_password rangeOfCharacterFromSet: upperCaseSet];
    
    NSRange lowerCaseRange;
    NSCharacterSet *lowerCaseSet = [NSCharacterSet lowercaseLetterCharacterSet];
    
    lowerCaseRange = [trimmed_new_password rangeOfCharacterFromSet: lowerCaseSet];
    
    if ([trimmed_email_or_user_handle length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Please enter your email or username." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else if ([trimmed_sec_code length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Please enter your password reset security code (this should have been sent to your email)." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else if ([trimmed_new_password length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Please enter your new password." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else if ([trimmed_new_password rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location == NSNotFound) { //at least one number
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Password must contain at least one number." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else if (upperCaseRange.location == NSNotFound) { //at least one uppercase
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Password must contain at least one uppercase letter." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else if (lowerCaseRange.location == NSNotFound) { //at least one lowercase
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Password must contain at least one lowercase letter." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else if (![trimmed_new_password isEqualToString:trimmed_new_password_retype]) { //retype password match
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Password and re-type passwords do not match." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else {
        //check if username or email
        BOOL isEmail;
        
        NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        
        if  ([emailTest evaluateWithObject:trimmed_email_or_user_handle] != YES && [trimmed_email_or_user_handle length]!=0)
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
        
        NSError *error;
        
        NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        trimmed_email_or_user_handle, @"option",
                                        option_type, @"option_type",
                                        securityCode.text, @"reset_password_security_code",
                                        newPassword.text, @"new_password",
                                        nil];
        
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
        
        NSURL *the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/users/forgot_password/reset_password_request/"];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:the_url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPBody:jsonData];
        
        NSHTTPURLResponse* urlResponse = nil;
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
        
        responseBody = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        if (!jsonData) {
            DLog(@"JSON error: %@", error);
        }
        
        connection1 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        [connection1 start];
        
        if (connection1) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
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
        NSData *data = [responseBody dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *json_info = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        //DLog(@"%@", json_info);
        
        if (json_info.count > 0) {
            BOOL valid = [[json_info objectForKey:@"valid"] boolValue];
            
            if (!valid) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"The security code doesn't match what was sent to your email." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }
            else {
                alertViewPasswordReset = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Your password has successfully been reset. You may now sign in." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertViewPasswordReset show];
            }
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == alertViewPasswordReset) {
        ViewController *homeScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
        
        //Push to User Settings controller
        [self.navigationController pushViewController:homeScreen animated:YES];
    }
}



@end
