//
//  AlbumTorrentDownloadButton.m
//  What
//
//  Created by What on 7/28/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "AlbumTorrentDownloadButton.h"

@implementation AlbumTorrentDownloadButton

- (id)init
{
    self = [super init];
    if (self) {
        
        [self setBackgroundImage:[UIImage imageNamed:@"../Images/downloadButton.png"] forState:UIControlStateNormal];
        
        // Initialization code
    }
    return self;
}

-(CGFloat)buttonHeight
{
    return [UIImage imageNamed:@"../Images/downloadButton.png"].size.height;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
