//
//  ContactYapster.h
//  Yapster
//
//  Created by Abu-Bakar Bah on 4/21/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactYapster : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView *webView;
    IBOutlet UIActivityIndicatorView *loading;
    
}

-(IBAction)goBack:(id)sender;

@end
