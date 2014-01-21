//
//  ProfileStatsFooter.m
//  What
//
//  Created by What on 6/22/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "ProfileStatsFooter.h"
#import "MarqueeLabel.h"

#define BAR1_HEIGHT 17.f
#define BAR2_HEIGHT 23.f
#define BAR3_HEIGHT 11.f
#define BAR_WIDTH 3.f
#define BAR_SPACING 2.f

@interface ProfileStatsFooter ()

@property (nonatomic, strong) MarqueeLabel *statsLabel;

@end

@implementation ProfileStatsFooter

@synthesize statsLabel = statsLabel_;

@synthesize paranoiaLevel = paranoiaLevel_;
@synthesize ratio = ratio_;
@synthesize upload = upload_;
@synthesize download = download_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setBackgroundColor:[UIColor darkGrayColor]];
        
        
        /*
        [ratioLabel_ setFont:[Constants appFontWithSize:RATIO_CELL_FONT_SIZE bolded:YES]];
        [ratioLabel_ setBackgroundColor:[UIColor clearColor]];
        [ratioLabel_ setTextColor:[UIColor lightGrayColor]];
        [ratioLabel_ setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:ratioLabel_];
         */
        
        statsLabel_ = [[MarqueeLabel alloc] initWithFrame:CGRectZero rate:60.f andFadeLength:0.f];
        //statsLabel_ = [[UILabel alloc] init];
        [statsLabel_ setContinuousMarqueeExtraBuffer:40.f];
        statsLabel_.font = [Constants appFontWithSize:12.f oblique:YES];
        [statsLabel_ setMarqueeType:MLContinuous];
        [statsLabel_ setAnimationDelay:3.f];
        [statsLabel_ setAnimationCurve:UIViewAnimationOptionCurveLinear];
        [statsLabel_ setBackgroundColor:[UIColor clearColor]];
        [statsLabel_ setTextColor:[UIColor lightGrayColor]];
        [statsLabel_ setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:statsLabel_];
        
        paranoiaLevel_ = [[NSString alloc] init];

    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    NSMutableAttributedString *attributedParanoia = [[NSMutableAttributedString alloc] initWithString:@"Paranoia: Very High"];
    
    [attributedParanoia beginEditing];
    [attributedParanoia addAttribute:NSFontAttributeName value:[Constants appFontWithSize:14.f bolded:YES] range:NSMakeRange(0, 9)];
    [attributedParanoia endEditing];
    
    //self.statsLabel.attributedText = attributedParanoia;
    self.statsLabel.text = [NSString stringWithFormat:@"Paranoia: %@  |  Ratio: %@  |  Uploaded: %@  |  Downloaded: %@", self.paranoiaLevel, self.ratio, self.upload, self.download];
    self.statsLabel.frame = CGRectMake(CELL_PADDING*2.5, 0, self.frame.size.width - CELL_PADDING*3.5, self.frame.size.height);
    [self.statsLabel setFadeLength:10.f];
    
    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGRect bar1 = CGRectMake(8, self.frame.size.height - BAR1_HEIGHT - 8, BAR_WIDTH, BAR1_HEIGHT);
    CGRect bar2 = CGRectMake(bar1.origin.x + bar1.size.width + BAR_SPACING, self.frame.size.height - BAR2_HEIGHT - 8, BAR_WIDTH, BAR2_HEIGHT);
    CGRect bar3 = CGRectMake(bar2.origin.x + bar2.size.width + BAR_SPACING, self.frame.size.height - BAR3_HEIGHT - 8, BAR_WIDTH, BAR3_HEIGHT);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);

    CGContextFillRect(context, bar1);
    CGContextFillRect(context, bar2);
    CGContextFillRect(context, bar3);
}


@end
