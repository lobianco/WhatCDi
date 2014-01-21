//
//  TableViewForLoader.m
//  What
//
//  Created by What on 6/20/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "MainTableViewController.h"
#import "UIBarButtonItem+Tools.h"
#import "MainTableViewCell.h"
#import <UIViewController+MMDrawerController.h>

@interface MainTableViewController () 
{
    @private
    //MainTableView *customTableView;
    UITableView *customTableView;
}

@property (nonatomic, strong) LoadingView *loader;

@end

@implementation MainTableViewController

- (void)dealloc {
    NSLog(@"main table dealloc");
    
    _pullToRefreshView.delegate = nil;
    _pullToRefreshView = nil;
    _loader = nil;
}

//NEED this
- (void)loadView {
    [super loadView];

    self.tableView = (UITableView*)self.view;
    UIView *replacementView = [[UIView alloc] initWithFrame:(CGRect){.origin=CGPointZero, .size=CGSizeMake(self.tableView.frame.size.width, self.tableView.frame.size.height - self.navigationController.navigationBar.frame.size.height)}];
    [self.tableView setFrame:replacementView.frame];
    [replacementView addSubview:([Constants deviceHasLargerScreen]) ? [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"../Images/tableBackgroundView-568h.png"]] : [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"../Images/tableBackgroundView.png"]]];
    [replacementView addSubview:self.tableView];
    self.view = replacementView;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *buttons;
    if ([Constants iOSVersion] >= 7.0) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -10;
        buttons = @[negativeSpacer, (self.navigationController.viewControllers.count > 1) ? [UIBarButtonItem backArrowWithTarget:self selector:@selector(back:)] : [UIBarButtonItem drawerButtonWithTarget:self selector:@selector(showDrawer:)]];
    }
    else {
        buttons = @[(self.navigationController.viewControllers.count > 1) ? [UIBarButtonItem backArrowWithTarget:self selector:@selector(back:)] : [UIBarButtonItem drawerButtonWithTarget:self selector:@selector(showDrawer:)]];
    }
    self.navigationItem.leftBarButtonItems = buttons;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setBackgroundView:([Constants deviceHasLargerScreen]) ? [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"../Images/tableBackgroundView-568h.png"]] : [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"../Images/tableBackgroundView.png"]]];

    self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.tableView delegate:self];
    self.pullToRefreshView.contentView = [[RippyContentView alloc] initWithFrame:CGRectZero];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showLoadingView];
        [self.pullToRefreshView startLoading];
        //[self refresh];
    });
}

-(void)showDrawer:(id)sender
{
    [self.mm_drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)back:(id)sender
{
    //UIViewController *previousController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    //[self.navigationController popToViewController:previousController animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showLoadingView
{
    self.tableView.userInteractionEnabled = NO;
    
    self.loader = [[LoadingView alloc] initWithFrame:(CGRect){.origin=CGPointZero, .size=CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)} numberOfCircles:3 circleSize:9.f widthToConstrict:80.f startAlpha:0.92f];
    [self.view addSubview:self.loader];
    [self.loader showLoader];
}

-(void)hideLoadingView
{
    [self.loader hideLoader];
    self.tableView.userInteractionEnabled = YES;
}

- (BOOL)loaderIsShowing {
    return ([self.view.subviews containsObject:self.loader] && self.loader.isVisible);
}

# pragma mark - SSPullToRefreshDelegate

-(void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    [self refresh];
}

-(void)refresh
{
    NSAssert(NO, @"override me");
}

# pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.pullToRefreshView refreshScrollViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.pullToRefreshView refreshScrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

//NEED this to add reply view to specific controllers
- (UITableView*)tableView {
    return customTableView;
}

- (void)setTableView:(UITableView *)tableView {
    if (tableView != customTableView) {
        customTableView = tableView;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
-(CAGradientLayer *)shadow
{
    CAGradientLayer *shadow = [CAGradientLayer layer];
    CGRect shadowFrame = CGRectMake(0, 0, CELL_WIDTH, SHADOW_HEIGHT);
    shadow.frame = shadowFrame;
    CGColorRef darkColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor;
    CGColorRef lightColor = [UIColor clearColor].CGColor;
    shadow.colors = [NSArray arrayWithObjects:(__bridge id)darkColor, (__bridge id)lightColor, nil];
    
    return shadow;
}
*/

@end
