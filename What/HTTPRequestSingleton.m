//
//  HTTPRequestSingleton.m
//  What
//
//  Created by What on 4/24/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "HTTPRequestSingleton.h"
#import "UserSingleton.h"

@implementation HTTPRequestSingleton

+ (HTTPRequestSingleton *)sharedClient
{
    
    if ([UserSingleton sharedInstance].useSSL)
    {
        static HTTPRequestSingleton * _sharedClient = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedClient = [[HTTPRequestSingleton alloc] initWithBaseURL:[NSURL URLWithString:cHostNameSSL]];
        });
        
        return _sharedClient;
    }
    
    else
    {
        static HTTPRequestSingleton * _sharedClient = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedClient = [[HTTPRequestSingleton alloc] initWithBaseURL:[NSURL URLWithString:cHostName]];
        });
        
        return _sharedClient;
    }
}

-(id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self)
    {
        [AFHTTPRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"text/html", @"text/plain", nil]];
        [self registerHTTPOperationClass:[AFHTTPRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"text/html"];
        [self setDefaultHeader:@"Content-type" value:@"text/html"];
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        
        [self setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            NSLog(@"network status changed: %@", [HTTPRequestSingleton networkStatusIntToString:status]);
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