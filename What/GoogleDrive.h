//
//  GoogleDrive.h
//  What
//
//  Created by What on 6/5/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTMOAuth2ViewControllerTouch.h"

@interface GoogleDrive : NSObject

+ (GoogleDrive *)sharedDrive;
- (void)uploadFile:(NSString *)file fromPath:(NSString *)path success:(void(^)(void))success failure:(void(^)(NSError *error))failure;
- (BOOL)isAuthorized;
- (BOOL)unauthorize;
- (GTMOAuth2ViewControllerTouch *)createAuthController;

@end
