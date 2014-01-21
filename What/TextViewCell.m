//
//  FieldCell.m
//  What
//
//  Created by What on 7/12/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "TextViewCell.h"
#import "UIButton+Tools.h"

#define BUTTON_PADDING 15.f
#define FIELD_PADDING 2.f

@interface TextViewCell ()

@property (nonatomic, strong) UIImage *keyboardImage;
@property (nonatomic, strong) UIButton *dismissKeyboardButton;

@end

@implementation TextViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self setBackgroundColor:[UIColor colorFromHexString:@"847f7a"]];
                
        if (!_textView)
        {
            _textView = [[UITextView alloc] initWithFrame:CGRectZero];
            [_textView setFont:[Constants appFontWithSize:12.f]];
            [_textView setTextColor:[UIColor colorFromHexString:cMenuTableFontColor]];
            [_textView setBackgroundColor:[UIColor clearColor]];
            [_textView setScrollsToTop:NO];
            [self.contentView addSubview:_textView];
        }
        
        if (!_dismissKeyboardButton)
        {
            _keyboardImage = [UIImage imageNamed:@"../Images/dismissKeyboardLight.png"];
            _dismissKeyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_dismissKeyboardButton setBackgroundImage:_keyboardImage forState:UIControlStateNormal];
            [_dismissKeyboardButton addTarget:self action:@selector(deactivateTextView:) forControlEvents:UIControlEventTouchUpInside];
            _dismissKeyboardButton.alpha = 0;
            [self.contentView addSubview:_dismissKeyboardButton];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}

-(void)keyboardWillShow
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.dismissKeyboardButton.alpha = 0.4;
    } completion:nil];
}

-(void)keyboardWillHide
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.dismissKeyboardButton.alpha = 0.f;
    } completion:nil];
}

-(void)deactivateTextView:(UIButton *)button
{
    if ([self.textView isFirstResponder])
        [self.textView resignFirstResponder];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.textView setFrame:CGRectMake(FIELD_PADDING, FIELD_PADDING, self.frame.size.width - FIELD_PADDING*2, self.frame.size.height - FIELD_PADDING*2)];
    [self.dismissKeyboardButton setFrame:CGRectMake(CELL_WIDTH - BUTTON_PADDING - self.keyboardImage.size.width, self.frame.size.height - BUTTON_PADDING - self.keyboardImage.size.height, self.keyboardImage.size.width, self.keyboardImage.size.height)];
    [self.dismissKeyboardButton expandHitTestEdgeInsets];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
