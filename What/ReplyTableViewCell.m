//
//  ReplyCell.m
//  What
//
//  Created by What on 7/10/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "ReplyTableViewCell.h"
#import "UIButton+Tools.h"

@interface ReplyTableViewCell ()

@property (nonatomic, strong) UIImage *keyboardImage;
@property (nonatomic, strong) UIView *bgView;

@end

@implementation ReplyTableViewCell

@synthesize inputTextView = inputTextView_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        //[self.contentView setBackgroundColor:[UIColor colorFromHexString:cThreadCellOddColor]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (!_bgView)
        {
            _bgView = [[UIView alloc] init];
            [_bgView setBackgroundColor:[UIColor colorFromHexString:cThreadCellOddColor]];
            self.backgroundView = _bgView;
        }
        
        if (!inputTextView_)
        {
            inputTextView_ = [[UITextView alloc] init];
            [inputTextView_ setFont:[Constants appFontWithSize:14.f]];
            [inputTextView_ setTextColor:[UIColor colorFromHexString:cCellFontDarkColor]];
            [inputTextView_ setBackgroundColor:[UIColor colorFromHexString:cThreadCellOddColor]];
            inputTextView_.scrollsToTop = NO;
            //[[inputTextField_ textInputTraits] setValue:[UIColor lightGrayColor] forKey:@"insertionPointColor"];
            [self.contentView addSubview:inputTextView_];
        }
        
        if (!_dismissKeyboard)
        {
            _keyboardImage = [UIImage imageNamed:@"../Images/dismissKeyboard.png"];
            _dismissKeyboard = [UIButton buttonWithType:UIButtonTypeCustom];
            [_dismissKeyboard setBackgroundImage:_keyboardImage forState:UIControlStateNormal];
            [self.contentView addSubview:_dismissKeyboard];
        }
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.inputTextView setFrame:CGRectMake(CELL_PADDING/2, CELL_PADDING/2, self.frame.size.width - CELL_PADDING, self.frame.size.height - CELL_PADDING)];
    [self.dismissKeyboard setFrame:CGRectMake(CELL_WIDTH - CELL_PADDING*2 - self.keyboardImage.size.width, self.frame.size.height - CELL_PADDING - self.keyboardImage.size.height, self.keyboardImage.size.width, self.keyboardImage.size.height)];
    [self.dismissKeyboard expandHitTestEdgeInsets];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
