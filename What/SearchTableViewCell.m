//
//  SearchCell.m
//  What
//
//  Created by What on 9/12/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "SearchTableViewCell.h"

@interface SearchTableViewCell ()

@property (nonatomic) UIRectCorner roundedCorners;

@end

@implementation SearchTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor colorFromHexString:cForumCellGradientLightColor];
        self.textLabel.textColor = [UIColor colorFromHexString:cCellFontDarkColor];
        self.textLabel.font = [Constants appFontWithSize:FONT_SIZE_SUBTITLE bolded:YES];
                
        if (!_selectedView) {
            _selectedView = [[SettingsCellSelectedView alloc] init];
        }
        
    }
    return self;
}

- (void)roundCorners:(UIRectCorner)corners {
    self.roundedCorners = corners;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if ([Constants iOSVersion] < 7.0) {
        UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:self.selectedView.bounds byRoundingCorners:self.roundedCorners cornerRadii:CGSizeMake(8.0f, 8.0f)];
        CAShapeLayer *shape = [[CAShapeLayer alloc] init];
        [shape setPath:rounded.CGPath];
        self.selectedView.layer.mask = shape;
        self.selectedBackgroundView = self.selectedView;
    }
    
    self.textLabel.frame = CGRectMake(CELL_PADDING, 0, CELL_WIDTH - CELL_PADDING*2, self.frame.size.height);
}

@end
