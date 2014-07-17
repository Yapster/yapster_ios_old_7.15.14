//
//  resizeImage.h
//  rateMyLook
//
//  Created by Nicholas Barrowclough on 10/28/12.
//  Copyright (c) 2012 Nicholas Barrowclough. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface resizeImage : NSObject {
    
    NSData *thumbnailImageData;
    UIImage *resized;
}


-(UIImage *)resizeImage:(UIImage *)image width:(CGFloat)resizedWidth height:(CGFloat)resizedHeight;

-(NSData *) thumbnailImageData;

@end
