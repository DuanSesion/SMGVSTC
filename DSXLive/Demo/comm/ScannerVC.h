//
//  ScannerVC.h
//  LiveDemo
//
//  Created by Wei Chen on 2018/6/22.
//  Copyright © 2018年 VideoSolar. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <AVFoundation/AVFoundation.h>

typedef void (^ScanResultBlock) (NSString *scode);

@interface ScannerVC : UIViewController<AVCaptureMetadataOutputObjectsDelegate>

@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (copy, nonatomic) ScanResultBlock scanRltBlock;

@end
