//
//  InboxConversationHeaderView.m
//  What
//
//  Created by What on 6/20/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "ConversationHeaderView.h"

#define LINE_INSET 20.f

@interface ConversationHeaderView ()

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) CAShapeLayer *dashedLine;
@property (nonatomic, strong) UIBezierPath *path;

@end

@implementation ConversationHeaderView

@synthesize dateLabel = dateLabel_;
@synthesize dashedLine = dashedLine_;
@synthesize path = path_;

- (id)initWithFrame:(CGRect)frame andDate:(NSString*)date
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = ([Constants debug] ? [UIColor lightGrayColor] :[UIColor clearColor]);
        
        dateLabel_ = [[UILabel alloc] initWithFrame:frame];
        [dateLabel_ setBackgroundColor:[UIColor clearColor]];
        [dateLabel_ setTextAlignment:NSTextAlignmentCenter];
        [dateLabel_ setText:date];
        [dateLabel_ setFont:[Constants appFontWithSize:10.f bolded:NO]];
        [dateLabel_ setTextColor:[UIColor grayColor]];
        [self addSubview:dateLabel_];
        
        dashedLine_ = [CAShapeLayer layer];
        dashedLine_.strokeStart = 0.0;
        dashedLine_.strokeColor = [UIColor grayColor].CGColor;
        dashedLine_.lineWidth = 1.f;
        dashedLine_.lineJoin = kCALineJoinMiter;
        dashedLine_.lineDashPattern = @[@4, @8];
        dashedLine_.lineDashPhase = 0.f;
        //[self.layer addSublayer:dashedLine_];
        
    }
    
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, LINE_INSET, self.frame.size.height);
    CGPathAddLineToPoint(path, NULL, self.frame.size.width - LINE_INSET, self.frame.size.height);
    [dashedLine_ setPath:path];
    CGPathRelease(path);
}


@end
