//
//  Constants.h
//  VM
//
//  Created by What on 4/23/12.
//  Copyright (c) 2012 What. All rights reserved.
//

#import <Foundation/Foundation.h>

//common imports
#import <QuartzCore/QuartzCore.h>
#import "UIColor+Tools.h"
#import "UIImage+Tools.h"
#import "LoadingImages.h"
#import "AFNetworking.h"

//Debugging
#define DEBUG_MODE
#ifdef DEBUG_MODE
    #define DebugLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
    #define DebugLog( s, ... )
#endif

//#define kNetworkRequestTimedOutNotification    @"RequestTimedOut"
//#define kNetworkBadGatewayNotification         @"BadGateway"
#define kNetworkRequestFailedNotification                   @"RequestFailedNotification"
//#define kAlertBannerKey                                     @"AlertBannerKey"
#define kLoggedInNotification                               @"LoggedInKey"
#define kLoggedOutNotification                              @"LoggedOutKey"

//Cookies
#define COOKIE_KEY @"whatCookieKey"

//What.cd Keys
#define wRESPONSE @"response"
#define wTHREAD_TITLE @"threadTitle"
#define wPOSTS @"posts"
#define wPOST_ID @"postId"
#define wHTML_BODY @"body"
#define wBB_BODY @"bbBody"
#define wADDED_TIME @"addedTime"
#define wAUTHOR @"author"
#define wAUTHOR_NAME @"authorName"
#define wAVATAR @"avatar"

//constants
#define CELL_WIDTH 320.f
#define CELL_PADDING 10.f
#define ACCESSORY_WIDTH 13.f
#define ACCESSORY_HEIGHT 18.f
#define TRANSPARENT_ALPHA 0.95f

#define FONT_SIZE_TITLE 15.f
#define FONT_SIZE_SUBTITLE 12.f
#define FONT_SIZE_TIME 10.f

#define FONT_SIZE_ALBUM_TITLE 15.f
#define FONT_SIZE_ALBUM_SUBTITLE 11.f
#define FONT_SIZE_ALBUM_TAGS 10.f
#define FONT_SIZE_ALBUM_STATS 8.f

#define FONT_SIZE_FORUM_NAME 13.f
#define FONT_SIZE_FORUM_SUBTITLE 10.f

//iOS versions
#define IOS6 6.0
#define IOS5 5.0

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//checks for empty stuff
static inline BOOL IsEmpty(id thing) {
    return thing == nil
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}

extern CGFloat const kSectionHeaderHeight;

//colors
extern NSString * const cMenuTableBackgroundColor;
extern NSString * const cMenuTableBackgroundSelectedColor;
extern NSString * const cMenuTableSeparatorColor;
extern NSString * const cMenuTableHeaderBackgroundColor;
extern NSString * const cMenuTableFontColor;

extern NSString * const cForumTableSeparatorLightColor;
extern NSString * const cForumTableSeparatorDarkColor;

extern NSString * const cForumCellGradientLightColor;
extern NSString * const cForumCellGradientDarkColor;
extern NSString * const cForumCellSelectedColor;

extern NSString * const cCellAccessoryColor;

extern NSString * const cFontWhiteColor;
extern NSString * const cCellFontLightColor;
extern NSString * const cCellFontMediumColor;
extern NSString * const cCellFontDarkColor;
//extern NSString * const cCellFontDarkReadColor;

extern NSString * const cThreadCellOddColor;
extern NSString * const cThreadCellEvenColor;

extern NSString * const cCyanColor;

extern NSString * const cHostName;
extern NSString * const cHostNameSSL;

@interface NSObject (ALContext)
@property (nonatomic, strong) id context;
@end

@interface Constants : NSObject

+(float)iOSVersion;
+(BOOL)debug;
+(UIFont *)appFontWithSize:(CGFloat)size;
+(UIFont *)appFontWithSize:(CGFloat)size bolded:(BOOL)bold;
+(UIFont *)appFontWithSize:(CGFloat)size oblique:(BOOL)oblique;
+(BOOL)deviceHasLargerScreen;
+ (BOOL)deviceHasRetinaScreen;
+(NSString *)platformString;

//cast CATransition to id so we don't have to include QuartzCore in this header
+(id)imagePopoverAnimation;

@end
