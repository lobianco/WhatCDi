//
//  ForumListPaginator.h
//  What
//
//  Created by What on 8/4/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "NMPaginator.h"

@interface ForumListPaginator : NMPaginator

-(id)initWithDelegate:(id<NMPaginatorDelegate>)paginatorDelegate pageId:(NSInteger)pageId;

@end
