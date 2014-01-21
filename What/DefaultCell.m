//
//  DropboxCell.m
//  What
//
//  Created by What on 7/30/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "DefaultCell.h"

@interface DefaultCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation DefaultCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //self.backgroundColor = [UIColor colorFromHexString:@"bbcbce"];
        
        if (!_label)
        {
            _label = [[UILabel alloc] initWithFrame:CGRectZero];
            _label.textColor = [UIColor colorFromHexString:cMenuTableFontColor];
            //_label.backgroundColor = [UIColor colorFromHexString:cMenuTableFontColor alpha:0.4];
            _label.backgroundColor = [UIColor clearColor];
            _label.font = [Constants appFontWithSize:FONT_SIZE_TITLE bolded:YES];
            [self.contentView addSubview:_label];
        }
        
    }
    return self;
}

-(void)setSettingsObject:(SettingsObject *)settingsObject
{
    if (_settingsObject != settingsObject)
    {
        _settingsObject = settingsObject;
    }
    
    self.label.text = _settingsObject.title;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.label.frame = CGRectMake(CELL_PADDING, 0, CELL_WIDTH - CELL_PADDING*2, self.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
