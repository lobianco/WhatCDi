//
//  InboxPaginator.m
//  What
//
//  Created by What on 8/4/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "InboxPaginator.h"
#import "API.h"
#import "WCDConversation.h"
#import "NSString+HTML.h"

@implementation InboxPaginator

- (void)nextPage
{
    [self fetchInboxWithPage:self.page+1];
}

-(void)fetchInboxWithPage:(NSInteger)page
{
    NSURLRequest *request = [[API sharedInterface] getInboxPage:page type:@"inbox" sort:@"unread" search:@"" searchtype:@""];
    [API getRequest:request completionBlockWithJSON:^(id JSON) {
        
        NSDictionary *response = [JSON objectForKey:@"response"];
        NSArray *conversations = [response objectForKey:@"messages"];
        
        //NSInteger unreadCount = 0;
        NSMutableArray *conversationsArray = [NSMutableArray new];
        for (NSDictionary *conversationDict in conversations)
        {
            WCDConversation *conversation = [[WCDConversation alloc] init];
            conversation.idNum = [[conversationDict objectForKey:@"convId"] integerValue];
            conversation.subject = [[conversationDict objectForKey:@"subject"] stringByDecodingHTMLEntities];
            conversation.unread = [[conversationDict objectForKey:@"unread"] boolValue];
            conversation.dateString = [conversationDict objectForKey:@"date"];
            
            WCDUser *user = [[WCDUser alloc] init];
            user.name = [conversationDict objectForKey:@"username"];
            user.idNum = [[conversationDict objectForKey:@"senderId"] integerValue];
            user.avatarURL = [NSURL URLWithString:[conversationDict objectForKey:@"avatar"]];
            
            conversation.user = user;

            [conversationsArray addObject:conversation];
            
            //if (conversation.unread)
            //    unreadCount++;
        }
        
        [self receivedResults:conversationsArray pageTotal:[[response objectForKey:@"pages"] integerValue]];
    
    } failureBlockWithError:^(NSError *error) {
                
        [self failedWithError:error];
        
    }];
}

@end
