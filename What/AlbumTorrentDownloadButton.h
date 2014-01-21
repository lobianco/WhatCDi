//
//  AlbumTorrentDownloadButton.h
//  What
//
//  Created by What on 7/28/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCDTorrent.h"

@interface AlbumTorrentDownloadButton : UIButton

@property (nonatomic, strong) WCDTorrent *torrent;

-(CGFloat)buttonHeight;

@end
