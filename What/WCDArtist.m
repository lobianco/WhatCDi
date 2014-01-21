//
//  ALArtist.m
//  What
//
//  Created by What on 7/15/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "WCDArtist.h"

@implementation WCDArtist

- (void)dealloc {
    NSLog(@"artist model dealloc");
    _imageURL = nil;
    _name = nil;
    _albumsDictionary = nil;
}

@end
