//
//  SMGRemoteMediaView.m
//  DSXLive
//
//  Created by 沈树亮 on 2019/8/6.
//  Copyright © 2019 xiong. All rights reserved.
//

#import "SMGRemoteMediaView.h"
#import "SMGConst.h"
#import <VSRTC/VSRTC.h>
#import <VSRTC/VSMedia.h>
#import <VSRTC/VSRoomUser.h>
#import "SMGShowHudView.h"

CGFloat PLHEIGHT = 200.f;
CGFloat PLWIDTH  = 115.f;

@interface SMGRemoteMediaView ()<VSMediaEventHandler> {
    VSMedia *_media;
}

@property (nonatomic, weak) SMGShowHudView *hud;

@end

@implementation SMGRemoteMediaView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)dealloc {
    [self OnClose];
}

- (SMGShowHudView *)hud {
    if (!_hud) {
        SMGShowHudView *hud = [SMGShowHudView smgShowLoading:@"正在缓冲..." view:self];
        _hud = hud;
    }
    return _hud;
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    [self getHostVideo];
    self.userInteractionEnabled = NO;
}

// 获取主持人直播画面
- (void)getHostVideo {
    [_media Unsubscribe];
    NSArray *users = [[VSRTC sharedInstance] getMemberList];
    [users enumerateObjectsUsingBlock:^(VSRoomUser *user, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = user.custom;
        NSDictionary *extend = dic[@"extend"];
        NSString *room_active_role = extend[@"room_active_role"];
        
        if ( [user stream_id] && [room_active_role containsString:@"remix"]) {
            VSMedia *media = [[VSRTC sharedInstance] FindRemoteMedia:[user stream_id]];
            if (!media) {
                media = [[VSRTC sharedInstance] CreateRemoteMedia:[user stream_id] reuseExist:YES];
            }
            _media = media;
            [media SetEventHandler:self];
            [media OpenWithVideo:YES andAudio:YES];
         
            [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            UIView *render_view = [media render_view];
            render_view.backgroundColor = [UIColor clearColor];
            render_view.userInteractionEnabled = YES;
            [self addSubview:render_view];
            [self bringSubviewToFront:self.hud];
            
            [render_view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.backgroundColor = [UIColor clearColor];
                obj.userInteractionEnabled = YES;
            }];
            
            [render_view.layer.sublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.backgroundColor = [UIColor clearColor].CGColor;
            }];
            
            [render_view mas_updateConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
    }];
}

#pragma mark - VSMediaEventHandler
- (void)OnOpening {
    
}

- (void)OnOpened {
     [_media Subscribe];
}

- (void)OnClose {
    [_media Unsubscribe];
}

- (void)OnError:(NSString *)errDesc {
    self.hud.hidden = NO;
}

- (void)OnStreamIdle {
//    _hud.hidden = YES;
}

- (void)OnStreamStarting {
//    self.hud.hidden = YES;
}

- (void)OnStreamStarted:(uint64_t)streamId {
    self.hud.hidden = YES;
}

- (void)OnStreamRestarting {
     self.hud.hidden = YES;
}
- (void)OnStreamFailed {
    self.hud.hidden = NO;
}

@end
