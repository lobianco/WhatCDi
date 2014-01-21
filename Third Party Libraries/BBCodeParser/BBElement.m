//
//  BBElement.m
//  BBCodeParser
//
//  Created by Miha Rataj on 2/2/12.
//  Copyright (c) 2012 Marg, d.o.o. All rights reserved.
//

#import "BBElement.h"
#import "BBCodeParser.h"

@implementation BBElement

- (id)init
{
    self = [super init];
    if (self)
    {
        _tag = [[NSString alloc] init];
        _format = [[NSMutableString alloc] init];
        _attributes = [[NSArray alloc] init];
        _elements = [[NSArray alloc] init];
        _parent = nil;
    }
    
    return self;
}

-(NSString *)plainText
{
    return [self createPlainTextFromString:self.format withChildren:self.elements];
}

-(NSString *)createPlainTextFromString:(NSString *)parentString withChildren:(NSArray *)children
{
    NSString *newFormat = [NSString stringWithString:parentString];
    for (int i = 0; i < children.count; i++)
    {
        BBElement *childElement = [children objectAtIndex:i];
        NSString *pattern = [NSString stringWithFormat:@"{BB_%i_BB}", i];
        NSString *childText = [self createPlainTextFromString:childElement.format withChildren:childElement.elements];
        
        newFormat = [newFormat stringByReplacingOccurrencesOfString:pattern withString:childText];
    }
    
    return newFormat;
}

- (BBAttribute *)attributeWithName:(NSString *)name
{
    for (BBAttribute *attribute in _attributes)
        if ([attribute.name isEqualToString:name])
            return attribute;
    
    return nil;
}

- (BBElement *)elementAtIndex:(NSInteger)index
{
    NSInteger endIndex = _startIndex + [self length];
    if (index < _startIndex || index > endIndex)
        return nil;
    
    for (BBElement *element in _elements)
    {
        BBElement *found = [element elementAtIndex:index];
        if (found != nil)
            return found;
    }
    
    return self;
}

- (NSInteger)length
{
    NSInteger length = [self.plainText length];
    for (BBElement *element in _elements)
        length += [element length];
    return length;
}

- (void)setElements:(NSArray *)elements
{
    if (elements == _elements)
        return;
    
    _elements = elements;
    
    for (BBElement *subelement in _elements)
        [subelement setParent:self];
}

- (void)dealloc
{
    _parent = nil;
}

-(NSString *)description
{
    /*
    NSMutableArray *elements = [NSMutableArray new];
    int i = 0;
    for (BBElement *element in self.elements)
    {
        NSDictionary *dict = @{[NSString stringWithFormat:@"%i", i]: [element description]};
        [elements addObject:dict];
        i++;
    }
    
    NSMutableArray *attributes = [NSMutableArray new];
    int j = 0;
    for (BBAttribute *attribute in self.attributes)
    {
        NSDictionary *dict = @{[NSString stringWithFormat:@"%i", j] : [attribute description]};
        [attributes addObject:dict];
        j++;
    }
     */
    
    NSDictionary *dict = @{@"tag": (self.tag.length > 0 ? self.tag : @"nil"),
                           @"attributes" : self.attributes.count > 0 ? self.attributes : @"nil",
                           @"format" : self.format,
                           @"elements" : self.elements.count > 0 ? self.elements : @"nil"};
    
    return [dict description];
}


@end
