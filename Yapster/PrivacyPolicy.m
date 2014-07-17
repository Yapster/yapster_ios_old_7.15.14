//
//  PrivacyPolicy.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 3/31/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "PrivacyPolicy.h"

@interface PrivacyPolicy ()

@end

@implementation PrivacyPolicy

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
	
    webView.delegate = self;
    
    webView.scalesPageToFit = YES;
    
    NSURL*url=[NSURL URLWithString:@"http://www.yapster.co/#!privacy/c1l0o"];
    NSURLRequest*request=[NSURLRequest requestWithURL:url];
    [[webView self] loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [loading stopAnimating];
}

-(IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
