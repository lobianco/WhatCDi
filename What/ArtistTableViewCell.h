//
//  ArtistAlbumCell.h
//  What
//
//  Created by What on 6/15/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTableViewCell.h"
#import "WCDAlbum.h"

#define ALBUM_IMAGE_HEIGHT 50.f

@interface ArtistTableViewCell : MainTableViewCell

@property (nonatomic, strong) WCDAlbum *album;
@property (nonatomic, strong) UILabel *albumNameLabel;

+(CGFloat)heightForAlbumCell;

@end
