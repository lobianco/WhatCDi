//
//  Dropbox.h
//  What
//
//  Created by What on 6/5/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlbumTableViewController.h"
#import <Dropbox/Dropbox.h>

@interface Dropbox : NSObject

+ (Dropbox *)sharedBox;

-(void)linkFromController:(UIViewController *)controller;
-(void)unlink;
-(BOOL)isLinked;

-(void)uploadWithFileName:(NSString *)filename fromPath:(NSString *)filepath;

@end
