//
//  RippyContentView.m
//  What
//
//  Created by What on 8/1/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "RippyContentView.h"

NSString * const rippyQuotes[] = {
    [0] = @"Woo!!",
    [1] = @"We have lift-off!",
    [2] = @"All done, friend.",
    [3] = @"Have a byte! Om nom.",
    [4] = @"Cheerio good sir.",
    [5] = @"I need a nap...",
    [6] = @"I <3 you"
};

#define TEXT_PADDING ([Constants iOSVersion] >= 7.0 ? @"\t\t" : @"\t\t\t\t\t\t\t\t\t\t\t")

@interface RippyContentView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *rippyText;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger loopCounter;

@end

@implementation RippyContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGSize imageSize = [RippyContentView rippyImage].size;
        
        _imageView = [[UIImageView alloc] initWithImage:[RippyContentView rippyImage]];
        _imageView.frame = CGRectMake((CELL_WIDTH/2) - (imageSize.width/2), 0.f, imageSize.width, imageSize.height);
        _imageView.image = [RippyContentView rippyImage];
        _imageView.alpha = 0.9f;
        [self addSubview:_imageView];
        
        _rippyText = [[UILabel alloc] initWithFrame:CGRectMake(0, 13, _imageView.frame.size.width, 20.f)];
        _rippyText.numberOfLines = 1;
        _rippyText.font = [UIFont fontWithName:@"Tahoma" size:10.f];
        _rippyText.textColor = [UIColor colorFromHexString:cCellFontDarkColor alpha:0.8];
        _rippyText.textAlignment = NSTextAlignmentCenter;
        _rippyText.backgroundColor = [UIColor clearColor];
        _rippyText.shadowOffset = CGSizeMake(0, 1);
        _rippyText.shadowColor = [UIColor colorFromHexString:@"f9f8f4" alpha:0.5f];
        [_imageView addSubview:_rippyText];
        
    }
    return self;
}

#pragma mark - SSPullToRefreshContentView

-(void)setState:(SSPullToRefreshViewState)state withPullToRefreshView:(SSPullToRefreshView *)view
{
    switch (state) {
		case SSPullToRefreshViewStateNormal: {
			self.rippyText.text = @"Pull down to refresh";
			break;
		}
			
		case SSPullToRefreshViewStateReady: {
			self.rippyText.text = @"Release to refresh";
			break;
		}
            
		case SSPullToRefreshViewStateLoading: {
            self.rippyText.text = [[@"" stringByPaddingToLength:11 withString:@" " startingAtIndex:0] stringByAppendingString:@"Loading."];
            self.rippyText.textAlignment = NSTextAlignmentLeft;
            self.loopCounter = 1;
            
            self.timer = [NSTimer timerWithTimeInterval:0.5f target:self selector:@selector(updateLoadingText:) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
            
			break;
		}
        
        case SSPullToRefreshViewStateClosing: {
            self.rippyText.text = [self randomRippyQuote];
            self.rippyText.textAlignment = NSTextAlignmentCenter;
            [self.timer invalidate]; self.timer = nil;
            break;
        }
	}
}

/*
-(void)setPullProgress:(CGFloat)pullProgress
{
    //NSLog(@"%f", pullProgress);
}
 */

-(void)updateLoadingText:(NSTimer *)timer
{
    int i = self.loopCounter % 3;
    NSMutableString *ellipsis = [[NSMutableString alloc] init];
    for (int j = 0; j <= i; j++)
        [ellipsis appendFormat:@"."];
    
    self.rippyText.text = [[@"" stringByPaddingToLength:11 withString:@" " startingAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"Loading%@", ellipsis]];
    self.loopCounter++;
}

-(NSString *)randomRippyQuote
{
    static int arrayCount = sizeof(rippyQuotes) / sizeof(rippyQuotes[0]);
    return rippyQuotes[arc4random_uniform(arrayCount)];
}

+ (UIImage *)rippyImage
{
    static UIImage *rippyImage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rippyImage = [UIImage imageNamed:@"../Images/rippyPulldown.png"];
    });
    
    return rippyImage;
}

@end
