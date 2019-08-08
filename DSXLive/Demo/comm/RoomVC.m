//
//  RoomVC.m
//
//  Created by pliu on 20/9/2017.
//  Copyright © 2017 VSVideo. All rights reserved.
//

#import "RoomVC.h"
#import "MediaViewGroup.h"
#import "LoginView.h"
#import <VSRTC/VSRTC.h>
#import <VSRTC/VSChat.h>
#import "Masonry.h"
#import "MBProgressHUD.h"
#import "MaterialDesignSymbol.h"
#import "EntypoSymbol.h"
#import "MaterialDesignColor.h"
#import "ConsoleTextView.h"

#define LOG_FOLDER        @"Log"

@interface RoomVC () <VSRTCDelegate, VSChatHandler>
{
}
@property (nonatomic, strong) UIView* panelView;
@property (nonatomic, strong) MediaViewGroup* localGroup;
@property (nonatomic, strong) ConsoleTextView* chatLog;
@property (nonatomic, strong) MediaViewGroup* remoteGroup;
@property (nonatomic, strong) UIView* controlPanel;
@property (nonatomic, strong) UIButton* btnHangup;
@property (nonatomic, strong) UIButton* btnSetting;
@property (nonatomic, strong) UIButton* btnHand;
@property (nonatomic, strong) UIButton* btnChat;
@property (nonatomic, strong) UIButton* btnCaptureMedia;
@property (nonatomic, strong) UIButton* btnScreenMedia;
@property (nonatomic, strong) UIButton* btnFileMedia;
@property (nonatomic, strong) MBProgressHUD *notifyView;

@property (nonatomic, strong) VSMedia* captureMedia;
@property (nonatomic, strong) VSMedia* screenMedia;
@property (nonatomic, strong) VSMedia* fileMedia;

@property (nonatomic, strong) VSChat* chatChannel;

@property (nonatomic, strong) NSString* logFilePath;
@end

@implementation RoomVC

- (id)init {
  self = [super init];
  
  [[VSRTC sharedInstance] setObserver:self];
  
  return self;
}

- (void)dealloc{
  // [[VSRTC sharedInstance] setObserver:nil];
  
  NSLog(@"RoomVC dealloc");
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.panelView = [UIView new];
  self.panelView.backgroundColor = [MaterialDesignColor blueGrey900];
  [self.view addSubview:self.panelView];
  [self.panelView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.mas_topLayoutGuide);
    make.width.left.equalTo(self.view);
    make.height.equalTo(self.view).multipliedBy(0.4);
  }];
  
  self.btnHangup = [UIButton new];
  [self.btnHangup setImage:[EntypoSymbol imageWithCode:EntypoIconCode.powerPlug fontSize:30.f fontColor:[UIColor redColor]] forState:UIControlStateNormal];
  [self.btnHangup addTarget:self action:@selector(onHangupClicked) forControlEvents:UIControlEventTouchUpInside ];
  [self.panelView addSubview:self.btnHangup];
  [self.btnHangup mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.panelView).offset(15);
    make.top.equalTo(self.panelView).offset(15);
    make.size.equalTo(@30);
  }];
  
  //[self.rtmpUrlLbl setImage:[MaterialDesignSymbol imageWithCode:MaterialDesignIconCode.exposure48px fontSize:30.f fontColor:[UIColor whiteColor]]];// 曝光参数
  
  self.btnSetting = [UIButton new];
  [self.btnSetting setImage:[MaterialDesignSymbol imageWithCode:MaterialDesignIconCode.settings48px fontSize:30.f fontColor:[UIColor whiteColor]] forState:UIControlStateNormal];
  [self.btnSetting addTarget:self action:@selector(onSettingClicked) forControlEvents:UIControlEventTouchUpInside ];
  [self.panelView addSubview:self.btnSetting];
  [self.btnSetting mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.btnHangup.mas_right).offset(10);
    make.top.equalTo(self.btnHangup);
    make.size.equalTo(@30);
  }];
  
  _localGroup = [[MediaViewGroup alloc] initWithMode:YES];
  _localGroup.backgroundColor = [UIColor blackColor];
  _localGroup.layer.cornerRadius = 5;
  _localGroup.layer.masksToBounds = YES;
  [self.view addSubview: _localGroup];
  [_localGroup mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self.view).offset(-10);
    make.top.equalTo(self.btnHangup);
    make.width.equalTo(self.panelView).multipliedBy(0.5);
    make.bottom.equalTo(self.panelView).offset(-10);
  } ];
  
  self.btnHand = [UIButton new];
  [self.btnHand setImage:[UIImage imageNamed:@"member_hand"] forState:UIControlStateNormal];
  [self.btnHand addTarget:self action:@selector(onHandActionClicked) forControlEvents:UIControlEventTouchUpInside];
  [self.panelView addSubview:self.btnHand];
  [self.btnHand mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self.localGroup.mas_left).offset(-5);
    make.bottom.equalTo(self.localGroup);
    make.size.equalTo(@30);
  }];
  
  self.btnChat = [UIButton new];
  [self.btnChat setImage:[MaterialDesignSymbol imageWithCode:MaterialDesignIconCode.chat48px fontSize:30.f fontColor:[UIColor whiteColor]] forState:UIControlStateNormal];
  [self.btnChat addTarget:self action:@selector(onChatActionClicked) forControlEvents:UIControlEventTouchUpInside];
  [self.panelView addSubview:self.btnChat];
  [self.btnChat mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self.localGroup.mas_left).offset(-5);
    make.bottom.equalTo(self.btnHand.mas_top).offset(-10);
    make.size.equalTo(@30);
  }];
  
  self.btnCaptureMedia = [UIButton new];
  [self.btnCaptureMedia setImage:[EntypoSymbol imageWithCode:EntypoIconCode.camera fontSize:30.f fontColor:[UIColor whiteColor]] forState:UIControlStateNormal];
  [self.btnCaptureMedia setImage:[EntypoSymbol imageWithCode:EntypoIconCode.camera fontSize:30.f fontColor:[UIColor greenColor]] forState:UIControlStateSelected];
  [self.btnCaptureMedia addTarget:self action:@selector(onCaptureMediaClicked) forControlEvents:UIControlEventTouchUpInside ];
  [self.panelView addSubview:self.btnCaptureMedia];
  [self.btnCaptureMedia mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self.localGroup.mas_left).offset(-5);
    make.bottom.equalTo(self.btnChat.mas_top).offset(-10);
    make.size.equalTo(@30);
  }];
  
  self.btnScreenMedia = [UIButton new];
  [self.btnScreenMedia setImage:[MaterialDesignSymbol imageWithCode:MaterialDesignIconCode.fullscreen24px fontSize:30.f fontColor:[UIColor whiteColor]] forState:UIControlStateNormal];
  [self.btnScreenMedia setImage:[MaterialDesignSymbol imageWithCode:MaterialDesignIconCode.fullscreen24px fontSize:30.f fontColor:[UIColor greenColor]] forState:UIControlStateSelected];
  [self.btnScreenMedia addTarget:self action:@selector(onScreenMediaClicked) forControlEvents:UIControlEventTouchUpInside];
  [self.panelView addSubview:self.btnScreenMedia];
  [self.btnScreenMedia mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self.localGroup.mas_left).offset(-5);
    make.bottom.equalTo(self.btnCaptureMedia.mas_top).offset(-10);
    make.size.equalTo(@30);
  }];
  
  self.btnFileMedia = [UIButton new];
  [self.btnFileMedia setImage:[EntypoSymbol imageWithCode:EntypoIconCode.folderVideo fontSize:30.f fontColor:[UIColor whiteColor]] forState:UIControlStateNormal];
  [self.btnFileMedia setImage:[EntypoSymbol imageWithCode:EntypoIconCode.folderVideo fontSize:30.f fontColor:[UIColor greenColor]] forState:UIControlStateSelected];
  [self.btnFileMedia addTarget:self action:@selector(onFileMediaClicked) forControlEvents:UIControlEventTouchUpInside];
  [self.panelView addSubview:self.btnFileMedia];
  [self.btnFileMedia mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self.localGroup.mas_left).offset(-5);
    make.bottom.equalTo(self.btnScreenMedia.mas_top).offset(-10);
    make.size.equalTo(@30);
  }];
  
  self.chatLog = [ConsoleTextView new];
  self.chatLog.prefixFormat = @"";
  self.chatLog.layer.cornerRadius = 5;
  self.chatLog.layer.masksToBounds = YES;
  self.chatLog.layer.borderWidth = 3;
  self.chatLog.layer.borderColor = [[UIColor darkGrayColor] CGColor];
  [self.panelView addSubview:self.chatLog];
  [self.chatLog mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.btnHangup);
    make.top.equalTo(self.btnHangup.mas_bottom).offset(10);
    make.right.equalTo(self.btnHand.mas_left).offset(-10);
    make.bottom.equalTo(self.btnHand);
  }];
  
  _remoteGroup = [[MediaViewGroup alloc] initWithMode:NO];
  _remoteGroup.backgroundColor = [UIColor blackColor];
  [self.view addSubview: _remoteGroup];
  [_remoteGroup mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(_panelView.mas_bottom);
    make.width.left.equalTo(self.view);
    make.bottom.equalTo(self.view);
  } ];
  
  [[VSRTC sharedInstance] setObserver:self];
  
  NSArray *memberList = [[VSRTC sharedInstance] getMemberList];
  for (VSRoomUser *user in memberList) {
    [self setRemoteMedia:user];
  }
  
  [self openLog];
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.navigationController.navigationBar.hidden = YES;
};

- (void) viewDidAppear:(BOOL)animated {
  [UIApplication sharedApplication].idleTimerDisabled = YES;
  [super viewDidAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
  [UIApplication sharedApplication].idleTimerDisabled = NO;
  [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)openLog {
  NSString *fileName = [[NSProcessInfo processInfo] globallyUniqueString];
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString* logDir = [[paths objectAtIndex:0] stringByAppendingPathComponent:LOG_FOLDER];
  if (![[NSFileManager defaultManager] fileExistsAtPath:logDir isDirectory:nil]){
    [[NSFileManager defaultManager] createDirectoryAtPath:logDir withIntermediateDirectories:YES attributes:nil error:nil];
  }
  
  self.logFilePath = [logDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",fileName]];
  [[VSRTC sharedInstance] startFileLog:self.logFilePath];
}

- (void)shareLog {
  [[VSRTC sharedInstance] stopFileLog];
  
  //在iOS 11不显示分享选项了
  //定义URL数组
  NSArray *urls=@[[ NSURL fileURLWithPath:self.logFilePath]];
  //创建分享的类型,注意这里没有常见的微信,朋友圈以QQ等,但是罗列完后,实际运行是相应按钮的,所以可以运行.
  
  UIActivityViewController *activituVC=[[UIActivityViewController alloc]initWithActivityItems:urls applicationActivities:nil];
  NSArray *cludeActivitys=@[UIActivityTypePostToFacebook,
                            UIActivityTypePostToTwitter,
                            UIActivityTypePostToWeibo,
                            UIActivityTypePostToVimeo,
                            UIActivityTypeMessage,
                            UIActivityTypeMail,
                            UIActivityTypeCopyToPasteboard,
                            UIActivityTypePrint,
                            UIActivityTypeAssignToContact,
                            UIActivityTypeSaveToCameraRoll,
                            UIActivityTypeAddToReadingList,
                            UIActivityTypePostToFlickr,
                            UIActivityTypePostToTencentWeibo];
  activituVC.excludedActivityTypes=cludeActivitys;
  
  //显示分享窗口
  [self presentViewController:activituVC animated:YES completion:nil];
}

- (void)setRemoteMedia:(VSRoomUser *)user {
  VSMedia *existMedia = [self.remoteGroup FindExistMedia:user.userId ofType:YES];
  if (existMedia != nil) {
    if ([existMedia stream_id] != [user stream_id]) {
      // change remote media
      [self.remoteGroup RemoveMediaView:[existMedia mid]];
      [[VSRTC sharedInstance] DestroyRemoteMedia:[existMedia mid]];
      existMedia = nil;
    } else {
      // only update user info
      MediaViewInterface *mediaView = [self.remoteGroup FindMediaView:user.userId];
      [mediaView updateUser:user];
    }
  }
  
  // add remote media
  if (existMedia == nil && [user stream_id] != 0) {
    VSMedia *newMedia = [[VSRTC sharedInstance] CreateRemoteMedia:[user stream_id] reuseExist:YES];
    [self.remoteGroup AddMediaView:newMedia forUser:user];
  }
}

- (void)clearRemoteMedia:(VSRoomUser *)user {
  VSMedia *existMedia = [self.remoteGroup FindExistMedia:user.userId ofType:YES];
  if (existMedia != nil && [existMedia stream_id] == [user stream_id]) {
    [self.remoteGroup RemoveMediaView:[existMedia mid]];
    [[VSRTC sharedInstance] DestroyRemoteMedia:[existMedia mid]];
  }
  VSMedia *existCourseMedia = [self.remoteGroup FindExistMedia:user.userId ofType:NO];
  if (existCourseMedia != nil && [existCourseMedia stream_id] == [user course_stream_id]) {
    [self.remoteGroup RemoveMediaView:[existCourseMedia mid]];
    [[VSRTC sharedInstance] DestroyRemoteMedia:[existCourseMedia mid]];
  }
}

- (void) onHangupClicked {
  [[VSRTC sharedInstance] leaveRoom];
}

- (void) onSettingClicked {
  [self shareLog];
  
      [[VSRTC sharedInstance] connectMediaService:@"rtmp://192.168.2.101:1935/rtmplive/livestream" host:@"" room:12345];
    
//    [[VSRTC sharedInstance] startup:@"rtmp://192.168.2.101:1935/rtmplive/livestream"];
    
    /*
    
    
#if 0
  
//  [[VSRTC sharedInstance] connectMediaService:@"https://sf.mlive.tv189.com:8089/janus" room:1234];

    [[VSRTC sharedInstance] startup:@"rtmp://192.168.2.101:1935/rtmplive/livestream"];
  
  NSString *roomInfo = [[VSRTC sharedInstance] getRoomInfo];
  NSDictionary *roomInfoDic = [self dictionaryMessage:roomInfo];
  NSMutableDictionary *newRoomInfoDic = [NSMutableDictionary dictionaryWithDictionary:roomInfoDic];
  NSNumber *hostOnDuty = newRoomInfoDic[@"hostOnDuty"];
  newRoomInfoDic[@"hostOnDuty"] = [NSNumber numberWithBool:!hostOnDuty.boolValue];
  
  NSString *newRoomInfo = [self jsonMessage:newRoomInfoDic];
  [[VSRTC sharedInstance] updateRoomInfo:newRoomInfo];
  
  [[VSRTC sharedInstance] kickUser:@"cp-6p"];
  
  [[VSRTC sharedInstance] fakeException:NO];
#else
  static BOOL sw = NO;
  [[VSRTC sharedInstance] sendMessage:@"上海Hello" toUser:@"cp-6p"];
  sw = !sw;
  
#endif
     */
}

- (void) onHandActionClicked {
  VSRoomUser *session = [[VSRTC sharedInstance] getSession];
  [[VSRTC sharedInstance] updateNickName:@"上海Hello"];
}

- (void) onChatActionClicked {
  if (self.chatChannel == nil) {
    [self alertWithTitle:@"Chat Not Init" message:@"Can not send message" ButtonArray:@[@"OK"] LastAlertAction:^(NSInteger index) {
    }];
    return;
  }
  [self.chatChannel SendMessage:@"广播消息:Public Message" toUser:nil];
  [self.chatChannel SendMessage:@"私聊消息:Private Message" toUser:@"2ISKvgHOKi5J"];
}

- (void) onCaptureMediaClicked {
  if (self.captureMedia == nil) {
    VSRoomUser* myself = [[VSRTC sharedInstance] getSession];
    self.captureMedia = [[VSRTC sharedInstance] CreateCaptureMedia];
    [_localGroup AddMediaView:self.captureMedia forUser:myself];
  } else {
    [_localGroup RemoveMediaView:[self.captureMedia mid]];
    self.captureMedia = nil;
    [[VSRTC sharedInstance] DestroyCaptureMedia];
  }
  self.btnCaptureMedia.selected = (self.captureMedia != nil);
}

- (void) onScreenMediaClicked {
  if (self.screenMedia == nil) {
    VSRoomUser* myself = [[VSRTC sharedInstance] getSession];
    self.screenMedia = [[VSRTC sharedInstance] CreateScreenMedia];
    [_localGroup AddMediaView:self.screenMedia forUser:myself];
  } else {
    [_localGroup RemoveMediaView:[self.screenMedia mid]];
    self.screenMedia = nil;
    [[VSRTC sharedInstance] DestroyScreenMedia];
  }
  self.btnScreenMedia.selected = (self.screenMedia != nil);
}

- (void) onFileMediaClicked {
  if (self.fileMedia == nil) {
    NSArray *documentTypes = @[@"public.video", @"public.mpeg-4", @"public.mpeg-4-video"];
    UIDocumentPickerViewController *documentPickerViewController = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:documentTypes inMode:UIDocumentPickerModeImport];
    documentPickerViewController.delegate = self;
    [self presentViewController:documentPickerViewController animated:YES completion:nil];
  } else {
    [_localGroup RemoveMediaView:[self.fileMedia mid]];
    self.fileMedia = nil;
    [[VSRTC sharedInstance] DestroyFileMedia];
    self.btnFileMedia.selected = NO;
  }
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
  NSArray *array = [[url absoluteString] componentsSeparatedByString:@"/"];
  NSString *fileName = [array lastObject];
  fileName = [fileName stringByRemovingPercentEncoding];
  NSLog(@"文件路径");
  
  VSRoomUser* myself = [[VSRTC sharedInstance] getSession];
  self.fileMedia = [[VSRTC sharedInstance] CreateFileMedia:url.path];
  [_localGroup AddMediaView:self.fileMedia forUser:myself];
  self.btnFileMedia.selected = YES;
}

- (void) onSessionInit:(VSRoomUser*)session {
  
}

- (void) onSessionUpdate:(VSRoomUser*)session {
  [self setRemoteMedia:session];
}

- (void)onSessionError:(int)status andDesc:(NSString *)msg {
  [self alertWithTitle:@"Session Error" message:msg ButtonArray:@[@"OK"] LastAlertAction:^(NSInteger index) {
    [[VSRTC sharedInstance] leaveRoom];
  }];
}

- (void)onSessionQuit {
  VSRoomUser* myself = [[VSRTC sharedInstance] getSession];
  [self clearRemoteMedia:myself];
  
  [self.localGroup RemoveAllMediaView];
  self.localGroup = nil;
  
  [self.remoteGroup RemoveAllMediaView];
  self.remoteGroup = nil;
  
  [self.navigationController popViewControllerAnimated:YES];
}

- (void) onMemberJoin:(VSRoomUser*)user {
  NSLog(@"[UI] onMemberJoin");
  
  [self setRemoteMedia:user];
}

- (void) onMemberUpdate:(VSRoomUser*)user {
  NSLog(@"[UI] onMemberUpdate");
  
  [self setRemoteMedia:user];
}

- (void) onMemberLeave:(VSRoomUser*)user {
  NSLog(@"[UI] onMemberLeave");
  
  [self clearRemoteMedia:user];
}

- (void)onAppMessage:(NSString*)msg {
  NSDictionary *msgDic = [self dictionaryMessage:msg];
  NSString *msgType = [msgDic objectForKey:@"type"];
  [self.chatLog log:[NSString stringWithFormat:@"got message type = %@", msgType]];
  [self displayHud:msg];
}

- (void)onRoomInfoRefresh:(NSString*)data {
  NSDictionary *dataDic = [self dictionaryMessage:data];
  NSLog(@"[UI] onRoomInfoRefresh data=%@", dataDic);
}

- (void)onMediaServiceReady {
  [self displayHud:@"onMediaServiceReady"];
  
  self.chatChannel = [[VSRTC sharedInstance] CreateChat];
  [self.chatChannel SetMessageHandler:self];
  [self.chatChannel Open];
}

- (void)onMediaServiceLost {
  [self displayHud:@"onMediaServiceLost"];
}

- (void)OnChatOpen {
  [self displayHud:@"OnChatOpen"];
}

- (void)OnChatClose {
  [self displayHud:@"OnChatClose"];
}

- (void)OnChatMessage:(NSDictionary *)msgDic {
  NSString *msgSender = [msgDic objectForKey:@"from"];
  NSString *msgContent = [msgDic objectForKey:@"text"];
  NSNumber *isWhisper = [msgDic objectForKey:@"whisper"];
  if (isWhisper && isWhisper.boolValue) {
    NSString *privateMsg = [NSString stringWithFormat:@"PRI:%@:%@", msgSender, msgContent];
    [self displayHud:privateMsg];
  } else {
    NSString *publicMsg = [NSString stringWithFormat:@"PUB:%@:%@", msgSender, msgContent];
    [self displayHud:publicMsg];
  }
}

- (void)displayHud:(NSString *)msg{
  self.notifyView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  self.notifyView.mode = MBProgressHUDModeText;
  self.notifyView.label.text = msg;
  self.notifyView.removeFromSuperViewOnHide = YES;
  self.notifyView.backgroundView.hidden = YES;
  [self.notifyView hideAnimated:YES afterDelay:1];
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

- (uint64_t)parseUint64String:(NSString *)str {
  NSScanner *scanner = [NSScanner scannerWithString:str];
  unsigned long long convertedValue = 0;
  [scanner scanUnsignedLongLong:&convertedValue];
  return convertedValue;
}

- (NSString *)jsonMessage:(NSDictionary *)dict {
  NSData *message = [NSJSONSerialization dataWithJSONObject:dict
                                                    options:NSJSONWritingPrettyPrinted
                                                      error:nil];
  NSString *messageString = [[NSString alloc] initWithData:message encoding:NSUTF8StringEncoding];
  return messageString;
}

- (NSDictionary *)dictionaryMessage:(NSString *)str
{
  NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
  NSError *err;
  NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                      options:NSJSONReadingMutableContainers
                                                        error:&err];
  return dic;
}

- (NSString *)randomStringWithLength:(int)len {
  NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
  for (int i = 0; i< len; i++) {
    uint32_t data = arc4random_uniform((uint32_t)[letters length]);
    [randomString appendFormat: @"%C", [letters characterAtIndex: data]];
  }
  return randomString;
}

@end
