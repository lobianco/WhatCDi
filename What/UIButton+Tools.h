//
//  UIButton+Tools.h
//  What
//
//  Created by What on 8/21/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Tools)

@property (nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;

-(void)expandHitTestEdgeInsets;

@end
