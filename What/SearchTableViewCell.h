//
//  SearchCell.h
//  What
//
//  Created by What on 9/12/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsCellSelectedView.h"

@interface SearchTableViewCell : UITableViewCell

@property (nonatomic, strong) SettingsCellSelectedView *selectedView;

- (void)roundCorners:(UIRectCorner)corners;

@end
