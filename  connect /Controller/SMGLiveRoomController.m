//
//  SMGLiveRoomController.m
//  DSXLive
//
//  Created by 沈树亮 on 2019/8/5.
//  Copyright © 2019 xiong. All rights reserved.
//

#import "SMGLiveRoomController.h"
#import "SMGConst.h"
#import <VSRTC/VSRTC.h>
#import <VSRTC/VSMedia.h>
#import <VSRTC/VSRoomUser.h>
#import <VSRTC/VSVideoConfig.h>
#import <VSRTC/VSChat.h>
#import "SMGLocalMediaView.h"
#import "SMGRemoteMediaView.h"
#import "SMGShowHudView.h"
#import "UIImage+smgImage.h"
#import "SMGMassageView.h"
#import "SMGSettingView.h"
#import "SMGHostPrivateTalk.h"

@interface SMGLiveRoomController ()<VSChatHandler, SMGLocalMediaDelegate, SMGSettingDelegate>
{
    BOOL _navgationBarHidden;
    BOOL _isUpHandel;
    BOOL _isShowUpHandel;// 是否提示举手弹窗
    CGFloat _streamBitrate;// 推流bit 默认720p 最佳1080p
}

// 状态栏蒙版
@property (nonatomic, weak) UIView *shadowView;
// 按键 & 消息层
@property (nonatomic, weak) UIView *contentView;
// 返回按钮
@property (nonatomic, weak) UIButton *backButton;
// 切换摄像头
@property (nonatomic, weak) UIButton *changeCamerButton;
// 光灯
@property (nonatomic, weak) UIButton *torchButton;
// 举手
@property (nonatomic, weak) UIButton *upHandleButton;
// 设置
@property (nonatomic, weak) UIButton *settButton;
// 切换画面
@property (nonatomic, weak) UIButton *changeButton;
// 连线状态
@property (nonatomic, weak) UILabel *label;
// 私聊
@property (nonatomic, weak) UIButton *privateButton;
// steambit
@property (nonatomic, weak) UILabel *streamLabel;
// 本机画面
@property (nonatomic, weak) SMGLocalMediaView *localMediaView;
// remote画面
@property (nonatomic, weak) SMGRemoteMediaView *remoteMediaView;
// 消息对话
@property (nonatomic, weak) SMGMassageView *massageView;
/** 消息 */
@property (nonatomic, strong) VSChat *chatChannel;
/** 私信 */
@property (nonatomic, strong) SMGHostPrivateTalk *privateTalk;

@end

@implementation SMGLiveRoomController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self setNavgationBar];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
//    [self setNavgationBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self remove];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

// 退出
- (void)remove {
    [[VSRTC sharedInstance] leaveRoom];
    [_chatChannel Close];
    [_localMediaView remove];
    [_privateTalk removePlayoutList];
    [_privateTalk.media Close];
    _privateTalk = nil;
    
    if (self.chooseModelStyle == 0) {
        [[VSRTC sharedInstance] DestroyCaptureMedia];
    }
    
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    [UIViewController attemptRotationToDeviceOrientation];
    [self.navigationController setNavigationBarHidden:_navgationBarHidden animated:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - initView
- (void)setNavgationBar {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{});
        self->_navgationBarHidden = self.navigationController.navigationBarHidden;
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    });
}

- (UIView *)shadowView {
    if (!_shadowView) {
        UIView *shadowView = [[UIView alloc] init];
        shadowView.frame = CGRectMake(0.f, 0.f, kSMGScreenHeight, kSMGStatusBarHeight);
        shadowView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:shadowView];
        
        CAGradientLayer* gradinentlayer = [CAGradientLayer layer];
        gradinentlayer.backgroundColor = [UIColor clearColor].CGColor;
        gradinentlayer.locations = @[@0.0, @0.05, @0.1, @0.15, @0.2, @0.25, @0.3, @0.35, @0.4, @0.45, @0.5];
        NSMutableArray *colors = [NSMutableArray array];
        __block UIColor *color = SMGHEX_RGBA(0x000000, 0.5f);
        [gradinentlayer.locations enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            color = [color colorWithAlphaComponent:[obj doubleValue]];
            [colors addObject:(__bridge id)color.CGColor];
        }];
        
        gradinentlayer.colors = colors;
        //分割点  设置 风电设置不同渐变的效果也不相同
        gradinentlayer.startPoint = CGPointMake(0.0, 1.0);
        gradinentlayer.endPoint = CGPointMake(0.0, 0.0);
        gradinentlayer.frame = shadowView.frame;
        [shadowView.layer addSublayer:gradinentlayer];
        _shadowView = shadowView;
    }
    return _shadowView;
}

- (UIView *)contentView {
    if (!_contentView) {
        UIView *contentView = [[UIView alloc] init];
        contentView.frame = self.view.frame;
        contentView.userInteractionEnabled = YES;
        contentView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:contentView];
        _contentView = contentView;
    }
    return _contentView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:SGMImage(@"连线返回@2x") forState:UIControlStateNormal];
        backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [backButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:backButton];
        _backButton = backButton;
    }
    return _backButton;
}

- (UIButton *)changeCamerButton {
    if (!_changeCamerButton) {
        UIButton *changeCamerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [changeCamerButton setImage:SGMImage(@"前后摄像头转换@2x") forState:UIControlStateNormal];
        [changeCamerButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:changeCamerButton];
        _changeCamerButton = changeCamerButton;
    }
    return _changeCamerButton;
}

- (UIButton *)torchButton {
    if (!_torchButton) {
        UIButton *torchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [torchButton setImage:SGMImage(@"闪光灯关@2x") forState:UIControlStateNormal];
        [torchButton setImage:SGMImage(@"闪光灯开@2x") forState:UIControlStateSelected];
        [torchButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:torchButton];
        _torchButton = torchButton;
    }
    return _torchButton;
}

- (UIButton *)settButton {
    if (!_settButton) {
        UIButton *settButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [settButton setImage:SGMImage(@"设置@2x") forState:UIControlStateNormal];
        [settButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:settButton];
        _settButton = settButton;
    }
    return _settButton;
}

- (UIButton *)upHandleButton {
    if (!_upHandleButton) {
        UIButton *upHandleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [upHandleButton setImage:SGMImage(@"举手@2x") forState:UIControlStateNormal];
        [upHandleButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:upHandleButton];
        _upHandleButton = upHandleButton;
    }
    return _upHandleButton;
}

- (UIButton *)changeButton {
    if (!_changeButton) {
        UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        changeButton.userInteractionEnabled = YES;
        [changeButton setImage:SGMImage(@"直播切换@2x")forState:UIControlStateNormal];
        changeButton.backgroundColor = [UIColor clearColor];
        [changeButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:changeButton];
        _changeButton = changeButton;
    }
    return _changeButton;
}

- (UIButton *)privateButton {
    if (!_privateButton) {
        UIButton *privateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageFromColor:SMGHEX_RGBA(0x41b48c, 1) size:CGSizeMake(5, 5)].drawRudio;
        [privateButton setImage:image forState:UIControlStateNormal];
        privateButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [privateButton setTitle:@" 私聊中..." forState:UIControlStateNormal];
        privateButton.backgroundColor = SMGHEX_RGBA(0x00000, 0.6);
        privateButton.layer.cornerRadius = 9.f;
        privateButton.clipsToBounds = YES;
        privateButton.hidden = YES;
        [self.contentView addSubview:privateButton];
        _privateButton = privateButton;
    }
    return _privateButton;
}

- (UILabel *)label {
    if (!_label) {
        UILabel *label = [[UILabel alloc] init];
        label.layer.cornerRadius = 9.f;
        label.clipsToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:12.f];
        label.text = @"";
        [self.contentView addSubview:label];
        _label = label;
    }
    return _label;
}

- (UILabel *)streamLabel {
    if (!_streamLabel) {
        UILabel *streamLabel = [[UILabel alloc] init];
        streamLabel.textColor = [UIColor whiteColor];
        streamLabel.font = [UIFont systemFontOfSize:13.f];
        streamLabel.text = @"0kb/s";
        [self.contentView addSubview:streamLabel];
        _streamLabel = streamLabel;
    }
    return _streamLabel;
}

- (SMGLocalMediaView *)localMediaView {
    if (!_localMediaView) {
        CGRect frame = CGRectMake(0.f, 0.f, kSMGScreenHeight, kSMGScreenWidth);
        SMGLocalMediaView *localMediaView = [[SMGLocalMediaView alloc] initWithFrame:frame];
        localMediaView.delegate = self;
        [self.view addSubview:localMediaView];
        _localMediaView = localMediaView;
    }
    return _localMediaView;
}

- (SMGRemoteMediaView *)remoteMediaView {
    if (!_remoteMediaView) {
        CGRect frame = CGRectMake(kSMGScreenHeight - PLHEIGHT, kSMGScreenWidth - PLWIDTH, PLHEIGHT, PLWIDTH);
        SMGRemoteMediaView *remoteMediaView = [[SMGRemoteMediaView alloc] initWithFrame:frame];
        [self.view addSubview:remoteMediaView];
        _remoteMediaView = remoteMediaView;
    }
    return _remoteMediaView;
}

- (SMGMassageView *)massageView {
    if (!_massageView) {
        SMGMassageView *massageView = [[SMGMassageView alloc] init];
        [self.contentView addSubview:massageView];
        _massageView = massageView;
    }
    return _massageView;
}

- (VSChat *)chatChannel {
    if (!_chatChannel) {
        _chatChannel = [[VSRTC sharedInstance] CreateChat];
        [_chatChannel SetMessageHandler:self];
        [_chatChannel Open];
    }
    return _chatChannel;
}

- (SMGHostPrivateTalk *)privateTalk {
    if (!_privateTalk) {
        _privateTalk = [[SMGHostPrivateTalk alloc] init];
    }
    return _privateTalk;
}

- (void)setup {
    self.view.backgroundColor = [UIColor blackColor];
    _streamBitrate = 720;
    [self setNavgationBar];
    [self initWithVSRTC];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActivity:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10.f);
        make.top.equalTo(self.contentView).offset(kSMGStatusBarHeight+10.f);
        make.size.mas_equalTo(CGSizeMake(32.f, 32.f));
    }];
}

- (void)initWithVSRTC {
    [[VSRTC sharedInstance] setObserver:self];
    
    if (self.chooseModelStyle == 0) {
        self.localMediaView.backgroundColor = [UIColor clearColor];
        [self.view bringSubviewToFront:self.contentView];
        [self.view bringSubviewToFront:self.remoteMediaView];
        [self initUILayouts];
        
    } else {
        self.remoteMediaView.backgroundColor = [UIColor blackColor];
        [self.remoteMediaView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    self.shadowView.hidden = NO;
}

- (void)initUILayouts {
    CGFloat height = kSMGScreenHeight;
    CGFloat width  = kSMGScreenWidth;
    if (height > kSMGScreenWidth) {
        height = kSMGScreenWidth;
        width = kSMGScreenHeight;
    }
    CGFloat maginY = (height - (kSMGStatusBarHeight + 32*5 + 101.f))/3;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.changeCamerButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.height.width.equalTo(self.backButton);
                make.top.equalTo(self.backButton.mas_bottom).offset(65.f);
            }];
            
            [self.torchButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.height.width.equalTo(self.backButton);
                make.top.equalTo(self.changeCamerButton.mas_bottom).offset(maginY);
            }];
            
            [self.upHandleButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.height.width.equalTo(self.backButton);
                make.top.equalTo(self.torchButton.mas_bottom).offset(maginY);
            }];
            
            [self.settButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.height.width.equalTo(self.backButton);
                make.top.equalTo(self.upHandleButton.mas_bottom).offset(maginY);
            }];
            
            [self.privateButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.backButton);
                make.left.equalTo(self.label.mas_right).offset(10.f);
                make.height.with.width.equalTo(self.label);
            }];
            
            [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.backButton.mas_right).offset(15.f);
                make.centerY.equalTo(self.backButton);
                make.height.mas_equalTo(18.f);
                make.width.mas_equalTo(72.f);
            }];
            
            [self.streamLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.settButton);
                make.left.equalTo(self.settButton.mas_right).offset(15.f);
            }];
        });

        [self.massageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(kSMGStatusBarHeight);
            make.right.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(PLHEIGHT, height - PLWIDTH - kSMGStatusBarHeight));
        }];
        
        CGRect frame = CGRectMake(width - PLHEIGHT + 10.f, height - PLWIDTH + 10.f, 20.f, 20.f);
        self.changeButton.frame = frame;
    });
}

#pragma mark - mm

- (void)becomeActivity:(NSNotification *)info {
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    [UIViewController attemptRotationToDeviceOrientation];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)enterForeground:(NSNotification *)info {
    if (self.chooseModelStyle == 0) {
        [self remove];
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)buttonAction:(id)sender {
    VSMedia *captureMedia = [[VSRTC sharedInstance] CreateCaptureMedia];
    VSVideoConfig *config = [[VSRTC sharedInstance] QueryVideoConfiger:captureMedia];
    
    if (self.backButton == sender) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定退出演播室" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *al = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *a2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self remove];
            self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alert addAction:al];
        [alert addAction:a2];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else if (self.changeCamerButton == sender) {
        [config SwitchCamera:![config isUseFrontCamera]];
        self.torchButton.selected = NO;
        
    } else if (self.torchButton == sender) {
        if (![config isUseFrontCamera]) {
            [config setTorch:![config torch]];
            self.torchButton.selected = !self.torchButton.selected;
        }
        
    } else if (self.upHandleButton == sender) {//举手
       VSRoomUser *user = [[VSRTC sharedInstance] getSession];
       NSMutableDictionary *dic = [user.custom mutableCopy];
       
        if (!_isUpHandel) {// [user stream_id]
            _isUpHandel = YES;
            _isShowUpHandel = YES;
            NSMutableDictionary *extend = [dic[@"extend"] mutableCopy];
            extend[@"handsUp"] = @"1";
            [[VSRTC sharedInstance] updateCustomExtendData:extend];
            [self performSelector:@selector(downHandel) withObject:nil afterDelay:30];
        }
        
    } else if (self.settButton == sender) {
        SMGSettingView *view = [[SMGSettingView alloc] init];
        [view setDefaultStramBit:_streamBitrate];
        view.delegate = self;
        [view showInView:self.view];
        
    } else if (self.changeButton == sender) {
        CGRect localFrame = self.localMediaView.frame;
        CGRect remoteFrame = self.remoteMediaView.frame;
        
        self.localMediaView.frame = remoteFrame;
        self.remoteMediaView.frame = localFrame;
        
        if (CGRectGetMinX(localFrame) == 0) {
            [self.view bringSubviewToFront:self.localMediaView];
            
        } else {
            [self.view bringSubviewToFront:self.remoteMediaView];
        }
        
        [self.view bringSubviewToFront:self.contentView];
        [self.view bringSubviewToFront:self.changeButton];
    }
}


// 30s后自动取消举手
- (void)downHandel {
    _isUpHandel = NO;
    VSRoomUser *user = [[VSRTC sharedInstance] getSession];
    NSMutableDictionary *dic = [user.custom mutableCopy];
    NSMutableDictionary *extend = [dic[@"extend"] mutableCopy];
    extend[@"handsUp"] = @"0";
    [[VSRTC sharedInstance] updateCustomExtendData:extend];
}

#pragma mark - VSRTCDelegate

- (void)onSessionInit:(VSRoomUser*)session {
    self.label.backgroundColor = SMGHEX_RGBA(0x00000, 0.6);
    self.label.text = @"连接成功";
    if (self.chooseModelStyle == 0) {
        [self.chatChannel Open];
    }
}

- (void)onSessionUpdate:(VSRoomUser*)session {
    if (self.chooseModelStyle == 0) {
        [self.chatChannel Open];
    }
    
    NSMutableDictionary *dic = [session.custom mutableCopy];
    NSDictionary *extend = dic[@"extend"];
    BOOL handsUp = [extend[@"handsUp"] boolValue];
    if (handsUp && _isShowUpHandel) {// 举手成功
        _isShowUpHandel = NO;
        [SMGShowHudView smgShowHandelWithView:self.view];
    }
    
    // 准备组
    BOOL video2prepare = [extend[@"video2prepare"] boolValue];
    // 播放组
    BOOL video2playout = [extend[@"video2playout"] boolValue];
    VSMedia *captureMedia = [[VSRTC sharedInstance] CreateCaptureMedia];
    VSRoomUser *user = [[VSRTC sharedInstance] getSession];
    
    // 私聊
    BOOL talk = [extend[@"talkToHost"][@"talk"] boolValue];
    if ((talk && !video2playout)) {
        self.privateButton.hidden = NO;
        [self openPrivateTalk];
        
    } else {
        self.privateButton.hidden = YES;
        [self closePrivateTalk];
    }
    
    if (video2prepare) {
        self.label.text = @"PREPARE";
        self.label.backgroundColor = SMGHEX_RGBA(0x41b48c, 1);
        [captureMedia Publish:NO streamBitrate:_streamBitrate stramLabel:user.userId];
        
        [self.privateTalk removePlayoutList];
        
    } else if (video2playout) {
        self.label.text = @"PLAYOUT";
        self.label.backgroundColor = SMGHEX_RGBA(0xff555a, 1);
        [captureMedia Publish:NO streamBitrate:_streamBitrate stramLabel:user.userId];
        
        // 播放组
        [self.privateTalk createPlayouyList];
        
    } else {
        self.label.backgroundColor = SMGHEX_RGBA(0x00000, 0.6);
        self.label.text = @"连接成功";
        [captureMedia Unpublish];
        [self.privateTalk removePlayoutList];
        [self closePrivateTalk];
    }
}

- (void)onSessionError:(int)errCode andDesc:(NSString *)errMsg {
    self.label.backgroundColor = SMGHEX_RGBA(0x00000, 0.6);
    self.label.text = @"连接失败";
    if (errCode == 400) {
        [SMGShowHudView smgShowMsg:@"你已被移出直播室" view:self.view.window];
        [self remove];
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)onSessionQuit {
    NSLog(@"退出了");
}

- (void)onRoomInfoRefresh:(NSString*)data {
//    NSData *da = [data dataUsingEncoding:NSUTF8StringEncoding];
//   NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:da options:NSJSONReadingMutableLeaves error:nil];
    
    [self.remoteMediaView getHostVideo];
}

- (void)onMemberJoin:(VSRoomUser*)user {
    [self.remoteMediaView getHostVideo];
   // [self.privateTalk addPlayoutUser:user];
}

- (void)onMemberUpdate:(VSRoomUser*)user {
    [self.remoteMediaView getHostVideo];
    
    // 责编进入
    NSDictionary *dic = user.custom;
    NSDictionary *extend = dic[@"extend"];
    NSString *room_active_role = extend[@"room_active_role"];
    BOOL video2playout = [extend[@"video2playout"] boolValue];
    
    // 责编私聊通话
    if (([room_active_role isEqualToString:@"host"] && user.stream_id)) {
        self.privateTalk.user = user;
        
        // 责编是否打开公聊（准备组）
        BOOL broadcastToPrepare = [extend[@"hostRole"][@"broadcastToPrepare"] boolValue];
        // 责编是否打开公聊（播放组）
        BOOL broadcastToPlayout = [extend[@"hostRole"][@"broadcastToPlayout"] boolValue];
        // 私聊
        BOOL talk = [extend[@"talkToHost"][@"talk"] boolValue];
        
        if (talk || broadcastToPrepare || broadcastToPlayout) {
            [self.privateTalk updateTalk];
            
        } else {
            [self.privateTalk closeTalk];
        }
    }
    
    if ([room_active_role isEqualToString:@"guest"]) {
        // 播放组通话
        if (video2playout) {
            [self.privateTalk addPlayoutUser:user];
            
        } else {
            [self.privateTalk removePlayoutUser:user];
        }
    }
}

- (void)onMemberLeave:(VSRoomUser*)user {
    // 责编离开
    NSDictionary *dic = user.custom;
    NSDictionary *extend = dic[@"extend"];
    NSString *room_active_role = extend[@"room_active_role"];
    if ([room_active_role isEqualToString:@"host"]) {
        [self closePrivateTalk];
    }
    
    [self.privateTalk removePlayoutUser:user];
}

- (void)onPartnerScanedScode {
    
}

- (void)onAppMessage:(NSString*)msg {
    NSLog(@"%@=====", msg);
}

- (void)onMediaServiceReady {
    
}

- (void)onMediaServiceLost {
    
}

#pragma mark - VSChatHandler
- (void)OnChatOpen {
    NSLog(@"==open===");
    
}

- (void)OnChatClose {
   NSLog(@"===close==");
}

- (void)OnChatMessage:(NSDictionary *)msgDic {
    [self.massageView addMassage:msgDic];
}

#pragma mark - SMGLocalMediaDelegate
- (void)getlocalMediaSteambit:(NSString *)streambits {
   self.streamLabel.text = streambits;
}

#pragma mark - SMGSettingDelegate
- (void)settingDidSelectedStreamBit:(NSInteger)streambit {
    _streamBitrate = streambit;
    VSMedia *captureMedia = [[VSRTC sharedInstance] CreateCaptureMedia];
    VSRoomUser *user = [[VSRTC sharedInstance] getSession];
    
    if (captureMedia.stream_state == VS_MEDIA_STREAM_STARTED ||
        captureMedia.stream_state == VS_MEDIA_STREAM_STARTING) {
        [captureMedia Publish:NO streamBitrate:_streamBitrate stramLabel:user.userId];
    }
}

#pragma mark - open private Talk
- (void)openPrivateTalk { // 责编私聊
    [self.privateTalk openTalk];
}

- (void)closePrivateTalk { // 关闭私聊
    [self.privateTalk closeTalk];
}
 
@end
