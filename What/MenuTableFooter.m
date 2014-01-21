//
//  MenuTableFooter.m
//  What
//
//  Created by What on 8/7/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "MenuTableFooter.h"

static const CGFloat circleDiameter = 10.f;

@interface MenuTableFooter ()

@property (nonatomic, strong) UILabel *footerLabel;

@end

@implementation MenuTableFooter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _footerLabel = [[UILabel alloc] init];
        _footerLabel.textColor = [UIColor colorFromHexString:cMenuTableFontColor];
        _footerLabel.font = [Constants appFontWithSize:19 bolded:YES];
        _footerLabel.numberOfLines = 1;
        _footerLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _footerLabel.backgroundColor = [UIColor clearColor];
        _footerLabel.text = @"Settings";
        _footerLabel.alpha = 0.3;
        [self addSubview:_footerLabel];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize footerLabelSize = [self.footerLabel.text sizeWithFont:self.footerLabel.font constrainedToSize:CGSizeMake(CELL_WIDTH, CGFLOAT_MAX) lineBreakMode:NSLineBreakByTruncatingTail];
    self.footerLabel.frame = CGRectMake((self.frame.size.width/2) - (footerLabelSize.width/2), 0, footerLabelSize.width, [MenuTableFooter height]);
    
    [self.firstBottomSeparator setFrame:CGRectMake(0, 1.f, CELL_WIDTH, 1.f)];
    [self.secondBottomSeparator setFrame:CGRectMake(0, 0.f, CELL_WIDTH, 1.f)];
}

+(CGFloat)height
{
    return 40.f;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect circleRect1 = CGRectMake(self.footerLabel.frame.origin.x + self.footerLabel.frame.size.width + CELL_PADDING*3,20.f - (circleDiameter/2), circleDiameter, circleDiameter);
    CGRect circleRect2 = CGRectMake(circleRect1.origin.x + CELL_PADDING/2 + circleDiameter, circleRect1.origin.y, circleDiameter, circleDiameter);
    CGRect circleRect3 = CGRectMake(self.footerLabel.frame.origin.x - CELL_PADDING*3 - circleDiameter, circleRect1.origin.y, circleDiameter, circleDiameter);
    CGRect circleRect4 = CGRectMake(circleRect3.origin.x - CELL_PADDING/2 - circleDiameter, circleRect1.origin.y, circleDiameter, circleDiameter);
    CGContextSetFillColorWithColor(context, [UIColor colorFromHexString:cMenuTableFontColor alpha:0.1].CGColor);
    CGContextFillEllipseInRect(context, circleRect1);
    CGContextFillEllipseInRect(context, circleRect2);
    CGContextFillEllipseInRect(context, circleRect3);
    CGContextFillEllipseInRect(context, circleRect4);
}

@end
