//
//  LoginViewController.m
//
//  Created by pliu on 20/9/2017.
//  Copyright © 2017 VSVideo. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "ScannerVC.h"
#import <VSRTC/VSRTC.h>
#include "Masonry.h"
#include "RoomVC.h"
#import "JTMaterialSwitch.h"
#import "MBProgressHUD.h"
#import "MaterialDesignSymbol.h"
#import "EntypoSymbol.h"
#import "MaterialDesignColor.h"
#import "TWSReleaseNotesView.h"
#import "LHPerformanceMonitorService.h"

#define CAMERA_STRESS_TEST      0
#define JOIN_STRESS_TEST        0

@interface LoginViewController () <JTMaterialSwitchDelegate, LoginViewDelegate> {
  LoginView* _loginView;
}
@property (nonatomic, strong) UIButton* btnReleaseNote;
@property (nonatomic, strong) MBProgressHUD *notifyView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _loginView = [[LoginView alloc] initWithFrame:CGRectZero];
  self.view = _loginView;
  _loginView.delegate = self;
  
  self.btnReleaseNote = [UIButton new];
  [self.view addSubview:self.btnReleaseNote];
  [self.btnReleaseNote addTarget:self action:@selector(onReleaseNoteClicked) forControlEvents:UIControlEventTouchUpInside ];
  [self.btnReleaseNote setImage:[MaterialDesignSymbol imageWithCode:MaterialDesignIconCode.newReleases48px fontSize:60.f fontColor:[UIColor whiteColor]] forState:UIControlStateNormal];
  [self.btnReleaseNote mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view).offset(10);
    make.bottom.equalTo(self.view).offset(-10);
    make.width.equalTo(@30);
    make.height.equalTo(@30);
  }];
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.navigationController.navigationBar.hidden = YES;
}

- (void) viewDidAppear:(BOOL)animated {
  [LHPerformanceMonitorService run];
  
  [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void) viewWillDisappear:(BOOL)animated {
  [UIApplication sharedApplication].idleTimerDisabled = NO;
  [super viewWillDisappear:animated];
}

- (void) onReleaseNoteClicked {
  // Create the release notes view
  NSString *currentAppVersion = [VSRTC version];
  TWSReleaseNotesView *releaseNotesView = [TWSReleaseNotesView viewWithReleaseNotesTitle:[NSString stringWithFormat:@"VideoSolar VSRTC SDK\n%@", currentAppVersion] text:@"• Support assistant mode\n• Support in room chat\n• Support hand action\n• Refine demo UI" closeButtonTitle:@"OK"];
  
  // Show the release notes view
  [releaseNotesView showInView:self.view];
}

- (void) onJoinClicked {
#if 1
  // for SDI
  NSMutableDictionary *talkToHost = [NSMutableDictionary new];
  talkToHost[@"talk"] = [NSNumber numberWithBool:NO];
  talkToHost[@"type"] = @"private";
  
  NSMutableDictionary *hostRole = [NSMutableDictionary new];
  hostRole[@"broadcastToPlayout"] = [NSNumber numberWithBool:NO];
  hostRole[@"broadcastToPrepare"] = [NSNumber numberWithBool:NO];
  hostRole[@"listenPlayout"] = [NSNumber numberWithBool:NO];
  hostRole[@"listenPrepare"] = [NSNumber numberWithBool:NO];
  
  NSMutableDictionary *extendInfo = [NSMutableDictionary new];
  extendInfo[@"room_active_role"] = @"guest";
  extendInfo[@"video2prepare"] = [NSNumber numberWithBool:NO];
  extendInfo[@"video2playout"] = [NSNumber numberWithBool:NO];
  extendInfo[@"handsUp"] = [NSNumber numberWithBool:NO];
  extendInfo[@"talkToHost"] = talkToHost;
  extendInfo[@"hostRole"] = hostRole;
  extendInfo[@"sdi"] = [NSNumber numberWithInt:-1];
  extendInfo[@"groupCompleteStatus"] = [NSNumber numberWithBool:NO];
  
  NSMutableDictionary *roomInfo = [NSMutableDictionary new];
  roomInfo[@"remixScreen"] = @"main";
  roomInfo[@"allowPlayoutPrivateChat"] = [NSNumber numberWithBool:NO];
  roomInfo[@"hostOnDuty"] = [NSNumber numberWithBool:NO];
  roomInfo[@"enableRemixImage"] = [NSNumber numberWithBool:NO];
  
#else
  // for Meeting
  NSMutableDictionary *extendInfo = [NSMutableDictionary new];
  extendInfo[@"room_active_role"] = @"participant";
  extendInfo[@"video2peer"] = [NSNumber numberWithBool:NO];
  extendInfo[@"video2pin"] = [NSNumber numberWithBool:YES];
  extendInfo[@"share2peer"] = [NSNumber numberWithBool:NO];
  extendInfo[@"handsUp"] = [NSNumber numberWithBool:NO];
  extendInfo[@"ioDeviceEnable"] = [NSNumber numberWithInt:1];
  
  NSMutableDictionary *roomInfo = [NSMutableDictionary new];
  roomInfo[@"allowDownloadShareFiles"] = [NSNumber numberWithBool:YES];
  roomInfo[@"allowChat"] = [NSNumber numberWithBool:YES];
  roomInfo[@"freedom2peer"] = [NSNumber numberWithBool:YES];
  roomInfo[@"ballBelongTo"] = @"";
#endif
 //
//    [self.navigationController pushViewController:[RoomVC new] animated:YES];
    
  
  [self showHud:@"Join Room..."];
  [[VSRTC sharedInstance] joinRoomWithApiKey:_loginView.apiKey
                                   andTenant:_loginView.tenantId
                                    andEvent:_loginView.eventId andRms:_loginView.rmsUrl andVrx:_loginView.vrxUrl andIls:_loginView.ilsUrl andVsu:_loginView.vsuUrl
                                     andUser:_loginView.userId
                                  andDisplay:_loginView.nickName
                                   andExtend:extendInfo andRoom:roomInfo
                                  completion:^(NSError *error) {
    [self hideHud];
    if (error == nil) {
      [self.navigationController pushViewController:[RoomVC new] animated:YES];
    } else {
        NSString *errStr = [NSString stringWithFormat:@"%@=%ld", error.localizedDescription, (long)error.code];
      [self displayHud:errStr];
    }
  }];
    
}

- (void) onScanClicked {
#if 0
  ScannerVC *scannerVC = [ScannerVC new];
  [scannerVC setScanRltBlock:^(NSString *scode) {
    NSString* errMsg = [[VSRTC sharedInstance] joinRoom:_loginView.roomSrv withAuth:scode andDefaultMedia:_loginView.janusUrl];
    if (errMsg.length > 0) {
      [self alertWithTitle:@"Error" message:errMsg ButtonArray:@[@"OK"] LastAlertAction:^(NSInteger index) {
      }];
      return;
    } else {
      [self.navigationController pushViewController:[RoomVC new] animated:YES];
    }
  }];
  [self presentViewController:scannerVC animated:YES completion:nil];
#endif
}

- (void)showHud:(NSString *)msg{
  self.notifyView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  self.notifyView.mode = MBProgressHUDModeText;
  self.notifyView.label.text = msg;
  self.notifyView.removeFromSuperViewOnHide = YES;
  self.notifyView.backgroundView.hidden = YES;
  [self.notifyView showAnimated:YES];
}

- (void)hideHud{
  [self.notifyView hideAnimated:YES];
}

- (void)displayHud:(NSString *)msg{
  self.notifyView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  self.notifyView.mode = MBProgressHUDModeText;
  self.notifyView.label.text = msg;
  self.notifyView.removeFromSuperViewOnHide = YES;
  self.notifyView.backgroundView.hidden = YES;
  [self.notifyView hideAnimated:YES afterDelay:0.5];
}

- (void)alertWithTitle:(NSString *)title message:(NSString *)message ButtonArray:(NSArray *)array LastAlertAction:(void(^)(NSInteger index))block {
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
  
  NSInteger alertActionNumber = array.count;
  for (uint32_t i = 0; i < alertActionNumber; i++)
  {
    if (i == array.count - 1)
    {
      UIAlertAction *alertAction = [UIAlertAction actionWithTitle:array[i] style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        if (block)
        {
          block(i);
        }
      }];
      [alertController addAction:alertAction];
    }else
    {
      UIAlertAction *alertAction = [UIAlertAction actionWithTitle:array[i] style:(UIAlertActionStyleDefault) handler:nil];
      [alertController addAction:alertAction];
    }
  }
  [self presentViewController:alertController animated:YES completion:nil];
}
- (void)switchStateChanged:(JTMaterialSwitchState)currentState fromSwitch:(JTMaterialSwitch *)control {
    
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
    
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    
}

- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
    return CGSizeMake(0, 0);
}

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    
}

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    
}

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
    
}

- (void)setNeedsFocusUpdate {
    
}

- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
    return 1;
}

- (void)updateFocusIfNeeded {
    
}

@end
