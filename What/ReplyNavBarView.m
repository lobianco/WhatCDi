//
//  ReplyNavBar.m
//  What
//
//  Created by What on 7/20/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "ReplyNavBarView.h"

#define PADDING 15.f

@interface ReplyNavBarView ()

@end

@implementation ReplyNavBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setBackgroundColor:[UIColor colorFromHexString:@"d1cdca"]];
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.5f;
        self.layer.shadowOffset = CGSizeMake(0, -2.f);
        self.layer.shadowRadius = 2.f;
        
        CGFloat iOS7Padding = ([Constants iOSVersion] >= 7.0 ? 10.f : 0.f);
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2 - (frame.size.width/4), 2 + iOS7Padding, frame.size.width/2, frame.size.height)];
        [_titleLabel setFont:[Constants appFontWithSize:19.f bolded:YES]];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextColor:[UIColor colorFromHexString:@"4c4947"]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_titleLabel];
        
        CGFloat errorMargin = 40.f;
        
        UIImage *postImage = [UIImage imageNamed:@"../Images/postButton.png"];
        _postButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_postButton setFrame:CGRectMake(frame.size.width - PADDING - postImage.size.width - (errorMargin/2), (self.frame.size.height/2) - (postImage.size.height/2) + 2.f + iOS7Padding - (errorMargin/2), postImage.size.width + errorMargin, postImage.size.height + errorMargin)];
        [_postButton setImage:postImage forState:UIControlStateNormal];
        [_postButton setShowsTouchWhenHighlighted:YES];
        [self addSubview:_postButton];
        
        UIImage *cancelImage = [UIImage imageNamed:@"../Images/cancelButton.png"];
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setFrame:CGRectMake(PADDING - (errorMargin/2), (self.frame.size.height/2) - (cancelImage.size.height/2) + 2.f + iOS7Padding - (errorMargin/2), cancelImage.size.width + errorMargin, cancelImage.size.height + errorMargin)];
        [_cancelButton setImage:cancelImage forState:UIControlStateNormal];
        [_cancelButton setShowsTouchWhenHighlighted:YES];
        [self addSubview:_cancelButton];
        
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
