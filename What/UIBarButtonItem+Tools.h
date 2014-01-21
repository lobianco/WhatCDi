//
//  UIBarButtonItem+Tools.h
//  What
//
//  Created by What on 7/20/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Tools)

+ (UIBarButtonItem *)backArrowWithTarget:(id)target selector:(SEL)selector;
+ (UIBarButtonItem *)replyButtonWithTarget:(id)target selector:(SEL)selector;
+ (UIBarButtonItem *)cameraButtonWithTarget:(id)target selector:(SEL)selector;
+ (UIBarButtonItem *)drawerButtonWithTarget:(id)target selector:(SEL)selector;

@end
