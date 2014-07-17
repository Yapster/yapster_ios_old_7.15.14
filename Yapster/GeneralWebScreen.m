//
//  GeneralWebScreen.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 5/29/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "GeneralWebScreen.h"

@interface GeneralWebScreen ()

@end

@implementation GeneralWebScreen

@synthesize web_link;

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
    
    web_link_label.text = web_link;
	
    webView.delegate = self;
    
    webView.scalesPageToFit = YES;
    
    NSURL*url=[NSURL URLWithString:web_link];
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
    cameFromWebScreen = true;
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
