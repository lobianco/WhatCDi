//
//  InboxConversationCell.m
//  What
//
//  Created by What on 6/19/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "ConversationMessageCell.h"
#import "NSDate+Tools.h"

#define AVATAR_WIDTH 40.f
#define MESSAGE_FONT_SIZE 13.f

@interface ConversationMessageCell ()

@property (nonatomic, strong) UIView *messageBoxView;
@property (nonatomic, readwrite) BOOL senderIsUser;

@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) NSURL *avatarURL;
@property (nonatomic, strong) UILabel *dateLabel;

@end

@implementation ConversationMessageCell

@synthesize messageBoxView = messageBoxView_;
@synthesize messageLabel = messageLabel_;
@synthesize avatar = avatar_;
@synthesize dateLabel = dateLabel_;
@synthesize avatarURL = avatarURL_;
@synthesize senderIsUser = senderIsUser_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier senderIsUser:(BOOL)senderIsUser
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        senderIsUser_ = senderIsUser;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        //remove cell border when in grouped tableview
        if (![Constants debug])
            self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        
        if (!avatar_)
        {
            avatar_ = [[UIImageView alloc] init];
            [avatar_ setImage:[UIImage imageWithColor:[UIColor purpleColor]]];
            [avatar_ setContentMode:UIViewContentModeScaleAspectFill];
            [avatar_ setClipsToBounds:YES];
            avatar_.layer.cornerRadius = 8.f;
            avatar_.layer.borderColor = [UIColor darkGrayColor].CGColor;
            avatar_.layer.borderWidth = 1.f;
            avatar_.userInteractionEnabled = YES;
            [self.contentView addSubview:avatar_];
        }
        
        if (!messageBoxView_)
        {
            messageBoxView_ = [[UIView alloc] init];
            [messageBoxView_ setBackgroundColor:(senderIsUser_ ? [UIColor lightGrayColor] : [UIColor grayColor])];
            [self.contentView addSubview:messageBoxView_];
            
            messageLabel_ = [[UILabel alloc] init];
            [messageLabel_ setBackgroundColor:[UIColor clearColor]];
            [messageLabel_ setNumberOfLines:0];
            [messageLabel_ setFont:[Constants appFontWithSize:MESSAGE_FONT_SIZE bolded:NO]];
            messageLabel_.lineBreakMode = NSLineBreakByWordWrapping;
            [messageBoxView_ addSubview:messageLabel_];
        }
        
        if (!dateLabel_)
        {
            dateLabel_ = [[UILabel alloc] init];
            [dateLabel_ setBackgroundColor:[UIColor clearColor]];
            [dateLabel_ setTextAlignment:NSTextAlignmentCenter];
            [dateLabel_ setNumberOfLines:1];
            [dateLabel_ setFont:[Constants appFontWithSize:8.f bolded:NO]];
            [dateLabel_ setTextColor:[UIColor grayColor]];
            [self.contentView addSubview:dateLabel_];
        }
        
    }
    return self;
}

/*
-(void)setMessage:(ALMessage *)message
{
    if (_message != message)
    {
        _message = message;
        
        //self.messageLabel.text = _message.bbBody;
        self.dateLabel.text = [NSDate relativeDateFromDateString:_message.sentDateString];
        [self setAvatarImageWithURL:_message.senderAvatar];
        
    }
}
 */

-(void)setAvatarImageWithURL:(NSURL *)url
{
    if (url.absoluteString.length > 0)
    {
        __weak ConversationMessageCell *weakCell = self;
        [self.avatar setImageWithURLRequest:[NSURLRequest requestWithURL:url] placeholderImage:[UIImage imageWithColor:[UIColor greenColor]] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            
            UIImage *resizedImage = [UIImage resizeImage:image newSize:CGSizeMake(weakCell.avatar.frame.size.width, weakCell.avatar.frame.size.height) contentMode:weakCell.avatar.contentMode];
            [weakCell.avatar setImage:resizedImage];
            //NSLog(@"image height: %f", image.size.height);
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"couldnt load avatar image");
            [weakCell.avatar setImage:[LoadingImages defaultProfileImageWithWidth:AVATAR_WIDTH]];
        }];
    }
    else
        [self.avatar setImage:[LoadingImages defaultProfileImageWithWidth:AVATAR_WIDTH]];
}

+(CGFloat)heightForContent:(NSString *)content
{

    CGFloat messageBoxViewWidth = CELL_WIDTH - AVATAR_WIDTH - CELL_PADDING*3;
    CGSize constraint = CGSizeMake(messageBoxViewWidth - CELL_PADDING*2, CGFLOAT_MAX);
    CGSize size = [content sizeWithFont:[Constants appFontWithSize:MESSAGE_FONT_SIZE bolded:NO] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];

    return MAX(AVATAR_WIDTH + CELL_PADDING*2, size.height + CELL_PADDING*4);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //message label
    [self.messageLabel setFrame:CGRectMake(CELL_PADDING, CELL_PADDING, self.messageBoxView.frame.size.width - CELL_PADDING*2, 0)];
    [self.messageLabel sizeToFit];
    
    //message box
    CGFloat messageBoxOriginX;
    CGFloat avatarOriginX;
    if (self.senderIsUser)
    {
        messageBoxOriginX = 0;
        avatarOriginX = CELL_WIDTH - AVATAR_WIDTH - CELL_PADDING*2;
    }
    
    else
    {
        messageBoxOriginX = AVATAR_WIDTH + CELL_PADDING;
        avatarOriginX = 0;
    }
    [self.messageBoxView setFrame:CGRectMake(messageBoxOriginX, CELL_PADDING, CELL_WIDTH - AVATAR_WIDTH - CELL_PADDING*3, self.messageLabel.frame.size.height + CELL_PADDING*2)];
    
    //avatar
    [self.avatar setFrame:CGRectMake(avatarOriginX, (self.messageBoxView.frame.size.height <= AVATAR_WIDTH ? CELL_PADDING + self.messageBoxView.frame.size.height - AVATAR_WIDTH : CELL_PADDING + self.messageBoxView.frame.size.height - AVATAR_WIDTH - 10.f), AVATAR_WIDTH, AVATAR_WIDTH)];
    [self setAvatarImageWithURL:self.avatarURL];
    
    //datelabel
    [self.dateLabel setFrame:CGRectMake(self.avatar.frame.origin.x, self.avatar.frame.origin.y + AVATAR_WIDTH + 3.f, AVATAR_WIDTH, 10.f)];

}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    
    if (self.senderIsUser)
    {
        CGContextMoveToPoint(context, CELL_WIDTH - CELL_PADDING - AVATAR_WIDTH - (CELL_PADDING/2), self.avatar.frame.origin.y + AVATAR_WIDTH/2);
        CGContextAddLineToPoint(context, CELL_WIDTH - AVATAR_WIDTH - CELL_PADDING*2, self.avatar.frame.origin.y + (AVATAR_WIDTH/4));
        CGContextAddLineToPoint(context, CELL_WIDTH - AVATAR_WIDTH - CELL_PADDING*2, self.avatar.frame.origin.y + AVATAR_WIDTH - (AVATAR_WIDTH/4));
        CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
        
    }
    
    else
    {
        CGContextMoveToPoint(context, CELL_PADDING + AVATAR_WIDTH + (CELL_PADDING/2), self.avatar.frame.origin.y + AVATAR_WIDTH/2);
        CGContextAddLineToPoint(context, CELL_PADDING*2 + AVATAR_WIDTH, self.avatar.frame.origin.y + (AVATAR_WIDTH/4));
        CGContextAddLineToPoint(context, CELL_PADDING*2 + AVATAR_WIDTH, self.avatar.frame.origin.y + AVATAR_WIDTH - (AVATAR_WIDTH/4));
        CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
    }
    
    CGContextClosePath(context);
    CGContextFillPath(context);
}

@end
