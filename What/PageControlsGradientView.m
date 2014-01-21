//
//  PageControlsGradientView.m
//  What
//
//  Created by What on 7/11/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "PageControlsGradientView.h"

@interface PageControlsGradientView ()

@property (nonatomic, strong) UIColor *color;

@end

@implementation PageControlsGradientView

@synthesize color = color_;

-(id)initWithColor:(UIColor *)color
{
    self = [super init];
    if (self) {
        
        color_ = color;
        self.opaque = NO;
        
    }
    
    return self;
}

- (id)initWithColorHex:(NSString *)hex
{
    return [self initWithColor:[UIColor colorFromHexString:hex]];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorSpace =  CGColorSpaceCreateDeviceRGB();
    
    NSArray *colors = @[(__bridge id)self.color.CGColor, (id)[UIColor clearColor].CGColor];
    
    CGFloat locations[2] = {0.0, 1.0};
        
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations); //If locations is NULL, the first color in colors is assigned to location 0, the last color incolors is assigned to location 1, and intervening colors are assigned locations that are at equal intervals in between.
    
    CGContextDrawLinearGradient(context, gradient, CGPointZero, CGPointMake(self.bounds.size.width/5, 0), 0);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

@end
