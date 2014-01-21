//
//  Constants.m
//  VM
//
//  Created by What on 4/23/12.
//  Copyright (c) 2012 What. All rights reserved.
//

#import <sys/utsname.h>
#import <objc/runtime.h>

CGFloat const kSectionHeaderHeight = 25.f;

//colors
NSString * const cMenuTableBackgroundColor = @"303030";
NSString * const cMenuTableBackgroundSelectedColor = @"222222";
NSString * const cMenuTableSeparatorColor = @"3a3939";
NSString * const cMenuTableHeaderBackgroundColor = @"4c4b49";
NSString * const cMenuTableFontColor = @"f7f5f1";

NSString * const cForumTableSeparatorDarkColor = @"a9a8a8";
NSString * const cForumTableSeparatorLightColor = @"f8f7f5";

NSString * const cForumCellGradientLightColor = @"f7f6f3";
NSString * const cForumCellGradientDarkColor = @"f4f3ef";
NSString * const cForumCellSelectedColor = @"dfddda";

NSString * const cCellAccessoryColor = @"b3b2b0";

NSString * const cFontWhiteColor = @"f7f7f6";
NSString * const cCellFontLightColor = @"afaead";
NSString * const cCellFontMediumColor = @"969594";
NSString * const cCellFontDarkColor = @"2c2b2a";

NSString * const cThreadCellEvenColor = @"fbfaf9"; //cForumCellGradientLightColor
NSString * const cThreadCellOddColor = @"f2f1f0";

NSString * const cCyanColor = @"479ccd";

NSString * const cHostName = @"https://what.cd";
NSString * const cHostNameSSL = @"https://ssl.what.cd";

@implementation NSObject (ALContext)
@dynamic context;
-(void)setContext:(id)context {
    objc_setAssociatedObject(self, @selector(context), context, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(id)context {
    return objc_getAssociatedObject(self, @selector(context));
}
@end

@implementation Constants

+(float)iOSVersion
{
    static float version = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = [[[UIDevice currentDevice] systemVersion] floatValue];
    });
    return version;
}

+(BOOL)debug
{
    return NO;
}

+(UIFont *)appFontWithSize:(CGFloat)size
{
    return [self defaultAppFontWithSize:size];
}

+(UIFont *)appFontWithSize:(CGFloat)size bolded:(BOOL)bold
{
    if (bold) {
        if ([Constants iOSVersion] >= 7.0)
            return [UIFont boldSystemFontOfSize:size];
        
        return [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];
    }
    
    return [self defaultAppFontWithSize:size];
}

+(UIFont *)appFontWithSize:(CGFloat)size oblique:(BOOL)oblique
{
    if (oblique) {
        if ([Constants iOSVersion] >= 7.0)
            return [UIFont italicSystemFontOfSize:size];
        
        return [UIFont fontWithName:@"HelveticaNeue-Italic" size:size];
    }
    
    return [self defaultAppFontWithSize:size];
}

+(UIFont *)defaultAppFontWithSize:(CGFloat)size
{
    if ([Constants iOSVersion] >= 7.0)
        return [UIFont systemFontOfSize:size];
    
    return [UIFont fontWithName:@"HelveticaNeue" size:size];
}

+(CATransition *)imagePopoverAnimation
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.type = kCATransitionFade;
    
    return transition;
}

+ (BOOL)deviceHasRetinaScreen {
    return ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0));
}

+ (BOOL)deviceHasLargerScreen {
    return ([[self platformString] isEqualToString:@"iPhone 5 (GSM)"] || [[self platformString] isEqualToString:@"iPhone 5 (GSM+CDMA)"] || [[self platformString] isEqualToString:@"iPod Touch 5G"]);
}

+ (NSString *)platformString
{
    NSString *platform = machineName();
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return platform;
}

NSString* machineName()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

@end
