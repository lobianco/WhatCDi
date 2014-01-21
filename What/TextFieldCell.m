//
//  TextFieldCell.m
//  What.CD
//
//  Created by What on 10/25/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "TextFieldCell.h"

@interface TextFieldCell ()

@end

@implementation TextFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self setBackgroundColor:[UIColor colorFromHexString:@"847f7a"]];
        
        if (!_label)
        {
            _label = [[UILabel alloc] init];
            [_label setFont:[Constants appFontWithSize:FONT_SIZE_TITLE bolded:YES]];
            [_label setBackgroundColor:([Constants debug] ? [UIColor greenColor] : [UIColor clearColor])];
            [_label setTextColor:[UIColor colorFromHexString:cMenuTableFontColor]];
            [self.contentView addSubview:_label];
        }
        
        if (!_textField)
        {
            _textField = [[UITextField alloc] init];
            [_textField setFont:[Constants appFontWithSize:12.f]];
            [_textField setTextColor:[UIColor colorFromHexString:cMenuTableFontColor]];
            [_textField setBackgroundColor:[UIColor clearColor]];
            _textField.adjustsFontSizeToFitWidth = YES;
            _textField.autocorrectionType = UITextAutocorrectionTypeNo;
            _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            _textField.textAlignment = UITextAlignmentLeft;
            [self.contentView addSubview:_textField];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.label.frame = CGRectMake(CELL_PADDING, 0, 120.f, self.frame.size.height);
    self.textField.frame = CGRectMake(self.label.frame.size.width + 20.f, 0, CELL_WIDTH - CELL_PADDING*2 - self.label.frame.size.width, self.frame.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
