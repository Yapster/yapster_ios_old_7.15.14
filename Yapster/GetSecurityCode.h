//
//  GetSecurityCode.h
//  Yapster
//
//  Created by Abu-Bakar Bah on 6/16/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface GetSecurityCode : UIViewController <UITextFieldDelegate, UIAlertViewDelegate> {
    IBOutlet UITextField *email;
}

@property(retain, nonatomic)UIAlertView *alertViewGotCode;
@property(retain, nonatomic)NSDictionary *json;
@property(retain, nonatomic)NSString *responseBody;
@property(retain, nonatomic)NSURLConnection *connection1;

-(IBAction)goBack:(id)sender;
-(IBAction)getSecurityCode:(id)sender;

@end
