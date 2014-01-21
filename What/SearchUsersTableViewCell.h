//
//  SearchUsersCell.h
//  What
//
//  Created by What on 6/10/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTableViewCell.h"
#import "WCDUser.h"

@interface SearchUsersTableViewCell : MainTableViewCell

@property (nonatomic, strong) WCDUser *user;

+(CGFloat)heightForRow;

@end
