//
//  UIImage+Color.h
//  What
//
//  Created by What on 5/23/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tools)

+(UIImage *)imageWithColor:(UIColor *)color;
+(UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize contentMode:(UIViewContentMode)contentMode;
+(UIImage *)noiseWithSixPercentAlpha;
+(UIImage *)noiseWithTenPercentAlpha;

@end
