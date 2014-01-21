//
//  ProfileDescriptionCell.m
//  What
//
//  Created by What on 7/18/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "ProfileDescriptionCell.h"

@interface ProfileDescriptionCell ()



@end

@implementation ProfileDescriptionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        if (!_profileText)
        {
            _profileText = [[UILabel alloc] initWithFrame:CGRectZero];
            _profileText.backgroundColor = [UIColor clearColor];
            _profileText.numberOfLines = 0;
            [_profileText setTextColor:[UIColor colorFromHexString:cCellFontDarkColor]];
            _profileText.font = [Constants appFontWithSize:FONT_SIZE_SUBTITLE];
            [self.contentView addSubview:_profileText];
        }
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.profileText.frame = CGRectMake(CELL_PADDING, CELL_PADDING, self.frame.size.width - CELL_PADDING*3 - self.accessoryView.frame.size.width, self.frame.size.height - CELL_PADDING*2);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
