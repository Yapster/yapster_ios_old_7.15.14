//
//  ScrollingTextView.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 7/3/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "ScrollingTextView.h"

@implementation ScrollingTextView

@synthesize text;
@synthesize speed;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setText:(NSString *)newText {
    text = [newText copy];
    point = CGPointZero;
    
    UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:16.0];
    UIColor *color = [UIColor whiteColor];
    
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:font,
                                     NSFontAttributeName,
                                     [NSNumber numberWithFloat:1.0],
                                     NSBaselineOffsetAttributeName,
                                     color,
                                     UITextAttributeTextColor,
                                     nil];
    
    stringWidth = [newText sizeWithAttributes:attrsDictionary].width;
    
    if (scroller == nil && speed > 0 && text != nil) {
        scroller = [NSTimer scheduledTimerWithTimeInterval:speed target:self selector:@selector(moveText:) userInfo:nil repeats:YES];
    }
}

- (void) setSpeed:(NSTimeInterval)newSpeed {
    if (newSpeed != speed) {
        speed = newSpeed;
        
        [scroller invalidate];
        scroller = nil;
        
        if (speed > 0 && text != nil) {
            scroller = [NSTimer scheduledTimerWithTimeInterval:speed target:self selector:@selector(moveText:) userInfo:nil repeats:YES];
        }
    }
}

- (void) moveText:(NSTimer *)timer {
    if (stringWidth > 220.0) {
        point.x = point.x - 1.0f;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)dirtyRect {
    // Drawing code here.
    
    DLog(@"dirtyRect.size.width %f", dirtyRect.size.width);
    
    if (point.x + stringWidth < 0) {
        point.x += dirtyRect.size.width;
    }
    
    UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:16.0];
    UIColor *color = [UIColor whiteColor];
    
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:font,
                                     NSFontAttributeName,
                                     [NSNumber numberWithFloat:1.0],
                                     NSBaselineOffsetAttributeName,
                                     color,
                                     UITextAttributeTextColor,
                                     nil];
    
    [text drawAtPoint:point withAttributes:attrsDictionary];
    
    if (point.x < 0) {
        CGPoint otherPoint = point;
        otherPoint.x += dirtyRect.size.width;
        [text drawAtPoint:otherPoint withAttributes:attrsDictionary];
    }
}

@end
