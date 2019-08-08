//
//  ScannerVC.m
//  LiveDemo
//
//  Created by Wei Chen on 2018/6/22.
//  Copyright © 2018 VideoSolar. All rights reserved.
//

#import "ScannerVC.h"

#define QRCodeWidth  260.0   //正方形二维码框的边长
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface ScannerVC ()
@property (nonatomic, strong) UIImageView *scanNetImageView;
@end

@implementation ScannerVC

- (void)back {
  [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  UIButton *backBtn = [UIButton new];
  [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
  [backBtn setImage:[UIImage imageNamed:@"back_close_white"] forState:UIControlStateNormal];
  backBtn.frame = CGRectMake(30, 30, 30, 30);
  [self.view addSubview:backBtn];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  
  
  [self setNav];
  
  // Device
  _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  
  // Input
  _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
  
  // Output
  _output = [[AVCaptureMetadataOutput alloc]init];
  [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
  //设置扫描区域，x与y对换了，宽与高也对换了
  //特别注意的地方：有效的扫描区域，定位是以设置的右顶点为原点。屏幕宽所在的那条线为y轴，屏幕高所在的线为x轴
  CGFloat x = ((SCREEN_HEIGHT-QRCodeWidth-64)/2.0)/SCREEN_HEIGHT;
  CGFloat y = ((SCREEN_WIDTH-QRCodeWidth)/2.0)/SCREEN_WIDTH;
  CGFloat width = QRCodeWidth/SCREEN_HEIGHT;
  CGFloat height = QRCodeWidth/SCREEN_WIDTH;
  _output.rectOfInterest = CGRectMake(x, y, width, height);
  
  
  // Session
  _session = [[AVCaptureSession alloc]init];
  [_session setSessionPreset:AVCaptureSessionPresetHigh];
  if ([_session canAddInput:self.input])
  {
    [_session addInput:self.input];
  }
  
  if ([_session canAddOutput:self.output])
  {
    [_session addOutput:self.output];
  }
  
  //    条码类型 AVMetadataObjectTypeQRCode
  _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
  
  // Preview
  _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
  _preview.videoGravity =AVLayerVideoGravityResizeAspectFill;
  _preview.frame =self.view.layer.bounds;
  [self.view.layer insertSublayer:_preview atIndex:0];
  
  self.scanNetImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_code"]];
  self.scanNetImageView.frame = CGRectMake((SCREEN_WIDTH-QRCodeWidth)/2.0, (SCREEN_HEIGHT-3*QRCodeWidth)/2.0, QRCodeWidth, QRCodeWidth);
  [self.view addSubview:self.scanNetImageView];
  
  
  //扫描框
  [self setupMaskView];
  
  //扫描动画
  [self setupScanWindowView];
  
  // Start
  [_session startRunning];
  [self startAnimation];
}

- (void)startAnimation {
  CABasicAnimation *scanNetAnimation = [CABasicAnimation animation];
  scanNetAnimation.keyPath = @"transform.translation.y";
  scanNetAnimation.byValue = @(QRCodeWidth);
  scanNetAnimation.duration = 2.0;
  scanNetAnimation.repeatCount = MAXFLOAT;
  scanNetAnimation.removedOnCompletion = NO;
  [self.scanNetImageView.layer addAnimation:scanNetAnimation forKey:@"scanNetAnimation"];
}

- (void)stopAnimation {
  [self.scanNetImageView.layer removeAllAnimations];
}

- (void)setupMaskView
{
  //设置统一的视图颜色和视图的透明度
  UIColor *color = [UIColor blackColor];
  float alpha = 0.8;
  
  //设置扫描区域外部上部的视图
  UIView *topView = [[UIView alloc]init];
  topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_HEIGHT-QRCodeWidth)/2.0);
  topView.backgroundColor = color;
  topView.alpha = alpha;
  
  //设置扫描区域外部左边的视图
  UIView *leftView = [[UIView alloc]init];
  leftView.frame = CGRectMake(0, topView.frame.size.height, (SCREEN_WIDTH-QRCodeWidth)/2.0,QRCodeWidth);
  leftView.backgroundColor = color;
  leftView.alpha = alpha;
  
  //设置扫描区域外部右边的视图
  UIView *rightView = [[UIView alloc]init];
  rightView.frame = CGRectMake((SCREEN_WIDTH-QRCodeWidth)/2.0+QRCodeWidth,topView.frame.size.height, (SCREEN_WIDTH-QRCodeWidth)/2.0,QRCodeWidth);
  rightView.backgroundColor = color;
  rightView.alpha = alpha;
  
  //设置扫描区域外部底部的视图
  UIView *botView = [[UIView alloc]init];
  botView.frame = CGRectMake(0, QRCodeWidth+topView.frame.size.height,SCREEN_WIDTH,SCREEN_HEIGHT-QRCodeWidth-topView.frame.size.height);
  botView.backgroundColor = color;
  botView.alpha = alpha;
  
  //将设置好的扫描二维码区域之外的视图添加到视图图层上
  [self.view addSubview:topView];
  [self.view addSubview:leftView];
  [self.view addSubview:rightView];
  [self.view addSubview:botView];
}

- (void)setupScanWindowView
{
  //设置扫描区域的位置(考虑导航栏和电池条的高度为64)
  UIView *scanWindow = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-QRCodeWidth)/2.0,(SCREEN_HEIGHT-QRCodeWidth-64)/2.0,QRCodeWidth,QRCodeWidth)];
  scanWindow.clipsToBounds = YES;
  [self.view addSubview:scanWindow];
  
  //设置扫描区域的动画效果
  CGFloat scanNetImageViewH = 3;
  CGFloat scanNetImageViewW = scanWindow.frame.size.width;
  UIImageView *scanNetImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"光线"]];
  scanNetImageView.frame = CGRectMake(0, -scanNetImageViewH, scanNetImageViewW, scanNetImageViewH);
  scanNetImageView.backgroundColor = [UIColor clearColor];
  CABasicAnimation *scanNetAnimation = [CABasicAnimation animation];
  scanNetAnimation.keyPath =@"transform.translation.y";
  scanNetAnimation.byValue = @(QRCodeWidth);
  scanNetAnimation.duration = 3.0;
  scanNetAnimation.repeatCount = MAXFLOAT;
  [scanNetImageView.layer addAnimation:scanNetAnimation forKey:nil];
  [scanWindow addSubview:scanNetImageView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)setNav
{
  [self.navigationItem setTitle:@"二维码"];
  UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(goBack)];
  
  [self.navigationItem setLeftBarButtonItem:leftBtn];
}

- (void)goBack
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

//然后实现 AVCaptureMetadataOutputObjectsDelegate
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
  NSString *stringValue;
  if ([metadataObjects count] >0)
  {
    //停止扫描
    [_session stopRunning];
    [self stopAnimation];
    AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
    stringValue = metadataObject.stringValue;
    
    NSLog(@"%@",stringValue);
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
      if (self.scanRltBlock) {
        self.scanRltBlock(stringValue);
      }
    }];
    
  }
  
}

@end
