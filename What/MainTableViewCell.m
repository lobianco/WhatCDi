//
//  GradientCell.m
//  What
//
//  Created by What on 7/14/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "MainTableViewCell.h"
#import "MainCellGradientView.h"
#import "ForumTableSeparator.h"
#import "MainCellAccessoryView.h"
#import "MainCellSelectedView.h"
#import "UIImage+Tools.h"

@interface MainTableViewCell ()

@property (nonatomic, strong) MainCellGradientView *gradientView;
@property (nonatomic, strong) UIView *noise;
@property (nonatomic, strong) ForumTableSeparator *topSeparator;
@property (nonatomic, strong) ForumTableSeparator *bottomSeparator;
@property (nonatomic, strong) MainCellSelectedView *selectedView;

@end

@implementation MainTableViewCell

@synthesize gradientView = gradientView_;
@synthesize bottomSeparator = bottomSeparator_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.accessoryView = [[MainCellAccessoryView alloc] init];
        
        if (!gradientView_)
        {
            gradientView_ = [[MainCellGradientView alloc] init];
            self.backgroundView = gradientView_;
        }
        
        if (!_noise) {
            UIColor *pattern = [UIColor colorWithPatternImage:[UIImage noiseWithSixPercentAlpha]];
            _noise = [[UIView alloc] init];
            [_noise setBackgroundColor:pattern];
            [self.contentView addSubview:_noise];
        }
        
        if (!_topSeparator)
        {
            _topSeparator = [[ForumTableSeparator alloc] initWithColorHex:cForumTableSeparatorLightColor];
            //_topSeparator.transform = CGAffineTransformMakeRotation(M_PI);
            [self.contentView addSubview:_topSeparator];
        }
        
        if (!bottomSeparator_)
        {
            bottomSeparator_ = [[ForumTableSeparator alloc] initWithColorHex:cForumTableSeparatorDarkColor];
            [self.contentView addSubview:bottomSeparator_];
        }
        
        if (!_selectedView)
        {
            _selectedView = [[MainCellSelectedView alloc] init];
            self.selectedBackgroundView = _selectedView;
        }
        
    }
    return self;
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    MainCellSelectedView *selectedView = (MainCellSelectedView*)self.selectedBackgroundView;
    selectedView.bottomShadow.alpha = 1.f;
    
    if (highlighted) {
        if (animated) {
            [UIView animateWithDuration:0.3f delay:0 options:0 animations:^{
                
                self.topSeparator.alpha = 0.f;
                self.bottomSeparator.alpha = 0.f;
                
            } completion:nil];
        }
        
        else {
            self.topSeparator.alpha = 0.f;
            self.bottomSeparator.alpha = 0.f;
        }
    }
    
    else {
        if (animated) {
            [UIView animateWithDuration:0.3f delay:0 options:0 animations:^{
                
                self.topSeparator.alpha = 1.f;
                self.bottomSeparator.alpha = 1.f;
                
            } completion:nil];
        }
        
        else {
            self.topSeparator.alpha = 1.f;
            self.bottomSeparator.alpha = 1.f;
        }
    }
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{    
    [super setSelected:selected animated:animated];
    [self setHighlighted:selected animated:animated];
    
    MainCellSelectedView *selectedView = (MainCellSelectedView*)self.selectedBackgroundView;
    selectedView.bottomShadow.alpha = 0;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.gradientView setFrame:self.bounds];
    [self.noise setFrame:self.bounds];
    
    if (self.accessoryView)
        self.accessoryView.frame = CGRectMake(self.frame.size.width - ACCESSORY_WIDTH - CELL_PADDING, self.frame.size.height/2 - ACCESSORY_HEIGHT/2, ACCESSORY_WIDTH, ACCESSORY_HEIGHT);
    
    CGFloat bottomSeparatorHeight = [Constants deviceHasRetinaScreen] ? 0.5f : 1.f;
    [self.topSeparator setFrame:CGRectMake(0, 0, CELL_WIDTH, 1.f)];
    [self.bottomSeparator setFrame:CGRectMake(0, self.frame.size.height - bottomSeparatorHeight, CELL_WIDTH, bottomSeparatorHeight)];
}


@end
