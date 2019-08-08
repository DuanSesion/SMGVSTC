//
//  SMGLiveHomeController.m
//  DSXLive
//
//  Created by 沈树亮 on 2019/8/5.
//  Copyright © 2019 xiong. All rights reserved.
//

#import "SMGLiveHomeController.h"
#import "SMGLiveRoomController.h"
#import "SMGConst.h"
#import "SMGLiveHomeBackgroundView.h"
#import "SMGLiveChooseView.h"
#import "SMGShowHudView.h"

@interface SMGLiveHomeController ()
<
   SMGLiveHomeBackgroundDelegate
>
{
    BOOL _navgationBarHidden;
}

@property (nonatomic, weak) SMGLiveHomeBackgroundView *backgroundView;
@property (nonatomic, weak) UIButton *joinButton;
@property (nonatomic, weak) UIView *contenView;
@property (nonatomic, weak) SMGLiveChooseView *liveChooseView;

@end

@implementation SMGLiveHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavgationBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:_navgationBarHidden animated:NO];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - initView
- (void)setNavgationBar {
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    [UIViewController attemptRotationToDeviceOrientation];
    
    _navgationBarHidden = self.navigationController.navigationBarHidden;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (SMGLiveHomeBackgroundView *)backgroundView {
    if (!_backgroundView) {
        SMGLiveHomeBackgroundView *backgroundView = [[SMGLiveHomeBackgroundView alloc] init];
        self.view = backgroundView;
        _backgroundView = backgroundView;
    }
    return _backgroundView;
}

- (UIButton *)joinButton {
    if (!_joinButton) {
        UIButton *joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        joinButton.backgroundColor = SMGHEX_RGBA(0x41b48c, 1);
        [joinButton setTitle:@"进入连线" forState:UIControlStateNormal];
        joinButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
        [joinButton addTarget:self action:@selector(joinRoomAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:joinButton];
        _joinButton = joinButton;
        
        CGFloat safeAreaInsetsHeight = 0.f;
        if (@available(iOS 11.0, *)) {
            safeAreaInsetsHeight = kSMGSafeAreaInsetsHeight;
        }
        [_joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(49.f);
            make.bottom.equalTo(self.view).offset(-safeAreaInsetsHeight);
        }];
    }
    return _joinButton;
}

- (UIView *)contenView {
    if (!_contenView) {
        UIView *contenView = [[UIView alloc] init];
        contenView.backgroundColor = [UIColor whiteColor];
        contenView.layer.cornerRadius = 5.f;
        CALayer *layer = [contenView layer];
        layer.shadowOffset  = CGSizeMake(0, 2.f);
        layer.shadowRadius  = 3;
        layer.shadowColor   = SMGHEX_RGBA(0x737373, 1).CGColor;
        layer.shadowOpacity = 0.5;
        [self.view addSubview:contenView];
        _contenView = contenView;
        [_contenView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(10.f);
            make.right.equalTo(self.view).offset(-10.f);
            make.top.equalTo(self.backgroundView).offset(200.f);
            make.bottom.equalTo(self.joinButton).offset(1.f);
        }];
    }
    return _contenView;
}

- (SMGLiveChooseView *)liveChooseView {
    if (!_liveChooseView) {
        SMGLiveChooseView *liveChooseView = [[SMGLiveChooseView alloc] init];
        [self.contenView addSubview:liveChooseView];
        _liveChooseView = liveChooseView;
    }
    return _liveChooseView;
}

- (void)setup {
    [[VSRTC sharedInstance] startup:@""];
    [[VSRTC sharedInstance] startFileLog:[NSHomeDirectory() stringByAppendingString:@"/Documents/a.txt"]];
    
    // 头部背景
    self.backgroundView.hidden = NO;
    
    [self setNavgationBar];
    
    // 选择区域背景
    self.contenView.hidden = NO;
    
    // 选择区域
    self.liveChooseView.hidden = NO;
    
    // 进入连线
    self.joinButton.hidden = NO;
}

#pragma mark - SMGLiveHomeBackgroundDelegate
- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tagert Action
- (void)joinRoomAction:(id)sender {
    
    NSMutableDictionary *extendInfo = [NSMutableDictionary new];
    NSMutableDictionary *roomInfo = [NSMutableDictionary new];
    
    NSString *apiKey   = PRD_APIKEY;
    NSString *tenantId = PRD_TENANT_ID;
    NSString *eventId  = PRD_EVENT_ID;
    NSString *rmsUrl   = PRD_RMS_URL;
    NSString *vrxUrl   = PRD_VRX_URL;
    NSString *ilsUrl   = PRD_ILS_URL;
    NSString *vsuUrl   = PRD_VSU_URL;
    NSString *userId   = @"b686f22800c48ceebb7f5cc30af09ef0";
    NSString *nickName = @"ios";
    
    if (self.user_id.length == 0) {
        self.user_id = userId;
    }
    
    if (self.name.length == 0) {
        self.name = nickName;
    }
    
    if (self.liveChooseView.chooseModelStyle == 0) {// 直播模式
        // for SDI
        NSMutableDictionary *talkToHost = [NSMutableDictionary new];
        talkToHost[@"talk"] = [NSNumber numberWithBool:NO];
        talkToHost[@"type"] = @"private";
        
        NSMutableDictionary *hostRole = [NSMutableDictionary new];
        hostRole[@"broadcastToPlayout"] = [NSNumber numberWithBool:NO];
        hostRole[@"broadcastToPrepare"] = [NSNumber numberWithBool:NO];
        hostRole[@"listenPlayout"] = [NSNumber numberWithBool:NO];
        hostRole[@"listenPrepare"] = [NSNumber numberWithBool:NO];
        
        extendInfo[@"room_active_role"] = @"guest";
        extendInfo[@"video2prepare"] = [NSNumber numberWithBool:NO];
        extendInfo[@"video2playout"] = [NSNumber numberWithBool:NO];
        extendInfo[@"handsUp"] = [NSNumber numberWithBool:NO];
        extendInfo[@"talkToHost"] = talkToHost;
        extendInfo[@"hostRole"] = hostRole;
        extendInfo[@"sdi"] = [NSNumber numberWithInt:-1];
        extendInfo[@"groupCompleteStatus"] = [NSNumber numberWithBool:NO];
        
        roomInfo[@"remixScreen"] = @"main";
        roomInfo[@"allowPlayoutPrivateChat"] = [NSNumber numberWithBool:NO];
        roomInfo[@"hostOnDuty"] = [NSNumber numberWithBool:NO];
        roomInfo[@"enableRemixImage"] = [NSNumber numberWithBool:NO];
        
    } else {// 返送模式
        // for Meeting
        extendInfo[@"room_active_role"] = @"participant";
        extendInfo[@"video2peer"] = [NSNumber numberWithBool:NO];
        extendInfo[@"video2pin"] = [NSNumber numberWithBool:YES];
        extendInfo[@"share2peer"] = [NSNumber numberWithBool:NO];
        extendInfo[@"handsUp"] = [NSNumber numberWithBool:NO];
        extendInfo[@"ioDeviceEnable"] = [NSNumber numberWithInt:1];
        
        roomInfo[@"allowDownloadShareFiles"] = [NSNumber numberWithBool:YES];
        roomInfo[@"allowChat"] = [NSNumber numberWithBool:YES];
        roomInfo[@"freedom2peer"] = [NSNumber numberWithBool:YES];
        roomInfo[@"ballBelongTo"] = @"";
    }
    
    SMGShowHudView *hud = [SMGShowHudView smgShow:@"连接中..." view:self.contenView];
    self.liveChooseView.hidden = YES;
    self.joinButton.hidden = YES;
    
    __weak typeof (self)weakSelf = self;
    [[VSRTC sharedInstance] joinRoomWithApiKey:apiKey andTenant:tenantId andEvent:eventId andRms:rmsUrl andVrx:vrxUrl andIls:ilsUrl andVsu:vsuUrl andUser:self.user_id andDisplay:self.name andExtend:extendInfo andRoom:roomInfo completion:^(NSError *error) {
        weakSelf.liveChooseView.hidden = NO;
        weakSelf.joinButton.hidden = NO;
        [hud hideAnimated];
        
        if (error == nil) {
            NSLog(@"OK");
            SMGLiveRoomController *vc = [[SMGLiveRoomController alloc] init];
            vc.chooseModelStyle = self.liveChooseView.chooseModelStyle;
            vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            if (weakSelf.navigationController) {
                [weakSelf.navigationController presentViewController:vc animated:YES completion:nil];
                
            } else {
                [weakSelf presentViewController:vc animated:YES completion:nil];
            }
            
        } else {
            [SMGShowHudView smgShowMsg:@"进入失败" view:self.view];
            NSString *errStr = [NSString stringWithFormat:@"%@=%ld", error.localizedDescription, (long)error.code];
            NSLog(@"%@", errStr);
        }
    }];
}


@end
