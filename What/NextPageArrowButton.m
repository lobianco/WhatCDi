//
//  NextPageArrow.m
//  What
//
//  Created by What on 7/10/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "NextPageArrowButton.h"

#define PADDING 4.f

@implementation NextPageArrowButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.opaque = NO;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorFromHexString:cCellAccessoryColor].CGColor);
    CGContextSetLineWidth(context, 3.f);
    CGContextSetLineJoin(context, kCGLineJoinMiter);
    
    CGContextMoveToPoint(context, PADDING, PADDING);
    CGContextAddLineToPoint(context, self.frame.size.width - PADDING, self.frame.size.height/2);
    CGContextAddLineToPoint(context, PADDING, self.frame.size.height - PADDING);
    
    CGContextStrokePath(context);
    
}


@end
