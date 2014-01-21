//
//  ForumTableSeparator.m
//  What
//
//  Created by What on 7/14/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "ForumTableSeparator.h"

@interface ForumTableSeparator ()

@property (nonatomic, strong) NSString *colorHex;

@end

@implementation ForumTableSeparator

@synthesize colorHex = colorHex_;

-(id)initWithColorHex:(NSString *)colorHex
{
    self = [super init];
    if (self) {
        
        colorHex_ = colorHex;
        
    }
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //top line
    CGContextBeginPath(context);
    CGContextSetFillColorWithColor(context, [UIColor colorFromHexString:self.colorHex].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, self.frame.size.width, 1.f));
}


@end
