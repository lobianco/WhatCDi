//
//  AlbumMainInfoHeader.h
//  What
//
//  Created by What on 5/29/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarqueeLabel.h"
#import "WCDAlbum.h"

#define ALBUM_WIDTH 80.f

#define ARTIST_FONT_SIZE 13.f
#define ALBUM_FONT_SIZE 16.f
#define RELEASED_FONT_SIZE 10.f

@interface AlbumTableHeaderView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, weak) WCDAlbum *album; //TODO weak??

- (UIImage *)fullSizedAlbumImage;

@end
