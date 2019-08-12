//
//  SMGLocalMediaView.m
//  DSXLive
//
//  Created by 沈树亮 on 2019/8/6.
//  Copyright © 2019 xiong. All rights reserved.
//

#import "SMGLocalMediaView.h"
#import "SMGConst.h"
#import <VSRTC/VSRTC.h>
#import <VSRTC/VSMedia.h>
#import <VSRTC/VSRoomUser.h>
#import <VSRTC/VSVideoConfig.h>

@interface SMGLocalMediaView ()<VSMediaEventHandler>
// 定时器获取上传的bit流
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SMGLocalMediaView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)remove {
    [self.timer invalidate];
    self.timer = nil;
}

- (NSTimer *)timer {
    if (!_timer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
         [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        _timer = timer;
    }
    return _timer;
}

- (void)timerAction:(id)timer {
    VSMedia *captureMedia = [[VSRTC sharedInstance] CreateCaptureMedia];
    __autoreleasing NSString *strambit = @"当前上传：0kb/s";
    if ([captureMedia getStats]) {
        strambit = [NSString stringWithFormat:@"当前上传：%@kb/s", [captureMedia getStats][@"net_upload_bw"]];
    }
    
    if ([captureMedia stream_state] == VS_MEDIA_STREAM_FAILED ||
        [captureMedia stream_state] == VS_MEDIA_STREAM_IDLE) {
        strambit = @"当前上传：0kb/s";
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(getlocalMediaSteambit:)]) {
        [self.delegate getlocalMediaSteambit:strambit];
    }
}

- (void)setup {
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    
    VSMedia *captureMedia = [[VSRTC sharedInstance] CreateCaptureMedia];
    [captureMedia SetEventHandler:self];
    
    
    VSVideoConfig *config = [[VSRTC sharedInstance] QueryVideoConfiger:captureMedia];
    [config setFaceBeauty:YES];
    
    UIView *captureMediaView = captureMedia.render_view;
    captureMediaView.tag = 10;
    captureMediaView.userInteractionEnabled = YES;
    [self addSubview:captureMediaView];
    
    captureMediaView.frame = CGRectMake(0.f, 0.f, kSMGScreenHeight, kSMGScreenWidth);
    [captureMediaView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [captureMediaView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = [UIColor clearColor];
        obj.userInteractionEnabled = YES;
        [captureMediaView addSubview:obj];
    }];
    
    [captureMediaView.layer.sublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = [UIColor clearColor].CGColor;
        [captureMediaView.layer addSublayer:obj];
    }];
    
    if ([captureMedia state] == VS_MEDIA_CLOSED) {
        NSArray<VSVideoFormat *>* fmts = [captureMedia GetVideoFormats];
        VSVideoFormat *pref_fmt = nil;
        for (VSVideoFormat *fmt in fmts) {
            if (fmt.width == 1280 && !fmt.front) {
                pref_fmt = fmt;
                break;
            }
        }
        if (pref_fmt != nil) {
            [captureMedia SetPreferVideoFormat:pref_fmt];
        }
        [captureMedia OpenWithVideo:YES andAudio:YES];
    }
 
    [self.timer setFireDate:[NSDate date]];
}

#pragma mark - updateStreming
- (void)updateStram {
    VSMedia *media = [[VSRTC sharedInstance] CreateCaptureMedia];
    
    if (media.stream_state == VS_MEDIA_STREAM_IDLE) {
        if (media.type == VS_MEDIA_CAPTURE) {
            [[VSRTC sharedInstance] updateStream:0 withType:YES];
        } else {
            [[VSRTC sharedInstance] updateStream:0 withType:NO];
        }
    } else if (media.stream_state == VS_MEDIA_STREAM_STARTED) {
        if (media.type == VS_MEDIA_CAPTURE) {
            [[VSRTC sharedInstance] updateStream:media.stream_id withType:YES];
        } else {
            [[VSRTC sharedInstance] updateStream:media.stream_id withType:NO];
        }
    } else {
        
    }
}

#pragma mark - VSMediaEventHandler
- (void)OnOpening {
    
}

- (void)OnOpened {
    
}

- (void)OnClose {
    
}

- (void)OnError:(NSString *)errDesc {
    
}

- (void)OnStreamIdle {
    [self updateStram];
}

- (void)OnStreamStarting {
    [self updateStram];
}

- (void)OnStreamStarted:(uint64_t)streamId {
//    VSMedia *captureMedia = [[VSRTC sharedInstance] CreateCaptureMedia];
//    NSLog(@"<<<<<<<<<< %@", [captureMedia getStats]);
    NSLog(@"<<<<<<<<<<>>>>>>>>>>>>>>  %llu", streamId);
    [self updateStram];
}

- (void)OnStreamRestarting {
    
}
- (void)OnStreamFailed {
    
}

@end
