//
//  UIBarButtonItem+Tools.m
//  What
//
//  Created by What on 7/20/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "UIBarButtonItem+Tools.h"

@implementation UIBarButtonItem (Tools)

+ (UIBarButtonItem *)backArrowWithTarget:(id)target selector:(SEL)selector
{
    UIImage *backButton = [UIImage imageNamed:@"../Images/backButton.png"];
    return [UIBarButtonItem navButtonWithImage:backButton target:target selector:selector];
}

+(UIBarButtonItem *)replyButtonWithTarget:(id)target selector:(SEL)selector
{
    UIImage *replyButton = [UIImage imageNamed:@"../Images/reply.png"];
    return [UIBarButtonItem navButtonWithImage:replyButton target:target selector:selector];
}

+(UIBarButtonItem *)cameraButtonWithTarget:(id)target selector:(SEL)selector
{
    UIImage *cameraButton = [UIImage imageNamed:@"../Images/camera.png"];
    return [UIBarButtonItem navButtonWithImage:cameraButton target:target selector:selector];
}

+(UIBarButtonItem *)drawerButtonWithTarget:(id)target selector:(SEL)selector
{
    UIImage *drawerButton = [UIImage imageNamed:@"../Images/navBarButton.png"];
    return [UIBarButtonItem navButtonWithImage:drawerButton target:target selector:selector];
}

+(UIBarButtonItem *)navButtonWithImage:(UIImage *)image target:(id)target selector:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0.f, 0, image.size.width + 20.f, image.size.height)];
    [button setShowsTouchWhenHighlighted:YES];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}



@end
