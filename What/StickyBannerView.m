//
//  StickyBannerView.m
//  What
//
//  Created by What on 7/10/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "StickyBannerView.h"

@implementation StickyBannerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //[self setBackgroundColor:[UIColor clearColor]];
        self.opaque = NO;
        
    }
    return self;
}


#define PSIZE 16.f

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //sticky banner
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextSetShadowWithColor(context, CGSizeZero, 4.f, [UIColor lightGrayColor].CGColor);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.bounds.size.width - TRIANGLE_LENGTH, 0);
    CGContextAddLineToPoint(context, self.bounds.size.width, 0);
    CGContextAddLineToPoint(context, self.bounds.size.width, TRIANGLE_LENGTH);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    //clear shadow
    CGContextSetShadowWithColor(context, CGSizeZero, 0, NULL);
    
    //star color
    CGContextSetFillColorWithColor(context, [UIColor darkGrayColor].CGColor);
    
    double r, theta;
    
    r = 0.8 * PSIZE / 2;
    theta = 2 * M_PI * (2.0 / 5.0); // 144 degrees
    
    CGContextTranslateCTM (context, PSIZE/2, PSIZE/2);
    
    CGFloat starOriginX = self.bounds.size.width - 16.f;
    CGFloat starOriginY = 2.f;
    CGContextMoveToPoint(context, starOriginX, (r * -1) + starOriginY); //multiply by -1 to flip it right side up
    for (int k = 1; k < 5; k++) {
        CGContextAddLineToPoint (context,
                                 r * sin(k * theta) + starOriginX,
                                 r * -1 * cos(k * theta) + starOriginY);
    }
    CGContextClosePath(context);
    CGContextFillPath(context);
}


@end
