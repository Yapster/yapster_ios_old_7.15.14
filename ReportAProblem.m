//
//  ReportAProblem.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 4/21/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "ReportAProblem.h"
#import "Stream.h"

@interface ReportAProblem ()

@end

@implementation ReportAProblem

@synthesize responseBodyReportProblem;
@synthesize reportProblemJson;
@synthesize json;
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
    
    phone.delegate = self;
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

-(IBAction)sendReport:(id)sender {
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedPhone = [phone.text stringByTrimmingCharactersInSet:whitespace];
    NSString *trimmedEmail = [email.text stringByTrimmingCharactersInSet:whitespace];
    NSString *trimmedDescription = [description.text stringByTrimmingCharactersInSet:whitespace];
    
    NSUInteger trimmedPhoneLength = [trimmedPhone length];
    NSUInteger trimmedEmailLength = [trimmedEmail length];
    NSUInteger trimmedDescriptionLength = [trimmedDescription length];
    
    //validate email
    NSString *emailValue = email.text;
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValidEmail = [emailTest evaluateWithObject:emailValue];
    
    [phone resignFirstResponder];
    [email resignFirstResponder];
    [description resignFirstResponder];
    
    if (trimmedPhoneLength == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Please enter your phone number." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else if (trimmedEmailLength == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Please enter your email address." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else if (!isValidEmail) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Please enter a valid email address." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else if (trimmedDescriptionLength == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Please enter a description." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else {
        //send report
        NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
        NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
        
        NSDictionary *newDatasetInfo;
        NSData* jsonData;
        NSURL *the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/report/general/"];
        
        NSError *error;
        
        newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                          tempSessionUserID, @"user_id",
                          tempSessionID, @"session_id",
                          email.text, @"contact_email",
                          phone.text, @"contact_phone_number",
                          description.text, @"description",
                          nil];
        
        //convert object to data
        jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:the_url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPBody:jsonData];
        
        NSHTTPURLResponse* urlResponse = nil;
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
        
        responseBodyReportProblem = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        if (!jsonData) {
            DLog(@"JSON error: %@", error);
        }
        
        connection1 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        [connection1 start];
    }
}

-(void)connection:(NSURLConnection *) connection didReceiveData:(NSData *)data {
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

-(void)connectionDidFinishLoading:(NSURLConnection *) connection {

    if (connection == connection1) {
        NSData *data = [responseBodyReportProblem dataUsingEncoding:NSUTF8StringEncoding];
        
        reportProblemJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        DLog(@"%@", reportProblemJson);
        
        if (json.count > 0) {
            BOOL valid = [[reportProblemJson objectForKey:@"valid"] boolValue];
            
            if (!valid) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Could not send your report at this time. Please try again later." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Report Sent" message:@"Your report has successfully been sent to the Yapster Team. Thank you!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Could not send your report at this time. Please try again later." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
    }
}

@end
