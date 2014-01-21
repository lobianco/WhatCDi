//
//  UIButton+Tools.m
//  What
//
//  Created by What on 8/21/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "UIButton+Tools.h"
#import <objc/runtime.h>

@implementation UIButton (Tools)

static const NSString *KEY_HIT_TEST_EDGE_INSETS = @"HitTestEdgeInsets";
@dynamic hitTestEdgeInsets;

-(void)expandHitTestEdgeInsets
{
    [self setHitTestEdgeInsets:UIEdgeInsetsMake(-20, -20, -20, -20)];
}

-(void)setHitTestEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = [NSValue value:&hitTestEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = objc_getAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS);
    if(value) {
        UIEdgeInsets edgeInsets; [value getValue:&edgeInsets]; return edgeInsets;
    }else {
        return UIEdgeInsetsZero;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if(UIEdgeInsetsEqualToEdgeInsets(self.hitTestEdgeInsets, UIEdgeInsetsZero) || !self.enabled || self.hidden) {
        return [super pointInside:point withEvent:event];
    }
    
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitTestEdgeInsets);
    
    return CGRectContainsPoint(hitFrame, point);
}

@end
