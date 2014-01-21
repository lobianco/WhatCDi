//
//  InboxConversationCell.h
//  What
//
//  Created by What on 6/19/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCDPost.h"

@interface ConversationMessageCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier senderIsUser:(BOOL)senderIsUser;

@property (nonatomic, strong) WCDPost *post;
@property (nonatomic, strong) UIImageView *avatar;

+(CGFloat)heightForContent:(NSString*)content;

@end
