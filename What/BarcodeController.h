//
//  BarcodeViewController.h
//  What
//
//  Created by What on 5/8/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "ZBarReaderViewController.h"

@class BarcodeController; //define class so protocal can see it
@protocol ALBarcodeDelegate <NSObject> //define delegate protocol
@required //define required or optional
-(void)handleBarcode:(NSString *)upc; //define delegate method
@end

@interface BarcodeController : ZBarReaderViewController

@property (nonatomic, weak) id <ALBarcodeDelegate> delegate; //define delegate property
@end
