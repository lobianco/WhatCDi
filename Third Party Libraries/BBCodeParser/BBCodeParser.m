//
//  BBCodeParser.m
//  BBCodeParser
//
//  Created by Miha Rataj on 2/2/12.
//  Optimized by What on 7/3/13
//  Copyright (c) 2012 Marg, d.o.o. All rights reserved.
//

#import "BBCodeParser.h"

static NSString *startTag__ = @"[";
static NSString *endTag__ = @"]";
static NSString *closingTag__ = @"/";

@interface BBCodeParser ()

@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic, strong) NSMutableArray *invalidTags;

@property (nonatomic, strong) NSMutableString *currentTag;

@property (nonatomic, assign) NSInteger codeCounter;
@property (nonatomic, assign) NSInteger longestTagLength;

@end

@implementation BBCodeParser

-(NSArray *)allBBTags
{
    static NSArray *allBBTags = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        allBBTags = @[@"b", @"i", @"u", @"s",
                    @"align", @"color", @"size",
                    @"url", @"img", @"quote",
                    @"important", //@"*", @"#",
                    @"pre", @"code", @"plain",
                    @"tex", @"artist", @"user",
                    @"torrent", @"rule", @"mature"];
    });
    return allBBTags;
}

#pragma mark -
#pragma mark - Init

- (id)init
{
    return [self initWithTags:[NSArray arrayWithObjects:@"i", nil]];
}

- (id)initWithTags:(NSArray *)tags
{
    self = [super init];
    if (self)
    {
        _element = [[BBParsingElement alloc] init];
                
        //get length of longest tag, inluding +2 for brackets and +1 for closing slash
        for (NSString *tag in self.allBBTags)
        {
            if (([tag length] + 3) > _longestTagLength)
                _longestTagLength = ([tag length] + 3);
        }
    
        //inverse array - array of all tags that are correct BBCode syntax, but invalid for current session
        NSMutableArray *allTags = [NSMutableArray arrayWithArray:[self allBBTags]];
        [allTags removeObjectsInArray:tags];
        
        _invalidTags = [[NSMutableArray alloc] init];
        for (NSString *tag in allTags)
        {
            [_invalidTags addObject:[NSString stringWithFormat:@"%@%@%@", startTag__, tag, endTag__]]; //[quote]
            [_invalidTags addObject:[NSString stringWithFormat:@"%@%@%@%@", startTag__, closingTag__, tag, endTag__]]; //[/quote]
            
            if ([tag isEqualToString:@"quote"] || [tag isEqualToString:@"url"] || [tag isEqualToString:@"size"] || [tag isEqualToString:@"hide"] || [tag isEqualToString:@"align"]  || [tag isEqualToString:@"img"])
                [_invalidTags addObject:[NSString stringWithFormat:@"%@%@=", startTag__, tag]]; //[quote=
        }
                        
        //valid tags
        _tags = [NSMutableArray new];
        for (NSString *tag in tags)
        {
            [_tags addObject:[NSString stringWithFormat:@"%@%@%@", startTag__, tag, endTag__]]; //[quote]
            [_tags addObject:[NSString stringWithFormat:@"%@%@%@%@", startTag__, closingTag__, tag, endTag__]]; //[/quote]
            
            if ([tag isEqualToString:@"quote"] || [tag isEqualToString:@"url"] || [tag isEqualToString:@"size"] || [tag isEqualToString:@"hide"]  || [tag isEqualToString:@"align"]  || [tag isEqualToString:@"img"])
                [_tags addObject:[NSString stringWithFormat:@"%@%@=", startTag__, tag]]; //[quote=
        }
        
    }
    return self;
}

#pragma mark -
#pragma mark - Parsing

- (BBParsingElement *)getLastUnparsedElementFor:(BBParsingElement *)parent
{
    for (BBParsingElement *subelement in parent.elements)
    {
        if (!subelement.parsed)
            return [self getLastUnparsedElementFor:subelement];
    }
    
    return parent;
}

- (BBParsingElement *)getLastUnparsedElement
{
    BBParsingElement *last = [self.element.elements lastObject];
    if (last.parsed || last == nil)
        return self.element;
    
    return [self getLastUnparsedElementFor:last];
}

- (NSArray *)getAttributesFromTag:(NSString *)tagWithAttributes
{
    /* EXAMPLES:
     
     1. [quote=JohnDoe|123456]
     
     2. [quote=JohnDoe];
     2. [url=http://www.google.com]
     2. [img=http://img.png]
     
     3. [quote]
     
     */
    
    
    //case 3
    if ([tagWithAttributes rangeOfString:@"="].location == NSNotFound)
        return nil;
    
    //only tags that should have attributes are: quote, url
    NSRange equalsRange = [tagWithAttributes rangeOfString:@"="];
    NSString *tagName = [tagWithAttributes substringToIndex:equalsRange.location];
    NSString *attributeString = [tagWithAttributes substringFromIndex:(equalsRange.location + equalsRange.length)];
    
    //case 2
    if ([tagWithAttributes rangeOfString:@"|"].location == NSNotFound)
    {
        BBAttribute *attribute = [[BBAttribute alloc] init];
        
        if ([tagName isEqualToString:@"url"] || [tagName isEqualToString:@"img"])
            [attribute setName:@"urlString"];
        
        else if ([tagName isEqualToString:@"quote"])
            [attribute setName:@"quoteAuthor"];
        
        [attribute setValue:attributeString];
        return @[attribute];
    }
    
    //case 1
    else
    {        
        if ([tagName isEqualToString:@"quote"])
        {
            NSArray *quoteComponents = [attributeString componentsSeparatedByString:@"|"];
            
            BBAttribute *authorAtt = [[BBAttribute alloc] init];
            BBAttribute *idAtt = [[BBAttribute alloc] init];
            
            [authorAtt setName:@"quoteAuthor"];
            [authorAtt setValue:[quoteComponents objectAtIndex:0]];
            
            [idAtt setName:@"quoteId"];
            [idAtt setValue:[quoteComponents objectAtIndex:1]];
            
            return @[authorAtt, idAtt];
        }
    }
    
    return nil;
}

- (void)parseStartedForTag:(NSString *)tag range:(int)range
{
    BBParsingElement *element = [[BBParsingElement alloc] init];
    [element setStartIndex:self.codeCounter];
    
    // Check if tag is valid BBCode tag.
    NSArray *components = [tag componentsSeparatedByString:@"="];
    if (components == nil || [components count] == 0)
        @throw [NSException exceptionWithName:@"Invalid components count!" reason:@"Element tag isn't valid." userInfo:nil];
    
    // Set element range
    [element setRange:(range - tag.length - 1)];
    
    // Set element's tag.
    NSString *tagName = [components objectAtIndex:0];
    [element setTag:tagName];
    
    // Set element's attributes.
    NSArray *attributes = [self getAttributesFromTag:tag];
    [element setAttributes:attributes];
    
    // Append children to last unparsed element.
    BBParsingElement *parentElement = [self getLastUnparsedElement];
    NSMutableArray *exitingChildren = [NSMutableArray arrayWithArray:parentElement.elements];
    [exitingChildren addObject:element];
    [parentElement setElements:exitingChildren];
    
    NSMutableString *newFormat = [NSMutableString stringWithFormat:@"%@%@%d%@", parentElement.format, [BBCodeParser startTagCharacter], [parentElement.elements count] - 1, [BBCodeParser endTagCharacter]];
    [parentElement setFormat:newFormat];
            
}

- (void)parseFinished
{
    BBParsingElement *element = [self getLastUnparsedElement];
    [element setParsed:YES];
    
}

- (BOOL)textStartsWithAllowedTag:(NSString *)text
{
    for (NSString *tag in self.tags)
    {
        if ([[text lowercaseString] hasPrefix:tag])
            return YES;
    }
    
    return NO;
}

- (BOOL)textStartsWithInvalidTag:(NSString *)text
{
    for (NSString *tag in self.invalidTags)
    {
        if ([[text lowercaseString] hasPrefix:tag])
            return YES;
    }
    
    return NO;
}

- (void)parse
{    
    self.codeCounter = 0;
    BOOL readingTag = NO;
    
    NSString *codeToParse = [NSString stringWithString:self.code];
    codeToParse = [codeToParse stringByReplacingOccurrencesOfString:@"[*]" withString:[NSString stringWithFormat:@"\n %C ", (unichar)0x2022]];
    
    unsigned int length = [codeToParse length];
    unichar buffer[length + 1];
    [codeToParse getCharacters:buffer range:NSMakeRange(0, length)];
    
    int i = 0;
    while (i < length)
    {
        unichar currentCharacter = buffer[i];

        //check if current character is bracket, and if the next few characters represents a valid tag. the MIN is so the range doesn't go past the end of code
        if (currentCharacter == '[' && [self textStartsWithAllowedTag:[codeToParse substringWithRange:NSMakeRange(i, MIN(self.longestTagLength, length-i))]])
        {
            self.currentTag = [[NSMutableString alloc] initWithCapacity:length-i];
            readingTag = YES;
            
            i++;
        }
        
        //Otherwise, remove all invalid tags from source string
        else if (currentCharacter == '[' && [self textStartsWithInvalidTag:[codeToParse substringWithRange:NSMakeRange(i, MIN(self.longestTagLength, length-i))]])
        {
            NSRange closeTag = [codeToParse rangeOfString:@"]" options:0 range:NSMakeRange(i, length-i)];
            
            NSAssert(closeTag.location != NSNotFound, @"No closing tag! Something went wrong.");
            
            i+=((closeTag.location+1)-i);

        }        
        
        // Otherwise, check if we just read the tag.
        else if (currentCharacter == ']' && self.currentTag != nil)
        {
            if ([self.currentTag hasPrefix:closingTag__])
                [self parseFinished];
            
            //img is special case - it can start and end with one set of brackets. e.g. [img=smiley.png]
            else if ([[self.currentTag lowercaseString] hasPrefix:@"img="])
            {
                NSLog(@"tag: %@", self.currentTag);
                [self parseStartedForTag:self.currentTag range:i];
                [self parseFinished];
            }
            
            else
                [self parseStartedForTag:self.currentTag range:i];
            
            self.currentTag = nil;
            readingTag = NO;
            
            i++;
        }
        
        // Otherwise just read.
        else
        {
            if (readingTag)
            {
                [self.currentTag appendFormat:@"%C", currentCharacter];
                i++;
            }
            else
            {
                BBParsingElement *element = [self getLastUnparsedElement];
                NSString *formatToAppend;
                
                //brackets that aren't part of a valid tag
                if (currentCharacter == '[' || currentCharacter == ']')
                {
                    formatToAppend = [NSString stringWithFormat:@"%C", currentCharacter];
                    
                    i++;
                    self.codeCounter++;
                }
                
                else
                {
                    NSRange range = [codeToParse rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"[]"] options:0 range:NSMakeRange(i, length - i)];
                    
                    if (range.location != NSNotFound)
                        formatToAppend = [codeToParse substringWithRange:NSMakeRange(i, range.location - i)];
                    
                    else
                        formatToAppend = [codeToParse substringFromIndex:i];
                    
                    self.codeCounter+=[formatToAppend length];
                    i+=[formatToAppend length];
                }
                
                
                NSRegularExpression *collapseLineBreaks = [NSRegularExpression regularExpressionWithPattern:@"\n+" options:NSRegularExpressionCaseInsensitive error:nil];
                formatToAppend = [collapseLineBreaks stringByReplacingMatchesInString:formatToAppend options:0 range:NSMakeRange(0, formatToAppend.length) withTemplate:@"\n"];
                
                
                
                //append new format
                [element.format appendString:formatToAppend];
                
                /*
                if ([[element.tag lowercaseString] isEqualToString:@"img"])
                {
                    //NSLog(@"%@", formatToAppend);
                }
                 */
                
            }
            
        }
        
    }    
    
    // In the end, finish parsing root element.
    [self parseFinished];
}


#pragma mark -
#pragma mark - Tags

+ (NSString *)startTagCharacter
{
    // WARNING!
    // If you change this, change also tagRegexPattern function!
    return @"{BB_";
}

+ (NSString *)endTagCharacter
{
    // WARNING!
    // If you change this, change also tagRegexPattern function!
    return @"_BB}";
}

+ (NSString *)tagRegexPattern
{
    // WARNING!
    // If you change this, you may also want to change startTagCharacter or endTagCharacter functions!
    return @"(\\{BB_[0-9]+_BB\\})";
}

#pragma mark -
#pragma mark - Dealloc

- (void)dealloc
{

}

@end
