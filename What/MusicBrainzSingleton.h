//
//  MusicBrainzSingleton.h
//  What
//
//  Created by What on 5/11/13.
//  Copyright (c) 2013 What. All rights reserved.
//

@interface MusicBrainzSingleton : AFHTTPClient

+ (MusicBrainzSingleton *)sharedClient;

@end