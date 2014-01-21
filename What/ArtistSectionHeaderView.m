//
//  ALSectionHeaderView.m
//  What
//
//  Created by What on 7/15/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "ArtistSectionHeaderView.h"

static const CGFloat circleDiameter = 10.f;

@interface ArtistSectionHeaderView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation ArtistSectionHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOpen:)];
        [self addGestureRecognizer:_tapGesture];
        
    }
    return self;
}

- (void)dealloc {
    _delegate = nil;
}

-(void)toggleOpen:(id)sender
{
    [self toggleOpenWithUserAction:YES];
}

-(void)toggleOpenWithUserAction:(BOOL)userAction
{
    if ([self.delegate respondsToSelector:@selector(collapseOrExpandCellsInSection:)])
        [self.delegate collapseOrExpandCellsInSection:self.section];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect circleRect1 = CGRectMake(rect.size.width - CELL_PADDING - circleDiameter, (rect.size.height/2) - (circleDiameter/2), circleDiameter, circleDiameter);
    CGRect circleRect2 = CGRectMake(circleRect1.origin.x - (CELL_PADDING/2) - circleDiameter, circleRect1.origin.y, circleDiameter, circleDiameter);
    CGContextSetFillColorWithColor(context, [UIColor colorFromHexString:@"495657" alpha:0.4].CGColor);
    CGContextFillEllipseInRect(context, circleRect1);
    CGContextFillEllipseInRect(context, circleRect2);
}

@end
