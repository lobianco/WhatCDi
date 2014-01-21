//
//  ProfileStatsFooter.h
//  What
//
//  Created by What on 6/22/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RATIO_CELL_HEIGHT 40.f
#define RATIO_CELL_FONT_SIZE 12.f

@interface ProfileStatsFooter : UIView

@property (nonatomic, strong) NSString *paranoiaLevel;
@property (nonatomic, strong) NSString *ratio;
@property (nonatomic, strong) NSString * upload;
@property (nonatomic, strong) NSString * download;

@end
