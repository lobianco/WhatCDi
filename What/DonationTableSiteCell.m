//
//  DonationTableSiteCell.m
//  What.CD
//
//  Created by What on 10/14/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "DonationTableSiteCell.h"

@interface DonationTableSiteCell ()

@property (nonatomic, strong) UIImage *buttonImage;
@property (nonatomic, strong) UILabel *siteDonationLabel;
@property (nonatomic, strong) UILabel *websiteAddressLabel;

@end

@implementation DonationTableSiteCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (!_siteDonationLabel) {
            _siteDonationLabel = [[UILabel alloc] init];
            _siteDonationLabel.text = @"If you still have some extra cash, please also consider donating to What.CD. The site could really use our help and it’s up to you and me to keep it alive.";
            _siteDonationLabel.textColor = [UIColor colorFromHexString:cMenuTableFontColor];
            _siteDonationLabel.font = [Constants appFontWithSize:12.f];
            _siteDonationLabel.backgroundColor = [UIColor clearColor];
            _siteDonationLabel.numberOfLines = 0;
            [self.contentView addSubview:_siteDonationLabel];
        }
        
        if (!_donateButton) {
            _buttonImage = [UIImage imageNamed:@"../Images/donateButton.png"];
            _donateButton = [DonateButton buttonWithType:UIButtonTypeCustom];
            [_donateButton setBackgroundImage:_buttonImage forState:UIControlStateNormal];
            [_donateButton.titleLabel setFont:[Constants appFontWithSize:20.f bolded:YES]];
            [_donateButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
            [_donateButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.8] forState:UIControlStateNormal];
            [_donateButton setTitle:@"Donate to the site" forState:UIControlStateNormal];
            _donateButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 16.f, 0);
            _donateButton.donatePath = @"https://what.cd/donate.php";
            [self.contentView addSubview:_donateButton];
            
        }
        
        if (!_websiteAddressLabel) {
            _websiteAddressLabel = [[UILabel alloc] init];
            _websiteAddressLabel.text = @"https://what.cd/donate.php";
            _websiteAddressLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.6];
            _websiteAddressLabel.font = [Constants appFontWithSize:13.f];
            _websiteAddressLabel.backgroundColor = [UIColor clearColor];
            _websiteAddressLabel.numberOfLines = 1;
            [_websiteAddressLabel setTextAlignment:NSTextAlignmentCenter];
            _websiteAddressLabel.layer.shadowColor = [UIColor colorFromHexString:@"29607f"].CGColor;
            _websiteAddressLabel.layer.shadowOffset = CGSizeMake(0, -1);
            _websiteAddressLabel.layer.shadowRadius = 0.f;
            _websiteAddressLabel.layer.shadowOpacity = 0.6f;
            [self.contentView addSubview:_websiteAddressLabel];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat siteDonationWidth = self.frame.size.width - CELL_PADDING*2;;
    self.siteDonationLabel.frame = CGRectMake(CELL_PADDING, CELL_PADDING, siteDonationWidth, 0);
    [self.siteDonationLabel sizeToFit];
    CGRect siteDonationFrame = self.siteDonationLabel.frame;
    siteDonationFrame.size.width = siteDonationWidth;
    self.siteDonationLabel.frame = siteDonationFrame;
    
    self.donateButton.frame = CGRectMake(self.frame.size.width/2 - self.buttonImage.size.width/2, self.frame.size.height - self.buttonImage.size.height - CELL_PADDING, self.buttonImage.size.width, self.buttonImage.size.height);
    self.websiteAddressLabel.frame = CGRectMake(0, self.donateButton.frame.origin.y + self.donateButton.frame.size.height/2 + 4.f, self.frame.size.width, 20.f);
}

@end
