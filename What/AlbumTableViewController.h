//
//  AlbumController.h
//  What
//
//  Created by What on 5/28/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTableViewController.h"
#import "WCDAlbum.h"

@interface AlbumTableViewController : MainTableViewController <UIGestureRecognizerDelegate>

- (id)initWithAlbum:(WCDAlbum *)album;

@end
