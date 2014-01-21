//
//  SectionInfo.h
//  What
//
//  Created by What on 7/15/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCDReleaseGroup.h"

@interface WCDSectionInfo : NSObject

@property (getter = isOpen) BOOL open;
@property (nonatomic, strong) WCDReleaseGroup *releaseGroup;


@end
