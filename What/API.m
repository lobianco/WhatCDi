//
//  API.m
//  What
//
//  Created by What on 4/28/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "API.h"
#import "JSONRequestSingleton.h"
#import "HTTPRequestSingleton.h"
#import "MusicBrainzSingleton.h"
#import "GoogleSingleton.h"
#import "EANDataSingleton.h"
#import "DiscogsSingleton.h"
#import "UserSingleton.h"
#import "AppDelegate.h"


@implementation API

+ (API *)sharedInterface
{
    static API * _sharedInterface = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInterface = [[API alloc] init];
    });
    
    return _sharedInterface;
}


# pragma mark - Barcode Searching

-(NSURLRequest *)searchMusicBrainzWithBarcode:(NSString *)barcode
{
    //barcode = @"638592008120";
    NSURLRequest *request = [[MusicBrainzSingleton sharedClient] requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/ws/2/release/?query=barcode:%@&fmt=json", barcode] parameters:nil];
    
    return request;
}

-(NSURLRequest *)searchDiscogsWithBarcode:(NSString *)barcode
{
    //barcode = @"4015121101921";
    NSURLRequest *request = [[DiscogsSingleton sharedClient] requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/database/search?q=%@&type=release", barcode] parameters:nil];
    
    return request;
}

/*
-(NSURLRequest *)searchEANDataWithBarcode:(NSString *)barcode
{
    //barcode = @"724383668922";
    NSURLRequest *request = [[EANDataSingleton sharedClient] requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/lookup/%@", barcode] parameters:nil];
    
    return request;
}

-(NSURLRequest *)searchGoogleWithBarcode:(NSString *)barcode
{
    //barcode = @"724383668922";
    NSURLRequest *request = [[GoogleSingleton sharedClient] requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/shopping/search/v1/public/products?country=US&q=%@&restrictBy=gtin=%@&key=%@&alt=json", barcode, barcode, GOOGLE_KEY] parameters:nil];
    
    return request;
}
 */

# pragma mark - GET methods

-(NSURLRequest *)createGETRequestWithParams:(NSDictionary *)params
{
    return [[JSONRequestSingleton sharedClient] requestWithMethod:@"GET" path:@"/ajax.php?" parameters:params];
}

-(NSURLRequest *)getIndex
{
    NSArray *objects = @[@"index"];
    NSArray *keys = @[@"action"];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSURLRequest *request = [self createGETRequestWithParams:params];
    
    return request;
}

-(NSURLRequest *)getAnnouncements
{
    NSArray *objects = @[@"announcements"];
    NSArray *keys = @[@"action"];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSURLRequest *request = [self createGETRequestWithParams:params];
    
    return request;
}

-(NSURLRequest *)getInboxPage:(NSInteger)page type:(NSString *)type sort:(NSString *)sort search:(NSString *)search searchtype:(NSString *)searchtype;
{    
    NSArray *objects = @[@"inbox", [NSString stringWithFormat:@"%i", page], type, sort, search, searchtype];
    NSArray *keys = @[@"action", @"page", @"type", @"sort", @"search", @"searchtype"];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSURLRequest *request = [self createGETRequestWithParams:params];
    
    return request;
}

-(NSURLRequest *)getInboxConversation:(NSString *)convo
{
    NSArray *objects = @[@"inbox", @"viewconv", convo];
    NSArray *keys = @[@"action", @"type", @"id"];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSURLRequest *request = [self createGETRequestWithParams:params];
    
    return request;
}

-(NSURLRequest *)getUserInfo:(NSInteger)userId
{
    NSArray *objects = @[@"user", [NSString stringWithFormat:@"%i",userId]];
    NSArray *keys = @[@"action", @"id"];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSURLRequest *request = [self createGETRequestWithParams:params];
    
    return request;
}

-(NSURLRequest *)getUserRecents:(NSString *)userId
{
    NSArray *objects = @[@"user_recents", userId, @"25"];
    NSArray *keys = @[@"action", @"userid", @"limit"];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSURLRequest *request = [self createGETRequestWithParams:params];
    
    return request;
}

-(NSURLRequest *)getArtistInfo:(NSString *)artistId
{
    NSArray *objects = @[@"artist", artistId, @"1"];
    NSArray *keys = @[@"action", @"id", @"artistreleases"];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSURLRequest *request = [self createGETRequestWithParams:params];
    
    NSLog(@"%@", request.URL);
    
    return request;
}

-(NSURLRequest *)getArtistSearch:(NSString *)searchTerm page:(NSInteger)page
{
    NSArray *objects = @[@"browse", searchTerm, [NSString stringWithFormat:@"%i", page]];
    NSArray *keys = @[@"action", @"artistname", @"page"];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        
    NSURLRequest *request = [self createGETRequestWithParams:params];
    
    return request;
}

-(NSURLRequest *)getUserSearch:(NSString *)searchTerm page:(NSUInteger)page;
{     
    NSArray *objects = @[@"usersearch", searchTerm, [NSString stringWithFormat:@"%i", page]];
    NSArray *keys = @[@"action", @"search", @"page"];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSURLRequest *request = [self createGETRequestWithParams:params];
    
    return request;
}

-(NSURLRequest *)getAlbumSearch:(NSString *)searchTerm page:(NSInteger)page
{
    NSArray *objects = @[@"browse", searchTerm, [NSString stringWithFormat:@"%i", page]];
    NSArray *keys = @[@"action", @"groupname", @"page"];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSURLRequest *request = [self createGETRequestWithParams:params];
    
    return request;
}

-(NSURLRequest *)getRecentTorrentsForPage:(NSInteger)page
{
    NSArray *objects = @[@"browse", [NSString stringWithFormat:@"%i", page]];
    NSArray *keys = @[@"action", @"page"];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSURLRequest *request = [self createGETRequestWithParams:params];
    
    return request;
}

-(NSURLRequest *)getTorrentInfo:(NSString *)torrentID
{
    NSArray *objects = @[@"torrentgroup", torrentID];
    NSArray *keys = @[@"action", @"id"];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSURLRequest *request = [self createGETRequestWithParams:params];
    
    return request;
}


-(NSURLRequest *)getForumCategoryView
{
    NSArray *objects = @[@"forum", @"main"];
    NSArray *keys = @[@"action", @"type"];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSURLRequest *request = [self createGETRequestWithParams:params];
    
    return request;
}

-(NSURLRequest *)getForumView:(NSInteger)Id page:(NSInteger)page
{
    NSArray *objects = @[@"forum", @"viewforum", [NSString stringWithFormat:@"%i", Id], [NSString stringWithFormat:@"%i", page]];
    NSArray *keys = @[@"action", @"type", @"forumid", @"page"];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSURLRequest *request = [self createGETRequestWithParams:params];
    
    return request;
}

-(NSURLRequest *)getForumThreadView:(NSString *)threadId postId:(NSString *)postId page:(NSString *)page
{
    NSArray *objects = @[@"forum", @"viewthread", threadId, postId, page];
    NSArray *keys = @[@"action", @"type", @"threadid", @"postid", @"page"];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSURLRequest *request = [self createGETRequestWithParams:params];
    
    return request;
}

# pragma mark - POST methods

-(NSURLRequest *)createHTTPPOSTRequestWithParams:(NSDictionary *)params path:(NSString *)path
{
    return [[HTTPRequestSingleton sharedClient] requestWithMethod:@"POST" path:path parameters:params];
}

-(NSURLRequest *)postInboxMessageReply:(NSString *)body withConversationId:(NSInteger)convoId toUser:(NSInteger)userId
{
    NSArray *objects = @[@"takecompose", [UserSingleton sharedInstance].authkey, [NSString stringWithFormat:@"%i",userId], [NSString stringWithFormat:@"%i",convoId], body];
    NSArray *keys = @[@"action", @"auth", @"toid", @"convid", @"body"];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSLog(@"%@", params);
    
    NSURLRequest *request = [self createHTTPPOSTRequestWithParams:params path:@"/inbox.php?"];
    
    return request;
}

-(NSURLRequest *)postForumThreadReply:(NSString *)body threadId:(NSInteger)threadId
{
    NSArray *objects = @[@"reply", [UserSingleton sharedInstance].authkey, [NSString stringWithFormat:@"%i",threadId], body];
    NSArray *keys = @[@"action", @"auth", @"thread", @"body"];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSLog(@"%@", params);
    
    NSURLRequest *request = [self createHTTPPOSTRequestWithParams:params path:@"/forums.php?"];
    
    return request;
}


# pragma mark - Send Request

+(void)getRequest:(NSURLRequest *)request completionBlockWithJSON:(void (^)(NSDictionary *))completion failureBlockWithError:(void (^)(NSError *))failure
{
    NSLog(@"url: %@", request.URL);
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                
        if ([[JSON valueForKey:@"status"] isEqualToString:@"success"]) {
            completion(JSON);
        }
        
        else {
            NSLog(@"request failure");
            completion(nil);
            
            [self postNotificationFromError:nil];
        }
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"get request error: %@", [error localizedDescription]);
        
        [self postNotificationFromError:error];
        
        failure(error);
        
    }];
    
    [[[JSONRequestSingleton sharedClient] operationQueue] addOperation:operation];
}

+(void)postRequest:(NSURLRequest *)request completionBlockWithResponse:(void (^)(NSDictionary *))completion failureBlockWithError:(void (^)(NSError *))failure
{
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"response URL: %@", operation.response.URL);
        NSLog(@"status: %i", operation.response.statusCode);
        NSLog(@"headers: %@", operation.response.allHeaderFields);
        
        if (operation.response.statusCode == 0)
            completion(nil);
        else
            completion(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"post error: %@", error);
        NSLog(@"response: %@", operation.response);
        
        [self postNotificationFromError:error];
        
        failure(error);
    }];
    
    [[[HTTPRequestSingleton sharedClient] operationQueue] addOperation:operation];

}


#pragma mark - Barcode Lookup

+(void)musicBrainzSearchRequest:(NSURLRequest *)request completionBlockWithResults:(void (^)(NSDictionary *))completion
{
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        if ([[JSON objectForKey:@"count"] intValue] > 0)
            completion(JSON);
        
        else
            completion(nil);
            
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"musicbrainz error");
        completion(nil);
        
    }];
    
    [[[MusicBrainzSingleton sharedClient] operationQueue] addOperation:operation];
}

+(void)discogsSearchRequest:(NSURLRequest *)request completionBlockWithResults:(void (^)(NSDictionary *))completion
{
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        if ([[JSON objectForKey:@"results"] count] > 0)
            completion(JSON);
        
        else
            completion(nil);
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"discogs request error");
        completion(nil);
        
    }];
    
    [[[DiscogsSingleton sharedClient] operationQueue] addOperation:operation];
}

/*
+(void)eanSearchRequest:(NSURLRequest *)request completionBlockWithResults:(void (^)(NSDictionary *))completion
{
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        if ([[[JSON objectForKey:@"status"] objectForKey:@"code"] intValue] == 200)
            completion(JSON);
        
        else
            completion(nil);
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"EAN request error");
        
    }];
    
    [[[EANDataSingleton sharedClient] operationQueue] addOperation:operation];
}

+(void)googleSearchRequest:(NSURLRequest *)request completionBlockWithResults:(void (^)(NSDictionary *))completion
{
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        if ([[JSON objectForKey:@"count"] intValue] > 0)
            completion(JSON);
        
        else
            completion(nil);
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"Google request error");
        
    }];
    
    [[[GoogleSingleton sharedClient] operationQueue] addOperation:operation];
}
 */

# pragma mark - Error Handling

+ (void)postNotificationFromError:(NSError *)error
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showFailureAlertBannerWithError:error ? error : nil];
    //[[NSNotificationCenter defaultCenter] postNotificationName:kNetworkRequestFailedNotification object:error ? error : nil];
}

@end
