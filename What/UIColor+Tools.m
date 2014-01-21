//
//  UIColor+ColorFromHex.m
//  VM
//
//  Created by What on 5/23/12.
//  Copyright (c) 2012 What. All rights reserved.
//

@implementation UIColor (Tools)

+(HexComponents)rgbFromHex:(NSString *)hex
{
    HexComponents nullReturn = {1.0, 0.0, 0.0};
    
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    
    if ([cString length] == 3) cString = [NSString stringWithFormat:@"%@%@", cString, cString];
    
    else if ([cString length] < 6) return nullReturn;
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  nullReturn;
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    HexComponents components = {(float)r, (float)g, (float)b};
    return components;
}

+(UIColor *)colorFromHexString: (NSString *)hex  
{  
    return [self colorFromHexString:hex alpha:1.0f];
}

+(UIColor *)colorFromHexString:(NSString *)hex alpha:(CGFloat)alpha
{
    HexComponents components = [self rgbFromHex:hex];
    
    float r = (float)components.rgbComponents[0];
    float g = (float)components.rgbComponents[1];
    float b = (float)components.rgbComponents[2];
    
    return [self colorWithRed:(r / 255.0f)
                        green:(g / 255.0f)
                         blue:(b / 255.0f)
                        alpha:alpha];
}

+(HexComponents)rgbComponentsFromHexString:(NSString *)hex
{
    HexComponents components = [self rgbFromHex:hex];
    float r = (float)components.rgbComponents[0];
    float g = (float)components.rgbComponents[1];
    float b = (float)components.rgbComponents[2];
    
    HexComponents result = {r / 255.0f, g / 255.0f, b / 255.0f};
    return result;
}

+(UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (UIColor *)darkerColor
{
    float h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:b * 0.8
                               alpha:a];
    return nil;
}

@end
