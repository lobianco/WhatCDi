//
//  UIColor+ColorFromHex.h
//  VM
//
//  Created by What on 5/23/12.
//  Copyright (c) 2012 What. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct {
    CGFloat rgbComponents[3];
} HexComponents;

@interface UIColor (Tools)

+ (UIColor *) colorFromHexString: (NSString *) hex;
+ (UIColor *) colorFromHexString: (NSString *) hex alpha:(CGFloat)alpha;

+ (HexComponents)rgbComponentsFromHexString:(NSString *)hex;

+ (UIColor *)randomColor;

-(UIColor *)darkerColor;

@end
