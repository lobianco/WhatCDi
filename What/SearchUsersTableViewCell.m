//
//  SearchUsersCell.m
//  What
//
//  Created by What on 6/10/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "SearchUsersTableViewCell.h"
#import <CoreText/CoreText.h>

#define AVATAR_WIDTH 32.f

@interface SearchUsersTableViewCell ()

@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *classLabel;

@end

@implementation SearchUsersTableViewCell

@synthesize label = label_;
@synthesize avatar = avatar_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        if (!avatar_)
        {
            avatar_ = [[UIImageView alloc] initWithImage:[LoadingImages defaultProfileImageWithWidth:AVATAR_WIDTH]];
            avatar_.layer.masksToBounds = YES;
            avatar_.layer.borderColor = [[UIColor colorFromHexString:cCellFontDarkColor] CGColor];
            avatar_.layer.borderWidth = 1.f;
            avatar_.layer.cornerRadius = 4.f;
            avatar_.contentMode = UIViewContentModeScaleAspectFill;
            [self addSubview:avatar_];
        }
        
        if (!label_)
        {
            label_ = [[UILabel alloc] initWithFrame:CGRectZero];
            [label_ setNumberOfLines:1];
            [label_ setFont:[Constants appFontWithSize:FONT_SIZE_TITLE bolded:YES]];
            [label_ setTextColor:[UIColor colorFromHexString:cCellFontDarkColor]];
            [label_ setBackgroundColor:[UIColor clearColor]];
            [self.contentView addSubview:label_];
        }
        
        if (!_classLabel)
        {
            _classLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [_classLabel setNumberOfLines:1];
            [_classLabel setFont:[Constants appFontWithSize:10.f bolded:YES]];
            [_classLabel setTextColor:[UIColor colorFromHexString:cCellFontMediumColor]];
            [_classLabel setBackgroundColor:[UIColor clearColor]];
            [self.contentView addSubview:_classLabel];
        }
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.avatar.frame = CGRectMake(CELL_PADDING, CELL_PADDING, AVATAR_WIDTH, AVATAR_WIDTH);
    
    CGFloat constrictWidth = CELL_WIDTH - AVATAR_WIDTH - CELL_PADDING*3;
    CGSize labelSize = [self.label sizeThatFits:CGSizeMake(constrictWidth, CGFLOAT_MAX)];
    self.label.frame = CGRectMake(CELL_PADDING*2 + AVATAR_WIDTH, CELL_PADDING, constrictWidth, labelSize.height);
    
    CGSize classSize = [self.classLabel sizeThatFits:CGSizeMake(constrictWidth, CGFLOAT_MAX)];
    self.classLabel.frame = CGRectMake(self.label.frame.origin.x, self.label.frame.origin.y + self.label.frame.size.height, constrictWidth, classSize.height);
}

-(void)setUser:(WCDUser *)user
{
    if (_user != user)
    {
        _user = user;
        
        if (user.enabled)
        {
            [self.label setTextColor:[UIColor colorFromHexString:cCellFontDarkColor]];
            self.label.text = user.name;
        }
        
        else
        {
            [self.label setTextColor:[UIColor colorFromHexString:cCellFontMediumColor]];
            
            if ([Constants iOSVersion] >= IOS6)
            {
                NSMutableAttributedString *crossedOutName = [[NSMutableAttributedString alloc] initWithString:_user.name];
                [crossedOutName addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, crossedOutName.length)];
                self.label.attributedText = crossedOutName;
            }
            
            else
            {
                //TODO
                self.label.text = user.name;
                //CTFontRef ref = CTFontCreateWithName((CFStringRef)@"HelveticaNeue", self.label.font.pointSize, NULL);
                //CTFontRef strikedFont = CTFontCreateCopyWithSymbolicTraits(ref, self.label.font.pointSize, NULL, kCTFontItalicTrait, kCTFontItalicTrait);
                //attribute = [[NSMutableDictionary alloc] initWithObjectsAndKeys:(__bridge id)italicFont, (NSString*)kCTFontAttributeName, nil];
            }
        }
        
        self.classLabel.text = [_user.memberClass uppercaseString];
        [self setAvatarWithURL:_user.avatarURL];
    }
}

-(void)setAvatarWithURL:(NSURL *)imageURL
{
    if (imageURL.absoluteString.length > 0)
    {
        __weak SearchUsersTableViewCell *weakCell = self;
        [self.avatar setImageWithURLRequest:[NSURLRequest requestWithURL:imageURL] placeholderImage:[LoadingImages defaultLoadingProfileImageWithWidth:AVATAR_WIDTH] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [weakCell.avatar setImage:image];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"couldnt load album image");
            [weakCell.avatar setImage:[LoadingImages defaultProfileImageWithWidth:AVATAR_WIDTH]];
        }];
    }
    
    else
        [self.avatar setImage:[LoadingImages defaultProfileImageWithWidth:AVATAR_WIDTH]];
    
}

+(CGFloat)heightForRow
{
    return AVATAR_WIDTH + CELL_PADDING*2;
}

@end
