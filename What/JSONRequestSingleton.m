//
//  JSONRequestOperation.m
//  What
//
//  Created by What on 4/24/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "JSONRequestSingleton.h"
#import "UserSingleton.h"

@implementation JSONRequestSingleton

+ (JSONRequestSingleton *)sharedClient
{
    if ([UserSingleton sharedInstance].useSSL)
    {
        static JSONRequestSingleton * _sharedClient = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedClient = [[JSONRequestSingleton alloc] initWithBaseURL:[NSURL URLWithString:cHostNameSSL]];
        });
        
        return _sharedClient;
    }
    
    else
    {
        static JSONRequestSingleton * _sharedClient = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedClient = [[JSONRequestSingleton alloc] initWithBaseURL:[NSURL URLWithString:cHostName]];
        });
        
        return _sharedClient;
    }
}

-(id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self)
    {
        [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"text/plain", nil]];
        [self setParameterEncoding:AFJSONParameterEncoding];
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        [self setDefaultHeader:@"Content-type" value:@"application/json"];
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        
        [self setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            NSLog(@"network status changed: %@", [JSONRequestSingleton networkStatusIntToString:status]);
        }];
    }
    
    return self;
}

+(NSString *)networkStatusIntToString:(AFNetworkReachabilityStatus)status
{
    switch (status) {
        case AFNetworkReachabilityStatusUnknown:
            return @"NETWORK STATUS UNKNOWN";
            
        case AFNetworkReachabilityStatusNotReachable:
            return @"NETWORK STATUS NOT REACHABLE";
            
        case AFNetworkReachabilityStatusReachableViaWWAN:
            return @"NETWORK STATUS REACHABLE VIA WWAN";
            
        case AFNetworkReachabilityStatusReachableViaWiFi:
            return @"NETWORK STATUS REACHABLE VIA WIFI";
            
        default:
            return nil;
    }
}


@end
