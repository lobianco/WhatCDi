//
//  SearchUsersPaginator.m
//  What
//
//  Created by What on 8/4/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "SearchUsersPaginator.h"
#import "API.h"
#import "WCDUser.h"
#import "NSString+HTML.h"

@interface SearchUsersPaginator ()

@property (nonatomic, strong) NSString *searchTerm;

@end

@implementation SearchUsersPaginator

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
    [self fetchUserSearch:self.searchTerm withPage:self.page+1];
}

-(void)fetchUserSearch:(NSString *)searchTerm withPage:(NSInteger)page
{
    NSURLRequest *request = [[API sharedInterface] getUserSearch:searchTerm page:page];
    [API getRequest:request completionBlockWithJSON:^(id JSON) {
        
        NSDictionary *response = [JSON objectForKey:@"response"];
        
        NSMutableArray *usersArray = [NSMutableArray new];
        NSArray *results = [response objectForKey:@"results"];
        for (NSDictionary *result in results)
        {
            WCDUser *user = [[WCDUser alloc] init];
            user.name = [[result objectForKey:@"username"] stringByDecodingHTMLEntities];
            user.idNum = [[result objectForKey:@"userId"] integerValue];
            user.donor = [[result objectForKey:@"donor"] boolValue];
            user.memberClass = [result objectForKey:@"class"];
            user.avatarURL = [NSURL URLWithString:[result objectForKey:@"avatar"]];
            user.warned = [[result objectForKey:@"warned"] boolValue];
            user.enabled = [[result objectForKey:@"enabled"] boolValue];
            
            [usersArray addObject:user];
        }
        
        [self receivedResults:usersArray pageTotal:[[response objectForKey:@"pages"] integerValue]];
        
    } failureBlockWithError:^(NSError *error) {
        
        [self failedWithError:error];
        
    }];
}

@end
