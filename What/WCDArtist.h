//
//  ALArtist.h
//  What
//
//  Created by What on 7/15/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCDArtist : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger idNum;
@property (nonatomic, strong) NSURL *imageURL;
//@property (nonatomic, strong) NSArray *albums;

//dict is sorted by release type
@property (nonatomic, strong) NSDictionary *albumsDictionary;

@end
