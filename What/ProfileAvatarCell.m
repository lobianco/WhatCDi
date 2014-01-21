//
//  ProfileAvatarCell.m
//  What
//
//  Created by What on 5/30/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "ProfileAvatarCell.h"
#import "LoadingView.h"
#import "NSDate+Tools.h"

#define USER_AVATAR_WIDTH 60.f
#define NAME_LABEL_HEIGHT 30.f

@interface ProfileAvatarCell ()

@property (nonatomic, strong) UIImage *fullSizedImage;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *classLabel;
@property (nonatomic, strong) UILabel *joinDateLabel;

@end

@implementation ProfileAvatarCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //[self.contentView setBackgroundColor:[UIColor colorFromHexString:cCellAccessoryColor alpha:0.9]];
        self.accessoryView = nil;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (!_avatarView)
        {
            //avatar image
            _avatarView = [[UIImageView alloc] initWithImage:[LoadingImages defaultProfileImageWithWidth:USER_AVATAR_WIDTH]];
            [_avatarView setContentMode:UIViewContentModeScaleAspectFill];
            [_avatarView setClipsToBounds:YES];
            _avatarView.layer.masksToBounds = YES;
            _avatarView.layer.cornerRadius = 6.f;
            _avatarView.layer.borderColor = [[UIColor colorFromHexString:cCellFontDarkColor] CGColor];
            _avatarView.layer.borderWidth = 1.f;
            _avatarView.userInteractionEnabled = YES;
            [self.contentView addSubview:_avatarView];
        }
        
        if (!_nameLabel)
        {
            //name
            _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [_nameLabel setBackgroundColor:([Constants debug] ? [UIColor redColor] : [UIColor clearColor])];
            _nameLabel.numberOfLines = 1;
            [_nameLabel setTextColor:[UIColor colorFromHexString:@"333"]];
            [_nameLabel setTextAlignment:NSTextAlignmentCenter];
            [_nameLabel setFont:[Constants appFontWithSize:24.f bolded:YES]];
            [self.contentView addSubview:_nameLabel];
        }
        
        if (!_classLabel)
        {
            _classLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [_classLabel setBackgroundColor:([Constants debug] ? [UIColor redColor] : [UIColor clearColor])];
            [_classLabel setTextColor:[UIColor colorFromHexString:@"444"]];
            [_classLabel setTextAlignment:NSTextAlignmentCenter];
            [_classLabel setFont:[Constants appFontWithSize:12.f bolded:YES]];
            [self.contentView addSubview:_classLabel];
        }
        
        if (!_joinDateLabel)
        {
            _joinDateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [_joinDateLabel setBackgroundColor:([Constants debug] ? [UIColor redColor] : [UIColor clearColor])];
            [_joinDateLabel setTextColor:[UIColor colorFromHexString:@"555"]];
            [_joinDateLabel setTextAlignment:NSTextAlignmentCenter];
            [_joinDateLabel setFont:[Constants appFontWithSize:9.f bolded:NO]];
            [self.contentView addSubview:_joinDateLabel];
        }
        
    }
    return self;
}

-(void)setUser:(WCDUser *)user
{
    if (_user != user)
    {
        _user = user;
        
        if (user.enabled)
        {
            [self.nameLabel setTextColor:[UIColor colorFromHexString:cCellFontDarkColor]];
            self.nameLabel.text = user.name;
        }
        
        else
        {
            [self.nameLabel setTextColor:[UIColor colorFromHexString:cCellFontMediumColor]];
            
            if ([Constants iOSVersion] >= IOS6)
            {
                NSMutableAttributedString *crossedOutName = [[NSMutableAttributedString alloc] initWithString:user.name];
                [crossedOutName addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, crossedOutName.length)];
                self.nameLabel.attributedText = crossedOutName;
            }
            
            else
            {
                //TODO
                self.nameLabel.text = user.name;
                //CTFontRef ref = CTFontCreateWithName((CFStringRef)@"HelveticaNeue", self.label.font.pointSize, NULL);
                //CTFontRef strikedFont = CTFontCreateCopyWithSymbolicTraits(ref, self.label.font.pointSize, NULL, kCTFontItalicTrait, kCTFontItalicTrait);
                //attribute = [[NSMutableDictionary alloc] initWithObjectsAndKeys:(__bridge id)italicFont, (NSString*)kCTFontAttributeName, nil];
            }
        }
        
        [self setAvatarImageWithURL:_user.avatarURL];
        [self.classLabel setText:[_user.memberClass uppercaseString]];
        [self.joinDateLabel setText:[NSString stringWithFormat:@"Joined in %@ of %@", [NSDate monthFromDateString:_user.joinDate], [NSDate yearFromDateString:_user.joinDate]]];
        
    }
    
    else
        DebugLog(@"ERROR: Already equal!");

}

-(void)setAvatarImageWithURL:(NSURL *)url
{
    if ([[url absoluteString] length] > 0)
    {
        //load avatar image
        __weak ProfileAvatarCell *weakSelf = self;
        [self.avatarView setImageWithURLRequest:[NSURLRequest requestWithURL:url] placeholderImage:[LoadingImages defaultLoadingProfileImageWithWidth:USER_AVATAR_WIDTH] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                    
            //save full sized image for image popover
            weakSelf.fullSizedImage = image;
            
            //antialias image
            UIImage *resizedImage = [UIImage resizeImage:image newSize:CGSizeMake(weakSelf.avatarView.frame.size.width, weakSelf.avatarView.frame.size.height) contentMode:weakSelf.avatarView.contentMode];
            [weakSelf.avatarView setImage:resizedImage];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
            NSLog(@"couldn't load avatar image");
            [weakSelf.avatarView setImage:[LoadingImages defaultProfileImageWithWidth:USER_AVATAR_WIDTH]];
            
        }];
    }
    
    else
    {
        [self.avatarView setImage:[LoadingImages defaultProfileImageWithWidth:USER_AVATAR_WIDTH]];
        self.fullSizedImage = [UIImage imageNamed:@"../Images/silhouette.png"];
    }
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
        
    [self.avatarView setFrame:CGRectMake((self.frame.size.width/2) - (USER_AVATAR_WIDTH/2), CELL_PADDING, USER_AVATAR_WIDTH, USER_AVATAR_WIDTH)];
    
    [self.nameLabel setFrame:CGRectMake(CELL_PADDING, self.avatarView.frame.origin.y + USER_AVATAR_WIDTH + 2.f, 0, 0)];
    [self.nameLabel sizeToFit];
    CGRect nameFrame = self.nameLabel.frame;
    nameFrame.size.width = self.frame.size.width - CELL_PADDING*2;
    self.nameLabel.frame = nameFrame;
    
    [self.classLabel setFrame:CGRectMake(CELL_PADDING, (self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height) - 2.f, 0, 0)];
    [self.classLabel sizeToFit];
    CGRect classFrame = self.classLabel.frame;
    classFrame.size.width = self.frame.size.width - CELL_PADDING*2;
    self.classLabel.frame = classFrame;
    
    [self.joinDateLabel setFrame:CGRectMake(CELL_PADDING, self.classLabel.frame.origin.y + self.classLabel.frame.size.height, 0, 0)];
    [self.joinDateLabel sizeToFit];
    CGRect joinDateFrame = self.joinDateLabel.frame;
    joinDateFrame.size.width = self.frame.size.width - CELL_PADDING*2;
    self.joinDateLabel.frame = joinDateFrame;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UIImage *)fullSizedAvatarImage
{
    return self.fullSizedImage;
}

+(CGFloat)height
{
    return 137.f;// (USER_AVATAR_WIDTH + CELL_PADDING*2 + NAME_LABEL_HEIGHT);
}

@end
