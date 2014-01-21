//
//  SearchArtistCell.m
//  What
//
//  Created by What on 7/25/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "SearchArtistTableViewCell.h"
#import "UIColor+Tools.h"

@interface SearchArtistTableViewCell ()

@property (nonatomic, strong) UILabel *artistName;

@end

@implementation SearchArtistTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        if (!_artistName)
        {
            _artistName = [[UILabel alloc] initWithFrame:CGRectZero];
            _artistName.backgroundColor = [UIColor clearColor];
            _artistName.font = [Constants appFontWithSize:FONT_SIZE_TITLE bolded:YES];
            _artistName.textColor = [UIColor colorFromHexString:cCellFontDarkColor];
            [self.contentView addSubview:_artistName];
        }
        
    }
    return self;
}

-(void)setArtist:(WCDArtist *)newArtist
{
    if (_artist != newArtist)
    {
        
        _artist = newArtist;
        self.artistName.text = _artist.name;
        
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.artistName.frame = CGRectMake(CELL_PADDING, 0, self.frame.size.width - CELL_PADDING*2, self.frame.size.height);
}

+(CGFloat)heightForRow
{
    return 44.f;
}

@end
