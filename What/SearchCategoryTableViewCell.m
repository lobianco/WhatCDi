//
//  SearchCategoryCell.m
//  What
//
//  Created by What on 6/7/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "SearchCategoryTableViewCell.h"

#define IMAGE_WIDTH 30.f

@interface SearchCategoryTableViewCell ()

@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) NSString *defaultText;

@end

@implementation SearchCategoryTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        /*
        if (!_image)
        {
            _image = [[UIImageView alloc] init];
            [self.contentView addSubview:_image];
        }
         */
        
        if (!_categoryLabel)
        {
            _categoryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [_categoryLabel setBackgroundColor:[UIColor clearColor]];
            [_categoryLabel setTextColor:[UIColor colorFromHexString:cCellFontDarkColor]];
            [_categoryLabel setFont:[Constants appFontWithSize:FONT_SIZE_SUBTITLE bolded:YES]];
            [_categoryLabel setLineBreakMode:NSLineBreakByTruncatingMiddle];
            [self.contentView addSubview:_categoryLabel];
        }
        
    }
    return self;
}

-(void)setCellType:(CellType)type
{
    if (type == UserCellType)
    {
        self.defaultText = @"Search users for";
        //self.image.image = [UIImage resizeImage:[UIImage imageNamed:@"../Images/silhouette.png"] newSize:CGSizeMake(self.frame.size.height - 1.f, self.frame.size.height - 1.f) contentMode:self.image.contentMode];
    }
    
    else if (type == ArtistCellType)
    {
        self.defaultText = @"Search artists for";
        //self.image.image = [UIImage resizeImage:[UIImage imageNamed:@"../Images/artistSearch.png"] newSize:CGSizeMake(self.frame.size.height - 1.f, self.frame.size.height - 1.f) contentMode:self.image.contentMode];
    }
    
    else if (type == AlbumCellType)
    {
        self.defaultText = @"Search albums for";
        //self.image.image = [UIImage resizeImage:[UIImage imageNamed:@"../Images/albumSearch.png"] newSize:CGSizeMake(self.frame.size.height - 1.f, self.frame.size.height - 1.f) contentMode:self.image.contentMode];
    }
    
    self.categoryLabel.text = [NSString stringWithFormat:@"%@...", self.defaultText];
}

-(void)appendText:(NSString *)text
{
    NSString *newText = [NSString stringWithFormat:@"%@ %@", self.defaultText, text];
    self.categoryLabel.text = newText;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //self.image.frame = CGRectMake(0, 0, self.frame.size.height - 1.f, self.frame.size.height - 1.f);
    
    self.categoryLabel.frame = CGRectMake(CELL_PADDING + self.imageView.frame.size.width, 0, CELL_WIDTH - CELL_PADDING*4 - self.imageView.frame.size.width, self.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
