//
//  SettingsTableHeader.m
//  What
//
//  Created by What on 8/7/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "SettingsTableHeader.h"
#import "UIButton+Tools.h"

static const CGFloat circleDiameter = 10.f;

@interface SettingsTableHeader ()

@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) UIImage *checkmarkImage;

@end

@implementation SettingsTableHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
                
        if (!_titleLabel)
        {
            _titleLabel = [[UILabel alloc] init];
            _titleLabel.textColor = [UIColor colorFromHexString:cMenuTableFontColor];
            _titleLabel.font = [Constants appFontWithSize:19 bolded:YES];
            _titleLabel.numberOfLines = 1;
            _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            _titleLabel.backgroundColor = [UIColor clearColor];
            _titleLabel.text = @"Settings";
            [self addSubview:_titleLabel];
        }
        
        /*
        if (!_doneButton)
        {
            _checkmarkImage = [UIImage imageNamed:@"../Images/checkmarkLight.png"];
            _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_doneButton setImage:_checkmarkImage forState:UIControlStateNormal];
            //[_doneButton addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
            [_doneButton setShowsTouchWhenHighlighted:YES];
            [self addSubview:_doneButton];
        }
         */
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize titleLabelSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(CELL_WIDTH, CGFLOAT_MAX) lineBreakMode:NSLineBreakByTruncatingTail];
    self.titleLabel.frame = CGRectMake((self.frame.size.width/2) - (titleLabelSize.width/2), self.frame.size.height -[SettingsTableHeader height], titleLabelSize.width, [SettingsTableHeader height]);
    
    //self.doneButton.frame = CGRectMake(self.frame.size.width - CELL_PADDING*1.5 - self.checkmarkImage.size.width, self.frame.size.height - (self.checkmarkImage.size.height/2) - 20.f, self.checkmarkImage.size.width, self.checkmarkImage.size.height);
    //[self.doneButton expandHitTestEdgeInsets];
    
    [self.firstBottomSeparator setFrame:CGRectMake(0, self.frame.size.height - 2.f, CELL_WIDTH, 1.f)];
    [self.secondBottomSeparator setFrame:CGRectMake(0, self.frame.size.height - 1.f, CELL_WIDTH, 1.f)];
}

+(CGFloat)height
{
    return 40.f;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect circleRect1 = CGRectMake(self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + CELL_PADDING*3, rect.size.height - 20.f - (circleDiameter/2), circleDiameter, circleDiameter);
    CGRect circleRect2 = CGRectMake(circleRect1.origin.x + CELL_PADDING/2 + circleDiameter, circleRect1.origin.y, circleDiameter, circleDiameter);
    CGRect circleRect3 = CGRectMake(self.titleLabel.frame.origin.x - CELL_PADDING*3 - circleDiameter, circleRect1.origin.y, circleDiameter, circleDiameter);
    CGRect circleRect4 = CGRectMake(circleRect3.origin.x - CELL_PADDING/2 - circleDiameter, circleRect1.origin.y, circleDiameter, circleDiameter);
    CGContextSetFillColorWithColor(context, [UIColor colorFromHexString:cMenuTableFontColor alpha:0.4].CGColor);
    CGContextFillEllipseInRect(context, circleRect1);
    CGContextFillEllipseInRect(context, circleRect2);
    CGContextFillEllipseInRect(context, circleRect3);
    CGContextFillEllipseInRect(context, circleRect4);
}


@end
