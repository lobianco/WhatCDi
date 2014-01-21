//
//  PickerCell.m
//  What
//
//  Created by What on 7/29/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "PickerCell.h"

@interface PickerCell ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *selectedOptionLabel;

@end

@implementation PickerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        if (!_label)
        {
            _label = [[UILabel alloc] init];
            [_label setFont:[Constants appFontWithSize:FONT_SIZE_TITLE bolded:YES]];
            [_label setBackgroundColor:([Constants debug] ? [UIColor greenColor] : [UIColor clearColor])];
            [_label setTextColor:[UIColor colorFromHexString:cMenuTableFontColor]];
            [self.contentView addSubview:_label];
        }
        
        if (!_selectedOptionLabel)
        {
            _selectedOptionLabel = [[UILabel alloc] init];
            [_selectedOptionLabel setFont:[Constants appFontWithSize:12.f bolded:NO]];
            [_selectedOptionLabel setTextColor:[UIColor colorFromHexString:cMenuTableFontColor]];
            [_selectedOptionLabel setBackgroundColor:([Constants debug] ? [UIColor greenColor] : [UIColor clearColor])];
            [_selectedOptionLabel setTextAlignment:NSTextAlignmentRight];
            [_selectedOptionLabel setLineBreakMode:NSLineBreakByTruncatingTail];
            [self.contentView addSubview:_selectedOptionLabel];
        }
        
    }
    return self;
}

-(void)setPickerObject:(PickerObject *)pickerObject
{
    if (_pickerObject != pickerObject)
    {
        _pickerObject = pickerObject;
        [self.label setText:pickerObject.title];
    }

    [self.selectedOptionLabel setText:pickerObject.selectedOption];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat selectedOptionWidth = [self.selectedOptionLabel.text sizeWithFont:self.selectedOptionLabel.font constrainedToSize:CGSizeMake(CELL_WIDTH - self.label.frame.size.width - CELL_PADDING, CGFLOAT_MAX) lineBreakMode:self.selectedOptionLabel.lineBreakMode].width;
    
    //77pt x 27pt is size given in Apple docs
    self.label.frame = CGRectMake(CELL_PADDING, 0, CELL_WIDTH - CELL_PADDING*3 - selectedOptionWidth, self.frame.size.height);
    self.selectedOptionLabel.frame = CGRectMake(CELL_WIDTH - CELL_PADDING - selectedOptionWidth, 0, selectedOptionWidth, self.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
