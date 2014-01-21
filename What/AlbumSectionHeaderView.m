//
//  AlbumSectionHeader.m
//  What
//
//  Created by What on 5/30/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "AlbumSectionHeaderView.h"

@implementation AlbumSectionHeaderView

@synthesize title = title_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor darkGrayColor]];
        
        title_ = [[UILabel alloc] initWithFrame:CGRectMake(CELL_PADDING, 0, frame.size.width - CELL_PADDING*2, frame.size.height)];
        [title_ setBackgroundColor:[UIColor clearColor]];
        [title_ setTextColor:[UIColor blackColor]];
        [title_ setFont:[Constants appFontWithSize:12.f bolded:YES]];
        [self addSubview:title_];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
