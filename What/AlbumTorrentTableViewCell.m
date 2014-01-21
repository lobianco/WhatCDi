//
//  AlbumTorrentFileCell.m
//  What
//
//  Created by What on 5/28/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "AlbumTorrentTableViewCell.h"
#import "NSString+Tools.h"
#import "NSDate+Tools.h"

@interface AlbumTorrentTableViewCell ()

@property (nonatomic, strong) UILabel *torrentLabel;
@property (nonatomic, strong) UILabel *uploaderLabel;
@property (nonatomic, strong) UIImageView *bannerView;

@end

@implementation AlbumTorrentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.accessoryView = nil;
        
        if (!_torrentLabel)
        {
            _torrentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [_torrentLabel setBackgroundColor:[UIColor clearColor]];
            [_torrentLabel setTextColor:[UIColor colorFromHexString:cCellFontDarkColor]];
            [_torrentLabel setFont:[Constants appFontWithSize:FONT_SIZE_ALBUM_TITLE bolded:YES]];
            _torrentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            _torrentLabel.numberOfLines = 1;
            [self.contentView addSubview:_torrentLabel];
        }
        
        if (!_uploaderLabel)
        {
            _uploaderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [_uploaderLabel setBackgroundColor:[UIColor clearColor]];
            [_uploaderLabel setTextColor:[UIColor colorFromHexString:cCellFontMediumColor]];
            [_uploaderLabel setFont:[Constants appFontWithSize:FONT_SIZE_ALBUM_SUBTITLE bolded:NO]];
            _uploaderLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            _uploaderLabel.numberOfLines = 1;
            [self.contentView addSubview:_uploaderLabel];
        }
        
        if (!_downloadButton)
        {
            _downloadButton = [[AlbumTorrentDownloadButton alloc] init];
            [self.contentView addSubview:_downloadButton];
        }
        
        if (!_bannerView) {
            UIImage *freeleechImage = [UIImage imageNamed:@"../Images/freeleechBanner.png"];
            _bannerView = [[UIImageView alloc] initWithImage:freeleechImage];
            [self.contentView addSubview:_bannerView];
            _bannerView.hidden = YES;
        }
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat torrentWidth = self.frame.size.width - CELL_PADDING*2;
    CGSize torrentSize = [self.torrentLabel sizeThatFits:CGSizeMake(torrentWidth, CGFLOAT_MAX)];
    self.torrentLabel.frame = CGRectMake(CELL_PADDING, CELL_PADDING, torrentWidth, torrentSize.height);
    
    CGSize uploaderSize = [self.uploaderLabel sizeThatFits:CGSizeMake(torrentWidth, CGFLOAT_MAX)];
    self.uploaderLabel.frame = CGRectMake(CELL_PADDING, self.torrentLabel.frame.origin.y + self.torrentLabel.frame.size.height, torrentWidth, uploaderSize.height);
    
    if (!self.bannerView.hidden) {
        [self.bannerView setFrame:CGRectMake(self.frame.size.width - self.bannerView.image.size.width, 1, self.bannerView.image.size.width, self.bannerView.image.size.height)];
        self.downloadButton.frame = CGRectMake(CELL_WIDTH - [self.downloadButton buttonHeight] - CELL_PADDING*3, (self.frame.size.height/2) - ([self.downloadButton buttonHeight]/2), [self.downloadButton buttonHeight], [self.downloadButton buttonHeight]);
    } else {
        self.downloadButton.frame = CGRectMake(CELL_WIDTH - [self.downloadButton buttonHeight] - CELL_PADDING, (self.frame.size.height/2) - ([self.downloadButton buttonHeight]/2), [self.downloadButton buttonHeight], [self.downloadButton buttonHeight]);
    }
}


-(void)setTorrent:(WCDTorrent *)torrent
{
    if (_torrent != torrent) {
        _torrent = torrent;
        
        NSMutableString *torrentString = [NSMutableString stringWithFormat:@"%@ / %@", torrent.format, torrent.encoding];
        if (torrent.scene)
            [torrentString appendString:@" / Scene"];
        
        //set labels
        [self.torrentLabel setText:torrentString];
        [self.uploaderLabel setText:[NSString stringWithFormat:@"Uploaded by %@ %@", torrent.username, [NSDate relativeDateFromDateString:torrent.time]]];
        self.bannerView.hidden = !torrent.freeTorrent;
        
        self.downloadButton.torrent = _torrent;
    }
    
    else
        DebugLog(@"ERROR: Already equal!");
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [self.downloadButton setHighlighted:NO];
}

+(CGFloat)heightForRowWithLabel:(NSString *)label andSubtitle:(NSString *)subtitle
{
    CGFloat constrictWidth = CELL_WIDTH - CELL_PADDING*2;
    
    CGSize torrentSize = [label sizeWithFont:[Constants appFontWithSize:FONT_SIZE_ALBUM_TITLE bolded:YES] constrainedToSize:CGSizeMake(constrictWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGSize uploaderSize = [subtitle sizeWithFont:[Constants appFontWithSize:FONT_SIZE_FORUM_SUBTITLE bolded:NO] constrainedToSize:CGSizeMake(constrictWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByTruncatingTail];
    
    return (torrentSize.height + uploaderSize.height + CELL_PADDING*2);
}

@end
