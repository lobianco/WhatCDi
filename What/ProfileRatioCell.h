//
//  ProfileRatioCell.h
//  What
//
//  Created by What on 5/30/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#define RATIO_CELL_HEIGHT 40.f
#define RATIO_CELL_FONT_SIZE 12.f

@interface ProfileRatioCell : UITableViewCell

@property (nonatomic, strong) UILabel *ratioLabel;
@property (nonatomic, strong) UILabel *uploadLabel;
@property (nonatomic, strong) UILabel *downloadLabel;

@end
