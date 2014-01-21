//
//  SettingsTable.h
//  What
//
//  Created by What on 6/27/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuController.h"
#import "SettingsTableHeader.h"

@interface SettingsTable : UITableView

@property (nonatomic, strong) SettingsTableHeader *settingsTableHeader;
@property (nonatomic, weak) MenuController *parentController;

-(void)addNotifications;
-(void)removeNotifications;

@end
