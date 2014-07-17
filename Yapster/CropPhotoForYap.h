//
//  CropPhotoForYap.h
//  Yapster
//
//  Created by Abu-Bakar Bah on 5/8/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GlobalVars.h"
#import "resizeImage.h"
#import "BFCropInterface.h"

@class CreateYap;

@interface CropPhotoForYap : UIViewController
{
    
}

@property (nonatomic, strong) CreateYap *createYapVC;
@property (nonatomic, strong) IBOutlet UIImageView *fullImageView;
@property (nonatomic, strong) IBOutlet UIView *cropView;
@property (nonatomic, strong) IBOutlet UIView *superView;
@property (nonatomic, strong) IBOutlet UIView *topButtonsView;
@property (nonatomic, strong) UIImage *fullImage;
@property (nonatomic, strong) UIImage *croppedImage;
@property (nonatomic, strong) BFCropInterface *cropper;

-(IBAction)goBack:(id)sender;
-(IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;
-(IBAction)cropImageMethod:(id)sender;
-(CGRect)frameForImage:(UIImage*)image inImageViewAspectFit:(UIImageView*)imageView;

@end
