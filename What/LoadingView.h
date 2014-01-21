//
//  LoadingEllipsisView.h
//  What
//
//  Created by What on 6/17/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

-(id)initWithFrame:(CGRect)frame numberOfCircles:(uint)numberOfCircles circleSize:(uint)circleSize widthToConstrict:(CGFloat)constrict startAlpha:(CGFloat)startAlpha;
-(void)showLoader;
-(void)hideLoader;

@property (nonatomic) BOOL isVisible;

@end
