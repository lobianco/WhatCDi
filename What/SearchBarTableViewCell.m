//
//  SearchBarCell.m
//  What
//
//  Created by What on 6/7/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "SearchBarTableViewCell.h"

@implementation SearchBarTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (!_searchBar)
        {
            if ([Constants iOSVersion] < 7.0) {
                _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 20.f, self.frame.size.height)];
                [[_searchBar.subviews objectAtIndex:0] removeFromSuperview];
            }
            else {
                _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            }
            _searchBar.placeholder = @"Search What.CD";
            _searchBar.barTintColor = [UIColor lightGrayColor];
            [self.contentView addSubview:_searchBar];
        }
        
    }
    return self;
}

@end
