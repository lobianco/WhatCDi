//
//  SelectedSettingsCell.m
//  What
//
//  Created by What on 9/12/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "SettingsCell.h"
#import "SettingsCellSelectedView.h"

@interface SettingsCell ()

@property (nonatomic, strong) SettingsCellSelectedView *selectedView;

@end

@implementation SettingsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        if (!_selectedView) {
            _selectedView = [[SettingsCellSelectedView alloc] init];
            self.selectedBackgroundView = _selectedView;
        }
        
    }
    return self;
}

@end
