//
//  SearchArtistsPaginator.m
//  What
//
//  Created by What on 8/4/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "SearchArtistsPaginator.h"
#import "API.h"
#import "WCDArtist.h"
#import "NSString+HTML.h"

@interface SearchArtistsPaginator ()

@property (nonatomic, strong) NSString *searchTerm;

@end

@implementation SearchArtistsPaginator

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
    [self fetchArtistSearch:self.searchTerm withPage:self.page+1];
}

//TODO improve artist search
-(void)fetchArtistSearch:(NSString *)searchTerm withPage:(NSInteger)page
{
    NSURLRequest *request = [[API sharedInterface] getArtistSearch:searchTerm page:page];
    [API getRequest:request completionBlockWithJSON:^(id JSON) {
        
        NSDictionary *response = [JSON objectForKey:@"response"];
        
        NSMutableSet *lookup = [[NSMutableSet alloc] init];
        NSMutableArray *artistsArray = [NSMutableArray new];
        
        NSArray *results = [response objectForKey:@"results"];
        for (NSDictionary *result in results)
        {
            NSArray *torrents = [result objectForKey:@"torrents"];
            for (NSDictionary *torrent in torrents)
            {
                NSArray *artists = [torrent objectForKey:@"artists"];
                for (NSDictionary *artistDict in artists)
                {
                    NSString *identifier = [[artistDict objectForKey:@"name"] stringByDecodingHTMLEntities];
                    //NSLog(@"IDENTIFIER: %@", identifier);
                    if ([identifier rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != NSNotFound)
                    {
                        // this is very fast constant time lookup in a hash table
                        if (![lookup containsObject:identifier])
                        {
                            WCDArtist *artist = [[WCDArtist alloc] init];
                            artist.name = identifier;
                            artist.idNum = [[artistDict objectForKey:@"id"] integerValue];
                            
                            //artist hasn't been added
                            [lookup addObject:identifier];
                            [artistsArray addObject:artist];
                        }
                    }
                }
            }
        }
        
        //NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
        //NSArray *sortedArray = [artistsArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
        
        int totalPages = ceil(artistsArray.count / 50.0); //default number of results per page for artist search
        
        [self receivedResults:artistsArray pageTotal:totalPages];
        
    } failureBlockWithError:^(NSError *error) {
        
        [self failedWithError:error];
        
    }];
}

@end
