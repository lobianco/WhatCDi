//
//  ForumListPaginator.m
//  What
//
//  Created by What on 8/4/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "ForumListPaginator.h"
#import "API.h"
#import "WCDThread.h"
#import "NSString+HTML.h"

@interface  ForumListPaginator ()

@property (nonatomic, assign) NSInteger pageId;

@end

@implementation ForumListPaginator

-(id)initWithDelegate:(id<NMPaginatorDelegate>)paginatorDelegate pageId:(NSInteger)pageId
{
    if(self = [super initWithDelegate:paginatorDelegate])
    {
        self.pageId = pageId;
    }
    
    return self;
}

- (void)nextPage
{
    [self fetchForum:self.pageId withPage:self.page+1];
}

-(void)fetchForum:(NSInteger)forumId withPage:(NSInteger)page
{
    NSURLRequest *request = [[API sharedInterface] getForumView:forumId page:page];
    [API getRequest:request completionBlockWithJSON:^(id JSON) {
        
        NSDictionary *response = [JSON objectForKey:@"response"];
        
        NSMutableArray *threads = [NSMutableArray new];
        for (NSDictionary *dict in [response objectForKey:@"threads"])
        {
            //"topicId": 150195,
            //"title": "Whataroo 2012!",
            //"authorId": 168713,
            //"authorName": "Steve096",
            //"locked": false,
            //"sticky": false,
            //"postCount": 552,
            //"lastID": 4148491,
            //"lastTime": "2012-08-08 15:03:18",
            //"lastAuthorId": 331548,
            //"lastAuthorName": "Isocline",
            //"lastReadPage": 0,
            //"lastReadPostId": 0,
            //"read": false
            
            WCDThread *thread = [[WCDThread alloc] init];
            thread.topicId = [[dict objectForKey:@"topicId"] integerValue];
            thread.title = [[dict objectForKey:@"title"] stringByDecodingHTMLEntities];
            thread.authorId = [[dict objectForKey:@"authorId"] integerValue];
            thread.authorName = [dict objectForKey:@"authorName"];
            thread.locked = [[dict objectForKey:@"locked"] boolValue];
            thread.sticky = [[dict objectForKey:@"sticky"] boolValue];
            thread.read = [[dict objectForKey:@"read"] boolValue];
            thread.postCount = [[dict objectForKey:@"postCount"] integerValue];
            thread.lastAuthorName = [dict objectForKey:@"lastAuthorName"];
            thread.lastTime = [dict objectForKey:@"lastTime"];
            thread.lastReadPage = [[dict objectForKey:@"lastReadPage"] integerValue];
            
            [threads addObject:thread];
        }
        
        [self receivedResults:threads pageTotal:[[response objectForKey:@"pages"] integerValue]];
        
    } failureBlockWithError:^(NSError *error) {
        
        [self failedWithError:error];
        
    }];
}

@end
