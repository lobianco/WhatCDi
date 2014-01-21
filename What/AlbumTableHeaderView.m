//
//  AlbumMainInfoHeader.m
//  What
//
//  Created by What on 5/29/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "AlbumTableHeaderView.h"
#import "LoadingView.h"
#import "MainCellGradientView.h"

@interface AlbumTableHeaderView () 

@property (nonatomic, strong) MainCellGradientView *gradientView;
@property (nonatomic, strong) UIImageView *albumView;
@property (nonatomic, strong) UIView *noise;
@property (nonatomic, strong) UIImage *fullSizedImage;
@property (nonatomic, strong) MarqueeLabel *albumLabel;
@property (nonatomic, strong) UILabel *artistLabel;
@property (nonatomic, strong) UILabel *releasedLabel;
@property (nonatomic, strong) UILabel *fileCountLabel;

@end

@implementation AlbumTableHeaderView

@synthesize albumLabel = albumLabel_;
@synthesize fullSizedImage = fullSizedImage_;
@synthesize artistLabel = artistLabel_;
@synthesize releasedLabel = releasedLabel_;
@synthesize fileCountLabel = fileCountLabel_;
@synthesize albumView = albumView_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        
        if (!_gradientView)
        {
            _gradientView = [[MainCellGradientView alloc] initWithFrame:frame];
            [self addSubview:_gradientView];
        }
        
        if (!_noise) {
            UIColor *pattern = [UIColor colorWithPatternImage:[UIImage noiseWithSixPercentAlpha]];
            _noise = [[UIView alloc] init];
            [_noise setBackgroundColor:pattern];
            [_noise setFrame:frame];
            [self addSubview:_noise];
        }
        
        if (!albumView_)
        {
            albumView_ = [[UIImageView alloc] initWithImage:[LoadingImages defaultAlbumImageWithWidth:ALBUM_WIDTH]];
            [albumView_ setFrame:CGRectMake(CELL_PADDING, CELL_PADDING, ALBUM_WIDTH, ALBUM_WIDTH)];
            albumView_.layer.masksToBounds = YES;
            albumView_.layer.borderColor = [[UIColor colorFromHexString:cCellFontDarkColor] CGColor];
            albumView_.layer.borderWidth = 1.f;
            albumView_.contentMode = UIViewContentModeScaleAspectFill;
            [self addSubview:albumView_];
            
        }
        
        CGFloat labelWidth = self.frame.size.width - CELL_PADDING*3 - albumView_.frame.size.width;
        
        if (!artistLabel_)
        {
            artistLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(albumView_.frame.origin.x + albumView_.frame.size.width + CELL_PADDING, albumView_.frame.origin.y + 28.f, labelWidth, ARTIST_FONT_SIZE)];
            [artistLabel_ setBackgroundColor:[UIColor clearColor]];
            [artistLabel_ setTextColor:[UIColor colorFromHexString:cCellFontDarkColor]];
            [artistLabel_ setFont:[Constants appFontWithSize:ARTIST_FONT_SIZE bolded:NO]];
            [self addSubview:artistLabel_];
        }
        
        if (!albumLabel_)
        {
            albumLabel_ = [[MarqueeLabel alloc] initWithFrame:CGRectMake(albumView_.frame.origin.x + albumView_.frame.size.width + CELL_PADDING, artistLabel_.frame.origin.y + artistLabel_.frame.size.height + 1.f, labelWidth, ALBUM_FONT_SIZE) rate:50.f andFadeLength:1.f];
            [albumLabel_ setContinuousMarqueeExtraBuffer:40.f];
            albumLabel_.font = [Constants appFontWithSize:ALBUM_FONT_SIZE bolded:YES];
            [albumLabel_ setMarqueeType:MLContinuous];
            [albumLabel_ setAnimationDelay:3.f];
            [albumLabel_ setAnimationCurve:UIViewAnimationOptionCurveEaseInOut];
            [albumLabel_ setBackgroundColor:[UIColor clearColor]];
            [albumLabel_ setTextColor:[UIColor colorFromHexString:cCellFontDarkColor]];
            [albumLabel_ setTextAlignment:NSTextAlignmentLeft];
            [self addSubview:albumLabel_];
        }
        
        if (!releasedLabel_)
        {
            releasedLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(albumView_.frame.origin.x + albumView_.frame.size.width + CELL_PADDING, albumLabel_.frame.origin.y + albumLabel_.frame.size.height + 1.f, labelWidth, RELEASED_FONT_SIZE)];
            [releasedLabel_ setBackgroundColor:[UIColor clearColor]];
            [releasedLabel_ setTextColor:[UIColor colorFromHexString:cCellFontMediumColor]];
            [releasedLabel_ setFont:[Constants appFontWithSize:RELEASED_FONT_SIZE bolded:YES]];
            [self addSubview:releasedLabel_];
        }
        
        if (!fileCountLabel_)
        {
            fileCountLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(albumView_.frame.origin.x + albumView_.frame.size.width + CELL_PADDING, releasedLabel_.frame.origin.y + releasedLabel_.frame.size.height + 1.f, labelWidth, RELEASED_FONT_SIZE)];
            [fileCountLabel_ setBackgroundColor:[UIColor clearColor]];
            [fileCountLabel_ setTextColor:[UIColor colorFromHexString:cCellFontMediumColor]];
            [fileCountLabel_ setFont:[Constants appFontWithSize:RELEASED_FONT_SIZE bolded:YES]];
            [self addSubview:fileCountLabel_];
        }
        
    }
    return self;
}

- (void)dealloc {
    NSLog(@"album table header dealloc");
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint touchPoint = [touch locationInView:self];
    if ([self hasAlbumImage] && CGRectContainsPoint(self.albumView.frame, touchPoint)) {
        return YES;
    }
    return NO;
}

-(void)setAlbum:(WCDAlbum *)newAlbum
{
    if (_album != newAlbum)
    {
        _album = newAlbum;
        
        [self setAlbumImageWithURL:_album.imageURL];
        [self.artistLabel setText:_album.artist];
        [self.albumLabel setText:_album.name];
        [self.releasedLabel setText:[NSString stringWithFormat:@"Released %i", _album.year]];
        
        NSString *release = ([[_album.torrentsDictionary allValues] count] != 1) ? @"releases" : @"release";
        [self.fileCountLabel setText:[NSString stringWithFormat:@"%u %@", [[_album.torrentsDictionary allValues] count], release]];
    }
    
    else
        DebugLog(@"ERROR: Already equal!");
}

-(void)setAlbumImageWithURL:(NSURL *)imageURL
{
    if ([[imageURL absoluteString] length] > 0)
    {
        
        //LoadingEllipsisView *loader = [LoadingEllipsisView staticLoaderWithFrame:CGRectMake(0, 0, ALBUM_WIDTH, ALBUM_WIDTH)];
        //[self.albumView addSubview:loader];
        //[loader showLoader];
        
        __weak AlbumTableHeaderView *weakHeader = self;
        [self.albumView setImageWithURLRequest:[NSURLRequest requestWithURL:imageURL] placeholderImage:[LoadingImages defaultLoadingAlbumImageWithWidth:ALBUM_WIDTH] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            UIImage *resizedImage = [UIImage resizeImage:image newSize:CGSizeMake(weakHeader.albumView.frame.size.width, weakHeader.albumView.frame.size.height) contentMode:weakHeader.albumView.contentMode];
            [weakHeader.albumView setImage:resizedImage];
            weakHeader.fullSizedImage = image;

        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
            NSLog(@"couldnt load album image");
            [weakHeader.albumView setImage:[LoadingImages defaultAlbumImageWithWidth:ALBUM_WIDTH]];
            weakHeader.fullSizedImage = [UIImage imageNamed:@"../Images/noAlbum.png"];
        }];
    }
    
    else
    {
        [self.albumView setImage:[LoadingImages defaultAlbumImageWithWidth:ALBUM_WIDTH]];
        self.fullSizedImage = [UIImage imageNamed:@"../Images/noAlbum.png"];
    }
    
}

-(UIImage *)fullSizedAlbumImage
{
    return self.fullSizedImage;
}

-(BOOL)hasAlbumImage
{
    return ([self fullSizedAlbumImage] != nil);
}

@end
