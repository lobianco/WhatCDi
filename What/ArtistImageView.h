//
//  ArtistImageView.h
//  What
//
//  Created by What on 8/27/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArtistTableViewController.h"

@interface ArtistImageView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *fullSizedImage;

-(void)updateArtistImageWithURL:(NSURL *)url;

@end
