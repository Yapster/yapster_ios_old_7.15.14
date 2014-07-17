//
//  GetSecurityCode.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 6/16/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "GetSecurityCode.h"
#import "ViewController.h"

@interface GetSecurityCode ()

@end

@implementation GetSecurityCode

@synthesize alertViewGotCode;
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
    
    email.leftViewMode = UITextFieldViewModeAlways;
    email.leftView     = fieldEmail;
    
    [email setBorderStyle:UITextBorderStyleNone];
    email.layer.cornerRadius = 5;
    
    [email setBackgroundColor:[UIColor whiteColor]];
    
    email.delegate = self;
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

-(IBAction)getSecurityCode:(id)sender {
    NSString *trimmed_email = [email.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([trimmed_email length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Please enter your email." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else {
        NSError *error;
        
        NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        email.text, @"email",
                                        nil];
        
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
        
        NSURL *the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/users/forgot_password/request_for_email/"];
        
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
        
        DLog(@"%@", json_info);
        
        if (json_info.count > 0) {
            BOOL valid = [[json_info objectForKey:@"valid"] boolValue];
            
            if (!valid) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"There is no active user with this email." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }
            else {
                alertViewGotCode = [[UIAlertView alloc] initWithTitle:@"Yapster" message:[NSString stringWithFormat:@"Password reset code sent to %@. Please check your email.", email.text] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertViewGotCode show];
            }
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == alertViewGotCode) {
        ViewController *homeScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
        
        //Push to User Settings controller
        [self.navigationController pushViewController:homeScreen animated:YES];
    }
}

@end
