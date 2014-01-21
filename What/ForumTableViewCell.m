//
//  ForumCell.m
//  What
//
//  Created by What on 7/9/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "ForumTableViewCell.h"
#import "StickyBannerView.h"
#import "NSString+Tools.h"
#import "NSString+HTML.h"
#import "NSDate+Tools.h"

@interface ForumTableViewCell ()

@property (nonatomic, strong) UIImageView *bannerView;

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *lastReplyLabel;
@property (nonatomic, strong) UIImageView *speechBubbleView;
@property (nonatomic, strong) UILabel *postCount;

@end

@implementation ForumTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //[self setBackgroundColor:[UIColor clearColor]];
                
        if (!_label)
        {
            _label = [[UILabel alloc] init];
            [_label setBackgroundColor:[UIColor clearColor]];
            [_label setFont:[Constants appFontWithSize:FONT_SIZE_TITLE bolded:YES]];
            [_label setNumberOfLines:2];
            [_label setLineBreakMode:NSLineBreakByTruncatingTail];
            [_label setTextColor:[UIColor colorFromHexString:cCellFontDarkColor]];
            [self.contentView addSubview:_label];
        }
        
        if (!_lastReplyLabel)
        {
            _lastReplyLabel = [[UILabel alloc] init];
            [_lastReplyLabel setBackgroundColor:[UIColor clearColor]];
            [_lastReplyLabel setFont:[Constants appFontWithSize:FONT_SIZE_SUBTITLE bolded:NO]];
            [_lastReplyLabel setNumberOfLines:1];
            [_lastReplyLabel setLineBreakMode:NSLineBreakByTruncatingTail];
            [_lastReplyLabel setTextAlignment:NSTextAlignmentLeft];
            [_lastReplyLabel setTextColor:[UIColor colorFromHexString:cCellFontMediumColor]];
            [self.contentView addSubview:_lastReplyLabel];
        }
        
        if (!_speechBubbleView)
        {
            _speechBubbleView = [[UIImageView alloc] initWithFrame:CGRectZero];
            [self.contentView addSubview:_speechBubbleView];
            
            _postCount = [[UILabel alloc] initWithFrame:CGRectZero];
            [_postCount setNumberOfLines:1];
            [_postCount setFont:[Constants appFontWithSize:8.f bolded:YES]];
            [_postCount setTextAlignment:NSTextAlignmentCenter];
            [_postCount setBackgroundColor:[UIColor clearColor]];
            [_speechBubbleView addSubview:_postCount];
        }
        
        if (!_bannerView) {
            UIImage *stickyImage = [UIImage imageNamed:@"../Images/stickyLockBanner.png"];
            _bannerView = [[UIImageView alloc] initWithImage:stickyImage];
            [self.contentView addSubview:_bannerView];
            _bannerView.hidden = YES;
        }
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setThread:(WCDThread *)thread
{
    if (_thread != thread)
    {
        _thread = thread;
        
        self.label.text = [_thread.title stringByDecodingHTMLEntities];
        self.lastReplyLabel.text = [NSString stringWithFormat:@"Last reply by %@ %@", _thread.lastAuthorName, [NSDate relativeDateFromDateString:_thread.lastTime]];
        [self setRead:_thread.read postCount:_thread.postCount sticky:_thread.sticky locked:_thread.locked];
        
    }
    
    else
        DebugLog(@"ERROR: Already equal!");
}

-(void)setRead:(BOOL)read postCount:(NSInteger)postCount sticky:(BOOL)sticky locked:(BOOL)locked
{
    if (sticky || locked)
    {
        UIImage *stickyImage;
        
        if (sticky && locked) {
            stickyImage = [UIImage imageNamed:@"../Images/stickyLockBanner.png"];
        }
        
        else if (sticky) {
            stickyImage = [UIImage imageNamed:@"../Images/stickyBanner.png"];
        }

        else if (locked) {
            stickyImage = [UIImage imageNamed:@"../Images/lockBanner.png"];
        }
        
        self.bannerView.image = stickyImage;
        self.bannerView.hidden = NO;
    }
    
    else {
        self.bannerView.hidden = YES;
    }
    
    //mark if read and set post count
    if (read) {
        [self.label setTextColor:[UIColor colorFromHexString:cCellFontMediumColor]];
        [self.speechBubbleView setImage:[UIImage imageNamed:@"../Images/readThreadMarker.png"]];
        [self.postCount setTextColor:[UIColor colorFromHexString:cCellFontMediumColor alpha:0.9f]];
    }
    
    else {
        [self.label setTextColor:[UIColor colorFromHexString:cCellFontDarkColor]];
        [self.speechBubbleView setImage:[UIImage imageNamed:@"../Images/newThreadMarker.png"]];
        [self.postCount setTextColor:[UIColor colorFromHexString:cForumTableSeparatorLightColor alpha:0.9f]];
    }
    
    NSString *posts = [NSString stringWithFormat:@"%i", postCount];
    [self.postCount setText:[posts abbreviatePostCount]];
    
    
}

+(CGFloat)heightForTitle:(NSString *)threadTitle
{
    CGFloat xOffset = CELL_PADDING*4;
    CGFloat maxLabelWidth = CELL_WIDTH - xOffset - CELL_PADDING*2 - ACCESSORY_WIDTH;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, maxLabelWidth, 0)];
    [label setNumberOfLines:2];
    [label setFont:[Constants appFontWithSize:FONT_SIZE_TITLE bolded:YES]];
    [label setText:threadTitle];
    [label setLineBreakMode:NSLineBreakByTruncatingTail];
    [label sizeToFit];
    
    UILabel *lastReplyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, maxLabelWidth, 0)];
    [lastReplyLabel setFont:[Constants appFontWithSize:FONT_SIZE_SUBTITLE bolded:NO]];
    [lastReplyLabel setNumberOfLines:1];
    [lastReplyLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [lastReplyLabel setText:@" "];
    [lastReplyLabel sizeToFit];
    
    return (label.frame.size.height + lastReplyLabel.frame.size.height + CELL_PADDING*2);
}

-(void)layoutSubviews
{
    [super layoutSubviews];
        
    [self.speechBubbleView setFrame:CGRectMake(CELL_PADDING*2 - (self.speechBubbleView.image.size.width/2), (self.frame.size.height/2) - (self.speechBubbleView.image.size.height/2), self.speechBubbleView.image.size.width, self.speechBubbleView.image.size.height)];
    [self.postCount setFrame:CGRectMake(0, -1.0, self.speechBubbleView.frame.size.width, self.speechBubbleView.frame.size.height)];
    
    if (!self.bannerView.hidden) {
        [self.bannerView setFrame:CGRectMake(self.frame.size.width - self.bannerView.image.size.width, 0, self.bannerView.image.size.width, self.bannerView.image.size.height)];
    }
    
    //NOTE ios5 sizetofit doesn't take number of lines into account
    CGFloat xOffset = self.speechBubbleView.frame.origin.x + self.speechBubbleView.frame.size.width + CELL_PADDING;
    CGFloat maxLabelWidth = CELL_WIDTH - xOffset - CELL_PADDING*2 - ACCESSORY_WIDTH;
    [self.label setFrame:CGRectMake(xOffset, CELL_PADDING, maxLabelWidth, 0)];
    [self.label sizeToFit];
    CGRect labelFrame = self.label.frame;
    labelFrame.size.width = maxLabelWidth;
    self.label.frame = labelFrame;

    [self.lastReplyLabel setFrame:CGRectMake(xOffset, self.label.frame.origin.y + self.label.frame.size.height + 2.f, maxLabelWidth, 0)];
    [self.lastReplyLabel sizeToFit];
    CGRect frame = self.lastReplyLabel.frame;
    frame.size.width = maxLabelWidth;
    self.lastReplyLabel.frame = frame;
    
}


@end
