//
//  UserCarouselCell.m
//  What
//
//  Created by What on 6/21/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "ProfileCarouselCell.h"
//#import "iCarousel.h"
#import "AlbumTableViewController.h"

#define SWIPE_VIEW_WIDTH 100.f
#define ALBUM_WIDTH 80.f
 
@interface ProfileCarouselCell () <SwipeViewDataSource>


//@property (nonatomic, strong) NSMutableDictionary *imageCacheArray;
//@property (nonatomic, strong) NSArray *swipeItemURLs;
//@property (nonatomic, strong) NSMutableArray *swipeItemTitles;
//@property (nonatomic, strong) NSMutableArray *swipeItemArtists;
//@property (nonatomic, strong) NSMutableArray *swipeItemIds;

@end

@implementation ProfileCarouselCell 

//@synthesize swipeItemURLs = swipeItemURLs_;
//@synthesize swipeItemTitles = swipeItemTitles_;
//@synthesize swipeItemArtists = swipeItemArists_;
//@synthesize swipeItemIds = swipeItemIds_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.accessoryView = nil;
        self.backgroundColor = [UIColor colorFromHexString:cMenuTableBackgroundColor];

        if (!_swipeView)
        {
            _swipeView = [[SwipeView alloc] init];
            //[swipeView_ setBackgroundColor:[UIColor colorFromHexString:cMenuTableBackgroundColor]];
            [_swipeView setBackgroundColor:[UIColor clearColor]];
            _swipeView.dataSource = self;
            _swipeView.decelerationRate = 0.9935f; //0.994
            _swipeView.pagingEnabled = NO;
            //swipeView_.defersItemViewLoading = YES;
            [self.contentView addSubview:_swipeView];
        }
        
        //imageCacheArray_ = [NSMutableDictionary new];
                
    }
    return self;
}

- (void)dealloc {
    NSLog(@"carousel dealloc");
    
    _albums = nil;
    _swipeView.delegate = nil;
    [_swipeView removeFromSuperview];
    _swipeView = nil;
}

-(void)setAlbums:(NSArray *)albums
{
    if (_albums != albums)
    {
        _albums = albums;
        [self.swipeView reloadData];
    }
    
    else
        DebugLog(@"ERROR: Already equal!");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //add extra pixels to height for antialiasing
    self.swipeView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

# pragma mark - iCarousel methods

-(NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    //fill with empty items until cell reloads
    if (!self.albums)
        return 5;
    
    return [self.albums count];
}

/*
-(UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    CGFloat width = self.frame.size.height - CELL_PADDING*2;
    
    UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.height, self.frame.size.height)];
    newView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:[UIColor greenColor]]];
    [imageView setFrame:CGRectMake(CELL_PADDING, CELL_PADDING, width, width)];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [newView addSubview:imageView];
    
    if ([self.imageCacheArray objectForKey:[NSNumber numberWithInteger:index]])
    {
        NSLog(@"not cropping");
        [imageView setImage:(UIImage *)[self.imageCacheArray objectForKey:[NSNumber numberWithInteger:index]]];
    }
    
    else
    {
        __weak UIImageView *weakView = imageView;
        [imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[self.swipeItemURLs objectAtIndex:index]] placeholderImage:[UIImage imageWithColor:[UIColor greenColor]] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {

            NSLog(@"cropping");
            
            //antialias image
            UIImage *resizedImage = [UIImage resizeImage:image newSize:CGSizeMake(weakView.frame.size.width, weakView.frame.size.height) contentMode:weakView.contentMode];
            [weakView setImage:resizedImage];
            
            [self.imageCacheArray setObject:resizedImage forKey:[NSNumber numberWithInteger:index]];
            
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"couldnt load album image");
        }];
    }
    
    return newView;
    
}
*/

-(UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIView *newView = (UIView *)view;
    UIImageView *imageView = nil;
    UILabel *titleLabel = nil;
    UILabel *artistLabel = nil;
    
    //create or reuse view
    if (view == nil)
    {        
        newView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SWIPE_VIEW_WIDTH, self.frame.size.height)];
        newView.backgroundColor = [UIColor colorFromHexString:cMenuTableBackgroundColor];
        
        //add a UIView under image and apply a shadow to it, to make it look like image has the shadow. can't apply shadow to image directly because clipstobounds needs to be yes on image (to prevent overflowing of image) - and that would clip the shadow
        //UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(CELL_PADDING, CELL_PADDING, ALBUM_WIDTH, ALBUM_WIDTH)];
        //TODO shadow color
        //shadowView.layer.shadowColor = [UIColor colorFromHexString:cCellFontDarkColor].CGColor;
        //shadowView.layer.shadowOffset = CGSizeZero;
        //shadowView.layer.shadowOpacity = 0.3;
        //shadowView.layer.shadowRadius = 8.0;
        
        imageView = [[UIImageView alloc] initWithImage:[LoadingImages defaultAlbumImageWithWidth:ALBUM_WIDTH]];
        [imageView setFrame:CGRectMake(CELL_PADDING, CELL_PADDING, ALBUM_WIDTH, ALBUM_WIDTH)];
        imageView.tag = 1;
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.borderColor = [UIColor colorFromHexString:cMenuTableFontColor].CGColor;
        imageView.layer.borderWidth = 1.f;
        
        //[shadowView addSubview:imageView];
        
        [newView addSubview:imageView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CELL_PADDING/2, imageView.frame.origin.y + imageView.frame.size.height + CELL_PADDING/2, imageView.frame.size.width + CELL_PADDING, 13)];
        [titleLabel setFont:[Constants appFontWithSize:12.f bolded:YES]];
        [titleLabel setTextColor:[UIColor colorFromHexString:cMenuTableFontColor]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        titleLabel.tag = 2;
        [newView addSubview:titleLabel];
        
        artistLabel = [[UILabel alloc] initWithFrame:CGRectMake(CELL_PADDING/2, titleLabel.frame.origin.y + titleLabel.frame.size.height, imageView.frame.size.width + CELL_PADDING, 10)];
        [artistLabel setFont:[Constants appFontWithSize:10.f bolded:NO]];
        [artistLabel setTextColor:[UIColor colorFromHexString:cMenuTableFontColor]];
        [artistLabel setBackgroundColor:[UIColor clearColor]];
        [artistLabel setTextAlignment:NSTextAlignmentCenter];
        artistLabel.tag = 3;
        [newView addSubview:artistLabel];
        
        view = newView;
    
    }
    
    else
    {
        //get a reference to the label in the recycled view
        imageView = (UIImageView *)[view viewWithTag:1];
        titleLabel = (UILabel *)[view viewWithTag:2];
        artistLabel = (UILabel *)[view viewWithTag:3];
    }
    
    //set labels
    WCDAlbum *album = (WCDAlbum *)(self.albums)[index];
    [titleLabel setText:album.name];
    [artistLabel setText:album.artist];
    
    //TODO
    //set image
    //because cropping decreases performance, cache cropped images in array and load them if available
    //if ([self.imageCacheArray objectForKey:[NSNumber numberWithInteger:index]])
    //{
        //NSLog(@"not cropping %@", [self.swipeItemTitles objectAtIndex:index]);
    //    [imageView setImage:(UIImage *)[self.imageCacheArray objectForKey:[NSNumber numberWithInteger:index]]];
    //}
    
    //else if ([album.imageURL.absoluteString length] > 0)
    if ([album.imageURL.absoluteString length] > 0)
    {
        __weak UIImageView *weakView = imageView;
        [imageView setImageWithURLRequest:[NSURLRequest requestWithURL:album.imageURL] placeholderImage:[LoadingImages defaultLoadingAlbumImageWithWidth:ALBUM_WIDTH] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            
            //NSLog(@"cropping %@", [self.swipeItemTitles objectAtIndex:index]);
            
            //antialias image
            UIImage *resizedImage = [UIImage resizeImage:image newSize:CGSizeMake(weakView.frame.size.width, weakView.frame.size.height) contentMode:weakView.contentMode];
            [weakView setImage:resizedImage];
            
            //[self.imageCacheArray setObject:resizedImage forKey:[NSNumber numberWithInteger:index]];
            
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"couldnt load album image: %@", album.name);
            
            [weakView setImage:[LoadingImages defaultAlbumImageWithWidth:ALBUM_WIDTH]];
        }];
    }
    
    else
    {
        [imageView setImage:[LoadingImages defaultAlbumImageWithWidth:ALBUM_WIDTH]];
    }
    
    /*
        
    __weak UIImageView *weakView = imageView;
    [imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[self.swipeItemURLs objectAtIndex:index]] placeholderImage:[UIImage imageWithColor:[UIColor greenColor]] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {

        //image is not cached
        if (response)
        {
            //antialias image
            UIImage *resizedImage = [UIImage resizeImage:image newSize:CGSizeMake(weakView.frame.size.width, weakView.frame.size.height) contentMode:weakView.contentMode];
            [weakView setImage:resizedImage];
            
            [self.imageCacheArray setObject:resizedImage forKey:[NSNumber numberWithInteger:index]];
        }
        
        else
        {
            //image is cached. load resized image from an array because resizing image again will decrease performance
            //TODO doesn't work when searching for a user that has snatches that were already cached
            [weakView setImage:[self.imageCacheArray objectForKey:[NSNumber numberWithInteger:index]]];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"couldnt load album image");
    }];
     */
    
    return view;
    
}

+(CGFloat)height
{
    return 130.f; //SWIPE_VIEW_WIDTH;
}

@end
