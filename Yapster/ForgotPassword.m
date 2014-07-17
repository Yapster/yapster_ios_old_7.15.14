//
//  ForgotPassword.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 6/16/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "ForgotPassword.h"

@interface ForgotPassword ()

@end

@implementation ForgotPassword

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
	
    buttonsView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)resetPasswordWithEmailAndSecurityCode:(id)sender {
    ResetPassword *resetPasswordVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ResetPasswordVC"];
    
    //Push to User Settings controller
    [self.navigationController pushViewController:resetPasswordVC animated:YES];
}

-(IBAction)getSecurityCode:(id)sender {
    GetSecurityCode *getSecurityCodeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GetSecurityCodeVC"];

    //Push to User Settings controller
    [self.navigationController pushViewController:getSecurityCodeVC animated:YES];
}

@end
