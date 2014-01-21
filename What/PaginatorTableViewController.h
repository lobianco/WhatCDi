//
//  SearchResultsController.h
//  What
//
//  Created by What on 7/26/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTableViewController.h"
#import "TorrentsPaginator.h"
#import "ForumListPaginator.h"
#import "SearchArtistsPaginator.h"
#import "SearchAlbumsPaginator.h"
#import "SearchUsersPaginator.h"
#import "InboxPaginator.h"

@interface PaginatorTableViewController : MainTableViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, NMPaginatorDelegate>

@property (nonatomic, strong) NMPaginator *paginator;

@end
