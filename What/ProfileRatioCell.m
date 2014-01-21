//
//  ProfileRatioCell.m
//  What
//
//  Created by What on 5/30/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "ProfileRatioCell.h"

@implementation ProfileRatioCell

@synthesize ratioLabel = ratioLabel_;
@synthesize uploadLabel = uploadLabel_;
@synthesize downloadLabel = downloadLabel_;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //[self setLeftSwipeRestrictFactor:8];
        //[self setRightSwipeRestrictFactor:4];
        
        if (!ratioLabel_)
        {
            //ratio label
            ratioLabel_ = [[UILabel alloc] init];
            [ratioLabel_ setFont:[Constants appFontWithSize:RATIO_CELL_FONT_SIZE bolded:YES]];
            [ratioLabel_ setBackgroundColor:[UIColor clearColor]];
            [ratioLabel_ setTextColor:[UIColor darkGrayColor]];
            [ratioLabel_ setTextAlignment:NSTextAlignmentCenter];
            [self.contentView addSubview:ratioLabel_];
        }
        
        if (!uploadLabel_)
        {
            //upload label
            uploadLabel_ = [[UILabel alloc] init];
            [uploadLabel_ setFont:[Constants appFontWithSize:RATIO_CELL_FONT_SIZE bolded:YES]];
            [uploadLabel_ setBackgroundColor:[UIColor clearColor]];
            [uploadLabel_ setTextColor:[UIColor darkGrayColor]];
            [uploadLabel_ setTextAlignment:NSTextAlignmentCenter];
            [self.contentView addSubview:uploadLabel_];
        }
        
        if (!downloadLabel_)
        {
            //download label
            downloadLabel_ = [[UILabel alloc] init];
            [downloadLabel_ setFont:[Constants appFontWithSize:RATIO_CELL_FONT_SIZE bolded:YES]];
            [downloadLabel_ setBackgroundColor:[UIColor clearColor]];
            [downloadLabel_ setTextColor:[UIColor darkGrayColor]];
            [downloadLabel_ setTextAlignment:NSTextAlignmentCenter];
            [self.contentView addSubview:downloadLabel_];
        }
        
    }
    
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.ratioLabel.frame = CGRectMake(0, 0, self.frame.size.width / 3, RATIO_CELL_HEIGHT);
    self.uploadLabel.frame = CGRectMake(ratioLabel_.frame.origin.x + ratioLabel_.frame.size.width, 0, self.frame.size.width / 3, RATIO_CELL_HEIGHT);
    self.downloadLabel.frame = CGRectMake(uploadLabel_.frame.origin.x + uploadLabel_.frame.size.width, 0, self.frame.size.width / 3, RATIO_CELL_HEIGHT);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
