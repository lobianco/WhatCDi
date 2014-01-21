//
//  ThreadViewCell.h
//  What
//
//  Created by What on 5/2/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "TTTAttributedLabel.h"
//#import <OHAttributedLabel/OHAttributedLabel.h>
#import "BBElement.h"
#import "WCDPostContent.h"

@class ThreadTableViewCell;
@protocol ThreadCellDelegate <NSObject>
@required
- (void)openLink:(NSURL *)url;
@end

@interface ThreadTableViewCell : UITableViewCell

@property (nonatomic, weak) id <ThreadCellDelegate> delegate;
@property (nonatomic, weak) WCDPostContent *content;

- (void)updateContent:(WCDPostContent *)content shouldDynamicallyReloadHeight:(BOOL)reload;
- (void)setColorHex:(NSString *)colorHex;
+ (NSString *)formatHTML:(NSString *)html forPreload:(BOOL)preload;

@end
