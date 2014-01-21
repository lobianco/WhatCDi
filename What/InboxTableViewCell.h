//
//  InboxMessageCell.h
//  What
//
//  Created by What on 6/12/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTableViewCell.h"
#import "WCDConversation.h"

@interface InboxTableViewCell : MainTableViewCell

@property (nonatomic, strong) WCDConversation *conversation;
@property (nonatomic, strong) UIImageView *senderAvatar;

+(CGFloat)heightForRows;

@end
