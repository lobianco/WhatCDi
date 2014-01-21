//
//  ImagePopupController.m
//  What
//
//  Created by What on 6/16/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "ImagePopupController.h"

#define IPHONE_WIDTH CELL_WIDTH
#define IPHONE_4_HEIGHT 480.f
#define IPHONE_5_HEIGHT 568.f

@interface ImagePopupController ()

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ImagePopupController

@synthesize image = image_;
@synthesize scrollView = scrollView_;
@synthesize imageView = imageView_;

-(id)initWithImage:(UIImage *)image
{
    self = [super init];
    
    if (self) {
        
        image_ = image;
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    image_ = nil;
    imageView_ = nil;
    scrollView_ = nil;
    
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
        
    [self.view setBackgroundColor:([Constants debug] ? [UIColor blueColor] : [UIColor blackColor])];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
            
    self.scrollView = [[UIScrollView alloc] init];
        
    if ([Constants deviceHasLargerScreen])
        [self.scrollView setFrame:(CGRect){.origin=CGPointMake(0, 0), .size=CGSizeMake(IPHONE_WIDTH, IPHONE_5_HEIGHT)}];
    else
        [self.scrollView setFrame:(CGRect){.origin=CGPointMake(0, 0), .size=CGSizeMake(IPHONE_WIDTH, IPHONE_4_HEIGHT)}];
    
    [self calculateScrollViewContentSize:self.scrollView.frame];
    [self.scrollView setBackgroundColor:([Constants debug] ? [UIColor redColor] : [UIColor blackColor])];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    

    self.imageView = [[UIImageView alloc] initWithImage:self.image];
    [self.imageView setFrame:(CGRect){.origin=CGPointMake(0, 0), .size=self.image.size}];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.scrollView addSubview:self.imageView];
    

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePopup:)];
    [self.scrollView addGestureRecognizer:tapGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    panGesture.delegate = self;
    [self.scrollView addGestureRecognizer:panGesture];
        
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self.scrollView];
    NSLog(@"%f %f", point.x, point.y);
}

-(void)didPan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.scrollView setContentOffset:CGPointZero animated:NO];
            
        } completion:nil];
    }
    
    else
    {
        CGPoint translation = [gesture translationInView:self.scrollView];
        [self.scrollView setContentOffset:CGPointMake(((translation.x * .5) * -1), ((translation.y * .5) * -1)) animated:NO];
    }
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //add 1 to compensate for the decimal fraction offset when setting content offset programatically
   return (self.imageView.frame.size.width <= (self.scrollView.frame.size.width + 1) && self.imageView.frame.size.height <= (self.scrollView.frame.size.height + 1));
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [self calculateScrollViewScaleFactors:self.scrollView.frame];
    [self centerScrollViewContents:self.scrollView.frame];
        
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)centerScrollViewContents:(CGRect)referenceFrame {
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < referenceFrame.size.width) {
        contentsFrame.origin.x = (referenceFrame.size.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < referenceFrame.size.height) {
        contentsFrame.origin.y = (referenceFrame.size.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imageView.center = CGPointMake(contentsFrame.size.width/2, contentsFrame.size.height/2);
    self.imageView.frame = contentsFrame;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self centerScrollViewContents:self.scrollView.bounds];
}

-(void)rotate:(NSNotification *)note
{
    CGFloat angle;
    CGRect frame;
    
    CGFloat width = IPHONE_WIDTH;
    CGFloat height = ([Constants deviceHasLargerScreen] ? IPHONE_5_HEIGHT : IPHONE_4_HEIGHT);
        
    switch ([[UIDevice currentDevice] orientation]) {
            
        case UIDeviceOrientationFaceDown:
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationUnknown:
            return;
            
        case UIDeviceOrientationPortraitUpsideDown:
            angle = M_PI;
            frame = (CGRect){.origin=CGPointMake(0, 0), .size=CGSizeMake(width, height)};
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            angle = M_PI_2;
            frame = CGRectMake(0, 0, height, width);
            break;
            
        case UIDeviceOrientationLandscapeRight:
            angle = - M_PI_2;
            frame = CGRectMake(0, 0, height, width);
            break;
            
        
        case UIDeviceOrientationPortrait:
        default:
            angle = 0.f;
            frame = (CGRect){.origin=CGPointMake(0, 0), .size=CGSizeMake(width, height)};
            break;
    }

    [self rotateViewToAngle:angle withFrame:frame];
}

-(void)rotateViewToAngle:(CGFloat)angle withFrame:(CGRect)frame
{
    
    [self calculateScrollViewContentSize:frame];
    
    CGAffineTransform rotate = CGAffineTransformMakeRotation(angle);

    [UIView animateWithDuration:0.4f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.view.transform = rotate;
        self.view.bounds = frame;
        self.scrollView.frame = frame;

        [self calculateScrollViewScaleFactors:frame];
        [self centerScrollViewContents:frame];
        
    } completion:^(BOOL finished) {
        

    }];
}

-(void)calculateScrollViewContentSize:(CGRect)referenceFrame
{
    CGFloat contentWidth;
    CGFloat contentHeight;
    
    if (referenceFrame.size.width > referenceFrame.size.height)
    {
        //landscape mode
        contentHeight = MAX(self.image.size.height, referenceFrame.size.height);
        contentWidth = (contentHeight / self.image.size.height) * self.image.size.width;
        
    }
    
    else
    {
        //portrait mode
        contentWidth = MAX(self.image.size.width, referenceFrame.size.width);
        contentHeight = (contentWidth / self.image.size.width) * self.image.size.height;
    }
    
    [self.scrollView setContentSize:CGSizeMake(contentWidth, contentHeight)];
}

-(void)calculateScrollViewScaleFactors:(CGRect)referenceFrame
{
    CGFloat scaleWidth = referenceFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = referenceFrame.size.height / self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    self.scrollView.minimumZoomScale = minScale;
    
    //calculate max scale
    if (scaleWidth > scaleHeight)
    {
        //picture will hit top and bottom of screen before left and right
        
        CGFloat imageHeightMax = MAX(self.image.size.height, referenceFrame.size.height);
        CGFloat maxScale = (imageHeightMax / self.image.size.height);
        
        self.scrollView.maximumZoomScale = maxScale;
        
        self.scrollView.zoomScale = (self.image.size.height < referenceFrame.size.height ? maxScale : minScale);
    }
    
    else
    {
        //picture will hit left and right before top and bottom
        
        CGFloat imageWidthMax = MAX(self.image.size.width, referenceFrame.size.width);
        CGFloat maxScale = (imageWidthMax / self.image.size.width);
        
        self.scrollView.maximumZoomScale = maxScale;
        
        self.scrollView.zoomScale = (self.image.size.width < referenceFrame.size.width ? maxScale : minScale);
    }
    
}


-(void)closePopup:(UITapGestureRecognizer *)gesture
{

    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    [self dismissViewControllerAnimated:NO completion:nil];

}

@end
