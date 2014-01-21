//
//  MusicBrainzSingleton.m
//  What
//
//  Created by What on 5/8/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "GoogleSingleton.h"

#define GOOGLE_BASE_URL @"https://www.googleapis.com"

@implementation GoogleSingleton

+ (GoogleSingleton *)sharedClient
{
    static GoogleSingleton * _sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[GoogleSingleton alloc] initWithBaseURL:[NSURL URLWithString:GOOGLE_BASE_URL]];
    });
    
    return _sharedClient;
}

-(id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self)
    {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        [self setDefaultHeader:@"Content-type" value:@"application/json"];
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    }
    
    return self;
}

@end
