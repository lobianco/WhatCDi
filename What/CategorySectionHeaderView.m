//
//  CategorySectionHeaderView.m
//  What
//
//  Created by What on 7/18/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "CategorySectionHeaderView.h"

@interface CategorySectionHeaderView ()

@property (nonatomic, strong) UIView *noiseView;

@end

@implementation CategorySectionHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //[self setBackgroundColor:[UIColor colorFromHexString:@"635e59"]];
        
        self.opaque = NO;
        
        if (!_title)
        {
            _title = [[UILabel alloc] initWithFrame:CGRectMake(CELL_PADDING, 0, frame.size.width - CELL_PADDING*2, frame.size.height)];
            _title.adjustsFontSizeToFitWidth = YES;
            _title.backgroundColor = [UIColor clearColor];
            _title.textColor = [UIColor colorFromHexString:@"495657"];
            _title.font = [Constants appFontWithSize:10.f bolded:YES];
            
            [self addSubview:_title];
        }
        
        if (!_noiseView)
        {
            _noiseView = [[UIView alloc] initWithFrame:frame];
            [_noiseView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage noiseWithTenPercentAlpha]]];
            [self addSubview:_noiseView];
        }
        
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
    
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    
    //top color
    const HexComponents firstComponents = [UIColor rgbComponentsFromHexString:@"dee2e2"];
    CGFloat firstR = (CGFloat)firstComponents.rgbComponents[0];
    CGFloat firstG = (CGFloat)firstComponents.rgbComponents[1];
    CGFloat firstB = (CGFloat)firstComponents.rgbComponents[2];
    
    //bottom color
    const HexComponents secondComponents = [UIColor rgbComponentsFromHexString:@"c7caca"];
    CGFloat secondR = (CGFloat)secondComponents.rgbComponents[0];
    CGFloat secondG = (CGFloat)secondComponents.rgbComponents[1];
    CGFloat secondB = (CGFloat)secondComponents.rgbComponents[2];
    
    const CGFloat components[8] = {firstR, firstG, firstB, TRANSPARENT_ALPHA, //top color
        secondR, secondG, secondB, TRANSPARENT_ALPHA}; //bottom color
    
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
    
    CGContextDrawLinearGradient(currentContext, gradient, CGPointZero, CGPointMake(0, self.bounds.size.height), 0);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(rgbColorspace);
    
    //top line
    CGContextBeginPath(currentContext);
    CGContextSetFillColorWithColor(currentContext, [UIColor colorFromHexString:@"8f9797"].CGColor);
    CGContextFillRect(currentContext, CGRectMake(0, 0, self.frame.size.width, 1.f));
    
    //bottom line
    CGContextBeginPath(currentContext);
    CGContextSetFillColorWithColor(currentContext, [UIColor colorFromHexString:@"8f9797"].CGColor);
    CGContextFillRect(currentContext, CGRectMake(0, self.frame.size.height - 1.f, self.frame.size.width, 1.f));

}


@end
