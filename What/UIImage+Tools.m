//
//  UIImage+Color.m
//  What
//
//  Created by What on 5/23/13.
//  Copyright (c) 2013 What. All rights reserved.
//

@implementation UIImage (Tools)

+(UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+(UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize contentMode:(UIViewContentMode)contentMode
{
    //NSLog(@"resizing image::");
    CGFloat horizontalRatio = newSize.width / image.size.width;
    CGFloat verticalRatio = newSize.height / image.size.height;
    CGFloat ratio;
    
    switch (contentMode) {
        case UIViewContentModeScaleAspectFit:
            ratio = MIN(horizontalRatio, verticalRatio);
            break;
            
        case UIViewContentModeScaleAspectFill:
        default:
            ratio = MAX(horizontalRatio, verticalRatio);
            break;
    }
    
    CGSize scaledSize = CGSizeMake(image.size.width * ratio, image.size.height * ratio);
    
    CGRect newRect = CGRectIntegral(CGRectMake((newSize.width - scaledSize.width)/2, (newSize.height - scaledSize.height)/2, scaledSize.width, scaledSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, YES, 0); //NO for transparency
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationMedium);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    //NSLog(@"resized image");
    
    return newImage;
}

+(UIImage *)noiseWithSixPercentAlpha
{
    static UIImage *noiseImageSixPercent = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        noiseImageSixPercent = [[UIImage imageNamed:@"../Images/noise_100%_.png"] imageByApplyingAlpha:0.06f];
    });
    return noiseImageSixPercent;
}

+(UIImage *)noiseWithTenPercentAlpha
{
    static UIImage *noiseImageTenPercent = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        noiseImageTenPercent = [[UIImage imageNamed:@"../Images/noise_100%_.png"] imageByApplyingAlpha:0.09f];
    });
    return noiseImageTenPercent;
}
 

- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, self.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
