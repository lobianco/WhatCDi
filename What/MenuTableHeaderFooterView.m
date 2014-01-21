//
//  MenuTableHeaderFooterNoiseView.m
//  What
//
//  Created by What on 8/7/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "MenuTableHeaderFooterView.h"

@interface MenuTableHeaderFooterView ()

@end

@implementation MenuTableHeaderFooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorFromHexString:cMenuTableHeaderBackgroundColor];
        
        if (!_firstBottomSeparator)
        {
            _firstBottomSeparator = [[ForumTableSeparator alloc] initWithColorHex:@"767574"];
            [self addSubview:_firstBottomSeparator];
            
            _secondBottomSeparator = [[ForumTableSeparator alloc] initWithColorHex:@"1a1a19"];
            [self addSubview:_secondBottomSeparator];
        }

    }
    return self;
}

@end
