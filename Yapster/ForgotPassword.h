//
//  ForgotPassword.h
//  Yapster
//
//  Created by Abu-Bakar Bah on 6/16/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetSecurityCode.h"
#import "ResetPassword.h"

@interface ForgotPassword : UIViewController {
    IBOutlet UIView *buttonsView;
}

-(IBAction)goBack:(id)sender;
-(IBAction)resetPasswordWithEmailAndSecurityCode:(id)sender;
-(IBAction)getSecurityCode:(id)sender;

@end
