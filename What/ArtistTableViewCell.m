//
//  ArtistAlbumCell.m
//  What
//
//  Created by What on 6/15/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "ArtistTableViewCell.h"
#import "LoadingView.h"
#import "NSString+HTML.h"

@interface ArtistTableViewCell ()

@property (nonatomic, strong) UIImageView *albumImage;

@end

@implementation ArtistTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        if (!_albumImage)
        {
            _albumImage = [[UIImageView alloc] initWithFrame:CGRectZero];
            [_albumImage setImage:[LoadingImages defaultAlbumImageWithWidth:ALBUM_IMAGE_HEIGHT]];
            [_albumImage setContentMode:UIViewContentModeScaleAspectFill];
            [_albumImage setClipsToBounds:YES];
            _albumImage.layer.masksToBounds = YES;
            _albumImage.layer.borderColor = [[UIColor colorFromHexString:cCellFontDarkColor] CGColor];
            _albumImage.layer.borderWidth = 1.f;
            _albumImage.userInteractionEnabled = YES;
            
            [self.contentView addSubview:_albumImage];
            
        }
        
        if (!_albumNameLabel)
        {
            _albumNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [_albumNameLabel setBackgroundColor:[Constants debug] ? [UIColor greenColor] : [UIColor clearColor]];
            [_albumNameLabel setFont:[Constants appFontWithSize:FONT_SIZE_ALBUM_TITLE bolded:YES]];
            [_albumNameLabel setNumberOfLines:1];
            [_albumNameLabel setLineBreakMode:NSLineBreakByTruncatingTail];
            [_albumNameLabel setTextColor:[UIColor colorFromHexString:cCellFontDarkColor]];
            [self.contentView addSubview:_albumNameLabel];
        }
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.albumImage setFrame:CGRectMake(CELL_PADDING, CELL_PADDING, ALBUM_IMAGE_HEIGHT, ALBUM_IMAGE_HEIGHT)];
    
    //album name
    CGFloat nameOriginX = CELL_PADDING*2 + ALBUM_IMAGE_HEIGHT;
    [self.albumNameLabel setFrame:CGRectMake(nameOriginX, CELL_PADDING, self.frame.size.width - nameOriginX - ACCESSORY_WIDTH - CELL_PADDING*2, 0)];
    [self.albumNameLabel sizeToFit];
    
    CGRect nameFrame = self.albumNameLabel.frame;
    nameFrame.size.width = self.frame.size.width - nameOriginX - ACCESSORY_WIDTH - CELL_PADDING*2;
    self.albumNameLabel.frame = nameFrame;
    
}

-(void)setAlbum:(WCDAlbum *)newAlbum
{
    if (_album != newAlbum)
    {
        _album = newAlbum;
        
        self.albumNameLabel.text = [_album.name stringByDecodingHTMLEntities];
        [self setAlbumImageWithURL:_album.imageURL];
        
        //[self setNeedsLayout];
    }
    
    else
        DebugLog(@"ERROR: Already equal!");
}

-(void)setAlbumImageWithURL:(NSURL *)url
{
    if ([[url absoluteString] length] > 0)
    {
        __weak ArtistTableViewCell *weakImage = self;
        [self.albumImage setImageWithURLRequest:[NSURLRequest requestWithURL:url] placeholderImage:[LoadingImages defaultLoadingAlbumImageWithWidth:ALBUM_IMAGE_HEIGHT] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            
            UIImage *resizedImage = [UIImage resizeImage:image newSize:CGSizeMake(ALBUM_IMAGE_HEIGHT, ALBUM_IMAGE_HEIGHT) contentMode:weakImage.albumImage.contentMode];
            [weakImage.albumImage setImage:resizedImage];
                
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
            NSLog(@"couldnt load album image");
            [weakImage.albumImage setImage:[LoadingImages defaultAlbumImageWithWidth:ALBUM_IMAGE_HEIGHT]];
            
        }];
        
    }
    
    else
    {
        [self.albumImage setImage:[LoadingImages defaultAlbumImageWithWidth:ALBUM_IMAGE_HEIGHT]];
    }

}

+(CGFloat)heightForAlbumCell
{
    /*
    float nameOriginX = CELL_PADDING*2 + ALBUM_IMAGE_HEIGHT;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(nameOriginX, CELL_PADDING, CELL_WIDTH - nameOriginX - CELL_PADDING, 0)];
    [label setFont:[Constants appFontWithSize:FORUM_CATEGORY_FONT_SIZE bolded:YES]];
    [label setNumberOfLines:1];
    [label setLineBreakMode:NSLineBreakByTruncatingTail];
    [label setText:text];
    [label sizeToFit];
    */
    
    return (ALBUM_IMAGE_HEIGHT + CELL_PADDING*2);
}

@end
