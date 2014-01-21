//
//  ThreadHeaderView.h
//  What
//
//  Created by What on 7/10/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCDPost.h"

@interface ThreadSectionHeaderView : UIView

@property (nonatomic, strong) WCDPost *post;
@property (nonatomic, strong) UIImageView *avatar;

-(void)setColor:(UIColor *)color;
+(CGFloat)heightForHeader;

@end
