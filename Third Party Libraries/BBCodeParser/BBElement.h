//
//  BBElement.h
//  BBCodeParser
//
//  Created by Miha Rataj on 2/2/12.
//  Copyright (c) 2012 Marg, d.o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBAttribute.h"

@interface BBElement : NSObject

@property (nonatomic, copy) NSString *tag;
@property (weak, nonatomic, readonly) NSString *plainText;

//must be strong if mutable
@property (nonatomic, strong) NSMutableString *format;
@property (nonatomic, strong) NSArray *attributes;
@property (nonatomic, strong) NSArray *elements;
@property (nonatomic, weak) BBElement *parent;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger range;

- (BBAttribute *)attributeWithName:(NSString *)name;
- (BBElement *)elementAtIndex:(NSInteger)index;

@end
