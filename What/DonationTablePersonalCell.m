//
//  DonationTablePersonalCell.m
//  What.CD
//
//  Created by What on 10/14/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "DonationTablePersonalCell.h"
#import "UserSingleton.h"

static CGFloat const kAvatarWidth = 60.f;

@interface DonationTablePersonalCell ()

@property (nonatomic, strong) UIImageView *myImage;
@property (nonatomic, strong) UIImage *buttonImage;
@property (nonatomic, strong) UILabel *firstParagraphLabel;
@property (nonatomic, strong) UILabel *remainingParagraphsLabel;
@property (nonatomic, strong) UILabel *bitcoinLabel;

@end

@implementation DonationTablePersonalCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (!_myImage) {
            _myImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"../Images/carolina88.png"]];
            [_myImage setContentMode:UIViewContentModeScaleAspectFill];
            [_myImage setClipsToBounds:YES];
            _myImage.layer.masksToBounds = YES;
            _myImage.layer.borderColor = [[UIColor colorFromHexString:cFontWhiteColor] CGColor];
            _myImage.layer.borderWidth = 1.f;
            _myImage.layer.cornerRadius = 4.f;
            [self.contentView addSubview:_myImage];
        }
        
        if (!_firstParagraphLabel) {
            _firstParagraphLabel = [[UILabel alloc] init];
            _firstParagraphLabel.textColor = [UIColor colorFromHexString:cMenuTableFontColor];
            _firstParagraphLabel.font = [Constants appFontWithSize:12.f];
            _firstParagraphLabel.backgroundColor = [UIColor clearColor];
            _firstParagraphLabel.numberOfLines = 0;
            NSString *username = [UserSingleton sharedInstance].username;
            username = (username == nil ? @"there" : username);
            NSString *text = [NSString stringWithFormat:@"Hi %@! I'm carolina88, the developer of What.CD for iPhone (WhatCDi) and a member of the What community since 2009.", username];
            if ([Constants iOSVersion] >= 6.0) {
                UIFont *boldFont = [Constants appFontWithSize:12.f bolded:YES];
                const NSRange range = NSMakeRange(0, 4+username.length);
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
                [attributedText addAttribute:NSFontAttributeName value:boldFont range:range];
                
                [_firstParagraphLabel setAttributedText:attributedText];
            } else {
                [_firstParagraphLabel setText:text];
            }
            [self.contentView addSubview:_firstParagraphLabel];
        }
        
        if (!_remainingParagraphsLabel) {
            _remainingParagraphsLabel = [[UILabel alloc] init];
            _remainingParagraphsLabel.font = [Constants appFontWithSize:12.f];
            _remainingParagraphsLabel.textColor = [UIColor colorFromHexString:cMenuTableFontColor];
            _remainingParagraphsLabel.backgroundColor = [UIColor clearColor];
            _remainingParagraphsLabel.numberOfLines = 0;
            NSString *text = @"I worked really hard on WhatCDi, and I hope it's noticeable. If you think it’s as awesome as I do and you would like to show your appreciation (aka buy me beer!!), please consider making a donation. By doing so, you'll be ensuring speedy and consistent updates in the future.\n\nIf you don't feel like donating, no hard feelings! I just hope you find the app useful. Thank you for your support and I hope you enjoy your stay :-)";
            if ([Constants iOSVersion] >= 6.0) {
                UIFont *italicFont = [Constants appFontWithSize:12.f oblique:YES];
                const NSRange italicRange = NSMakeRange(9, 6);
                UIFont *boldFont = [Constants appFontWithSize:12.f bolded:YES];
                const NSRange boldRange = NSMakeRange(180, 17);
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
                [attributedText addAttribute:NSFontAttributeName value:italicFont range:italicRange];
                [attributedText addAttribute:NSFontAttributeName value:boldFont range:boldRange];
                
                [_remainingParagraphsLabel setAttributedText:attributedText];
            } else {
                [_remainingParagraphsLabel setText:text];
            }
            [self.contentView addSubview:_remainingParagraphsLabel];
        }
        
        if (!_donateButton) {
            _buttonImage = [UIImage imageNamed:@"../Images/donateButton.png"];
            _donateButton = [DonateButton buttonWithType:UIButtonTypeCustom];
            [_donateButton setBackgroundImage:_buttonImage forState:UIControlStateNormal];
            [_donateButton.titleLabel setFont:[Constants appFontWithSize:20.f bolded:YES]];
            [_donateButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
            [_donateButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.8] forState:UIControlStateNormal];
            [_donateButton setTitle:@"Donate to the developer" forState:UIControlStateNormal];
            _donateButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 16.f, 0);
            _donateButton.donatePath = @"http://whatcdios.com/donations";
            [self.contentView addSubview:_donateButton];
            
        }
        
        if (!_bitcoinLabel) {
            _bitcoinLabel = [[UILabel alloc] init];
            _bitcoinLabel.text = @"http://whatcdios.com/donations";
            _bitcoinLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.6];
            _bitcoinLabel.font = [Constants appFontWithSize:13.f];
            _bitcoinLabel.backgroundColor = [UIColor clearColor];
            _bitcoinLabel.numberOfLines = 1;
            [_bitcoinLabel setTextAlignment:NSTextAlignmentCenter];
            _bitcoinLabel.layer.shadowColor = [UIColor colorFromHexString:@"29607f"].CGColor;
            _bitcoinLabel.layer.shadowOffset = CGSizeMake(0, -1);
            _bitcoinLabel.layer.shadowRadius = 0.f;
            _bitcoinLabel.layer.shadowOpacity = 0.6f;
            [self.contentView addSubview:_bitcoinLabel];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.myImage.frame = CGRectMake(self.frame.size.width - CELL_PADDING - kAvatarWidth, CELL_PADDING, kAvatarWidth, kAvatarWidth);
    
    CGFloat firstParagraphWidth = self.frame.size.width - CELL_PADDING*4 - kAvatarWidth;
    self.firstParagraphLabel.frame = CGRectMake(CELL_PADDING, CELL_PADDING, firstParagraphWidth, 0.f);
    [self.firstParagraphLabel sizeToFit];
    CGRect firstParagraphFrame = self.firstParagraphLabel.frame;
    firstParagraphFrame.size.width = firstParagraphWidth;
    self.firstParagraphLabel.frame = firstParagraphFrame;
    
    CGFloat remainingParagraphsWidth = self.frame.size.width - CELL_PADDING*2;
    self.remainingParagraphsLabel.frame = CGRectMake(CELL_PADDING, self.firstParagraphLabel.frame.origin.y + self.firstParagraphLabel.frame.size.height + CELL_PADDING, remainingParagraphsWidth, 0);
    [self.remainingParagraphsLabel sizeToFit];
    CGRect remainingParagraphsFrame = self.remainingParagraphsLabel.frame;
    remainingParagraphsFrame.size.width = remainingParagraphsWidth;
    self.remainingParagraphsLabel.frame = remainingParagraphsFrame;
    
    self.donateButton.frame = CGRectMake(self.frame.size.width/2 - self.buttonImage.size.width/2, self.frame.size.height - self.buttonImage.size.height - CELL_PADDING, self.buttonImage.size.width, self.buttonImage.size.height);
    self.bitcoinLabel.frame = CGRectMake(0, self.donateButton.frame.origin.y + self.donateButton.frame.size.height/2 + 4.f, self.frame.size.width, 20.f);
}

@end
