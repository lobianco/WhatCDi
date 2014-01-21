//
//  MyHTMLParser.m
//  What
//
//  Created by What on 6/26/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "MyHTMLParser.h"
#import "HTMLParser.h"
#import "NSString+HTML.h"
#import "TFHpple.h"

@implementation MyHTMLParser

+(BOOL)htmlContainsRichText:(NSString *)html {
    NSData *data = [[html stringByDecodingHTMLEntities] dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
    
    if ([doc searchWithXPathQuery:@"//blockquote"].count > 0)
        return YES;
    if ([doc searchWithXPathQuery:@"//img"].count > 0)
        return YES;
    if ([doc searchWithXPathQuery:@"//a"].count > 0)
        return YES;
    if ([doc searchWithXPathQuery:@"//strong"].count > 0)
        return YES;
    if ([doc searchWithXPathQuery:@"//span"].count > 0)
        return YES;
    if ([doc searchWithXPathQuery:@"//ul"].count > 0)
        return YES;
    if ([doc searchWithXPathQuery:@"//ol"].count > 0)
        return YES;
    
    return NO;
}

+ (NSURL *)extractFirstImageFromHTML:(NSString *)html
{
    NSData *data = [[html stringByDecodingHTMLEntities] dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
    
    NSArray *images = [doc searchWithXPathQuery:@"//img"];
    
    for (TFHppleElement *element in images)
    {
        NSString *imageURLString = [element objectForKey:@"src"];
        
        BOOL hasHTTPPrefix = ([[imageURLString lowercaseString] hasPrefix:@"http://"] || [[imageURLString lowercaseString] hasPrefix:@"https://"]);
        
        if (hasHTTPPrefix)
            return [NSURL URLWithString:imageURLString];
    }
    
    return nil;
    
}

@end


/*
//preliminary regexes - use xpath and find range of matches and remove that way, avoiding regex?
//remove <br />
NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<br[^>]*>" options:NSRegularExpressionCaseInsensitive error:nil];
[regex replaceMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];

//div opening regex
regex = [NSRegularExpression regularExpressionWithPattern:@"<div[^>]*>" options:NSRegularExpressionCaseInsensitive error:nil];
[regex replaceMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];

//div closing regex
regex = [NSRegularExpression regularExpressionWithPattern:@"</div>" options:NSRegularExpressionCaseInsensitive error:nil];
[regex replaceMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];

//a tags with javascript
regex = [NSRegularExpression regularExpressionWithPattern:@"<a href=\"javascript[^>]*>.*?</a>" options:NSRegularExpressionCaseInsensitive error:nil];
[regex replaceMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];

//remove <strong>
regex = [NSRegularExpression regularExpressionWithPattern:@"<strong[^>]*>" options:NSRegularExpressionCaseInsensitive error:nil];
[regex replaceMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];

regex = [NSRegularExpression regularExpressionWithPattern:@"</strong>" options:NSRegularExpressionCaseInsensitive error:nil];
[regex replaceMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];

//remove <span>
regex = [NSRegularExpression regularExpressionWithPattern:@"<span[^>]*>" options:NSRegularExpressionCaseInsensitive error:nil];
[regex replaceMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];

regex = [NSRegularExpression regularExpressionWithPattern:@"</span>" options:NSRegularExpressionCaseInsensitive error:nil];
[regex replaceMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];

//a regex
regex = [NSRegularExpression regularExpressionWithPattern:@"<a[^>]*>" options:NSRegularExpressionCaseInsensitive error:nil];
[regex replaceMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];

regex = [NSRegularExpression regularExpressionWithPattern:@"</a>" options:NSRegularExpressionCaseInsensitive error:nil];
[regex replaceMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];

//img regex
regex = [NSRegularExpression regularExpressionWithPattern:@"<img[^>]+>" options:NSRegularExpressionCaseInsensitive error:nil];
[regex replaceMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@"(image here)"];
 */