//
//  MusicBrainzSingleton.h
//  What
//
//  Created by What on 5/8/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#define GOOGLE_KEY @"AIzaSyCrIKDu_kRtqc7Wjv4xRi0xQnWzwx-hLRI"

@interface GoogleSingleton : AFHTTPClient

+ (GoogleSingleton *)sharedClient;

@end
