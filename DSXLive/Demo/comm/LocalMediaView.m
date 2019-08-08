#import "LocalMediaView.h"
#import "Masonry.h"
#import "MaterialDesignSymbol.h"
#import "EntypoSymbol.h"
#import <VSRTC/VSRTC.h>

@interface LocalMediaView() <VSMediaEventHandler>
{
}
@property (nonatomic, strong) UIView* videoView;
@property (nonatomic, strong) UILabel* lblName;
@property (nonatomic, strong) UILabel* lblStream;
@property (nonatomic, strong) UIButton* btnCtl;
@property (nonatomic, strong) UIButton* btnStream;
@property (nonatomic, strong) UIButton* btnAudio;
@property (nonatomic, strong) UIButton* btnVideo;
@property (nonatomic, strong) VSMedia* media;
@property (nonatomic, strong) VSRoomUser* user;

@end


@implementation LocalMediaView

- (void)dealloc{
  NSLog(@"LocalMediaView dealloc");
}

- (id) initWithMedia:(VSMedia *)media andUser:(VSRoomUser*)user {
  self = [super init];
  
  self.backgroundColor = [UIColor grayColor];
  
  self.media = media;
  self.user = [user copy];
  
  [self.media SetEventHandler:self];
  
  _videoView = [media render_view];
  [self addSubview:_videoView];
  [_videoView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.with.top.equalTo(self);
    make.size.equalTo(self);
  }];
  
  // name
  _lblName = [[UILabel alloc] init];
  [_lblName setText:@""];
  [_lblName setTextColor:[UIColor whiteColor]];
  [_lblName setBackgroundColor:[UIColor darkGrayColor]];
  [_lblName setTextAlignment:NSTextAlignmentRight];
  [_lblName setFont:[UIFont systemFontOfSize:10.0]];
  [_lblName sizeToFit];
  [_lblName setAlpha:0.7];
  [self addSubview:_lblName];
  [_lblName mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.with.top.equalTo(self);
  }];
  
  // stream
  _lblStream = [[UILabel alloc] init];
  [_lblStream setText:@""];
  [_lblStream setTextColor:[UIColor whiteColor]];
  [_lblStream setTextAlignment:NSTextAlignmentLeft];
  [_lblStream setBackgroundColor:[UIColor darkGrayColor]];
  [_lblStream setFont:[UIFont systemFontOfSize:10.0]];
  [_lblStream sizeToFit];
  [_lblStream setAlpha:0.7];
  [self addSubview:_lblStream];
  [_lblStream mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.with.bottom.equalTo(self);
  }];
  
  _btnCtl = [UIButton new];
  [_btnCtl addTarget:self action:@selector(btnCtlAction) forControlEvents:UIControlEventTouchUpInside];
  [_btnCtl setBackgroundImage:[MaterialDesignSymbol imageWithCode:MaterialDesignIconCode.settingsPower24px fontSize:30.f fontColor:[UIColor darkGrayColor]] forState:UIControlStateNormal];
  [self addSubview:_btnCtl];
  [_btnCtl mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(self).offset(-5);
    make.right.equalTo(self).offset(-5);
    make.size.equalTo(@30);
  }];
  
  _btnStream = [UIButton new];
  [_btnStream addTarget:self action:@selector(btnStreamAction) forControlEvents:UIControlEventTouchUpInside];
  [_btnStream setBackgroundImage:[MaterialDesignSymbol imageWithCode:MaterialDesignIconCode.publish24px fontSize:30.f fontColor:[UIColor darkGrayColor]] forState:UIControlStateNormal];
  [self addSubview:_btnStream];
  [_btnStream mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(self).offset(-5);
    make.right.mas_equalTo(_btnCtl.mas_left).offset(-5);
    make.size.equalTo(@30);
  }];
  
  _btnAudio = [UIButton new];
  [_btnAudio setImage:[MaterialDesignSymbol imageWithCode:MaterialDesignIconCode.micOff24px fontSize:30.f fontColor:[UIColor darkGrayColor]] forState:UIControlStateNormal];
  [_btnAudio addTarget:self action:@selector(btnAudioAction) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:_btnAudio];
  [_btnAudio mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self).offset(5);
    make.top.equalTo(self).offset(5);
    make.size.equalTo(@30);
  }];
  
  _btnVideo = [UIButton new];
  [_btnVideo setImage:[MaterialDesignSymbol imageWithCode:MaterialDesignIconCode.videocamOff24px fontSize:30.f fontColor:[UIColor darkGrayColor]] forState:UIControlStateNormal];
  [_btnVideo addTarget:self action:@selector(btnVideoAction) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:_btnVideo];
  [_btnVideo mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(_btnAudio.mas_right).offset(5);
    make.top.equalTo(self).offset(5);
    make.size.equalTo(@30);
  }];
  
  [self syncMediaState];
  [self syncMediaStreamState];
  
  return self;
}

- (BOOL)isMatchUser:(NSString*)userId {
  return [self.user.userId isEqualToString:userId];
}

- (BOOL)isMatchUser:(NSString*)userId andType:(BOOL)isCapture {
  if (![self.user.userId isEqualToString:userId]) {
    return NO;
  }
  uint64_t sourceStreamId = isCapture ? [self.user stream_id] : [self.user course_stream_id];
  return sourceStreamId == [self.media stream_id];
}

- (VSMedia*)media {
  return _media;
}

- (void)updateUser:(VSRoomUser *)user {
  
}

- (void)syncMediaState {
  switch (self.media.state) {
    case VS_MEDIA_CLOSED:
      [_btnCtl setBackgroundImage:[MaterialDesignSymbol imageWithCode:MaterialDesignIconCode.settingsPower24px fontSize:30.f fontColor:[UIColor darkGrayColor]] forState:UIControlStateNormal];
      
      if ([self.media has_audio]) {
        [_btnAudio setImage:[MaterialDesignSymbol imageWithCode:MaterialDesignIconCode.mic24px fontSize:30.f fontColor:[UIColor greenColor]] forState:UIControlStateNormal];
      } else {
        [_btnAudio setImage:[MaterialDesignSymbol imageWithCode:MaterialDesignIconCode.micOff24px fontSize:30.f fontColor:[UIColor darkGrayColor]] forState:UIControlStateNormal];
      }
      _btnAudio.enabled = NO;
      
      if ([self.media has_video]) {
        [_btnVideo setImage:[MaterialDesignSymbol imageWithCode:MaterialDesignIconCode.videocam24px fontSize:30.f fontColor:[UIColor greenColor]] forState:UIControlStateNormal];
      } else {
        [_btnVideo setImage:[MaterialDesignSymbol imageWithCode:MaterialDesignIconCode.videocamOff24px fontSize:30.f fontColor:[UIColor darkGrayColor]] forState:UIControlStateNormal];
      }
      _btnVideo.enabled = NO;
      
      _btnStream.enabled = NO;
      break;
    case VS_MEDIA_OPENING:
      [_btnCtl setBackgroundImage:[MaterialDesignSymbol imageWithCode:MaterialDesignIconCode.settingsPower24px fontSize:30.f fontColor:[UIColor yellowColor]] forState:UIControlStateNormal];
      _btnStream.enabled = NO;
      break;
    case VS_MEDIA_OPENED:
      [_btnCtl setBackgroundImage:[MaterialDesignSymbol imageWithCode:MaterialDesignIconCode.settingsPower24px fontSize:30.f fontColor:[UIColor greenColor]] forState:UIControlStateNormal];
      
      if ([self.media has_audio]) {
        [_btnAudio setImage:[MaterialDesignSymbol imageWithCode:MaterialDesignIconCode.mic24px fontSize:30.f fontColor:[UIColor greenColor]] forState:UIControlStateNormal];
      } else {
        [_btnAudio setImage:[MaterialDesignSymbol imageWithCode:MaterialDesignIconCode.micOff24px fontSize:30.f fontColor:[UIColor darkGrayColor]] forState:UIControlStateNormal];
      }
      _btnAudio.enabled = YES;
      
      if ([self.media has_video]) {
        [_btnVideo setImage:[MaterialDesignSymbol imageWithCode:MaterialDesignIconCode.videocam24px fontSize:30.f fontColor:[UIColor greenColor]] forState:UIControlStateNormal];
      } else {
        [_btnVideo setImage:[MaterialDesignSymbol imageWithCode:MaterialDesignIconCode.videocamOff24px fontSize:30.f fontColor:[UIColor darkGrayColor]] forState:UIControlStateNormal];
      }
      _btnVideo.enabled = YES;
      
      _btnStream.enabled = YES;
      break;
    case VS_MEDIA_ERROR:
      [_btnCtl setBackgroundImage:[MaterialDesignSymbol imageWithCode:MaterialDesignIconCode.settingsPower24px fontSize:30.f fontColor:[UIColor redColor]] forState:UIControlStateNormal];
      _btnStream.enabled = NO;
      break;
  }
}

- (void)syncMediaStreamState {
  switch (self.media.stream_state) {
    case VS_MEDIA_STREAM_IDLE:
      [_btnStream setBackgroundImage:[MaterialDesignSymbol imageWithCode:MaterialDesignIconCode.publish24px fontSize:30.f fontColor:[UIColor darkGrayColor]] forState:UIControlStateNormal];
      self.lblStream.text = [NSString stringWithFormat:@"sid:%llu", [self.media stream_id]];
      break;
    case VS_MEDIA_STREAM_STARTING:
      [_btnStream setBackgroundImage:[MaterialDesignSymbol imageWithCode:MaterialDesignIconCode.publish24px fontSize:30.f fontColor:[UIColor yellowColor]] forState:UIControlStateNormal];
      self.lblStream.text = [NSString stringWithFormat:@"sid:%llu", [self.media stream_id]];
      break;
    case VS_MEDIA_STREAM_STARTED:
      [_btnStream setBackgroundImage:[MaterialDesignSymbol imageWithCode:MaterialDesignIconCode.publish24px fontSize:30.f fontColor:[UIColor greenColor]] forState:UIControlStateNormal];
      self.lblStream.text = [NSString stringWithFormat:@"sid:%llu", [self.media stream_id]];
      break;
    case VS_MEDIA_STREAM_RESTARTING:
      [_btnStream setBackgroundImage:[MaterialDesignSymbol imageWithCode:MaterialDesignIconCode.publish24px fontSize:30.f fontColor:[UIColor blueColor]] forState:UIControlStateNormal];
      self.lblStream.text = [NSString stringWithFormat:@"sid:%llu", [self.media stream_id]];
      break;
    case VS_MEDIA_STREAM_FAILED:
      [_btnStream setBackgroundImage:[MaterialDesignSymbol imageWithCode:MaterialDesignIconCode.publish24px fontSize:30.f fontColor:[UIColor redColor]] forState:UIControlStateNormal];
      self.lblStream.text = [NSString stringWithFormat:@"err=%ld sid:%llu", [self.media stream_err], [self.media stream_id]];
      break;
  }
  
  // should not happen
  if (self.media.type == VS_MEDIA_REMOTE) {
    return;
  }
  
  if (self.media.stream_state == VS_MEDIA_STREAM_IDLE) {
    if (self.media.type == VS_MEDIA_CAPTURE) {
      [[VSRTC sharedInstance] updateStream:0 withType:YES];
    } else {
      [[VSRTC sharedInstance] updateStream:0 withType:NO];
    }
  } else if (self.media.stream_state == VS_MEDIA_STREAM_STARTED) {
    if (self.media.type == VS_MEDIA_CAPTURE) {
      [[VSRTC sharedInstance] updateStream:self.media.stream_id withType:YES];
    } else {
      [[VSRTC sharedInstance] updateStream:self.media.stream_id withType:NO];
    }
  } else {
    
  }
}

- (void)OnOpening {
  [self syncMediaState];
}

- (void)OnOpened {
  [self syncMediaState];
}

- (void)OnClose {
  [self syncMediaState];
}

- (void)OnError:(NSString *)errDesc {
  [self syncMediaState];
}

- (void)OnStreamIdle; {
  [self syncMediaStreamState];
}

- (void)OnStreamStarting {
  [self syncMediaStreamState];
}

- (void)OnStreamStarted:(uint64_t)streamId {
  [self syncMediaStreamState];
}

- (void)OnStreamRestarting {
  [self syncMediaStreamState];
}

- (void)OnStreamFailed {
  [self syncMediaStreamState];
}

- (void) btnCtlAction {
  if ([self.media state] == VS_MEDIA_CLOSED) {
    NSArray<VSVideoFormat *>* fmts = [self.media GetVideoFormats];
    VSVideoFormat *pref_fmt = nil;
    for (VSVideoFormat *fmt in fmts) {
      if (fmt.width == 1280 && !fmt.front) {
        pref_fmt = fmt;
        break;
      }
    }
    if (pref_fmt != nil) {
      [self.media SetPreferVideoFormat:pref_fmt];
    }
    [self.media OpenWithVideo:YES andAudio:YES];
  } else {
    [self.media Close];
  }
}

- (void) btnStreamAction {
  if ([self.media stream_state] == VS_MEDIA_STREAM_IDLE) {
    NSString *userId = [[VSRTC sharedInstance] getSession].userId;
    if ([self.media type] == VS_MEDIA_SCREEN || [self.media type] == VS_MEDIA_FILE) {
      [self.media Publish:NO streamBitrate:1200 stramLabel:[NSString stringWithFormat:@"%@-courseware-obj", userId]];
    } else {
      [self.media Publish:NO streamBitrate:1200 stramLabel:userId];
    }
  } else {
    [self.media Unpublish];
  }
}

- (void) btnVideoAction {
  static BOOL flag = YES;
  
  NSArray<VSVideoFormat *>* fmts = [self.media GetVideoFormats];
  VSVideoFormat *pref_fmt = nil;
  for (VSVideoFormat *fmt in fmts) {
    // if (fmt.width == (flag ? 1024 : 352) && (flag == fmt.front)) {
    if (fmt.width == 1280 && (flag == fmt.front)) {
      pref_fmt = fmt;
      break;
    }
  }
  if (pref_fmt != nil) {
    [self.media SetPreferVideoFormat:pref_fmt];
  }
  
  flag = !flag;
  /*
  if ([self.media has_video]) {
    [self.media EnableVideo:NO];
  } else {
    [self.media EnableVideo:YES];
  }
   */
}

- (void) btnAudioAction {
  if ([self.media has_audio]) {
    [self.media EnableAudio:NO];
   // [[VSRTC sharedInstance] ScaleCamera:10];
   //  [[VSRTC sharedInstance] SwitchFlashLight:YES];
  // [[VSRTC sharedInstance] SwitchFaceBeauty:YES];
  } else {
    [self.media EnableAudio:YES];
   // [[VSRTC sharedInstance] ScaleCamera:2];
   //  [[VSRTC sharedInstance] SwitchFlashLight:NO];
   //[[VSRTC sharedInstance] SwitchFaceBeauty:NO];
  }
}

@end
