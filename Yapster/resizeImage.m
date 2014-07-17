//
//  resizeImage.m
//  rateMyLook
//
//  Created by Nicholas Barrowclough on 10/28/12.
//  Copyright (c) 2012 Nicholas Barrowclough. All rights reserved.
//

#import "resizeImage.h"

@implementation resizeImage


-(UIImage *)resizeImage:(UIImage *)image width:(CGFloat)resizedWidth height:(CGFloat)resizedHeight
{
    UIGraphicsBeginImageContext(CGSizeMake(resizedWidth ,resizedHeight));
    [image drawInRect:CGRectMake(0, 0, resizedWidth, resizedHeight)];
    resized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resized;
}


- (NSData *) thumbnailImageData {
    thumbnailImageData = UIImageJPEGRepresentation(resized, 0.7);
    return thumbnailImageData;
}

@end
