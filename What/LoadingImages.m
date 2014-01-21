//
//  LoadingImages.m
//  What
//
//  Created by What on 8/21/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "LoadingImages.h"

@implementation LoadingImages

+(UIImage *)defaultProfileImageWithWidth:(CGFloat)width;
{
    if (width == 36.f)
        return [LoadingImages defaultProfileImage36px];
    else if (width == 60.f)
        return [LoadingImages defaultProfileImage60px];
    else if (width == 30.f)
        return [LoadingImages defaultProfileImage30px];
    else if (width == 32.f)
        return [LoadingImages defaultProfileImage32px];
    else if (width == 24.f)
        return [LoadingImages defaultProfileImage24px];
    else
    {
        NSLog(@"wronga size");
        return nil;
    }
}

+(UIImage *)defaultLoadingProfileImageWithWidth:(CGFloat)width;
{
    if (width == 36.f)
        return [LoadingImages defaultLoadingProfileImage36px];
    else if (width == 60.f)
        return [LoadingImages defaultLoadingProfileImage60px];
    else if (width == 30.f)
        return [LoadingImages defaultLoadingProfileImage30px];
    else if (width == 32.f)
        return [LoadingImages defaultLoadingProfileImage32px];
    else if (width == 24.f)
        return [LoadingImages defaultLoadingProfileImage24px];
    else
    {
        NSLog(@"wronga size2");
        return nil;
    }
}

+(UIImage *)defaultAlbumImageWithWidth:(CGFloat)width;
{
    if (width == 80.f)
        return [LoadingImages defaultAlbumImage80px];
    else if (width == 50.f)
        return [LoadingImages defaultAlbumImage50px];
    else
    {
        NSLog(@"wronga size3");
        return nil;
    }
}

+(UIImage *)defaultLoadingAlbumImageWithWidth:(CGFloat)width;
{
    if (width == 80.f)
        return [LoadingImages defaultLoadingAlbumImage80px];
    else if (width == 50.f)
        return [LoadingImages defaultLoadingAlbumImage50px];
    else
    {
        NSLog(@"wronga size4");
        return nil;
    }
}

+(UIImage *)defaultProfileImage24px
{
    static UIImage *defaultImage = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
        UIImage *silhouette = [UIImage imageNamed:@"../Images/silhouette.png"];
        defaultImage = [UIImage resizeImage:silhouette newSize:CGSizeMake(24.f, 24.f) contentMode:UIViewContentModeScaleAspectFill];
    });
    
    return defaultImage;
}

+(UIImage *)defaultLoadingProfileImage24px
{
    static UIImage *defaultLoadingImage = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
        UIImage *silhouette = [UIImage imageNamed:@"../Images/silhouette_loading.png"];
        defaultLoadingImage = [UIImage resizeImage:silhouette newSize:CGSizeMake(24.f, 24.f) contentMode:UIViewContentModeScaleAspectFill];
    });
    
    return defaultLoadingImage;
}

+(UIImage *)defaultProfileImage30px
{
    static UIImage *defaultImage = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
        UIImage *silhouette = [UIImage imageNamed:@"../Images/silhouette.png"];
        defaultImage = [UIImage resizeImage:silhouette newSize:CGSizeMake(30.f, 30.f) contentMode:UIViewContentModeScaleAspectFill];
    });
    
    return defaultImage;
}

+(UIImage *)defaultLoadingProfileImage30px
{
    static UIImage *defaultLoadingImage = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
        UIImage *silhouette = [UIImage imageNamed:@"../Images/silhouette_loading.png"];
        defaultLoadingImage = [UIImage resizeImage:silhouette newSize:CGSizeMake(30.f, 30.f) contentMode:UIViewContentModeScaleAspectFill];
    });
    
    return defaultLoadingImage;
}

+(UIImage *)defaultProfileImage32px
{
    static UIImage *defaultImage = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
        UIImage *silhouette = [UIImage imageNamed:@"../Images/silhouette.png"];
        defaultImage = [UIImage resizeImage:silhouette newSize:CGSizeMake(32.f, 32.f) contentMode:UIViewContentModeScaleAspectFill];
    });
    
    return defaultImage;
}

+(UIImage *)defaultLoadingProfileImage32px
{
    static UIImage *defaultLoadingImage = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
        UIImage *silhouette = [UIImage imageNamed:@"../Images/silhouette_loading.png"];
        defaultLoadingImage = [UIImage resizeImage:silhouette newSize:CGSizeMake(32.f, 32.f) contentMode:UIViewContentModeScaleAspectFill];
    });
    
    return defaultLoadingImage;
}

+(UIImage *)defaultProfileImage36px
{
    static UIImage *defaultImage = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
        UIImage *silhouette = [UIImage imageNamed:@"../Images/silhouette.png"];
        defaultImage = [UIImage resizeImage:silhouette newSize:CGSizeMake(36.f, 36.f) contentMode:UIViewContentModeScaleAspectFill];
    });
    
    return defaultImage;
}

+(UIImage *)defaultLoadingProfileImage36px
{
    static UIImage *defaultLoadingImage = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
        UIImage *silhouette = [UIImage imageNamed:@"../Images/silhouette_loading.png"];
        defaultLoadingImage = [UIImage resizeImage:silhouette newSize:CGSizeMake(36.f, 36.f) contentMode:UIViewContentModeScaleAspectFill];
    });
    
    return defaultLoadingImage;
}

+(UIImage *)defaultProfileImage60px
{
    static UIImage *defaultImage = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
        UIImage *silhouette = [UIImage imageNamed:@"../Images/silhouette.png"];
        defaultImage = [UIImage resizeImage:silhouette newSize:CGSizeMake(60.f, 60.f) contentMode:UIViewContentModeScaleAspectFill];
    });
    
    return defaultImage;
}

+(UIImage *)defaultLoadingProfileImage60px
{
    static UIImage *defaultLoadingImage = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
        UIImage *silhouette = [UIImage imageNamed:@"../Images/silhouette_loading.png"];
        defaultLoadingImage = [UIImage resizeImage:silhouette newSize:CGSizeMake(60.f, 60.f) contentMode:UIViewContentModeScaleAspectFill];
    });
    
    return defaultLoadingImage;
}

+(UIImage *)defaultAlbumImage80px
{
    static UIImage *defaultImage = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
        UIImage *silhouette = [UIImage imageNamed:@"../Images/noAlbum.png"];
        defaultImage = [UIImage resizeImage:silhouette newSize:CGSizeMake(80.f, 80.f) contentMode:UIViewContentModeScaleAspectFill];
    });
    
    return defaultImage;
}

+(UIImage *)defaultLoadingAlbumImage80px
{
    static UIImage *defaultLoadingImage = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
        UIImage *silhouette = [UIImage imageNamed:@"../Images/noAlbum_loading.png"];
        defaultLoadingImage = [UIImage resizeImage:silhouette newSize:CGSizeMake(80.f, 80.f) contentMode:UIViewContentModeScaleAspectFill];
    });
    
    return defaultLoadingImage;
}

+(UIImage *)defaultAlbumImage50px
{
    static UIImage *defaultImage = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
        UIImage *silhouette = [UIImage imageNamed:@"../Images/noAlbum.png"];
        defaultImage = [UIImage resizeImage:silhouette newSize:CGSizeMake(50.f, 50.f) contentMode:UIViewContentModeScaleAspectFill];
    });
    
    return defaultImage;
}

+(UIImage *)defaultLoadingAlbumImage50px
{
    static UIImage *defaultLoadingImage = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
        UIImage *silhouette = [UIImage imageNamed:@"../Images/noAlbum_loading.png"];
        defaultLoadingImage = [UIImage resizeImage:silhouette newSize:CGSizeMake(50.f, 50.f) contentMode:UIViewContentModeScaleAspectFill];
    });
    
    return defaultLoadingImage;
}

@end
