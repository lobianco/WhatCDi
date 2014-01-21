//
//  LaunchController.m
//  What
//
//  Created by What on 8/22/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "LaunchTableViewController.h"
#import "UIApplication+AppDimensions.h"

@interface LaunchTableViewController ()

@end

@implementation LaunchTableViewController

- (id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorFromHexString:cMenuTableBackgroundColor];
    
    UIImage *logo = [UIImage imageNamed:@"../Images/logo.png"];
    UIImageView *logoView = [[UIImageView alloc] initWithImage:logo];
    logoView.alpha = 0.f;
    [logoView setFrame:CGRectMake((self.view.frame.size.width / 2) - (logo.size.width / 2),(self.view.frame.size.height/2) - (logo.size.height/2),logo.size.width,logo.size.height)];
    [self.view addSubview:logoView];
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        logoView.alpha = 1.f;
    } completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
