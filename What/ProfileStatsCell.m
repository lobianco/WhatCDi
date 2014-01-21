//
//  ProfileStatsCell.m
//  What.CD
//
//  Created by What on 9/30/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "ProfileStatsCell.h"

@interface ProfileStatsCell ()

@end

@implementation ProfileStatsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.contentView.backgroundColor = [UIColor colorFromHexString:cMenuTableBackgroundColor];
        
        if (!_titleLabel)
        {
            _titleLabel = [[UILabel alloc] init];
            [_titleLabel setFont:[Constants appFontWithSize:FONT_SIZE_TITLE bolded:YES]];
            [_titleLabel setBackgroundColor:([Constants debug] ? [UIColor greenColor] : [UIColor clearColor])];
            [_titleLabel setTextColor:[UIColor colorFromHexString:cMenuTableFontColor]];
            [self.contentView addSubview:_titleLabel];
        }
        
        if (!_valueLable)
        {
            _valueLable = [[UILabel alloc] init];
            [_valueLable setFont:[Constants appFontWithSize:12.f bolded:NO]];
            [_valueLable setTextColor:[UIColor colorFromHexString:cMenuTableFontColor]];
            [_valueLable setBackgroundColor:([Constants debug] ? [UIColor greenColor] : [UIColor clearColor])];
            [_valueLable setTextAlignment:NSTextAlignmentRight];
            [_valueLable setLineBreakMode:NSLineBreakByTruncatingTail];
            [self.contentView addSubview:_valueLable];
        }
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat selectedOptionWidth = [self.valueLable.text sizeWithFont:self.valueLable.font constrainedToSize:CGSizeMake(CELL_WIDTH - self.titleLabel.frame.size.width - CELL_PADDING, CGFLOAT_MAX) lineBreakMode:self.valueLable.lineBreakMode].width;
    
    //77pt x 27pt is size given in Apple docs
    self.titleLabel.frame = CGRectMake(CELL_PADDING, 0, CELL_WIDTH - CELL_PADDING*3 - selectedOptionWidth, self.frame.size.height);
    self.valueLable.frame = CGRectMake(CELL_WIDTH - CELL_PADDING - selectedOptionWidth, 0, selectedOptionWidth, self.frame.size.height);
}

@end
