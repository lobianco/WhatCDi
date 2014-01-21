//
//  CategoryCell.m
//  What
//
//  Created by What on 7/14/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "CategoryTableViewCell.h"

@interface CategoryTableViewCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation CategoryTableViewCell

@synthesize label = label_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        if (!label_)
        {
            label_ = [[UILabel alloc] initWithFrame:CGRectZero];
            [label_ setBackgroundColor:[UIColor clearColor]];
            [label_ setFont:[Constants appFontWithSize:FONT_SIZE_TITLE bolded:YES]];
            [label_ setNumberOfLines:2];
            [label_ setLineBreakMode:NSLineBreakByTruncatingTail];
            [label_ setTextColor:[UIColor colorFromHexString:cCellFontDarkColor]];
            [self.contentView addSubview:label_];
        }
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setForum:(WCDForum *)forum
{
    if (_forum != forum)
    {
        _forum = forum;
        
        self.label.text = _forum.name;

    }
    
    else
        DebugLog(@"ERROR: Already equal!");
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.label setFrame:CGRectMake(CELL_PADDING, CELL_PADDING, self.frame.size.width - CELL_PADDING*2 - ACCESSORY_WIDTH, 0)];
    [self.label sizeToFit];
    
}

+(CGFloat)heightForLabelText:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CELL_PADDING, CELL_PADDING, CELL_WIDTH - CELL_PADDING*2 - ACCESSORY_WIDTH, 0)];
    [label setFont:[Constants appFontWithSize:FONT_SIZE_TITLE bolded:YES]];
    [label setNumberOfLines:2];
    [label setLineBreakMode:NSLineBreakByTruncatingTail];
    [label setText:text];
    [label sizeToFit];
    
    return (label.frame.size.height + CELL_PADDING*2);
}

@end
