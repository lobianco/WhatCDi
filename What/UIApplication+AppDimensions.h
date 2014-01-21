//
//  UIApplicationAppDimensions.h
//  VM
//
//  Created by What on 4/25/12.
//  Copyright (c) 2012 What. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIApplication (AppDimensions)

+(CGSize) currentSize;
+(CGSize) sizeInOrientation:(UIInterfaceOrientation)orientation;
+(BOOL) isCurrentOrientationPortrait;


@end
