//
//  EANDataSingleton.h
//  What
//
//  Created by What on 5/11/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#define EAN_KEY @"46573C28518BAB45"

@interface EANDataSingleton : AFHTTPClient

+ (EANDataSingleton *)sharedClient;

@end
