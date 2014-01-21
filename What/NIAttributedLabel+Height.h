//
//  NSAttributedString+Height.h
//  What
//
//  Created by What on 5/15/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "NIAttributedLabel.h"

@interface NIAttributedLabel (Height)

-(CGFloat)heightForStringWithFixedWidth:(CGFloat)width;

@end
