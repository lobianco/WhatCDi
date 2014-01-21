//
//  MenuTable.h
//  What
//
//  Created by What on 6/27/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuController.h"
#import "MenuTableHeader.h"
#import "MenuTableFooter.h"

@interface MenuTable : UITableView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) MenuTableHeader *menuTableHeader;
@property (nonatomic, strong) MenuTableFooter *menuTableFooter;
@property (nonatomic, weak) MenuController *parentController;

@end
