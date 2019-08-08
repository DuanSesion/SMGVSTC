//
//  LoginView.m
//
//  Created by pliu on 20/9/2017.
//  Copyright © 2017 VSVideo. All rights reserved.
//

#import "LoginView.h"

#include "Masonry/Masonry.h"
#import "JTMaterialSwitch.h"
#import "MaterialDesignSymbol.h"
#import "EntypoSymbol.h"
#import "MaterialDesignColor.h"

#import <VSRTC/VSRTC.h>

#if 0


#define DEV_APIKEY              @"o9d9fjewlsdhioiqwjioeeijlkjwlr9c"
#define DEV_TENANT_ID           @"22"
#define DEV_EVENT_ID            @"cgpree"
#define DEV_RMS_URL             @"https://vrc.edu.hinet.net"
#define DEV_VRX_URL             @"https://vrx.edu.hinet.net"
#define DEV_ILS_URL             @"https://ils.edu.hinet.net"
#define DEV_VSU_URL             @"https://sf.edu.hinet.net"
#define DEV_USER_ID             @"ios"
#define DEV_NICK_NAME           @"ios"


#define DEV_APIKEY              @"o9d9fjewlsdhioiqwjioeeijlkjwlr9c"
#define DEV_TENANT_ID           @"17"
#define DEV_EVENT_ID            @"131"
#define DEV_RMS_URL             @"https://vrc-edu.96296.tv"
#define DEV_VRX_URL             @"https://vrx.96296.tv"
#define DEV_ILS_URL             @"https://ils.96296.tv"
#define DEV_VSU_URL             @"https://sf.96296.tv"
#define DEV_USER_ID             @"ios"
#define DEV_NICK_NAME           @"ios"

#define PRD_APIKEY              @"o9d9fjewlsdhioiqwjioeeijlkjwlr9c"
#define PRD_TENANT_ID           @"1"
#define PRD_EVENT_ID            @"b2nms5"
#define PRD_RMS_URL             @"https://controller.mlive.tv189.com"
#define PRD_VRX_URL             @"https://vrx.mlive.tv189.com"
#define PRD_ILS_URL             @"https://ils.mlive.tv189.com"
#define PRD_VSU_URL             @"https://sf.mlive.tv189.com:8089/janus"
#define PRD_USER_ID             @"ios"
#define PRD_NICK_NAME           @"ios"

#define DEV_APIKEY              @"o9d9fjewlsdhioiqwjioeeijlkjwlr9c"
#define DEV_TENANT_ID           @"17"
#define DEV_EVENT_ID            @"131"
#define DEV_RMS_URL             @"https://vrc-edu.96296.tv"
#define DEV_VRX_URL             @"https://meeting.96296.tv"
#define DEV_ILS_URL             @"https://ils.96296.tv"
#define DEV_VSU_URL             @"https://sf.96296.tv"
#define DEV_USER_ID             @"ios"
#define DEV_NICK_NAME           @"ios"

#define DEV_APIKEY              @"o9d9fjewlsdhioiqwjioeeijlkjwlr9c"
#define DEV_TENANT_ID           @"17"
#define DEV_EVENT_ID            @"tbkao0"
#define DEV_RMS_URL             @"https://rmsrtc.cmi.chinamobile.com"
#define DEV_VRX_URL             @"https://vrxrtc.cmi.chinamobile.com"
#define DEV_ILS_URL             @"https://ilsrtc.cmi.chinamobile.com"
#define DEV_VSU_URL             @"https://sfrtc.cmi.chinamobile.com"
#define DEV_USER_ID             @"cp-"
#define DEV_NICK_NAME           @"cp-"

#define DEV_APIKEY              @"o9d9fjewlsdhioiqwjioeeijlkjwlr9c"
#define DEV_TENANT_ID           @"17"
#define DEV_EVENT_ID            @"1tdcx9"
#define DEV_RMS_URL             @"https://rms.content.hkunicom.com"
#define DEV_VRX_URL             @"https://vrx.content.hkunicom.com"
#define DEV_ILS_URL             @"https://ils.content.hkunicom.com"
#define DEV_VSU_URL             @"https://sf.content.hkunicom.com"
#define DEV_USER_ID             @"cp-"
#define DEV_NICK_NAME           @"cp-"

#endif

#define DEV_APIKEY              @"o9d9fjewlsdhioiqwjioeeijlkjwlr9c"
#define DEV_TENANT_ID           @"1"
#define DEV_EVENT_ID            @"3557"
#define DEV_RMS_URL             @"https://ops.smgtech.net"
#define DEV_VRX_URL             @"https://vrx.smgtech.net"
#define DEV_ILS_URL             @"https://ils.smgtech.net"
#define DEV_VSU_URL             @"https://sfu.smgtech.net:8089/janus"
#define DEV_USER_ID             @"cp-"
#define DEV_NICK_NAME           @"cp-"

#define PRD_APIKEY              @"o9d9fjewlsdhioiqwjioeeijlkjwlr9c"
#define PRD_TENANT_ID           @"1"
#define PRD_EVENT_ID            @"zrjgpm"
#define PRD_RMS_URL             @"https://vrc-ocn.poc.videosolar.com"
#define PRD_VRX_URL             @"https://vrx-ocn.poc.videosolar.com"
#define PRD_ILS_URL             @"https://ils-ocn.poc.videosolar.com"
#define PRD_VSU_URL             @"https://sf-ocn.poc.videosolar.com:8089/janus"
#define PRD_USER_ID             @"ios"
#define PRD_NICK_NAME           @"ios"

@interface LoginView() <JTMaterialSwitchDelegate>
@property (nonatomic, strong) UIImageView* headerLogo;
@property (nonatomic, strong) UILabel* apiKeyLbl;
@property (nonatomic, strong) UILabel* tenantIdLbl;
@property (nonatomic, strong) UILabel* eventIdLbl;
@property (nonatomic, strong) UILabel* rmsUrlLbl;
@property (nonatomic, strong) UILabel* vrxUrlLbl;
@property (nonatomic, strong) UILabel* ilsUrlLbl;
@property (nonatomic, strong) UILabel* vsuUrlLbl;
@property (nonatomic, strong) UILabel* userIdLbl;
@property (nonatomic, strong) UILabel* nickNameLbl;
@property (nonatomic, strong) UILabel* testEnvLbl;
@property (nonatomic, strong) UILabel* mediaModeLbl;

@property (nonatomic, strong) UITextField* apiKeyTf;
@property (nonatomic, strong) UITextField* tenantIdTf;
@property (nonatomic, strong) UITextField* eventIdTf;
@property (nonatomic, strong) UITextField* rmsUrlTf;
@property (nonatomic, strong) UITextField* vrxUrlTf;
@property (nonatomic, strong) UITextField* ilsUrlTf;
@property (nonatomic, strong) UITextField* vsuUrlTf;
@property (nonatomic, strong) UITextField* userIdTf;
@property (nonatomic, strong) UITextField* nickNameTf;
@property (nonatomic, strong) JTMaterialSwitch* testEnvSwitch;
@property (nonatomic, strong) JTMaterialSwitch* mediaModeSwitch;

@property (nonatomic, strong) UIButton* joinBtn;
@property (nonatomic, strong) UIButton* scanBtn;
@end


@implementation LoginView

@dynamic apiKey;
@dynamic tenantId;
@dynamic eventId;
@dynamic rmsUrl;
@dynamic vrxUrl;
@dynamic ilsUrl;
@dynamic vsuUrl;
@dynamic userId;
@dynamic nickName;

- (id) initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
  tapGr.cancelsTouchesInView = NO;
  [self addGestureRecognizer:tapGr];
  
  self.backgroundColor = [MaterialDesignColor blueGrey900];
  
  self.headerLogo = [UIImageView new];
  [self.headerLogo setImage:[UIImage imageNamed:@"logo_header"]];
  [self addSubview:self.headerLogo];
  
  self.apiKeyLbl = [self newLabel:@"API Key"];
  [self addSubview:self.apiKeyLbl];
  self.tenantIdLbl = [self newLabel:@"Tenant ID"];
  [self addSubview:self.tenantIdLbl];
  self.eventIdLbl = [self newLabel:@"Event ID"];
  [self addSubview:self.eventIdLbl];
  self.rmsUrlLbl = [self newLabel:@"RMS URL"];
  [self addSubview:self.rmsUrlLbl];
  self.vrxUrlLbl = [self newLabel:@"VRX URL"];
  [self addSubview:self.vrxUrlLbl];
  self.ilsUrlLbl = [self newLabel:@"ILS URL"];
  [self addSubview:self.ilsUrlLbl];
  self.vsuUrlLbl = [self newLabel:@"VSU URL"];
  [self addSubview:self.vsuUrlLbl];
  self.userIdLbl = [self newLabel:@"User ID"];
  [self addSubview:self.userIdLbl];
  self.nickNameLbl = [self newLabel:@"Nick Name"];
  [self addSubview:self.nickNameLbl];
  self.testEnvLbl = [self newLabel:@"EnvPreset"];
  [self addSubview:self.testEnvLbl];
  self.mediaModeLbl = [self newLabel:@"MediaMode"];
  [self addSubview:self.mediaModeLbl];
  
  self.apiKeyTf = [self newTextFiled:@""];
  [self addSubview:self.apiKeyTf];
  self.tenantIdTf = [self newTextFiled:@""];
  [self addSubview:self.tenantIdTf];
  self.eventIdTf = [self newTextFiled:@""];
  [self addSubview:self.eventIdTf];
  self.rmsUrlTf = [self newTextFiled:@""];
  [self addSubview:self.rmsUrlTf];
  self.vrxUrlTf = [self newTextFiled:@""];
  [self addSubview:self.vrxUrlTf];
  self.ilsUrlTf = [self newTextFiled:@""];
  [self addSubview:self.ilsUrlTf];
  self.vsuUrlTf = [self newTextFiled:@""];
  [self addSubview:self.vsuUrlTf];
  self.userIdTf = [self newTextFiled:@""];
  [self addSubview:self.userIdTf];
  self.nickNameTf = [self newTextFiled:@""];
  [self addSubview:self.nickNameTf];
  
  self.testEnvSwitch = [[JTMaterialSwitch alloc] init];
  self.testEnvSwitch.isOn = NO;
  self.testEnvSwitch.delegate = self;
  [self addSubview:self.testEnvSwitch];
  
  self.mediaModeSwitch = [[JTMaterialSwitch alloc] init];
  self.mediaModeSwitch.isOn = NO;
  self.mediaModeSwitch.delegate = self;
  [self addSubview:self.mediaModeSwitch];
  
  self.joinBtn = [UIButton new];
  [self addSubview:self.joinBtn];
  [_joinBtn addTarget:self action:@selector(onJoinClicked) forControlEvents:UIControlEventTouchUpInside ];
  // [self.joinBtn setImage:[MaterialDesignSymbol imageWithCode:MaterialDesignIconCode.call48px fontSize:60.f fontColor:[UIColor greenColor]] forState:UIControlStateNormal];
  [self.joinBtn setImage:[UIImage imageNamed:@"join_room"] forState:UIControlStateNormal];
  
  self.scanBtn = [UIButton new];
  [self addSubview:self.scanBtn];
  [self.scanBtn addTarget:self action:@selector(onScanClicked) forControlEvents:UIControlEventTouchUpInside ];
  //[self.scanBtn setImage:[EntypoSymbol imageWithCode:EntypoIconCode.camera fontSize:60.f fontColor:[UIColor whiteColor]] forState:UIControlStateNormal];
  [self.scanBtn setImage:[UIImage imageNamed:@"scan_qrcode"] forState:UIControlStateNormal];
  
  UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
  [self addGestureRecognizer:tapGesturRecognizer];
  
  [self loadParam];
  [self setLayout];
  
  return self ;
}

-(void)tapAction:(id)tap {
  [self endEditing:YES];
}

-(UITextField*) newTextFiled:(NSString*) title
{
  UITextField* tf = [[UITextField alloc] initWithFrame:CGRectZero ];
  tf.textColor = [UIColor darkGrayColor];
  tf.backgroundColor = [UIColor whiteColor];
  tf.tintColor = [UIColor redColor];
  tf.borderStyle = UITextBorderStyleRoundedRect;
  return tf;
}

- (UILabel*) newLabel:(NSString*) title
{
  UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectZero ];
  lbl.textColor = [UIColor greenColor];
  lbl.backgroundColor = [UIColor clearColor];
  lbl.tintColor = [UIColor redColor];
  lbl.textAlignment = NSTextAlignmentRight;
  [lbl setText:title];
  return lbl;
}

- (void)loadParam {
  NSString *optionApiKey = [[NSUserDefaults standardUserDefaults] objectForKey:APIKEY_KEY];
  NSString *optionTenantId = [[NSUserDefaults standardUserDefaults] objectForKey:TENANT_ID_KEY];
  NSString *optionEventId = [[NSUserDefaults standardUserDefaults] objectForKey:EVENT_ID_KEY];
  NSString *optionRmsUrl = [[NSUserDefaults standardUserDefaults] objectForKey:RMS_URL_KEY];
  NSString *optionVrxUrl = [[NSUserDefaults standardUserDefaults] objectForKey:VRX_URL_KEY];
  NSString *optionIlsUrl = [[NSUserDefaults standardUserDefaults] objectForKey:ILS_URL_KEY];
  NSString *optionVsuUrl = [[NSUserDefaults standardUserDefaults] objectForKey:VSU_URL_KEY];
  NSString *optionUserId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID_KEY];
  NSString *optionNickName = [[NSUserDefaults standardUserDefaults] objectForKey:NICK_NAME_KEY];
  
  self.apiKeyTf.text = optionApiKey != nil ? optionApiKey : DEV_APIKEY;
  self.tenantIdTf.text = optionTenantId != nil ? optionTenantId : DEV_TENANT_ID;
  self.eventIdTf.text = optionEventId != nil ? optionEventId : DEV_EVENT_ID;
  self.rmsUrlTf.text = optionRmsUrl != nil ? optionRmsUrl : DEV_RMS_URL;
  self.vrxUrlTf.text = optionVrxUrl != nil ? optionVrxUrl : DEV_VRX_URL;
  self.ilsUrlTf.text = optionIlsUrl != nil ? optionIlsUrl : DEV_ILS_URL;
  self.vsuUrlTf.text = optionVsuUrl != nil ? optionVsuUrl : DEV_VSU_URL;
  self.userIdTf.text = optionUserId != nil ? optionUserId : DEV_USER_ID;
  self.nickNameTf.text = optionNickName != nil ? optionNickName : DEV_NICK_NAME;
}

- (void)saveParam {
  [[NSUserDefaults standardUserDefaults] setObject:self.apiKeyTf.text forKey:APIKEY_KEY];
  [[NSUserDefaults standardUserDefaults] setObject:self.tenantIdTf.text forKey:TENANT_ID_KEY];
  [[NSUserDefaults standardUserDefaults] setObject:self.eventIdTf.text forKey:EVENT_ID_KEY];
  [[NSUserDefaults standardUserDefaults] setObject:self.rmsUrlTf.text forKey:RMS_URL_KEY];
  [[NSUserDefaults standardUserDefaults] setObject:self.vrxUrlTf.text forKey:VRX_URL_KEY];
  [[NSUserDefaults standardUserDefaults] setObject:self.ilsUrlTf.text forKey:ILS_URL_KEY];
  [[NSUserDefaults standardUserDefaults] setObject:self.vsuUrlTf.text forKey:VSU_URL_KEY];
  [[NSUserDefaults standardUserDefaults] setObject:self.userIdTf.text forKey:USER_ID_KEY];
  [[NSUserDefaults standardUserDefaults] setObject:self.nickNameTf.text forKey:NICK_NAME_KEY];
}

- (void)setLayout {
  [self.headerLogo mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self);
    make.top.equalTo(self).offset(20);
    make.width.equalTo(self).multipliedBy(0.5);
    make.height.equalTo(self).multipliedBy(0.1);
  } ];
  
  [self.apiKeyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self).multipliedBy(0.3);
    make.top.equalTo(self.headerLogo.mas_bottom).offset(15);
    make.width.equalTo(self).multipliedBy(0.3);
  } ];
  [self.tenantIdLbl mas_makeConstraints:^(MASConstraintMaker *make) {
    make.width.left.equalTo(self.apiKeyLbl);
    make.top.equalTo(self.apiKeyLbl.mas_bottom).offset(15);
    make.size.equalTo(self.apiKeyLbl);
  } ];
  [self.eventIdLbl mas_makeConstraints:^(MASConstraintMaker *make) {
    make.width.left.equalTo(self.tenantIdLbl);
    make.top.equalTo(self.tenantIdLbl.mas_bottom).offset(15);
    make.size.equalTo(self.tenantIdLbl);
  } ];
  [self.rmsUrlLbl mas_makeConstraints:^(MASConstraintMaker *make) {
    make.width.left.equalTo(self.eventIdLbl);
    make.top.equalTo(self.eventIdLbl.mas_bottom).offset(15);
    make.size.equalTo(self.eventIdLbl);
  } ];
  [self.vrxUrlLbl mas_makeConstraints:^(MASConstraintMaker *make) {
    make.width.left.equalTo(self.rmsUrlLbl);
    make.top.equalTo(self.rmsUrlLbl.mas_bottom).offset(15);
    make.size.equalTo(self.rmsUrlLbl);
  } ];
  [self.ilsUrlLbl mas_makeConstraints:^(MASConstraintMaker *make) {
    make.width.left.equalTo(self.vrxUrlLbl);
    make.top.equalTo(self.vrxUrlLbl.mas_bottom).offset(15);
    make.size.equalTo(self.vrxUrlLbl);
  } ];
  [self.vsuUrlLbl mas_makeConstraints:^(MASConstraintMaker *make) {
    make.width.left.equalTo(self.ilsUrlLbl);
    make.top.equalTo(self.ilsUrlLbl.mas_bottom).offset(15);
    make.size.equalTo(self.ilsUrlLbl);
  } ];
  [self.userIdLbl mas_makeConstraints:^(MASConstraintMaker *make) {
    make.width.left.equalTo(self.vsuUrlLbl);
    make.top.equalTo(self.vsuUrlLbl.mas_bottom).offset(15);
    make.size.equalTo(self.vsuUrlLbl);
  } ];
  [self.nickNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
    make.width.left.equalTo(self.userIdLbl);
    make.top.equalTo(self.userIdLbl.mas_bottom).offset(15);
    make.size.equalTo(self.userIdLbl);
  } ];
  [self.testEnvLbl mas_makeConstraints:^(MASConstraintMaker *make) {
    make.width.left.equalTo(self.nickNameLbl);
    make.top.equalTo(self.nickNameLbl.mas_bottom).offset(15);
    make.size.equalTo(self.nickNameLbl);
  } ];
  [self.mediaModeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.testEnvSwitch.mas_right);
    make.top.equalTo(self.testEnvLbl);
    make.width.equalTo(self.testEnvLbl);
    make.size.equalTo(self.testEnvLbl);
  } ];
  
  [self.apiKeyTf mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.apiKeyLbl.mas_right).offset(15);
    make.right.equalTo(self).offset(-30);
    make.centerY.equalTo(self.apiKeyLbl);
    make.height.equalTo(self.apiKeyLbl);
  } ];
  [self.tenantIdTf mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.tenantIdLbl.mas_right).offset(15);
    make.right.equalTo(self).offset(-30);
    make.centerY.equalTo(self.tenantIdLbl);
    make.height.equalTo(self.tenantIdLbl);
  } ];
  [self.eventIdTf mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.eventIdLbl.mas_right).offset(15);
    make.right.equalTo(self).offset(-30);
    make.centerY.equalTo(self.eventIdLbl);
    make.height.equalTo(self.eventIdLbl);
  } ];
  [self.rmsUrlTf mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.rmsUrlLbl.mas_right).offset(15);
    make.right.equalTo(self).offset(-30);
    make.centerY.equalTo(self.rmsUrlLbl);
    make.height.equalTo(self.rmsUrlLbl);
  } ];
  [self.vrxUrlTf mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.vrxUrlLbl.mas_right).offset(15);
    make.right.equalTo(self).offset(-30);
    make.centerY.equalTo(self.vrxUrlLbl);
    make.height.equalTo(self.vrxUrlLbl);
  } ];
  [self.ilsUrlTf mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.ilsUrlLbl.mas_right).offset(15);
    make.right.equalTo(self).offset(-30);
    make.centerY.equalTo(self.ilsUrlLbl);
    make.height.equalTo(self.ilsUrlLbl);
  } ];
  [self.vsuUrlTf mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.vsuUrlLbl.mas_right).offset(15);
    make.right.equalTo(self).offset(-30);
    make.centerY.equalTo(self.vsuUrlLbl);
    make.height.equalTo(self.vsuUrlLbl);
  } ];
  [self.userIdTf mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.userIdLbl.mas_right).offset(15);
    make.right.equalTo(self).offset(-30);
    make.centerY.equalTo(self.userIdLbl);
    make.height.equalTo(self.userIdLbl);
  } ];
  [self.nickNameTf mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.nickNameLbl.mas_right).offset(15);
    make.right.equalTo(self).offset(-30);
    make.centerY.equalTo(self.nickNameLbl);
    make.height.equalTo(self.nickNameLbl);
  } ];
  [self.testEnvSwitch mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.testEnvLbl.mas_right).offset(15);
    make.centerY.equalTo(self.testEnvLbl);
    make.width.equalTo(@50);
    make.height.equalTo(@30);
  }];
  [self.mediaModeSwitch mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.mediaModeLbl.mas_right).offset(15);
    make.centerY.equalTo(self.mediaModeLbl);
    make.width.equalTo(@50);
    make.height.equalTo(@30);
  }];
  
  [self.joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self).multipliedBy(0.65);
    make.top.equalTo(self.testEnvLbl.mas_bottom).offset(15);
    make.size.equalTo(@60);
  } ];
  [self.scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self).multipliedBy(1.35);
    make.top.equalTo(self.testEnvLbl.mas_bottom).offset(15);
    make.size.equalTo(@60);
  } ];
}

- (void) layoutSubviews {
  // will be call by super@UIView, don't make constraint in it
  UIInterfaceOrientation ori = [[UIApplication sharedApplication] statusBarOrientation];
  if (ori == UIDeviceOrientationPortrait || ori == UIDeviceOrientationPortraitUpsideDown) {
    
  } else {
    
  }
}

- (void)switchStateChanged:(JTMaterialSwitchState)currentState fromSwitch:(JTMaterialSwitch*)control {
  if (control == self.testEnvSwitch) {
    if (currentState == JTMaterialSwitchStateOn) {
      self.apiKeyTf.text = DEV_APIKEY;
      self.tenantIdTf.text = DEV_TENANT_ID;
      self.eventIdTf.text = DEV_EVENT_ID;
      self.rmsUrlTf.text = DEV_RMS_URL;
      self.vrxUrlTf.text = DEV_VRX_URL;
      self.ilsUrlTf.text = DEV_ILS_URL;
      self.vsuUrlTf.text = DEV_VSU_URL;
      self.userIdTf.text = DEV_USER_ID;
      self.nickNameTf.text = DEV_NICK_NAME;
    } else {
      self.apiKeyTf.text = PRD_APIKEY;
      self.tenantIdTf.text = PRD_TENANT_ID;
      self.eventIdTf.text = PRD_EVENT_ID;
      self.rmsUrlTf.text = PRD_RMS_URL;
      self.vrxUrlTf.text = PRD_VRX_URL;
      self.ilsUrlTf.text = PRD_ILS_URL;
      self.vsuUrlTf.text = PRD_VSU_URL;
      self.userIdTf.text = PRD_USER_ID;
      self.nickNameTf.text = PRD_NICK_NAME;
    }
    [self saveParam];
  } else if (control == self.mediaModeSwitch) {
    [[VSRTC sharedInstance] setMediaServiceMode:currentState == JTMaterialSwitchStateOn];
  }
}

- (NSString*) apiKey {
  return self.apiKeyTf.text;
}

- (NSString*) tenantId {
  return self.tenantIdTf.text;
}

- (NSString*) eventId {
  return self.eventIdTf.text;
}

- (NSString*) rmsUrl {
  return self.rmsUrlTf.text;
}

- (NSString*) vrxUrl {
  return self.vrxUrlTf.text;
}

- (NSString*) ilsUrl {
  return self.ilsUrlTf.text;
}

- (NSString*) vsuUrl {
  return self.vsuUrlTf.text;
}

- (NSString*) userId {
  return self.userIdTf.text;
}

- (NSString*) nickName {
  return self.nickNameTf.text;
}

#pragma mark - delegate
- (void) onJoinClicked {
  if (self.delegate) {
    [self saveParam];
    [self.delegate onJoinClicked];
  }
}

- (void) onScanClicked {
  if (self.delegate) {
    [self saveParam];
    [self.delegate onScanClicked];
  }
}

#pragma mark - actions
- (void)viewTapped:(UITapGestureRecognizer *)tapGr {
  [self.apiKeyTf resignFirstResponder];
  [self.tenantIdTf resignFirstResponder];
  [self.eventIdTf resignFirstResponder];
  [self.rmsUrlTf resignFirstResponder];
  [self.vrxUrlTf resignFirstResponder];
  [self.ilsUrlTf resignFirstResponder];
  [self.vsuUrlTf resignFirstResponder];
  [self.userIdTf resignFirstResponder];
  [self.nickNameTf resignFirstResponder];
}
@end
