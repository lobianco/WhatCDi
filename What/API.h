//
//  API.h
//  What
//
//  Created by What on 4/28/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface API : NSObject

+ (API *)sharedInterface;

//Barcode Search
-(NSURLRequest *)searchMusicBrainzWithBarcode:(NSString *)barcode;
//-(NSURLRequest *)searchGoogleWithBarcode:(NSString *)barcode;
//-(NSURLRequest *)searchEANDataWithBarcode:(NSString *)barcode;
-(NSURLRequest *)searchDiscogsWithBarcode:(NSString *)barcode;

//GET requests
-(NSURLRequest *)getIndex;
-(NSURLRequest *)getAnnouncements;
-(NSURLRequest *)getInboxPage:(NSInteger)page type:(NSString *)type sort:(NSString *)sort search:(NSString *)search searchtype:(NSString *)searchtype;
-(NSURLRequest *)getInboxConversation:(NSString *)convo;
-(NSURLRequest *)getUserInfo:(NSInteger)userId;
-(NSURLRequest *)getUserRecents:(NSString *)userId;
-(NSURLRequest *)getArtistInfo:(NSString *)artist;
-(NSURLRequest *)getForumCategoryView;
-(NSURLRequest *)getForumView:(NSInteger)Id page:(NSInteger)page;
-(NSURLRequest *)getForumThreadView:(NSString *)threadId postId:(NSString *)postId page:(NSString *)page;
-(NSURLRequest *)getTorrentInfo:(NSString *)torrentID;
-(NSURLRequest *)getArtistSearch:(NSString *)searchTerm page:(NSInteger)page;
-(NSURLRequest *)getUserSearch:(NSString *)searchTerm page:(NSUInteger)page;
-(NSURLRequest *)getAlbumSearch:(NSString *)searchTerm page:(NSInteger)page;
-(NSURLRequest *)getRecentTorrentsForPage:(NSInteger)page;

//POST requests
-(NSURLRequest *)postInboxMessageReply:(NSString *)body withConversationId:(NSInteger)convoId toUser:(NSInteger)userId;
-(NSURLRequest *)postForumThreadReply:(NSString *)body threadId:(NSInteger)threadId;

//initiate operations
+(void)getRequest:(NSURLRequest *)request completionBlockWithJSON:(void(^)(NSDictionary *responseDict))completion failureBlockWithError:(void(^)(NSError *error))failure;
+(void)postRequest:(NSURLRequest *)request completionBlockWithResponse:(void(^)(NSDictionary *responseDict))completion failureBlockWithError:(void(^)(NSError *error))failure;

//search requests
+(void)musicBrainzSearchRequest:(NSURLRequest *)request completionBlockWithResults:(void(^)(NSDictionary *responseDict))completion;
+(void)discogsSearchRequest:(NSURLRequest *)request completionBlockWithResults:(void(^)(NSDictionary *responseDict))completion;
//+(void)eanSearchRequest:(NSURLRequest *)request completionBlockWithResults:(void(^)(NSDictionary *responseDict))completion;
//+(void)googleSearchRequest:(NSURLRequest *)request completionBlockWithResults:(void(^)(NSDictionary *responseDict))completion;

@end
