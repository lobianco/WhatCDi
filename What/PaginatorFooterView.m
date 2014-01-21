//
//  PaginatorFooterNoiseView.m
//  What
//
//  Created by What on 8/8/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "PaginatorFooterView.h"
#import "ForumTableSeparator.h"

@interface PaginatorFooterView ()

@property (nonatomic, strong) ForumTableSeparator *firstTopSeparator;
@property (nonatomic, strong) ForumTableSeparator *secondTopSeparator;

@property (nonatomic, strong) ForumTableSeparator *firstBottomSeparator;
@property (nonatomic, strong) ForumTableSeparator *secondBottomSeparator;

@property (nonatomic, strong) UIView *noiseView;

@end

@implementation PaginatorFooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorFromHexString:@"c9c8c7"];
        
        if (!_noiseView) {
            _noiseView = [[UIView alloc] init];
            [_noiseView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage noiseWithTenPercentAlpha]]];
            [self addSubview:_noiseView];
        }
        
        if (!_firstTopSeparator)
        {
            _firstTopSeparator = [[ForumTableSeparator alloc] initWithColorHex:@"f9f8f4"];
            [self addSubview:_firstTopSeparator];
            
            _secondTopSeparator = [[ForumTableSeparator alloc] initWithColorHex:@"82817f"];
            [self addSubview:_secondTopSeparator];
        }
        
        if (!_firstBottomSeparator)
        {
            _firstBottomSeparator = [[ForumTableSeparator alloc] initWithColorHex:@"82817f"];
            [self addSubview:_firstBottomSeparator];
            
            _secondBottomSeparator = [[ForumTableSeparator alloc] initWithColorHex:@"f9f8f4"]; //cForumTableSeparatorLightColor
            [self addSubview:_secondBottomSeparator];
        }
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.noiseView setFrame:self.frame];
    
    [self.firstTopSeparator setFrame:CGRectMake(0, 0, CELL_WIDTH, 1.f)];
    [self.secondTopSeparator setFrame:CGRectMake(0, 1, CELL_WIDTH, 1.f)];
    
    [self.firstBottomSeparator setFrame:CGRectMake(0, self.frame.size.height - 2.f, CELL_WIDTH, 1.f)];
    [self.secondBottomSeparator setFrame:CGRectMake(0, self.frame.size.height - 1.f, CELL_WIDTH, 1.f)];
}

@end
