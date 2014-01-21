//
//  TableViewForLoader.h
//  What
//
//  Created by What on 6/20/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "SSPullToRefresh.h"
//#import "MainTableView.h"

@interface MainTableViewController : UITableViewController <SSPullToRefreshViewDelegate>

//@property (nonatomic, strong) MainTableView *tableView;
@property (nonatomic, strong) SSPullToRefreshView *pullToRefreshView;

- (void)showLoadingView;
- (void)hideLoadingView;
- (BOOL)loaderIsShowing;
- (void)refresh;

@property (nonatomic, strong) UIView *footerShadowView;

@end
