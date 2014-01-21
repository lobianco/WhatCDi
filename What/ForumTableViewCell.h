//
//  ForumCell.h
//  What
//
//  Created by What on 7/9/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTableViewCell.h"
#import "WCDThread.h"

@interface ForumTableViewCell : MainTableViewCell

@property (nonatomic, strong) WCDThread *thread;


//@property (nonatomic, strong) UILabel *originalAuthorLabel;

//-(void)setRead:(BOOL)read postCount:(NSInteger)postCount sticky:(BOOL)sticky locked:(BOOL)locked;
+(CGFloat)heightForTitle:(NSString *)threadTitle;

@end
