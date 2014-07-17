//
//  ReportAProblem.h
//  Yapster
//
//  Created by Abu-Bakar Bah on 4/21/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVars.h"

@class Stream;

@interface ReportAProblem : UIViewController <UINavigationControllerDelegate, UITextFieldDelegate>
{
    IBOutlet UITextField *phone;
    IBOutlet UITextField *email;
    IBOutlet UITextView *description;
}

@property(retain, nonatomic)Stream *stream;
@property(retain, nonatomic)NSString *responseBodyReportProblem;
@property(retain, nonatomic)NSMutableDictionary *reportProblemJson;
@property(retain, nonatomic)NSArray *json;
@property(retain, nonatomic)NSURLConnection *connection1;

-(IBAction)goBack:(id)sender;
-(IBAction)sendReport:(id)sender;

@end
