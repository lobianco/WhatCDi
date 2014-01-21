//
//  AlbumTorrentFileCell.h
//  What
//
//  Created by What on 5/28/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCDTorrent.h"
#import "MainTableViewCell.h"
#import "AlbumTorrentDownloadButton.h"

@interface AlbumTorrentTableViewCell : MainTableViewCell

@property (nonatomic, strong) WCDTorrent *torrent;
@property (nonatomic, strong) AlbumTorrentDownloadButton *downloadButton;

+(CGFloat)heightForRowWithLabel:(NSString *)label andSubtitle:(NSString *)subtitle;

@end
