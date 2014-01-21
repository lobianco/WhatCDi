//
//  PageControlsCell.m
//  What
//
//  Created by What on 7/10/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "PageControlsView.h"
#import "NextPageArrowButton.h"
#import "LastPageArrowButton.h"
#import "PageControlsGradientView.h"
#import "UIButton+Tools.h"

#define SWIPEVIEW_WIDTH 150.f
#define SWIPEVIEW_VIEW_WIDTH 80.f

#define ARROW_WIDTH 18.f
#define DOUBLE_ARROW_WIDTH (ARROW_WIDTH*1.5f)
#define ARROW_PADDING 14.f

@interface PageControlsView () <SwipeViewDataSource, SwipeViewDelegate>

@property (nonatomic, strong) NextPageArrowButton *nextPage;
@property (nonatomic, strong) NextPageArrowButton *previousPage;

@property (nonatomic, strong) LastPageArrowButton *lastPage;
@property (nonatomic, strong) LastPageArrowButton *firstPage;

@end

@implementation PageControlsView

@synthesize nextPage = nextPage_;
@synthesize previousPage = previousPage_;

@synthesize lastPage = lastPage_;
@synthesize firstPage = firstPage_;

//@synthesize pageLabel = pageLabel_;

@synthesize swipeView = swipeView_;

@synthesize pickerItems = pickerItems_;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"../Images/replyNavBar.png"]]];
        
        if (!nextPage_)
        {
            nextPage_ = [[NextPageArrowButton alloc] initWithFrame:CGRectZero];
            [nextPage_ addTarget:self.delegate action:@selector(gotoNextPage) forControlEvents:UIControlEventTouchUpInside];
            nextPage_.showsTouchWhenHighlighted = YES;
            [self addSubview:nextPage_];
        }
        
        if (!previousPage_)
        {
            previousPage_ = [[NextPageArrowButton alloc] initWithFrame:CGRectZero];
            previousPage_.transform = CGAffineTransformMakeRotation(M_PI);
            [previousPage_ addTarget:self.delegate action:@selector(gotoPreviousPage) forControlEvents:UIControlEventTouchUpInside];
            previousPage_.showsTouchWhenHighlighted = YES;
            [self addSubview:previousPage_];
        }
        
        if (!lastPage_)
        {
            lastPage_ = [[LastPageArrowButton alloc] initWithFrame:CGRectZero];
            [lastPage_ addTarget:self.delegate action:@selector(gotoLastPage) forControlEvents:UIControlEventTouchUpInside];
            lastPage_.showsTouchWhenHighlighted = YES;
            [self addSubview:lastPage_];
        }
        
        if (!firstPage_)
        {
            firstPage_ = [[LastPageArrowButton alloc] initWithFrame:CGRectZero];
            firstPage_.transform = CGAffineTransformMakeRotation(M_PI);
            [firstPage_ addTarget:self.delegate action:@selector(gotoFirstPage) forControlEvents:UIControlEventTouchUpInside];
            firstPage_.showsTouchWhenHighlighted = YES;
            [self addSubview:firstPage_];
        }
        
        
        if (!swipeView_)
        {
            swipeView_ = [[SwipeView alloc] initWithFrame:CGRectMake((frame.size.width/2) - (SWIPEVIEW_WIDTH/2), 0, SWIPEVIEW_WIDTH, frame.size.height)];
            swipeView_.dataSource = self;
            swipeView_.delegate = self;
            swipeView_.decelerationRate = 0.994f; //0.994
            swipeView_.pagingEnabled = NO;
            //swipeView_.scrollEnabled = NO;
            swipeView_.alignment = SwipeViewAlignmentCenter;
            swipeView_.backgroundColor = [UIColor colorFromHexString:cCellAccessoryColor alpha:0.4f];
            [self addSubview:swipeView_];
            
            [swipeView_ addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"../Images/swipeviewShadow.png"]]];
            
            UIImageView *rightShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"../Images/swipeviewShadow.png"]];
            rightShadow.transform = CGAffineTransformMakeRotation(M_PI);
            [rightShadow setFrame:CGRectMake(swipeView_.frame.size.width - rightShadow.image.size.width, 0, rightShadow.image.size.width, rightShadow.image.size.height)];
            [swipeView_ addSubview:rightShadow];
        }
        
        //setup is based on position of swipeview
        //[self setup];
        
    }
    
    return self;
}

-(void)layoutSubviews
{
    
    [super layoutSubviews];

    PageControlsGradientView *leftGradient = (PageControlsGradientView*)[self.swipeView viewWithTag:100];
    [leftGradient setFrame:CGRectMake(0, 0, self.swipeView.frame.size.width, self.swipeView.frame.size.height)];
    
    PageControlsGradientView *rightGradient = (PageControlsGradientView*)[self.swipeView viewWithTag:101];
    [rightGradient setFrame:CGRectMake(0, 0, self.swipeView.frame.size.width, self.swipeView.frame.size.height)];
    
    CGFloat arrowHeight = ARROW_WIDTH*1.5f;
    CGFloat arrowYOrigin = (self.frame.size.height/2) - (arrowHeight/2);
    
    [self.nextPage setFrame:CGRectMake(self.swipeView.frame.origin.x + self.swipeView.frame.size.width + ARROW_PADDING, arrowYOrigin, ARROW_WIDTH, arrowHeight)];
    [self.nextPage setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
    [self.previousPage setFrame:CGRectMake(self.swipeView.frame.origin.x - ARROW_PADDING - ARROW_WIDTH, arrowYOrigin, ARROW_WIDTH, arrowHeight)];
    [self.previousPage setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
    [self.lastPage setFrame:CGRectMake(self.nextPage.frame.origin.x + self.nextPage.frame.size.width + ARROW_PADDING, arrowYOrigin, DOUBLE_ARROW_WIDTH, arrowHeight)];
    [self.lastPage setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
    [self.firstPage setFrame:CGRectMake(self.previousPage.frame.origin.x - ARROW_PADDING - DOUBLE_ARROW_WIDTH, arrowYOrigin, DOUBLE_ARROW_WIDTH, arrowHeight)];
    [self.firstPage setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
}

# pragma mark - iCarousel methods

-(NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return self.pickerItems;
}


-(UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIView *newView = (UIView *)view;
    UILabel *titleLabel = nil;
    
    //TODO stop page controls (if moving, aka if someone flicked the page numbers and they are still sliding) before switching pages
    
    //create or reuse view
    if (view == nil)
    {
        newView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0f, SWIPEVIEW_VIEW_WIDTH, swipeView.frame.size.height)];
        newView.backgroundColor = [UIColor clearColor];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(4.f, 0, newView.frame.size.width - 8.f, newView.frame.size.height)];
        [titleLabel setFont:[Constants appFontWithSize:16.f bolded:YES]];
        [titleLabel setTextColor:(index == swipeView.tag ? [UIColor colorFromHexString:@"575452"] : [UIColor colorFromHexString:cCellFontLightColor])];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.tag = 2;
        [newView addSubview:titleLabel];
        
        view = newView;
    }
    
    else
    {
        //get a reference to the label in the recycled view
        titleLabel = (UILabel *)[view viewWithTag:2];
        [titleLabel setTextColor:(index == swipeView.tag ? [UIColor colorFromHexString:@"575452"] : [UIColor colorFromHexString:cCellFontLightColor])];
    }
    
    //set labels
    [titleLabel setText:[NSString stringWithFormat:@"Page %i", index+1]];

    return view;
    
}

-(void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
    [self.delegate gotoPage:index+1];
    
    /*
    NSTimeInterval animationDuration = 0.2f;
    
    //expand swipe view
    if (!swipeView.scrollEnabled)
    {
        //NSLog(@"expand scrollview");
        
        [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
          
            [self.delegate enlargeControls:YES forView:self.tag withDuration:animationDuration];
            
            [swipeView setFrame:self.bounds];
            [self setNeedsLayout];
                        
        } completion:^(BOOL finished) {
            
            swipeView.scrollEnabled = YES;
            
        }];
    }
    
    //collapse swipe view
    else
    {
        swipeView.scrollEnabled = NO;
        
        [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
           
            [self.delegate enlargeControls:NO forView:self.tag withDuration:animationDuration];
                        
            swipeView.frame = CGRectMake((self.frame.size.width/2) - (SWIPEVIEW_WIDTH/2), 0, SWIPEVIEW_WIDTH, self.bounds.size.height);
            [self setNeedsLayout];
            
            //[swipeView scrollToItemAtIndex:[swipeView currentItemIndex] duration:0.f];
            
        } completion:nil];
        
        
        NSLog(@"item %i", index+1);
        [self.delegate gotoPage:index+1];
        
    }
     */
    
}

-(void)swipeViewDidEndDecelerating:(SwipeView *)swipeView
{
    [swipeView scrollToItemAtIndex:[swipeView currentItemIndex] duration:0.2f];
}

-(void)swipeViewDidEndDragging:(SwipeView *)swipeView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
        [swipeView scrollToItemAtIndex:[swipeView currentItemIndex] duration:0.2f];
    
}

-(void)setPickerItems:(NSInteger)pickerItems
{
    if (pickerItems_ != pickerItems)
        pickerItems_ = pickerItems;
    
    [self.swipeView reloadData];
}

-(void)setPage:(NSInteger)page lastIndex:(NSInteger)lastIndex
{
    int newTag = page - 1;
    self.swipeView.tag = newTag;
    [self.swipeView reloadData];
    //[self.swipeView setCurrentItemIndex:lastIndex-1];
    [self.swipeView scrollToItemAtIndex:newTag duration:0.3f];
    
}

@end
