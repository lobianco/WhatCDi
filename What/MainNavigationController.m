//
//  MainNavigationController.m
//  What
//
//  Created by What on 6/12/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "MainNavigationController.h"

@interface MainNavigationController ()

@end

@implementation MainNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                UITextAttributeTextColor: [UIColor colorFromHexString:cMenuTableFontColor],
                          UITextAttributeTextShadowColor: [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0],
                         UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
                                     UITextAttributeFont: [Constants appFontWithSize:0.0 bolded:YES],
     }];
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"../Images/navBar.png"] forBarMetrics:UIBarMetricsDefault];
    self.view.layer.masksToBounds = NO;
    self.navigationBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.navigationBar.layer.shadowOpacity = 0.3;
    self.navigationBar.layer.shadowOffset = CGSizeMake(0,2);
    CGRect shadowPath = CGRectMake(self.navigationBar.layer.bounds.origin.x - 10, self.navigationBar.layer.bounds.size.height - 6, self.navigationBar.layer.bounds.size.width + 20, 5);
    self.navigationBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:shadowPath].CGPath;
    self.navigationBar.layer.shouldRasterize = YES;
    
    //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navBarTapped)];
    //[self.navigationBar addGestureRecognizer:tap];

}

/*
-(void)navBarTapped {
    NSLog(@"test");
}
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
