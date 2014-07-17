//
//  CropPhotoForYap.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 5/8/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "CropPhotoForYap.h"
#import "CreateYap.h"

@interface CropPhotoForYap ()

@end

@implementation CropPhotoForYap

@synthesize createYapVC;
@synthesize fullImageView;
@synthesize cropView;
@synthesize superView;
@synthesize topButtonsView;
@synthesize fullImage;
@synthesize croppedImage;

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
    
    self.view.backgroundColor = [UIColor blackColor];
	
    //fullImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //fullImageView.image = fullImage;
    
    /*[cropView.layer setCornerRadius:cropView.frame.size.width/2];*/
    [cropView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [cropView.layer setBorderWidth:1.0];
    
    UIView *a_view = [[UIView alloc] initWithFrame:[self frameForImage:fullImage inImageViewAspectFit:fullImageView]];
    
    superView.hidden = YES;
    superView.backgroundColor = [UIColor grayColor];
    superView.frame = a_view.frame;
    
    //DLog(@"%f", a_view.frame.origin.y);
    
    //[superView clipsToBounds];
    //[self.view bringSubviewToFront:topButtonsView];
    
    cropView.frame = CGRectMake(110, 0, cropView.frame.size.width, cropView.frame.size.height);
    cropView.hidden = YES;
    
    // must have user interaction enabled on view that will hold crop interface
    self.fullImageView.userInteractionEnabled = YES;
    
    self.fullImageView.contentMode = UIViewContentModeScaleAspectFit;

    self.fullImageView.image = self.fullImage;
    
    // ** this is where the magic happens
    
    // allocate crop interface with frame and image being cropped
    self.cropper = [[BFCropInterface alloc]initWithFrame:self.fullImageView.bounds andImage:self.fullImage];
    // this is the default color even if you don't set it
    self.cropper.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.60];
    // white is the default border color.
    self.cropper.borderColor = [UIColor whiteColor];
    // add interface to superview. here we are covering the main image view.
    [self.fullImageView addSubview:self.cropper];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goBack:(id)sender {
    sessionUnCroppedPhoto = nil;
    sessionCroppedPhoto = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    switch (recognizer.state) {
            
        case UIGestureRecognizerStateChanged: {
            
            CGPoint translation = [recognizer translationInView:self.view];
            
            //allow dragging only in Y coordinates by only updating the Y coordinate with translation position
            recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
            
            //recognizer.view.center = CGPointMake(yapBtn.center.x + translation.x, yapBtn.center.y + translation.y);
            
            [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
            
            
            //get the top edge coordinate for the top left corner of crop frame
            float topEdgePosition = CGRectGetMinY(cropView.frame);
            
            //get the bottom edge coordinate for bottom left corner of crop frame
            float bottomEdgePosition = CGRectGetMaxY(cropView.frame);
            
            //get the left edge coordinate for the top left corner of crop frame
            float leftEdgePosition = CGRectGetMinX(cropView.frame);
            
            //get the right edge coordinate for bottom left corner of crop frame
            float rightEdgePosition = CGRectGetMaxX(cropView.frame);
            
            //get image size after aspect ratio
            UIView *a_view = [[UIView alloc] initWithFrame:[self frameForImage:fullImage inImageViewAspectFit:fullImageView]];
            
            double aspect_width = a_view.frame.size.width;
            double aspect_height = a_view.frame.size.height;
            
            DLog(@"%f %f", leftEdgePosition, topEdgePosition);
            
            //check if crop view is out of bounds
            if (topEdgePosition <= 0) {
                cropView.frame = CGRectMake(cropView.frame.origin.x, 0, 160, 160);
            }
            
            if (bottomEdgePosition >= a_view.frame.size.height) {
                cropView.frame = CGRectMake(cropView.frame.origin.x, (aspect_height-cropView.frame.size.height), 160, 160);
            }
            
            if (leftEdgePosition <= (320-aspect_width)/2) {
                cropView.frame = CGRectMake((320-aspect_width)/2, cropView.frame.origin.y, 160, 160);
            }
            
            if (rightEdgePosition > (aspect_width+((320-aspect_width)/2))) {
                cropView.frame = CGRectMake((aspect_width-cropView.frame.size.width)+((320-aspect_width)/2), cropView.frame.origin.y, 160, 160);
            }
            
            /*if (bottomEdgePosition >= [[UIScreen mainScreen] bounds].size.height) {
                cropView.frame = CGRectMake(cropView.frame.origin.x, [[UIScreen mainScreen] bounds].size.height-cropView.frame.size.height, 160, 160);
            }
            
            if (leftEdgePosition <= 0) {
                cropView.frame = CGRectMake(0, cropView.frame.origin.y, 160, 160);
            }
            
            if (rightEdgePosition > 320) {
                cropView.frame = CGRectMake(320-cropView.frame.size.width, cropView.frame.origin.y, 160, 160);
            }*/
            
            /*if (bottomEdgePosition >=460) {
                
                //draw drag view in max bottom position
                cropView.frame = CGRectMake(0, 230, 160, 160);
            }*/
            
            
        }
            
        default:
            break;
    }
}

-(CGRect)frameForImage:(UIImage*)image inImageViewAspectFit:(UIImageView*)imageView
{
    float imageRatio = image.size.width / image.size.height;
    
    float viewRatio = imageView.frame.size.width / imageView.frame.size.height;
    
    if(imageRatio < viewRatio)
    {
        float scale = imageView.frame.size.height / image.size.height;
        
        float width = scale * image.size.width;
        
        float topLeftX = (imageView.frame.size.width - width) * 0.5;
        
        return CGRectMake(topLeftX, 0, width, imageView.frame.size.height);
    }
    else
    {
        float scale = imageView.frame.size.width / image.size.width;
        
        float height = scale * image.size.height;
        
        float topLeftY = (imageView.frame.size.height - height) * 0.5;
        
        return CGRectMake(0, topLeftY, imageView.frame.size.width, height);
    }
}

-(IBAction)cropImageMethod:(id)sender {/*
    //get top corner coordinate of crop frame
    
    float topEdgePosition = CGRectGetMinY(cropView.frame);
    float leftEdgePosition = CGRectGetMinX(cropView.frame);
    
    //get image size after aspect ratio
    UIView *a_view = [[UIView alloc] initWithFrame:[self frameForImage:fullImage inImageViewAspectFit:fullImageView]];
    
    //double aspect_width = a_view.frame.size.width;
    //double aspect_height = a_view.frame.size.height;
    
    DLog(@"%f %f", cropView.frame.size.width, cropView.frame.size.height);
    
    //crop image to selected bounds
    CGRect croppedRect;
    
    croppedRect = CGRectMake(leftEdgePosition, topEdgePosition, cropView.frame.size.width, cropView.frame.size.height);
    
    CGImageRef tmp = CGImageCreateWithImageInRect([fullImageView.image CGImage], croppedRect);
    
    //croppedImage = [UIImage imageWithCGImage:tmp scale:1.0 orientation: fullImageView.image.imageOrientation];
    
    // crop image
    croppedImage = [self getCroppedImage];
    
    CGImageRelease(tmp);
 
    fullImageView.image = croppedImage;
    
    createYapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateYapVC"];
    
    self.createYapVC = createYapVC;
    
    sessionCroppedPhoto = croppedImage;
    
    //Push to User Settings controller
    //[self.navigationController pushViewController:createYapVC animated:YES];
    
    //[self.navigationController popViewControllerAnimated:YES];
    
    //[self resizeImage];*/
    
    // crop image
    croppedImage = [self.cropper getCroppedImage];
    
    // remove crop interface from superview
    [self.cropper removeFromSuperview];
    self.cropper = nil;
    
    self.fullImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    // display new cropped image
    //self.fullImageView.image = croppedImage;
    
    createYapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateYapVC"];
    
    self.createYapVC = createYapVC;
    
    sessionUnCroppedPhoto = fullImageView.image;
    sessionCroppedPhoto = croppedImage;
    
    cameFromCropImageScreen = true;

    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImage*)getCroppedImage {
    CGRect rect = self.cropView.frame;
    CGRect drawRect = [self cropRectForFrame:rect];
    UIImage *croppedImage2 = [self imageByCropping:fullImage toRect:drawRect];
    
    return croppedImage2;
}

- (UIImage *)imageByCropping:(UIImage *)image toRect:(CGRect)rect
{
    if (UIGraphicsBeginImageContextWithOptions) {
        UIGraphicsBeginImageContextWithOptions(rect.size,
                                               /* opaque */ NO,
                                               /* scaling factor */ 0.0);
    } else {
        UIGraphicsBeginImageContext(rect.size);
    }
    
    // stick to methods on UIImage so that orientation etc. are automatically
    // dealt with for us
    [image drawAtPoint:CGPointMake(-rect.origin.x, -rect.origin.y)];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

-(CGRect)cropRectForFrame:(CGRect)frame
{
    //NSAssert(self.contentMode == UIViewContentModeScaleAspectFit, @"content mode must be aspect fit");
    
    CGFloat widthScale = self.fullImageView.frame.size.width / self.fullImage.size.width;
    CGFloat heightScale = self.fullImageView.frame.size.height / self.fullImage.size.height;
    
    float x, y, w, h, offset;
    if (widthScale<heightScale) {
        offset = (self.fullImageView.bounds.size.height - (self.fullImage.size.height*widthScale))/2;
        x = frame.origin.x / widthScale;
        y = (frame.origin.y-offset) / widthScale;
        w = frame.size.width / widthScale;
        h = frame.size.height / widthScale;
    } else {
        offset = (self.fullImageView.bounds.size.width - (self.fullImage.size.width*heightScale))/2;
        x = (frame.origin.x-offset) / heightScale;
        y = frame.origin.y / heightScale;
        w = frame.size.width / heightScale;
        h = frame.size.height / heightScale;
    }
    return CGRectMake(x, y, w, h);
}

@end
