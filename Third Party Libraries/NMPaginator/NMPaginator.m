//
//  NMPaginator.m
//
//  Created by Nicolas Mondollot on 07/04/12.
//

#import "NMPaginator.h"
//#import "AppDelegate.h"

@interface NMPaginator() {
}

// protected properties
@property (assign, readwrite) NSInteger page; 
@property (assign, readwrite) NSInteger pageTotal;
@property (nonatomic, strong, readwrite) NSMutableArray *results;
@property (assign, readwrite) RequestStatus requestStatus;

@end

@implementation NMPaginator

-(id)initWithDelegate:(id<NMPaginatorDelegate>)paginatorDelegate
{
    if (self = [self init])
    {
        _delegate = paginatorDelegate;
    }
    return self;
}

-(id)init
{
    if (self = [super init])
    {
        [self setDefaultValues];
    }
    
    return self;
}

- (void)dealloc {
    NSLog(@"paginator dealloc");
    _results = nil;
    _delegate = nil;
}

- (void)setDefaultValues
{
    self.pageTotal = 0;
    self.page = 0;
    self.results = [NSMutableArray array];
    self.requestStatus = RequestStatusNone;
}

- (void)reset
{
    [self setDefaultValues];
    
    // send message to delegate
    if([self.delegate respondsToSelector:@selector(paginatorDidReset:)])
        [self.delegate paginatorDidReset:self];
}

- (BOOL)reachedLastPage
{
    if(self.requestStatus == RequestStatusNone) return NO; // if we haven't made a request, we can't know for sure
    
    //NSInteger totalPages = ceil((float)self.total/(float)self.pageSize); // total number of pages
    return self.page >= self.pageTotal;
}

# pragma - fetch results

- (void)fetchFirstPage
{
    // reset paginator
    [self reset];
    [self fetchNextPage];
}

-(void)fetchNextPage
{
    // don't do anything if there's already a request in progress
    if(self.requestStatus == RequestStatusInProgress)
        return;
    
    if(![self reachedLastPage]) {
        self.requestStatus = RequestStatusInProgress;
        [self nextPage];
    }
}

-(void)nextPage
{
    NSAssert(NO, @"override me");
}

#pragma mark received results

// call these from subclass when you receive the results

- (void)receivedResults:(NSArray *)results pageTotal:(NSInteger)total;
{
    [self.results addObjectsFromArray:results];
    self.page++;
    self.pageTotal = total;
    self.requestStatus = RequestStatusDone;
    
    [self.delegate paginator:self didReceiveResults:results];
}

- (void)failedWithError:(NSError *)error
{
    self.requestStatus = RequestStatusDone;
    
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //[appDelegate showFailureAlertBannerWithError:error];
    
    [self.delegate paginatorDidFailToRespond:self];
}

@end
