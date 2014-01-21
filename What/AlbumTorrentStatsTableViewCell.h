//
//  AlbumTorrentStatsCell.h
//  What
//
//  Created by What on 7/27/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCDTorrent.h"

@interface AlbumTorrentStatsTableViewCell : UITableViewCell

@property (nonatomic, strong) WCDTorrent *torrent;

+(CGFloat)heightForRow;

@end
