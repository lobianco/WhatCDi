//
//  ToggleCell.h
//  What
//
//  Created by What on 6/27/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToggleObject.h"
#import "SettingsTable.h"
#import "SettingsCell.h"

@interface ToggleCell : SettingsCell

@property (nonatomic, strong) ToggleObject *toggleObject;
//@property (nonatomic, strong) UISwitch *toggle;

-(void)setChecked:(BOOL)checked animated:(BOOL)animated;

+(CGFloat)heightForCell;

@end
