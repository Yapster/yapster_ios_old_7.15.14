//
//  GeneralWebScreen.h
//  Yapster
//
//  Created by Abu-Bakar Bah on 5/29/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVars.h"

@interface GeneralWebScreen : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView *webView;
    IBOutlet UILabel *web_link_label;
    IBOutlet UIActivityIndicatorView *loading;
    
}

@property(retain, nonatomic) NSString *web_link;

-(IBAction)goBack:(id)sender;

@end
