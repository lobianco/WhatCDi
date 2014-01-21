//
//  ToggleCell.m
//  What
//
//  Created by What on 6/27/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "ToggleCell.h"

//#define PARTIAL_SIDE_PANEL_WIDTH 64.f
#define SUBLABEL_FONT_SIZE 14.f

@interface ToggleCell ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *checkmark;

@end

@implementation ToggleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        if (!_label)
        {
            _label = [[UILabel alloc] init];
            [_label setFont:[Constants appFontWithSize:FONT_SIZE_TITLE bolded:YES]];
            [_label setBackgroundColor:([Constants debug] ? [UIColor greenColor] : [UIColor clearColor])];
            [_label setTextColor:[UIColor colorFromHexString:cMenuTableFontColor]];
            [self.contentView addSubview:_label];
        }
        
        if (!_checkmark)
        {
            _checkmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"../Images/checkmarkLight.png"]];
            [self.contentView addSubview:_checkmark];
        }
        
    }
    return self;
}

-(void)setToggleObject:(ToggleObject *)toggleObject
{
    if (_toggleObject != toggleObject)
    {        
        _toggleObject = toggleObject;
        
        [self.label setText:toggleObject.title];
    }
}

-(void)setChecked:(BOOL)checked animated:(BOOL)animated
{
    if (checked)
    {
        if (animated)
        {
            [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.checkmark.alpha = 1.f;
            } completion:nil];
        }
        
        else
            self.checkmark.alpha = 1.f;
    }
    
    else
    {
        if (animated)
        {
            [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.checkmark.alpha = 0.f;
            } completion:nil];
        }
        
        else
            self.checkmark.alpha = 0.f;
    }
}

+(CGFloat)heightForCell
{
    return 44.f;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //77pt x 27pt is size given in Apple docs
    self.checkmark.frame = CGRectMake(CELL_WIDTH - CELL_PADDING*1.5 - self.checkmark.image.size.width, (self.frame.size.height/2) - (self.checkmark.image.size.height/2), self.checkmark.image.size.width, self.checkmark.image.size.height);
    self.label.frame = CGRectMake(CELL_PADDING, 0, CELL_WIDTH - CELL_PADDING*2 - self.checkmark.image.size.width, self.frame.size.height);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
