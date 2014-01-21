//
//  SearchResultsPaginator.m
//  What
//
//  Created by What on 7/26/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "TorrentsPaginator.h"
#import "API.h"
#import "WCDAlbum.h"
#import "NSString+HTML.h"

@implementation TorrentsPaginator

- (void)nextPage
{
    [self fetchTorrentsWithPage:self.page+1];
}

-(void)fetchTorrentsWithPage:(NSInteger)page
{
    NSURLRequest *request = [[API sharedInterface] getRecentTorrentsForPage:page];
    [API getRequest:request completionBlockWithJSON:^(id JSON) {
        
        NSDictionary *response = [JSON objectForKey:@"response"];
        
        NSMutableArray *albumsArray = [NSMutableArray new];
        NSArray *results = [response objectForKey:@"results"];
        for (NSDictionary *result in results)
        {
            if ([result objectForKey:@"category"] == nil) //this limits search to only music
            {
                WCDAlbum *album = [[WCDAlbum alloc] init];
                album.name = [[result objectForKey:@"groupName"] stringByDecodingHTMLEntities];
                album.idNum = [[result objectForKey:@"groupId"] integerValue];
                album.artist = [result objectForKey:@"artist"];
                album.imageURL = [NSURL URLWithString:[result objectForKey:@"cover"]];
                album.releaseTypeString = [result objectForKey:@"releaseType"];
                
                [albumsArray addObject:album];
            }
        }
        
        [self receivedResults:albumsArray pageTotal:[[response objectForKey:@"pages"] integerValue]];
        
    } failureBlockWithError:^(NSError *error) {
        
        [self failedWithError:error];
        
    }];
}

@end
