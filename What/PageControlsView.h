//
//  PageControlsCell.h
//  What
//
//  Created by What on 7/10/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeView.h"

@class PageControlsView; //define class so protocal can see it

@protocol ALPageControlsDelegate <NSObject> //define delegate protocol
@required //define required or optional
-(void)gotoNextPage; //define delegate method
-(void)gotoLastPage;
-(void)gotoPreviousPage;
-(void)gotoFirstPage;
-(void)gotoPage:(NSInteger)page;
//-(void)enlargeControls:(BOOL)enlarge forView:(NSInteger)tag withDuration:(NSTimeInterval)duration;
@end

@interface PageControlsView : UIView

@property (nonatomic, weak) id <ALPageControlsDelegate> delegate; //define delegate property
//@property (nonatomic, strong) UILabel *pageLabel;

@property (nonatomic, strong) SwipeView *swipeView;
@property (nonatomic, assign) NSInteger pickerItems;

-(void)setPage:(NSInteger)page lastIndex:(NSInteger)lastIndex;

@end
