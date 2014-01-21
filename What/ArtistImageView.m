//
//  ArtistImageView.m
//  What
//
//  Created by What on 8/27/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "ArtistImageView.h"
#import "ImagePopupController.h"

@interface ArtistImageView ()

//@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;


@end

@implementation ArtistImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor redColor];
        
        _imageView = [[UIImageView alloc] initWithFrame:frame];
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        _imageView.layer.masksToBounds = YES;
        _imageView.userInteractionEnabled = YES;
        [self addSubview:_imageView];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"artist image dealloc");
}

-(void)updateArtistImageWithURL:(NSURL *)url
{    
    __weak UIImageView *weakImage = self.imageView;
    __weak ArtistImageView *weakSelf = self;
    [self.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:url] placeholderImage:[UIImage imageNamed:@"../Images/artistLoader.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
        CGFloat heightScale = weakImage.frame.size.width / image.size.width;
        
        UIImage *resizedImage = [UIImage resizeImage:image newSize:CGSizeMake(weakImage.frame.size.width, (image.size.height * heightScale)) contentMode:weakImage.contentMode];
        
        [weakImage setImage:resizedImage];
        weakSelf.fullSizedImage = image;
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"couldnt load album image");
        [weakSelf.imageView setImage:[UIImage imageNamed:@"../Images/artist.png"]];
    }];
    
}

@end
