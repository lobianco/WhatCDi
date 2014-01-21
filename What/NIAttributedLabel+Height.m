//
//  NSAttributedString+Height.m
//  What
//
//  Created by What on 5/15/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "NIAttributedLabel+Height.h"

@implementation NIAttributedLabel (Height)

-(CGFloat)heightForStringWithFixedWidth:(CGFloat)width
{
    /*
    if (self.attributedString.length == 0)
    {
        CGSize maximumLabelSize = CGSizeMake(width, FLT_MAX);
        CGSize expectedLabelSize = [self.text sizeWithFont:self.font constrainedToSize:maximumLabelSize lineBreakMode:self.lineBreakMode];
        
        return expectedLabelSize.height;
    }
        
        
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) self.attributedString);
    CGSize targetSize = CGSizeMake(width, CGFLOAT_MAX);
    CGSize fitSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [self.attributedString length]), NULL, targetSize, NULL);
    CFRelease(framesetter);
    
    return fitSize.height;
     */
    
    NSAssert(NO, @"ERROR");
    return 0;
}

@end
