//
//  Skydrive.h
//  What
//
//  Created by What on 6/6/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "LiveConnectClient.h"

@interface Skydrive : NSObject// <LiveOperationDelegate, LiveUploadOperationDelegate, LiveAuthDelegate>

-(void)uploadFile:(NSString *)filePath;

@end
