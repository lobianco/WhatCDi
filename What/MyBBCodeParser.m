//
//  MyBBCodeParser.m
//  What
//
//  Created by What on 6/26/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "MyBBCodeParser.h"
#import "NSString+HTML.h"


@interface MyBBCodeParser ()

@end

@implementation MyBBCodeParser

//static int parserCount = 1;

-(void)parseCode:(NSString *)code completion:(void (^)(BBElement *))completion
{        
    BBCodeParser *parser = [[BBCodeParser alloc] initWithTags:[NSArray arrayWithObjects:@"quote", @"b", @"i", @"important", @"url", @"img", nil]];
    [parser setCode:[code stringByDecodingHTMLEntities]];
    [parser parse];
    
    completion(parser.element);
}

/*
-(NSDictionary *)sortElement:(BBElement *)element
{
    NSMutableDictionary *elementDict = [NSMutableDictionary new];
    
    [elementDict setObject:[[NSMutableString alloc] initWithString:element.format] forKey:@"format"];
    
    //only add this tag if not dealing with root element (in which case it will be empty)
    if ([element.tag length] > 0)
        [elementDict setObject:[NSString stringWithString:element.tag] forKey:@"tag"];
    
    NSMutableDictionary *attributesDict = [NSMutableDictionary new];
    
    for (BBAttribute *attribute in element.attributes)
        [attributesDict setObject:attribute.value forKey:attribute.name];
    
    if ([attributesDict count] > 0)
        [elementDict setObject:attributesDict forKey:@"attributes"];
    
    for (BBElement *childElement in element.elements)
    {        
        NSMutableArray *childArray = [elementDict objectForKey:@"children"];
        if (!childArray)
            childArray = [NSMutableArray new];
        
        [childArray addObject:[self sortElement:childElement]];
        [elementDict setObject:childArray forKey:@"children"];
        
    }
    
    return elementDict;
}
 */

/*
-(CGFloat)elementChildrenLength:(NSArray *)elements currentLength:(CGFloat)length
{
    CGFloat newLength = length;
    for (BBElement *element in elements)
        newLength += [self elementChildrenLength:element.elements currentLength:element.text.length];
    
    return newLength;
}
 */

@end
