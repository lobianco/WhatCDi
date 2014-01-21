//
//  SearchCategoryCell.h
//  What
//
//  Created by What on 6/7/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchTableViewCell.h"

typedef enum {
    ArtistCellType,
    UserCellType,
    AlbumCellType
} CellType;

@interface SearchCategoryTableViewCell : SearchTableViewCell

//@property (nonatomic, strong) UIImageView *image;

-(void)setCellType:(CellType)type;
-(void)appendText:(NSString *)text;

@end
