//
//  EANDataSingleton.m
//  What
//
//  Created by What on 5/11/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "EANDataSingleton.h"

#define EANDATA_BASE_URL @"http://m.eandata.com"

@implementation EANDataSingleton

+ (EANDataSingleton *)sharedClient
{
    static EANDataSingleton * _sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[EANDataSingleton alloc] initWithBaseURL:[NSURL URLWithString:EANDATA_BASE_URL]];
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
