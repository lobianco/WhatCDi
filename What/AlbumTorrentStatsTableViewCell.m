//
//  AlbumTorrentStatsCell.m
//  What
//
//  Created by What on 7/27/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "AlbumTorrentStatsTableViewCell.h"
#import "NSString+Tools.h"

@interface AlbumTorrentStatsTableViewCell ()

@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) UILabel *seedersLabel;
@property (nonatomic, strong) UILabel *leechersLabel;
@property (nonatomic, strong) UILabel *snatchedLabel;
@property (nonatomic, strong) UILabel *logLabel;
@property (nonatomic, strong) UILabel *cueLabel;

//images
@property (nonatomic, strong) UIImageView *cellShadows;
@property (nonatomic, strong) UIImageView *seeders;
@property (nonatomic, strong) UIImageView *leechers;
@property (nonatomic, strong) UIImageView *snatches;
@property (nonatomic, strong) UIImageView *fileSize;
@property (nonatomic, strong) UIImageView *log;
@property (nonatomic, strong) UIImageView *cue;

@end

@implementation AlbumTorrentStatsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        if (!_cellShadows)
        {
            _cellShadows = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"../Images/albumStatsShadow.png"]];
            [self.contentView addSubview:_cellShadows];
        }
        
        //seeders
        if (!_seeders)
        {
            _seeders = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"../Images/seeders.png"]];
            [self.contentView addSubview:_seeders];
        }
        
        if (!_seedersLabel)
        {
            _seedersLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [_seedersLabel setTextColor:[UIColor colorFromHexString:@"e4e0db"]];
            [_seedersLabel setBackgroundColor:[UIColor clearColor]];
            [_seedersLabel setFont:[Constants appFontWithSize:FONT_SIZE_ALBUM_STATS]];
            [_seedersLabel setTextAlignment:NSTextAlignmentLeft];
            [self.contentView addSubview:_seedersLabel];
        }
        
        //leechers
        if (!_leechers)
        {
            _leechers = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"../Images/leechers.png"]];
            [self.contentView addSubview:_leechers];
        }
        
        if (!_leechersLabel)
        {
            _leechersLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [_leechersLabel setTextColor:[UIColor colorFromHexString:@"e4e0db"]];
            [_leechersLabel setBackgroundColor:[UIColor clearColor]];
            [_leechersLabel setFont:[Constants appFontWithSize:FONT_SIZE_ALBUM_STATS]];
            [_leechersLabel setTextAlignment:NSTextAlignmentLeft];
            [self.contentView addSubview:_leechersLabel];
        }
        
        
        //snatches
        if (!_snatches)
        {
            _snatches = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"../Images/snatches.png"]];
            [self.contentView addSubview:_snatches];
        }
        
        if (!_snatchedLabel)
        {
            _snatchedLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [_snatchedLabel setTextColor:[UIColor colorFromHexString:@"e4e0db"]];
            [_snatchedLabel setBackgroundColor:[UIColor clearColor]];
            [_snatchedLabel setFont:[Constants appFontWithSize:FONT_SIZE_ALBUM_STATS]];
            [_snatchedLabel setTextAlignment:NSTextAlignmentLeft];
            [self.contentView addSubview:_snatchedLabel];
        }
        
        //filesize
        if (!_fileSize)
        {
            _fileSize = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"../Images/filesize.png"]];
            [self.contentView addSubview:_fileSize];
        }
        
        if (!_sizeLabel)
        {
            _sizeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [_sizeLabel setTextColor:[UIColor colorFromHexString:@"e4e0db"]];
            [_sizeLabel setBackgroundColor:[UIColor clearColor]];
            [_sizeLabel setFont:[Constants appFontWithSize:FONT_SIZE_ALBUM_STATS]];
            [_sizeLabel setTextAlignment:NSTextAlignmentLeft];
            _sizeLabel.adjustsFontSizeToFitWidth = YES;
            [self.contentView addSubview:_sizeLabel];
        }
        
        //log
        if (!_log)
        {
            _log = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"../Images/log.png"]];
            [self.contentView addSubview:_log];
        }
        
        if (!_logLabel)
        {
            _logLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [_logLabel setTextColor:[UIColor colorFromHexString:@"e4e0db"]];
            [_logLabel setBackgroundColor:[UIColor clearColor]];
            [_logLabel setFont:[Constants appFontWithSize:FONT_SIZE_ALBUM_STATS]];
            [_logLabel setTextAlignment:NSTextAlignmentLeft];
            [self.contentView addSubview:_logLabel];
        }
        
        //cue
        if (!_cue)
        {
            _cue = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"../Images/cue.png"]];
            [self.contentView addSubview:_cue];
        }
        
        if (!_cueLabel)
        {
            _cueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [_cueLabel setTextColor:[UIColor colorFromHexString:@"e4e0db"]];
            [_cueLabel setBackgroundColor:[UIColor clearColor]];
            [_cueLabel setFont:[Constants appFontWithSize:FONT_SIZE_ALBUM_STATS]];
            [_cueLabel setTextAlignment:NSTextAlignmentLeft];
            [self.contentView addSubview:_cueLabel];
        }
        
    }
    return self;
}

-(void)setTorrent:(WCDTorrent *)torrent
{
    if (_torrent != torrent)
    {
        _torrent = torrent;
        
        NSString *size = [NSString formatFileSize:_torrent.size];
        [self.sizeLabel setText:size];
        
        NSString *seeders = [NSString stringWithFormat:@"%i", _torrent.seeders];
        [self.seedersLabel setText:seeders];
        
        NSString *leechers = [NSString stringWithFormat:@"%i", _torrent.leechers];
        [self.leechersLabel setText:leechers];
        
        NSString *snatches = [NSString stringWithFormat:@"%i", _torrent.snatches];
        [self.snatchedLabel setText:snatches];
        
        if (_torrent.hasLog)
        {
            NSString *log = [NSString stringWithFormat:@"%i%%", _torrent.logScore];
            [self.logLabel setText:log];
            //[self.log setImage:[UIImage imageNamed:@"../Images/log.png"]];
        }
        else
        {
            [self.logLabel setText:@"0%"];
            //[self.log setImage:[UIImage imageNamed:@"../Images/noLog.png"]];
        }
        
        
        //cue
        NSString *cue = [NSString stringWithFormat:@"Cue"];
        [self.cueLabel setText:cue];
        if (_torrent.hasCue)
            [self.cue setImage:[UIImage imageNamed:@"../Images/cue.png"]];
        
        else
            [self.cue setImage:[UIImage imageNamed:@"../Images/noCue.png"]];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.cellShadows.frame = CGRectMake(0, self.frame.size.height - self.cellShadows.image.size.height, self.cellShadows.image.size.width, self.cellShadows.image.size.height);
    
    
    //CGFloat labelHeight = [self.seedersLabel.text sizeWithFont:self.seedersLabel.font constrainedToSize:CGSizeMake((self.frame.size.width - CELL_PADDING*2)/6, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
    CGFloat labelHeight = self.seeders.frame.size.height;
    CGFloat labelPadding = 4.f;
    CGFloat labelY = self.seeders.frame.origin.y;
    
    //seeders
    self.seeders.frame = CGRectMake(CELL_PADDING, self.cellShadows.frame.origin.y + 6.f, self.seeders.image.size.width, self.seeders.image.size.height);
    self.seedersLabel.frame = CGRectMake(self.seeders.frame.origin.x + self.seeders.frame.size.width + labelPadding, labelY, ((self.frame.size.width - CELL_PADDING*2) / 6) - self.seeders.image.size.width - labelPadding, labelHeight);
    
    //leechers
    self.leechers.frame = CGRectMake(CELL_PADDING + (self.frame.size.width/6), self.seeders.frame.origin.y, self.leechers.image.size.width, self.leechers.image.size.height);
    self.leechersLabel.frame = CGRectMake(self.leechers.frame.origin.x + self.leechers.frame.size.width + labelPadding, labelY, ((self.frame.size.width - CELL_PADDING*2) / 6) - self.leechers.image.size.width - labelPadding, labelHeight);
    
    //snatches
    self.snatches.frame = CGRectMake(CELL_PADDING + ((self.frame.size.width/6)*2), self.seeders.frame.origin.y, self.snatches.image.size.width, self.snatches.image.size.height);
    self.snatchedLabel.frame = CGRectMake(self.snatches.frame.origin.x + self.snatches.frame.size.width + labelPadding, labelY, ((self.frame.size.width - CELL_PADDING*2) / 6) - self.snatches.image.size.width - labelPadding, labelHeight);
    
    //size
    self.fileSize.frame = CGRectMake(CELL_PADDING + ((self.frame.size.width/6)*3), self.seeders.frame.origin.y, self.fileSize.image.size.width, self.fileSize.image.size.height);
    self.sizeLabel.frame = CGRectMake(self.fileSize.frame.origin.x + self.fileSize.frame.size.width + labelPadding, labelY, ((self.frame.size.width - CELL_PADDING*2) / 6) - self.fileSize.image.size.width - labelPadding, labelHeight);
    
    //log
    self.log.frame = CGRectMake(CELL_PADDING + ((self.frame.size.width/6)*4), self.seeders.frame.origin.y, self.log.image.size.width, self.log.image.size.height);
    self.logLabel.frame = CGRectMake(self.log.frame.origin.x + self.log.frame.size.width + labelPadding, labelY, ((self.frame.size.width - CELL_PADDING*2) / 6) - self.log.image.size.width - labelPadding, labelHeight);
    
    //cue
    self.cue.frame = CGRectMake(CELL_PADDING + ((self.frame.size.width/6)*5), self.seeders.frame.origin.y, self.cue.image.size.width, self.cue.image.size.height);
    self.cueLabel.frame = CGRectMake(self.cue.frame.origin.x + self.cue.frame.size.width + labelPadding, labelY, ((self.frame.size.width - CELL_PADDING*2) / 6) - self.cue.image.size.width - labelPadding, labelHeight);
}

+(CGFloat)heightForRow
{
    return [UIImage imageNamed:@"../Images/albumStatsShadow.png"].size.height;
}

@end
