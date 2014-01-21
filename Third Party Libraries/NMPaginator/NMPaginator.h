//
//  NMPaginator.h
//
//  Created by Nicolas Mondollot on 07/04/12.
//

#import <Foundation/Foundation.h>

typedef enum {
    SearchTypeArtist,
    SearchTypeUser,
    SearchTypeAlbum,
    SearchTypeBrowseTorrents,
    SearchTypeForumList
} SearchType;

typedef enum {
    RequestStatusNone,
    RequestStatusInProgress,
    RequestStatusDone // request succeeded or failed
} RequestStatus;

@protocol NMPaginatorDelegate <NSObject>
@required
- (void)paginator:(id)paginator didReceiveResults:(NSArray *)results;
- (void)paginatorDidFailToRespond:(id)paginator;
@optional
- (void)paginatorDidReset:(id)paginator;
@end

@interface NMPaginator : NSObject

@property (nonatomic, weak) id<NMPaginatorDelegate> delegate;
//@property (assign, readwrite) NSInteger pageSize; // number of results per page
@property (assign, readonly) NSInteger page; // number of pages already fetched
@property (assign, readonly) NSInteger pageTotal; // total number of results
@property (assign, readonly) RequestStatus requestStatus;
@property (nonatomic, strong, readonly) NSMutableArray *results;

- (id)initWithDelegate:(id<NMPaginatorDelegate>)paginatorDelegate;

- (void)reset;
- (BOOL)reachedLastPage;

- (void)fetchFirstPage;
- (void)fetchNextPage;

// call these from subclass when you receive the results
- (void)receivedResults:(NSArray *)results pageTotal:(NSInteger)total;
- (void)failedWithError:(NSError *)error;

@end
