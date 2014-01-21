//
//  InboxMessageCell.m
//  What
//
//  Created by What on 6/12/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "InboxTableViewCell.h"
#import "LoadingView.h"
#import "NSString+HTML.h"
#import "NSDate+Tools.h"

#define MESSAGE_AVATAR_WIDTH 36.f

@interface InboxTableViewCell ()

//@property (nonatomic, strong) LoadingEllipsisView *loader;

@property (nonatomic, strong) UILabel *subjectLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *senderLabel;

@property (nonatomic, assign) BOOL isSystem;

@end

@implementation InboxTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        if (!_senderAvatar)
        {
            _senderAvatar = [[UIImageView alloc] initWithImage:[LoadingImages defaultProfileImageWithWidth:MESSAGE_AVATAR_WIDTH]];
            [_senderAvatar setContentMode:UIViewContentModeScaleAspectFill];
            [_senderAvatar setClipsToBounds:YES];
            _senderAvatar.layer.masksToBounds = YES;
            _senderAvatar.layer.borderColor = [[UIColor colorFromHexString:cCellFontDarkColor] CGColor];
            _senderAvatar.layer.borderWidth = 1.f;
            _senderAvatar.layer.cornerRadius = 6.f;
            _senderAvatar.userInteractionEnabled = YES;
            _senderAvatar.tag = 1;
            [self.contentView addSubview:_senderAvatar];
            
        }
        
        if (!_senderLabel)
        {
            _senderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [_senderLabel setBackgroundColor:[Constants debug] ? [UIColor greenColor] : [UIColor clearColor]];
            _senderLabel.font = [Constants appFontWithSize:FONT_SIZE_TITLE bolded:YES];
            [self.contentView addSubview:_senderLabel];
        }
        
        if (!_subjectLabel)
        {
            _subjectLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [_subjectLabel setBackgroundColor:[Constants debug] ? [UIColor redColor] : [UIColor clearColor]];
            _subjectLabel.font = [Constants appFontWithSize:FONT_SIZE_SUBTITLE bolded:NO];
            [self.contentView addSubview:_subjectLabel];
        }
        
        if (!_dateLabel)
        {
            _dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [_dateLabel setBackgroundColor:[Constants debug] ? [UIColor blueColor] : [UIColor clearColor]];
            [_dateLabel setTextAlignment:NSTextAlignmentRight];
            _dateLabel.font = [Constants appFontWithSize:FONT_SIZE_TIME];
            [self.contentView addSubview:_dateLabel];
        }
        
    }
    return self;
}

-(void)setConversation:(WCDConversation *)conversation
{
    if (_conversation != conversation)
    {
        _conversation = conversation;
        
        self.subjectLabel.text = [conversation.subject stringByDecodingHTMLEntities];
        self.dateLabel.text = [NSDate relativeDateFromDateString:conversation.dateString];
        self.isSystem = (conversation.user.idNum == 0);
        self.senderAvatar.userInteractionEnabled = !self.isSystem;
        
        if (self.isSystem)
        {
            self.senderLabel.text = @"System";
            [self.senderAvatar setImage:[UIImage imageNamed:@"../Images/system.png"]];
            
        }
        else
        {
            self.senderLabel.text = conversation.user.name;
            [self setAvatarImageWithURL:conversation.user.avatarURL];
        }
        
        [self setUnread:conversation.unread];
        
    }
}

-(void)setAvatarImageWithURL:(NSURL *)imageURL
{
    if ([[imageURL absoluteString] length] > 0)
    {
        __weak InboxTableViewCell *weakAvatar = self;
        [self.senderAvatar setImageWithURLRequest:[NSURLRequest requestWithURL:imageURL] placeholderImage:[LoadingImages defaultLoadingProfileImageWithWidth:MESSAGE_AVATAR_WIDTH] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            
            UIImage *resizedImage = [UIImage resizeImage:image newSize:CGSizeMake(MESSAGE_AVATAR_WIDTH, MESSAGE_AVATAR_WIDTH) contentMode:weakAvatar.senderAvatar.contentMode];
            [weakAvatar.senderAvatar setImage:resizedImage];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
            NSLog(@"couldn't load remote image");
            [weakAvatar.senderAvatar setImage:[LoadingImages defaultProfileImageWithWidth:MESSAGE_AVATAR_WIDTH]];
        }];
    }
    
    else
    {
        [self.senderAvatar setImage:[LoadingImages defaultProfileImageWithWidth:MESSAGE_AVATAR_WIDTH]];
    }
}

-(void)setUnread:(BOOL)unread
{
    [self.subjectLabel setTextColor:[UIColor colorFromHexString:cCellFontMediumColor]];
    [self.dateLabel setTextColor:[UIColor colorFromHexString:cCellFontLightColor]];
    
    if (unread)
    {
        [_senderLabel setTextColor:[UIColor colorFromHexString:cCellFontDarkColor]];
    }
    else
    {
        [_senderLabel setTextColor:[UIColor colorFromHexString:cCellFontMediumColor]];
    }

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.senderAvatar setFrame:CGRectMake(CELL_PADDING, CELL_PADDING, MESSAGE_AVATAR_WIDTH, MESSAGE_AVATAR_WIDTH)];
    
    CGFloat subjectLabelX = self.senderAvatar.frame.origin.x + self.senderAvatar.frame.size.width + CELL_PADDING;
    
    [self.senderLabel setFrame:CGRectMake(subjectLabelX, self.senderAvatar.frame.origin.y, self.frame.size.width - subjectLabelX - CELL_PADDING, 20.f)];
    
    [self.subjectLabel setFrame:CGRectMake(subjectLabelX, self.senderAvatar.frame.origin.y + self.senderAvatar.frame.size.height - 13.f, self.frame.size.width - subjectLabelX - CELL_PADDING*2 - self.accessoryView.frame.size.width, 13.f)];
    
    CGFloat dateOriginX = self.frame.size.width - CELL_PADDING - 100.f;
    
    [self.dateLabel setFrame:CGRectMake(dateOriginX, self.senderLabel.frame.origin.y, self.frame.size.width - dateOriginX - CELL_PADDING, 15.f)];
    
    CGRect accessoryFrame = self.accessoryView.frame;
    accessoryFrame.origin.y = (self.subjectLabel.frame.origin.y + self.subjectLabel.frame.size.height) - self.accessoryView.frame.size.height;
    [self.accessoryView setFrame:accessoryFrame];
    
}

+(CGFloat)heightForRows
{
    return MESSAGE_AVATAR_WIDTH + CELL_PADDING*2;
}

@end
