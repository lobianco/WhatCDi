//
//  NewsCell.m
//  What
//
//  Created by What on 7/19/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "AnnouncementsTableViewCell.h"
#import "NSString+HTML.h"
#import "LoadingView.h"
#import "NSDate+Tools.h"

#define IMAGE_WIDTH 60.f
#define IMAGE_HEIGHT 90.f

#define CELL_HEIGHT (IMAGE_HEIGHT + CELL_PADDING*2)

@interface AnnouncementsTableViewCell ()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UILabel *body;
@property (nonatomic, strong) UIImageView *newsImage;

@end

@implementation AnnouncementsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        if (!_title)
        {
            _title = [[UILabel alloc] initWithFrame:CGRectZero];
            _title.backgroundColor = [UIColor clearColor];
            _title.numberOfLines = 2;
            _title.font = [Constants appFontWithSize:FONT_SIZE_TITLE bolded:YES];
            _title.textColor = [UIColor colorFromHexString:cCellFontDarkColor];
            _title.lineBreakMode = NSLineBreakByTruncatingTail;
            [self.contentView addSubview:_title];
        }
        
        if (!_time)
        {
            _time = [[UILabel alloc] initWithFrame:CGRectZero];
            _time.backgroundColor = [UIColor clearColor];
            _time.numberOfLines = 1;
            _time.font = [Constants appFontWithSize:FONT_SIZE_TIME bolded:NO];
            _time.textColor = [UIColor colorFromHexString:cCellFontLightColor];
            _time.lineBreakMode = NSLineBreakByTruncatingTail;
            _time.textAlignment = NSTextAlignmentLeft;
            [self.contentView addSubview:_time];
            
        }
        
        if (!_body)
        {
            _body = [[UILabel alloc] initWithFrame:CGRectZero];
            _body.backgroundColor = [UIColor clearColor];
            _body.numberOfLines = 0;
            _body.font = [Constants appFontWithSize:FONT_SIZE_SUBTITLE bolded:NO];
            _body.textColor = [UIColor colorFromHexString:cCellFontMediumColor];
            _body.lineBreakMode = NSLineBreakByTruncatingTail;
            [self.contentView addSubview:_body];
        }
        
        if (!_newsImage)
        {
            _newsImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"../Images/newsLoader.png"]];
            _newsImage.contentMode = UIViewContentModeScaleToFill;
            [_newsImage setClipsToBounds:YES];
            _newsImage.layer.masksToBounds = YES;
            _newsImage.layer.borderColor = [[UIColor colorFromHexString:cCellFontDarkColor] CGColor];
            _newsImage.layer.borderWidth = 1.f;
            _newsImage.userInteractionEnabled = YES;
            [self.contentView addSubview:_newsImage];

        }
    }
    return self;
}

-(void)setAnnouncement:(WCDAnnouncement *)announcement
{
    if (_announcement != announcement) {
        
        _announcement = announcement;
        
        self.title.text = [announcement.title stringByDecodingHTMLEntities];
        self.body.text = [announcement.htmlBody stringByConvertingHTMLToPlainText];
        self.time.text = [NSDate relativeDateFromDateString:announcement.newsTime];
        [self setAvatarImageWithURL:announcement.imageURL];
    }
    
    [self setNeedsLayout];
}

-(void)setAvatarImageWithURL:(NSURL *)imageURL
{
    if ([[imageURL absoluteString] length] > 0)
    {
        NSLog(@"setting remote image");
        __weak AnnouncementsTableViewCell *weakAvatar = self;
        [self.newsImage setImageWithURLRequest:[NSURLRequest requestWithURL:imageURL] placeholderImage:[UIImage imageNamed:@"../Images/newsLoader.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            
            UIImage *resizedImage = [UIImage resizeImage:image newSize:CGSizeMake(IMAGE_WIDTH, IMAGE_HEIGHT) contentMode:weakAvatar.newsImage.contentMode];
            [weakAvatar.newsImage setImage:resizedImage];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
            NSLog(@"couldn't load remote image");
            [weakAvatar.newsImage setImage:[UIImage imageNamed:@"../Images/news.png"]];
            
        }];
    }
    
    else {
        self.newsImage.image = nil;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.newsImage.frame = self.newsImage.image ? CGRectMake(CELL_PADDING, CELL_PADDING, IMAGE_WIDTH, IMAGE_HEIGHT) : CGRectZero;
    
    CGFloat timeXOrigin = self.newsImage.frame.origin.x + self.newsImage.frame.size.width + CELL_PADDING;
    CGFloat labelWidth = CELL_WIDTH - CELL_PADDING*2 - timeXOrigin - self.accessoryView.frame.size.width;
    self.time.frame = CGRectMake(timeXOrigin, CELL_PADDING, labelWidth, 0);
    [self.time sizeToFit];
    
    self.title.frame = CGRectMake(self.time.frame.origin.x, self.time.frame.origin.y + self.time.frame.size.height, labelWidth, 0);
    [self.title sizeToFit];
    
    CGRect titleFrame = self.title.frame;
    titleFrame.size.width = labelWidth;
    self.title.frame = titleFrame;
    
    CGFloat bodyHeight = [self.body.text sizeWithFont:self.body.font constrainedToSize:CGSizeMake(labelWidth, CGFLOAT_MAX) lineBreakMode:self.body.lineBreakMode].height;
    self.body.frame = CGRectMake(self.time.frame.origin.x, self.title.frame.origin.y + self.title.frame.size.height, labelWidth, MIN(CELL_HEIGHT - (self.title.frame.origin.y + self.title.frame.size.height) - CELL_PADDING, bodyHeight));
}

+(CGFloat)height
{
    //CGFloat titleHeight = [[announcement.title stringByDecodingHTMLEntities] sizeWithFont:[Constants appFontWithSize:14.f bolded:YES] constrainedToSize:CGSizeMake(CELL_WIDTH - CELL_PADDING*2, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
    
    //CGFloat bodyHeight =
    
    return CELL_HEIGHT;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
