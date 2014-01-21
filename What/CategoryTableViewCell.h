//
//  CategoryCell.h
//  What
//
//  Created by What on 7/14/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTableViewCell.h"
#import "WCDForum.h"

@interface CategoryTableViewCell : MainTableViewCell

@property (nonatomic, strong) WCDForum *forum;

+(CGFloat)heightForLabelText:(NSString *)text;

@end
