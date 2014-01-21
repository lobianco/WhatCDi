//
//  SearchAlbumsPaginator.m
//  What
//
//  Created by What on 8/4/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "SearchAlbumsPaginator.h"
#import "API.h"
#import "NSString+HTML.h"
#import "WCDAlbum.h"

@interface SearchAlbumsPaginator ()

@property (nonatomic, strong) NSString *searchTerm;

@end

@implementation SearchAlbumsPaginator

-(id)initWithDelegate:(id<NMPaginatorDelegate>)paginatorDelegate searchTerm:(NSString *)searchTerm
{
    if(self = [super initWithDelegate:paginatorDelegate])
    {        
        _searchTerm = searchTerm;
    }
    
    return self;
}

- (void)nextPage
{
    [self fetchAlbumSearch:self.searchTerm withPage:self.page+1];
}

-(void)fetchAlbumSearch:(NSString *)searchTerm withPage:(NSInteger)page
{
    NSURLRequest *request = [[API sharedInterface] getAlbumSearch:searchTerm page:page];
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
