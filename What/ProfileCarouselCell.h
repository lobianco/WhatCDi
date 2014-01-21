//
//  UserCarouselCell.h
//  What
//
//  Created by What on 6/21/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeView.h"
#import "MainTableViewCell.h"

@interface ProfileCarouselCell : UITableViewCell

@property (nonatomic, strong) SwipeView *swipeView;
@property (nonatomic, strong) NSArray *albums;

+(CGFloat)height;

@end
