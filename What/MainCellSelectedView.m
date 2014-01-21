//
//  CellSelectedView.m
//  What
//
//  Created by What on 7/25/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "MainCellSelectedView.h"
#import "UIColor+Tools.h"

@interface MainCellSelectedView ()

@property (nonatomic, strong) UIImageView *topShadow;
//@property (nonatomic, strong) MainCellSelectedNoiseView *noiseView;

@end

@implementation MainCellSelectedView

- (id)init {
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor colorFromHexString:cForumCellSelectedColor];
        
        /*
        if (!_noiseView) {
            _noiseView = [[MainCellSelectedNoiseView alloc] init];
            [self addSubview:_noiseView];
        }
         */
        
        UIImage *shadow = [UIImage imageNamed:@"../Images/cellSelectedShadow.png"];
        
        if (!_topShadow) {
            _topShadow = [[UIImageView alloc] initWithImage:shadow];
            _topShadow.alpha = 0.9;
            [self addSubview:_topShadow];
        }
        
        if (!_bottomShadow) {
            _bottomShadow = [[UIImageView alloc] initWithImage:shadow];
            _bottomShadow.transform = CGAffineTransformMakeRotation(M_PI);
            [self addSubview:_bottomShadow];
        }
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    //self.noiseView.frame = self.bounds;
    self.topShadow.frame = CGRectMake(0, 0, self.topShadow.image.size.width, self.topShadow.image.size.height);
    self.bottomShadow.frame = CGRectMake(0, self.frame.size.height - self.bottomShadow.image.size.height, self.frame.size.width, self.bottomShadow.image.size.height);
}

@end

//NOTE because this view will be going in a cell, we can't just add a subview with the noise image like normal. we have to add it via drawRect and make sure it's frame is correct
/*
@implementation MainCellSelectedNoiseView

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    [[UIColor colorWithPatternImage:[UIImage noiseWithTenPercentAlpha]] set];
    CGContextFillRect(context, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
    CGContextRestoreGState(context);
}

@end
*/