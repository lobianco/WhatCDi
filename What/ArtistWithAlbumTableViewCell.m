//
//  ArtistAlbumCell.m
//  What
//
//  Created by What on 7/25/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "ArtistWithAlbumTableViewCell.h"
#import "NSString+HTML.h"

@interface ArtistWithAlbumTableViewCell ()

@property (nonatomic, strong) UILabel *albumTagsLabel;
@property (nonatomic, strong) UILabel *albumYearLabel;

@end

@implementation ArtistWithAlbumTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        if (!_albumYearLabel)
        {
            _albumYearLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [_albumYearLabel setNumberOfLines:1];
            [_albumYearLabel setFont:[Constants appFontWithSize:FONT_SIZE_ALBUM_SUBTITLE bolded:YES]];
            [_albumYearLabel setTextColor:[UIColor colorFromHexString:cCellFontMediumColor]];
            [_albumYearLabel setBackgroundColor:[UIColor clearColor]];
            [_albumYearLabel setLineBreakMode:NSLineBreakByTruncatingTail];
            [self.contentView addSubview:_albumYearLabel];
        }
        
        if (!_albumTagsLabel)
        {
            _albumTagsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [_albumTagsLabel setNumberOfLines:1];
            [_albumTagsLabel setFont:[Constants appFontWithSize:FONT_SIZE_ALBUM_TAGS oblique:YES]];
            [_albumTagsLabel setTextColor:[UIColor colorFromHexString:cCellFontMediumColor]];
            [_albumTagsLabel setBackgroundColor:[UIColor clearColor]];
            [_albumTagsLabel setLineBreakMode:NSLineBreakByTruncatingTail];
            [self.contentView addSubview:_albumTagsLabel];
        }
        
    }
    return self;
}

-(void)setAlbum:(WCDAlbum *)newAlbum
{
    [super setAlbum:newAlbum];
    
    self.albumYearLabel.text = [NSString stringWithFormat:@"%i", newAlbum.year];
    self.albumTagsLabel.text = [[[newAlbum.tags valueForKey:@"description"] componentsJoinedByString:@", "] stringByDecodingHTMLEntities];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
        
    //year label
    [self.albumYearLabel setFrame:CGRectMake(self.albumNameLabel.frame.origin.x, self.albumNameLabel.frame.origin.y + self.albumNameLabel.frame.size.height, self.frame.size.width - self.albumNameLabel.frame.origin.x - ACCESSORY_WIDTH - CELL_PADDING, 0)];
    [self.albumYearLabel sizeToFit];
    
    
    //tags
    CGFloat constrictWidth = CELL_WIDTH - self.albumNameLabel.frame.origin.x - ACCESSORY_WIDTH - CELL_PADDING*2;
    CGSize tagsSize = [self.albumTagsLabel sizeThatFits:CGSizeMake(constrictWidth, CGFLOAT_MAX)];
    [self.albumTagsLabel setFrame:CGRectMake(self.albumNameLabel.frame.origin.x, self.albumYearLabel.frame.origin.y + self.albumYearLabel.frame.size.height, constrictWidth, tagsSize.height)];
}

@end
