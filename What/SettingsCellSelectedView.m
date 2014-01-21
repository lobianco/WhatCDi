//
//  SettingsSelectedView.m
//  What
//
//  Created by What on 9/12/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "SettingsCellSelectedView.h"

@interface SettingsCellSelectedView ()

@property (nonatomic, strong) SettingsCellSelectedGradientView *gradientView;

@end

@implementation SettingsCellSelectedView

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        
        if (!_gradientView) {
            _gradientView = [[SettingsCellSelectedGradientView alloc] init];
            [self addSubview:_gradientView];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.gradientView.frame = self.bounds;
}

@end

@implementation SettingsCellSelectedGradientView

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    UIColor *selectedColor = [UIColor colorFromHexString:cCyanColor];
    NSArray *colorsArray = [NSArray arrayWithObjects:(id)[selectedColor CGColor], (id)[[selectedColor darkerColor] CGColor], nil];
    CGColorSpaceRef colorSpace =  CGColorSpaceCreateDeviceRGB();
    const CGFloat locations[2] = {0.0, 1.0};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colorsArray, locations);
    
    CGContextDrawLinearGradient(context, gradient, CGPointZero, CGPointMake(0, self.bounds.size.height), 0);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    CGContextRestoreGState(context);
}

@end
