//
//  SearchAlbumCell.m
//  What
//
//  Created by What on 7/25/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "SearchAlbumTableViewCell.h"
#import "NSString+HTML.h"

@interface SearchAlbumTableViewCell ()

@property (nonatomic, strong) UILabel *albumArtistLabel;
@property (nonatomic, strong) UILabel *albumReleaseTypeLabel;

@end

@implementation SearchAlbumTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        if (!_albumArtistLabel)
        {
            _albumArtistLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [_albumArtistLabel setNumberOfLines:1];
            [_albumArtistLabel setFont:[Constants appFontWithSize:FONT_SIZE_ALBUM_SUBTITLE bolded:YES]];
            [_albumArtistLabel setTextColor:[UIColor darkGrayColor]];
            [_albumArtistLabel setBackgroundColor:[UIColor clearColor]];
            [_albumArtistLabel setLineBreakMode:NSLineBreakByTruncatingTail];
            [self.contentView addSubview:_albumArtistLabel];
        }
        
        if (!_albumReleaseTypeLabel)
        {
            _albumReleaseTypeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [_albumReleaseTypeLabel setNumberOfLines:1];
            [_albumReleaseTypeLabel setFont:[Constants appFontWithSize:FONT_SIZE_ALBUM_TAGS oblique:YES]];
            [_albumReleaseTypeLabel setTextColor:[UIColor grayColor]];
            [_albumReleaseTypeLabel setBackgroundColor:[UIColor clearColor]];
            [_albumReleaseTypeLabel setLineBreakMode:NSLineBreakByTruncatingTail];
            [self.contentView addSubview:_albumReleaseTypeLabel];
        }
        
    }
    return self;
}

-(void)setAlbum:(WCDAlbum *)newAlbum
{
    [super setAlbum:newAlbum];
    
    self.albumArtistLabel.text = [newAlbum.artist stringByDecodingHTMLEntities];
    self.albumReleaseTypeLabel.text = newAlbum.releaseTypeString;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //artist label
    CGFloat constrictWidth = CELL_WIDTH - self.albumNameLabel.frame.origin.x - ACCESSORY_WIDTH - CELL_PADDING*2;
    CGSize artistLabelSize = [self.albumArtistLabel sizeThatFits:CGSizeMake(constrictWidth, CGFLOAT_MAX)];
    [self.albumArtistLabel setFrame:CGRectMake(self.albumNameLabel.frame.origin.x, self.albumNameLabel.frame.origin.y + self.albumNameLabel.frame.size.height, constrictWidth, artistLabelSize.height)];
    
    
    //release type label
    CGSize releaseTypeSize = [self.albumReleaseTypeLabel sizeThatFits:CGSizeMake(constrictWidth, CGFLOAT_MAX)];
    [self.albumReleaseTypeLabel setFrame:CGRectMake(self.albumNameLabel.frame.origin.x, self.albumArtistLabel.frame.origin.y + self.albumArtistLabel.frame.size.height, constrictWidth, releaseTypeSize.height)];
}

@end
