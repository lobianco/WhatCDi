//
//  ProfileAvatarCell.h
//  What
//
//  Created by What on 5/30/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCDUser.h"
#import "MainTableViewCell.h"

@interface ProfileAvatarCell : MainTableViewCell

@property (nonatomic, strong) WCDUser *user;
@property (nonatomic, strong) UIImageView *avatarView;

-(UIImage *)fullSizedAvatarImage;

+(CGFloat)height;

@end
