//
//  ThreadHeaderView.m
//  What
//
//  Created by What on 7/10/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "ThreadSectionHeaderView.h"
#import "LoadingView.h"
#import "NSDate+Tools.h"
#import "ForumTableSeparator.h"

#define HEADER_MARGIN 10.f

#define THREAD_AVATAR_WIDTH 30.f

#define LABEL_HEIGHT 15.f
#define LABEL_WIDTH 100.f

@interface ThreadSectionHeaderView ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *postIdLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) ForumTableSeparator *bottomSeparator;

@end

@implementation ThreadSectionHeaderView

@synthesize avatar = avatar_;

@synthesize nameLabel = nameLabel_;
@synthesize postIdLabel = postIdLabel_;
@synthesize timeLabel = timeLabel_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //avatar
        if (!avatar_)
        {
            //CGContext errors if these exact settings aren't used
            avatar_ = [[UIImageView alloc] initWithImage:[LoadingImages defaultProfileImageWithWidth:THREAD_AVATAR_WIDTH]];
            [avatar_ setContentMode:UIViewContentModeScaleAspectFill];
            [avatar_ setClipsToBounds:YES];
            avatar_.layer.masksToBounds = YES;
            avatar_.layer.borderColor = [[UIColor colorFromHexString:cCellFontDarkColor] CGColor];
            avatar_.layer.borderWidth = 1.f;
            avatar_.layer.cornerRadius = 4.f;
            avatar_.userInteractionEnabled = YES;
            [self addSubview:avatar_];
        }
        
        //author name
        if (!nameLabel_)
        {
            nameLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
            [nameLabel_ setBackgroundColor:[UIColor clearColor]];
            [nameLabel_ setFont:[Constants appFontWithSize:FONT_SIZE_FORUM_NAME bolded:YES]];
            [nameLabel_ setTextColor:[UIColor colorFromHexString:cCellFontDarkColor]];
            [self addSubview:nameLabel_];
        }
        
        //post ID
        if (!postIdLabel_)
        {
            postIdLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
            [postIdLabel_ setBackgroundColor:[UIColor clearColor]];
            postIdLabel_.textAlignment = NSTextAlignmentRight;
            [postIdLabel_ setFont:[Constants appFontWithSize:FONT_SIZE_FORUM_SUBTITLE oblique:NO]];
            [postIdLabel_ setTextColor:[UIColor colorFromHexString:cCellFontMediumColor]];
            [self addSubview:postIdLabel_];
        }
        
        //time
        if (!timeLabel_)
        {
            timeLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
            [timeLabel_ setBackgroundColor:[UIColor clearColor]];
            [timeLabel_ setFont:[Constants appFontWithSize:FONT_SIZE_FORUM_SUBTITLE]];
            timeLabel_.textAlignment = NSTextAlignmentRight;
            [timeLabel_ setTextColor:[UIColor colorFromHexString:cCellFontMediumColor]];
            [self addSubview:timeLabel_];
        }
        
        if (!_bottomSeparator)
        {
            _bottomSeparator = [[ForumTableSeparator alloc] initWithColorHex:cForumTableSeparatorLightColor];
            [self addSubview:_bottomSeparator];
        }
        
    }
    return self;
}

-(void)setColor:(UIColor *)color
{
    [self setBackgroundColor:color];
}

-(void)setPost:(WCDPost *)post
{
    if (_post != post)
    {
        _post = post;
        
        [self setAvatarURL:_post.user.avatarURL];
        self.nameLabel.text = _post.user.name;
        self.postIdLabel.text = [NSString stringWithFormat:@"#%i", _post.idNum];
        self.timeLabel.text = [NSDate relativeDateFromDateString:_post.addedTime];
    }
}

-(void)setAvatarURL:(NSURL *)avatarURL
{
    if ([[avatarURL absoluteString] length] > 0)
    {
        //load avatar image
        __weak ThreadSectionHeaderView *weakAvatar = self;
        [self.avatar setImageWithURLRequest:[NSURLRequest requestWithURL:avatarURL] placeholderImage:[LoadingImages defaultLoadingProfileImageWithWidth:THREAD_AVATAR_WIDTH] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            
            //TODO this causes context errors
            //UIImage *resizedImage = [UIImage resizeImage:image newSize:CGSizeMake(weakAvatar.frame.size.width, weakAvatar.frame.size.height) contentMode:weakAvatar.contentMode];
            //[weakAvatar.avatar setImage:resizedImage];
            [weakAvatar.avatar setImage:image];
        
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"couldnt load avatar image");
            NSLog(@"error url: %@", request.URL);
            
            [weakAvatar.avatar setImage:[LoadingImages defaultProfileImageWithWidth:THREAD_AVATAR_WIDTH]];
            
        }];
    }
    
    else
    {
        [self.avatar setImage:[LoadingImages defaultProfileImageWithWidth:THREAD_AVATAR_WIDTH]];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.nameLabel setFrame:CGRectMake(HEADER_MARGIN*2 + THREAD_AVATAR_WIDTH, HEADER_MARGIN + THREAD_AVATAR_WIDTH - LABEL_HEIGHT, LABEL_WIDTH, LABEL_HEIGHT)];
    [self.postIdLabel setFrame:CGRectMake(self.frame.size.width - LABEL_WIDTH - HEADER_MARGIN, HEADER_MARGIN, LABEL_WIDTH, LABEL_HEIGHT)];
    [self.timeLabel setFrame:CGRectMake(self.frame.size.width - LABEL_WIDTH - HEADER_MARGIN, self.nameLabel.frame.origin.y, LABEL_WIDTH, LABEL_HEIGHT)];
    [self.avatar setFrame:CGRectMake(HEADER_MARGIN, HEADER_MARGIN, THREAD_AVATAR_WIDTH, THREAD_AVATAR_WIDTH)];
    [self.bottomSeparator setFrame:CGRectMake(0, 0, 320, 1.f)];
}

+(CGFloat)heightForHeader
{
    return (THREAD_AVATAR_WIDTH + HEADER_MARGIN*2);
}

@end
