//
//  MenuTableHeader.h
//  What
//
//  Created by What on 8/6/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuTableHeaderFooterView.h"
#import "WCDUser.h"

@interface MenuTableHeader : MenuTableHeaderFooterView

//@property (nonatomic, strong) UIButton *settingsButton;
@property (nonatomic, strong) UIButton *heartButton;
@property (nonatomic, strong) WCDUser *user;

+(CGFloat)height;

@end
