//
//  ProfileAvatarHeader.m
//  What
//
//  Created by What on 5/30/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "ProfileJoinedDateView.h"

@implementation ProfileJoinedDateView

@synthesize joinedLabel = joinedLabel_;
@synthesize lastActiveLabel = lastActiveLabel_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        joinedLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
        [joinedLabel_ setBackgroundColor:[UIColor clearColor]];
        [joinedLabel_ setTextColor:[UIColor lightGrayColor]];
        [joinedLabel_ setTextAlignment:NSTextAlignmentCenter];
        [joinedLabel_ setFont:[Constants appFontWithSize:9.f bolded:YES]];
        [joinedLabel_ setFrame:CGRectMake(CELL_PADDING, frame.size.height - 50.f, frame.size.width - CELL_PADDING*2, 20.f)];
        //[self addSubview:joinedLabel_];
        
        lastActiveLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
        [lastActiveLabel_ setBackgroundColor:[UIColor clearColor]];
        [lastActiveLabel_ setTextColor:[UIColor darkGrayColor]];
        [lastActiveLabel_ setTextAlignment:NSTextAlignmentCenter];
        [lastActiveLabel_ setFont:[Constants appFontWithSize:11.f oblique:YES]];
        [lastActiveLabel_ setFrame:CGRectMake(CELL_PADDING, frame.size.height - 38.f, frame.size.width - CELL_PADDING*2, 20.f)];
        [self addSubview:lastActiveLabel_];
        
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
