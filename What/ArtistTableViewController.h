//
//  ArtistController.h
//  What
//
//  Created by What on 6/13/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTableViewController.h"
#import "WCDArtist.h"

@interface ArtistTableViewController : MainTableViewController

-(id)initWithArtist:(WCDArtist *)artist;

@end
