//
//  BarcodeViewController.m
//  What
//
//  Created by What on 5/8/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "BarcodeController.h"
#import "API.h"
#import <AVFoundation/AVFoundation.h>

@interface BarcodeController () <ZBarReaderDelegate>
{
    @private
    BOOL isFocusing;
}

@end

@implementation BarcodeController

@synthesize delegate; //synthesize delegate

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        
        ZBarImageScanner *zScanner = self.scanner;
        // EXAMPLE: disable rarely used I2/5 to improve performance
        [zScanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.readerDelegate = self;
    [self setCameraFlashMode:UIImagePickerControllerCameraFlashModeOff];
    self.supportedOrientationsMask = ZBarOrientationMask(UIInterfaceOrientationMaskPortrait);
    
    //hide info button
    int infoButtonIndex = [Constants iOSVersion] < IOS6 ? 2 : 3;
    UIButton *infoButton = [[[[[self.view.subviews objectAtIndex:2] subviews] objectAtIndex:0] subviews] objectAtIndex:infoButtonIndex];
    [infoButton setHidden:YES];
    
    self.wantsFullScreenLayout = YES;
    self.tracksSymbols = YES;
    
    //gestures
    UITapGestureRecognizer *tapToFocus = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusCamera:)];
    UIView *cameraOverlay = [[UIView alloc] initWithFrame:self.view.frame];
    [cameraOverlay addGestureRecognizer:tapToFocus];
    [self setCameraOverlayView:cameraOverlay];
}

#pragma mark - Scanner Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    
    ZBarSymbol *symbol;
    for (ZBarSymbol *sym in results) {
        symbol = sym;
        break;
    }

    [self delegateCallbackWithUPC:symbol.data];
}

# pragma mark - Focus Camera

- (void)focusCamera:(id)sender
{
    if (!isFocusing)
    {
        CGPoint touchPoint = [(UITapGestureRecognizer*)sender locationInView:self.cameraOverlayView];
        double focus_x = touchPoint.x/self.cameraOverlayView.frame.size.width;
        double focus_y = (touchPoint.y+66)/self.cameraOverlayView.frame.size.height;
        NSError *error;
        NSArray *devices = [AVCaptureDevice devices];
        for (AVCaptureDevice *device in devices)
        {
            if ([device hasMediaType:AVMediaTypeVideo])
            {
                if ([device position] == AVCaptureDevicePositionBack)
                {
                    CGPoint point = CGPointMake(focus_y, 1-focus_x);
                    if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus] && [device lockForConfiguration:&error])
                    {
                        isFocusing = YES;
                        [device setFocusPointOfInterest:point];
                        CGRect rect = CGRectMake(touchPoint.x-30, touchPoint.y-30, 60, 60);
                        UIView *focusRect = [[UIView alloc] initWithFrame:rect];
                        focusRect.layer.borderColor = [UIColor greenColor].CGColor;
                        focusRect.layer.borderWidth = 2;
                        [self.cameraOverlayView addSubview:focusRect];
                        //[self performSelector:@selector(dismissFocusRect:) withObject:focusRect afterDelay:1.f];
                        [self dismissFocusRect:focusRect];
                        [device setFocusMode:AVCaptureFocusModeAutoFocus];
                        [device unlockForConfiguration];
                    }
                }
            }
        }
    }
}

- (void)dismissFocusRect:(id)object
{
    UIView *focusRect = (UIView *)object;
    focusRect.alpha = 0;
    
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:^{
            
            [focusRect removeFromSuperview];
            isFocusing = NO;
            
        }];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [animation setFromValue:[NSNumber numberWithFloat:0.0]];
        [animation setToValue:[NSNumber numberWithFloat:1.0]];
        [animation setDuration:0.2f];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [animation setAutoreverses:YES];
        [animation setRepeatCount:2];
        [[focusRect layer] addAnimation:animation forKey:@"opacity"];
    }
}


# pragma mark - Rotation

-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate Callback

-(void)delegateCallbackWithUPC:(NSString *)upc
{
    if ([self.delegate respondsToSelector:@selector(handleBarcode:)])
        [self.delegate handleBarcode:upc];
    
    else
        NSLog(@"delegate doesn't respond to bar code handler");
}

@end
