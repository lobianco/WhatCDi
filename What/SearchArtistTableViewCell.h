//
//  SearchArtistCell.h
//  What
//
//  Created by What on 7/25/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "MainTableViewCell.h"
#import "WCDArtist.h"

@interface SearchArtistTableViewCell : MainTableViewCell

@property (nonatomic, strong) WCDArtist *artist;

+(CGFloat)heightForRow;

@end
