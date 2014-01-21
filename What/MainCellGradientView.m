//
//  CellGradientView.m
//  What
//
//  Created by What on 7/10/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "MainCellGradientView.h"

@interface MainCellGradientView ()

@end

@implementation MainCellGradientView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace =  CGColorSpaceCreateDeviceRGB();
    
    //top color
    const HexComponents firstComponents = [UIColor rgbComponentsFromHexString:cForumCellGradientLightColor];
    CGFloat firstR = (CGFloat)firstComponents.rgbComponents[0];
    CGFloat firstG = (CGFloat)firstComponents.rgbComponents[1];
    CGFloat firstB = (CGFloat)firstComponents.rgbComponents[2];
    
    //bottom color
    const HexComponents secondComponents = [UIColor rgbComponentsFromHexString:cForumCellGradientDarkColor];
    CGFloat secondR = (CGFloat)secondComponents.rgbComponents[0];
    CGFloat secondG = (CGFloat)secondComponents.rgbComponents[1];
    CGFloat secondB = (CGFloat)secondComponents.rgbComponents[2];
    
    const CGFloat components[8] = {firstR, firstG, firstB, 1.0, //top color
                                   secondR, secondG, secondB, 1.0}; //bottom color
    
    const CGFloat locations[2] = {0.0, 1.0};
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    
    CGContextDrawLinearGradient(context, gradient, CGPointZero, CGPointMake(0, self.bounds.size.height), 0);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    CGContextRestoreGState(context);
}

@end
