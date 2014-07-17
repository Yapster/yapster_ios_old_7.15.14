//
//  CropCorners.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 6/12/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "CropCorners.h"

@implementation CropCorners

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void) drawMountainsInRect: (CGRect) rect inContext: (CGContextRef) context withColorSpace: (CGColorSpaceRef) colorSpace
{
    UIColor * darkColor = [UIColor colorWithRed:1.0/255.0 green:93.0/255.0 blue:67.0/255.0 alpha:1];
    UIColor * lightColor = [UIColor colorWithRed:63.0/255.0 green:109.0/255.0 blue:79.0/255.0 alpha:1];
    
    NSArray * mountainColors = @[(__bridge id)darkColor.CGColor, (__bridge id)lightColor.CGColor];
    CGFloat mountainLocations[] = { .1, .2 };
    CGGradientRef mountainGrad = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) mountainColors, mountainLocations);
    CGPoint mountainStart = CGPointMake(rect.size.height / 2, 100);
    CGPoint mountainEnd = CGPointMake(rect.size.height / 2, rect.size.width);
    
    CGContextSaveGState(context);
    
    CGContextSaveGState(context); // Previous Code
    
    CGMutablePathRef backgroundMountains = CGPathCreateMutable();
    CGPathMoveToPoint(backgroundMountains, nil, -5, 157);
    CGPathAddQuadCurveToPoint(backgroundMountains, nil, 30, 129, 77, 157);
    
    CGPathAddQuadCurveToPoint(backgroundMountains, nil, 30, 129, 77, 157);  // Old Code
    
    // Background Mountain Stroking
    CGContextAddPath(context, backgroundMountains);
    CGContextSetStrokeColorWithColor(context,[UIColor blackColor].CGColor);
    CGContextStrokePath(context);
    
    CGPathAddCurveToPoint(backgroundMountains, nil, 190, 210, 200, 70, 303, 125); // Old Code
    CGPathAddQuadCurveToPoint(backgroundMountains, nil, 340, 150, 350, 150);
    CGPathAddQuadCurveToPoint(backgroundMountains, nil, 380, 155, 410, 145);
    CGPathAddCurveToPoint(backgroundMountains, nil, 500, 100, 540, 190, 580, 165);
    CGPathAddLineToPoint(backgroundMountains, nil, 580, rect.size.width);
    CGPathAddLineToPoint(backgroundMountains, nil, -5, rect.size.width);
    CGPathCloseSubpath(backgroundMountains);
    
    CGPathCloseSubpath(backgroundMountains); // Previous Code
    
    // Background Mountain Drawing
    CGContextAddPath(context, backgroundMountains);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, mountainGrad, mountainStart, mountainEnd, 0);
    CGContextSetLineWidth(context, 4);
    
    CGContextStrokePath(context);  // Previous Code
    
    // Foreground Mountains
    CGMutablePathRef foregroundMountains = CGPathCreateMutable();
    CGPathMoveToPoint(foregroundMountains, nil, -5, 190);
    CGPathAddCurveToPoint(foregroundMountains, nil, 160, 250, 200, 140, 303, 190);
    CGPathAddCurveToPoint(foregroundMountains, nil, 430, 250, 550, 170, 590, 210);
    CGPathAddLineToPoint(foregroundMountains, nil, 590, 230);
    CGPathAddCurveToPoint(foregroundMountains, nil, 300, 260, 140, 215, 0, 225);
    CGPathCloseSubpath(foregroundMountains);
    
    // Foreground Mountain drawing
    CGContextAddPath(context, foregroundMountains);
    CGContextClip(context);
    CGContextSetFillColorWithColor(context, darkColor.CGColor);
    CGContextFillRect(context, CGRectMake(0, 170, 590, 90));
    
    // Foreground Mountain stroking
    CGContextAddPath(context, foregroundMountains);
    CGContextSetStrokeColorWithColor(context,[UIColor blackColor].CGColor);
    CGContextStrokePath(context);
    
    // Cleanup Code
    CGPathRelease(foregroundMountains);
    CGPathRelease(backgroundMountains); // Previous Code
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    [self drawMountainsInRect:rect inContext:context withColorSpace:colorSpace];
    // draw grass
    // draw flowers
    
    CGColorSpaceRelease(colorSpace);
}

@end
