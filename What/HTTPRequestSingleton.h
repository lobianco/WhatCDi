//
//  HTTPRequestSingleton.h
//  What
//
//  Created by What on 4/24/13.
//  Copyright (c) 2013 What. All rights reserved.
//

@interface HTTPRequestSingleton : AFHTTPClient

+ (HTTPRequestSingleton *)sharedClient;

@end
