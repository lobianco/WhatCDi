//
//  MenuTableHeader.m
//  What
//
//  Created by What on 8/6/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "MenuTableHeader.h"
#import "AppDelegate.h"
#import "UIButton+Tools.h"

#define AVATAR_WIDTH 24.f
#define BUTTON_PADDING 5.f

@interface MenuTableHeader () <UIAlertViewDelegate>

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UIButton *usernameSelectedButton;
//@property (nonatomic, strong) UIImageView *settingsGearImage;

@end

@implementation MenuTableHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        if (!_avatarView)
        {
            _avatarView = [[UIImageView alloc] initWithImage:[LoadingImages defaultProfileImageWithWidth:AVATAR_WIDTH]];
            [_avatarView setContentMode:UIViewContentModeScaleAspectFill];
            [_avatarView setClipsToBounds:YES];
            _avatarView.layer.masksToBounds = YES;
            _avatarView.layer.borderColor = [[UIColor colorFromHexString:cCellFontDarkColor] CGColor];
            _avatarView.layer.borderWidth = 1.f;
            _avatarView.layer.cornerRadius = 4.f;
            _avatarView.userInteractionEnabled = YES;
            [self addSubview:_avatarView];
        }
        
        if (!_usernameLabel)
        {
            _usernameLabel = [[UILabel alloc] init];
            _usernameLabel.textColor = [UIColor colorFromHexString:@"d3d1ce"];
            _usernameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14.f];
            _usernameLabel.numberOfLines = 1;
            _usernameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            _usernameLabel.backgroundColor = [UIColor clearColor];
            [self addSubview:_usernameLabel];
        }
        
        if (!_usernameSelectedButton)
        {
            _usernameSelectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _usernameSelectedButton.adjustsImageWhenHighlighted = YES;
            _usernameSelectedButton.layer.cornerRadius = 4.f;
            _usernameSelectedButton.layer.masksToBounds = YES;
            _usernameSelectedButton.clipsToBounds = YES;
            
            [_usernameSelectedButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25f]] forState:UIControlStateHighlighted];
            [_usernameSelectedButton addTarget:self action:@selector(signOut:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_usernameSelectedButton];
        }
        
        /*
        if (!_settingsButton)
        {
            UIImage *gearImage = [UIImage imageNamed:@"../Images/gear.png"];
            _settingsGearImage = [[UIImageView alloc] initWithImage:gearImage];
            //[self addSubview:_settingsGearImage];
            
            _settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _settingsButton.adjustsImageWhenHighlighted = YES;
            _settingsButton.layer.cornerRadius = 4.f;
            _settingsButton.layer.masksToBounds = YES;
            _settingsButton.clipsToBounds = YES;
            [_settingsButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25f]] forState:UIControlStateHighlighted];
            //[self addSubview:_settingsButton];
        }
         */
        
        if (!_heartButton) {
            _heartButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_heartButton setImage:[UIImage imageNamed:@"../Images/heart.png"] forState:UIControlStateNormal];
            [self addSubview:_heartButton];
        }
        
    }
    return self;
}

-(void)setUser:(WCDUser *)user
{
    if (_user != user)
    {
         NSLog(@"user");
        _user = user;
        
        self.usernameLabel.text = user.name;
        [self setAvatarImageWithURL:user.avatarURL];
        
        [self setNeedsLayout];
        
    }
    else
        NSLog(@"user is same");
}

-(void)setAvatarImageWithURL:(NSURL *)url
{
    if ([[url absoluteString] length] > 0)
    {
        __weak MenuTableHeader *weakSelf = self;
        [self.avatarView setImageWithURLRequest:[NSURLRequest requestWithURL:url] placeholderImage:[LoadingImages defaultLoadingProfileImageWithWidth:AVATAR_WIDTH] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {

            //antialias image
            UIImage *resizedImage = [UIImage resizeImage:image newSize:CGSizeMake(weakSelf.avatarView.frame.size.width, weakSelf.avatarView.frame.size.height) contentMode:weakSelf.avatarView.contentMode];
            [weakSelf.avatarView setImage:resizedImage];

        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
            NSLog(@"couldn't load menu table image");
            [weakSelf.avatarView setImage:[LoadingImages defaultProfileImageWithWidth:AVATAR_WIDTH]];
                        
        }];
    }
    
    else
    {
        [self.avatarView setImage:[LoadingImages defaultProfileImageWithWidth:AVATAR_WIDTH]];
    }
    
}

-(void)signOut:(UIButton *)button
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign Out?" message:@"Are you sure you want to sign out? Your settings will be erased." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex)
        return;
    
    NSLog(@"sign out");
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.sidePanelController closeDrawerAnimated:YES completion:^(BOOL finished) {
        [appDelegate logout];
    }];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.avatarView.frame = CGRectMake(CELL_PADDING, self.frame.size.height - AVATAR_WIDTH - CELL_PADDING, AVATAR_WIDTH, AVATAR_WIDTH);
    
    CGFloat usernameWidth = [self.usernameLabel.text sizeWithFont:self.usernameLabel.font constrainedToSize:CGSizeMake(CELL_WIDTH - 120.f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByTruncatingTail].width;
    self.usernameLabel.frame = CGRectMake(self.avatarView.frame.origin.x + self.avatarView.frame.size.width + CELL_PADDING, self.avatarView.frame.origin.y, usernameWidth, self.avatarView.frame.size.height);
    self.usernameSelectedButton.frame = CGRectMake(self.avatarView.frame.origin.x - BUTTON_PADDING, self.avatarView.frame.origin.y - BUTTON_PADDING, self.avatarView.frame.size.width + usernameWidth + CELL_PADDING + BUTTON_PADDING*2, self.avatarView.frame.size.height + BUTTON_PADDING*2);
    
    self.heartButton.frame = CGRectMake(self.frame.size.width - 80.f, self.frame.size.height - CELL_PADDING - 20.f, 20.f, 17.f);
    [self.heartButton expandHitTestEdgeInsets];
    
    //self.settingsGearImage.frame = CGRectMake(CELL_WIDTH - 80.f, self.avatarView.frame.origin.y + (self.avatarView.frame.size.height/2) - (self.settingsGearImage.image.size.height/2), self.settingsGearImage.image.size.width, self.settingsGearImage.image.size.height);
    //self.settingsButton.frame = CGRectMake(self.settingsGearImage.frame.origin.x - BUTTON_PADDING, self.settingsGearImage.frame.origin.y - BUTTON_PADDING, self.settingsGearImage.frame.size.width + BUTTON_PADDING*2, self.settingsGearImage.frame.size.height + BUTTON_PADDING*2);
    
    [self.firstBottomSeparator setFrame:CGRectMake(0, self.frame.size.height - 2.f, CELL_WIDTH, 1.f)];
    [self.secondBottomSeparator setFrame:CGRectMake(0, self.frame.size.height - 1.f, CELL_WIDTH, 1.f)];
}

+(CGFloat)height
{
    return AVATAR_WIDTH + CELL_PADDING*2;
}


@end
