//
//  NewsCell.h
//  What
//
//  Created by What on 7/19/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTableViewCell.h"
#import "WCDAnnouncement.h"

@interface AnnouncementsTableViewCell : MainTableViewCell

@property (nonatomic, weak) WCDAnnouncement *announcement;

+(CGFloat)height;

@end
