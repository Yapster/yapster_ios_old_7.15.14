//
//  ContactYapster.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 4/21/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "ContactYapster.h"

@interface ContactYapster ()

@end

@implementation ContactYapster

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
    
    NSURL*url=[NSURL URLWithString:@"http://www.yapster.co/#!trouble-shooting/c1gjj"];
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
