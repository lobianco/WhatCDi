//
//  ReplyView.h
//  What
//
//  Created by What on 7/10/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReplyView;
@protocol ALReplyViewDelegate <NSObject>
@required

-(void)postReply:(NSString *)replyText;
-(void)showReplyView:(BOOL)show;

@end

@interface ReplyView : UIView

@property (nonatomic, weak) id <ALReplyViewDelegate> delegate;

- (void)show:(BOOL)show;
- (void)postFailed;

@end
