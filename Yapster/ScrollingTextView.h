//
//  ScrollingTextView.h
//  Yapster
//
//  Created by Abu-Bakar Bah on 7/3/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollingTextView : UIView {
    NSTimer * scroller;
    CGPoint point;
    NSString * text;
    NSTimeInterval speed;
    CGFloat stringWidth;
}

@property (nonatomic, copy) NSString * text;
@property (nonatomic) NSTimeInterval speed;

@end
