//
//  LoadingEllipsisView.m
//  What
//
//  Created by What on 6/17/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "LoadingView.h"

#define SCALE_DURATION 0.5f
#define OPACITY_DURATION 0.3f
#define CIRCLES_DELAY 0.3f

@interface LoadingView () 
{
    @private
    uint bigCircleRadius;
    uint smallCircleRadius;
    
    //CGFloat beginningAlpha;
    //CGFloat endingAlpha;
    
    uint circles;
    CGFloat animationDelay;
}

@property (nonatomic, strong) NSMutableArray *points;

@end

@implementation LoadingView

@synthesize points = points_;

- (id)initWithFrame:(CGRect)frame numberOfCircles:(uint)numberOfCircles circleSize:(uint)circleSize widthToConstrict:(CGFloat)constrict startAlpha:(CGFloat)startAlpha
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.layer setBackgroundColor:[UIColor colorFromHexString:cForumCellSelectedColor alpha:startAlpha].CGColor];
        self.userInteractionEnabled = NO;
        
        bigCircleRadius = circleSize;
        smallCircleRadius = circleSize / 3;
        
        circles = numberOfCircles;
        
        CGRect rectForCircles = CGRectMake((frame.size.width/2) - (constrict/2), (frame.size.height/2) - (constrict/2), constrict, constrict);
        
        self.alpha = 0;
        animationDelay = (CGFloat)(circles * .3f);
        
        CGFloat spacing = rectForCircles.size.width / circles;
        
        points_ = [NSMutableArray new];
        for (int i = 0; i < circles; i++)
            [points_ addObject:[NSValue valueWithCGPoint:CGPointMake((rectForCircles.origin.x + (spacing*i)) + (spacing / 2), rectForCircles.origin.y + rectForCircles.size.height/2)]];
        
    }
    return self;
}

-(void)showLoader
{
    self.isVisible = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveLinear animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            [self drawCircles];
        }];
    });
}

-(void)hideLoader
{
    [self stopAnimatingWithDuration:0.25f afterDelay:0.5f];
    self.isVisible = NO;
}

-(void)stopAnimatingWithDuration:(CGFloat)duration afterDelay:(CGFloat)delay
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            //[self removeFromSuperview];
        }];
    });
}

-(void)drawStaticCircles
{
    int radius = (int)((self.frame.size.width/4)/2);
    int diameter = radius*2;
    
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius) cornerRadius:radius].CGPath;
    [circle setPosition:CGPointMake((CGFloat)diameter, (self.frame.size.height/2) - radius)];
    [circle setFillColor:[UIColor colorFromHexString:@"2e2d2c" alpha:0.7f].CGColor];
    [circle setStrokeColor:[UIColor colorFromHexString:@"2e2d2c" alpha:0.8f].CGColor];
    [circle setLineWidth:1.f];
    [self.layer addSublayer:circle];
    
    CAShapeLayer *circle2 = [CAShapeLayer layer];
    circle2.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius) cornerRadius:radius].CGPath;
    [circle2 setPosition:CGPointMake((CGFloat)2.5*diameter, (self.frame.size.height/2) - radius)];
    [circle2 setFillColor:[UIColor colorFromHexString:@"2e2d2c" alpha:0.7f].CGColor];
    [circle2 setStrokeColor:[UIColor colorFromHexString:@"2e2d2c" alpha:0.8f].CGColor];
    [circle2 setLineWidth:1.f];
    [self.layer addSublayer:circle2];

}

-(void)drawCircles
{
    //int length = sizeof(points) / sizeof(points[0]);
    for (int i = 0; i < circles; i++)
    {
        //don't show first circle at the 0 second mark, because it might not appear sometimes
        double delayInSeconds = CIRCLES_DELAY*(i+1);
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

            CAShapeLayer *sublayer = [self.layer.sublayers objectAtIndex:i];
            CGPoint position = [[self.points objectAtIndex:i] CGPointValue];
            [sublayer addAnimation:[self animationWithPosition:position] forKey:@"animateCircle"];
            
        });
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //if (self.isStatic)
    //{
        
    //}
    
    //else
    //{
        for (int i = 0; i < circles; i++)
        {
            CAShapeLayer *circle = [CAShapeLayer layer];
            
            circle.fillColor = [UIColor colorFromHexString:@"484745"].CGColor;
            circle.strokeColor = [UIColor colorFromHexString:@"484745"].CGColor;
            circle.lineWidth = 1.f;
            circle.opacity = 0;
                
            [self.layer addSublayer:circle];
        }
    //}

}

-(CAAnimationGroup *)animationWithPosition:(CGPoint)position
{
    
    CABasicAnimation *scaleFromBigAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    scaleFromBigAnimation.beginTime = 0.f;
    scaleFromBigAnimation.duration = SCALE_DURATION;
    scaleFromBigAnimation.fillMode = kCAFillModeForwards;
    scaleFromBigAnimation.fromValue = (__bridge id)([UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2*bigCircleRadius, 2*bigCircleRadius) cornerRadius:bigCircleRadius].CGPath);
    scaleFromBigAnimation.toValue = (__bridge id)([UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2*((bigCircleRadius+smallCircleRadius)/2), 2*((bigCircleRadius+smallCircleRadius)/2)) cornerRadius:((bigCircleRadius+smallCircleRadius)/2)].CGPath);
    scaleFromBigAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
    CABasicAnimation *positionFromBigAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionFromBigAnimation.beginTime = scaleFromBigAnimation.beginTime;
    positionFromBigAnimation.duration = SCALE_DURATION;
    positionFromBigAnimation.fillMode = kCAFillModeForwards;
    positionFromBigAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(position.x - bigCircleRadius, position.y - bigCircleRadius)];
    positionFromBigAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(position.x - ((bigCircleRadius+smallCircleRadius)/2), position.y - ((bigCircleRadius+smallCircleRadius)/2))];
    positionFromBigAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
    CABasicAnimation *opacityFromBigAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityFromBigAnimation.beginTime = scaleFromBigAnimation.beginTime;
    opacityFromBigAnimation.duration = OPACITY_DURATION;
    opacityFromBigAnimation.fillMode = kCAFillModeForwards;
    opacityFromBigAnimation.fromValue = [NSNumber numberWithFloat:0.f];
    opacityFromBigAnimation.toValue = [NSNumber numberWithFloat:1.f];
    opacityFromBigAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    
    CABasicAnimation *scaleToSmallAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    scaleToSmallAnimation.beginTime = animationDelay;
    scaleToSmallAnimation.duration = SCALE_DURATION;
    scaleToSmallAnimation.fillMode = kCAFillModeForwards;
    scaleToSmallAnimation.fromValue = (__bridge id)([UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2*((bigCircleRadius+smallCircleRadius)/2), 2*((bigCircleRadius+smallCircleRadius)/2)) cornerRadius:((bigCircleRadius+smallCircleRadius)/2)].CGPath);
    scaleToSmallAnimation.toValue = (__bridge id)([UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2*smallCircleRadius, 2*smallCircleRadius) cornerRadius:smallCircleRadius].CGPath);
    scaleToSmallAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
    CABasicAnimation *positionToSmallAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionToSmallAnimation.beginTime = scaleToSmallAnimation.beginTime;
    positionToSmallAnimation.duration = SCALE_DURATION;
    positionToSmallAnimation.fillMode = kCAFillModeForwards;
    positionToSmallAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(position.x - ((bigCircleRadius+smallCircleRadius)/2), position.y - ((bigCircleRadius+smallCircleRadius)/2))];
    positionToSmallAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(position.x - smallCircleRadius, position.y - smallCircleRadius)];
    positionToSmallAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
    CABasicAnimation *opacityToSmallAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityToSmallAnimation.beginTime = (scaleToSmallAnimation.beginTime + scaleToSmallAnimation.duration) - OPACITY_DURATION;
    opacityToSmallAnimation.duration = OPACITY_DURATION;
    opacityToSmallAnimation.fillMode = kCAFillModeForwards;
    opacityToSmallAnimation.fromValue = [NSNumber numberWithFloat:1.f];
    opacityToSmallAnimation.toValue = [NSNumber numberWithFloat:0.f];
    opacityToSmallAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    [group setValue:NSStringFromCGPoint(position) forKey:@"id"];
    group.repeatCount = HUGE_VALF;
    [group setDuration:scaleFromBigAnimation.beginTime + scaleFromBigAnimation.duration + scaleToSmallAnimation.beginTime + scaleToSmallAnimation.duration];
    [group setAnimations:[NSArray arrayWithObjects:opacityFromBigAnimation, scaleFromBigAnimation, positionFromBigAnimation, opacityToSmallAnimation, scaleToSmallAnimation, positionToSmallAnimation, nil]];

    return group;

}

/*
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([[anim valueForKey:@"id"] isEqual:@"fadeOut"])
    {
        [self.layer removeAllAnimations];
        self.layer.sublayers = nil;
        [self removeFromSuperview];
    }
}
*/

-(void)pauseAnimations
{
    CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0.0f;
    self.layer.timeOffset = pausedTime;
}

-(void)resumeAnimations
{
    CFTimeInterval pausedTime = [self.layer timeOffset];
    self.layer.speed = 1.f;
    self.layer.timeOffset = 0.f;
    self.layer.beginTime = 0.f;
    
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.layer.beginTime = timeSincePause;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    int length = sizeof(rects) / sizeof(rects[0]);
    for (int i = 0; i < length; i++)
    {
        CGRect rectangle = rects[i];
        CGContextAddEllipseInRect(context, rectangle);
    }
    
    CGContextSetFillColor(context, CGColorGetComponents([UIColor redColor].CGColor));
    CGContextFillPath(context);
}
*/


@end
