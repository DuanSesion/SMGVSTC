//
//  SMGHostPrivateTalk.m
//  DSXLive
//
//  Created by 沈树亮 on 2019/8/9.
//  Copyright © 2019 xiong. All rights reserved.
//

#import "SMGHostPrivateTalk.h"
#import <VSRTC/VSRTC.h>

@interface SMGHostPrivateTalk ()<VSMediaEventHandler>

@property (nonatomic, strong) NSMutableArray <VSRoomUser*>*playouyList;

@end

@implementation SMGHostPrivateTalk

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)dealloc {
    [self closeTalk];
    [self removePlayoutList];
}

- (NSMutableArray *)playouyList {
    if (!_playouyList) {
        _playouyList = [NSMutableArray array];
    }
    return _playouyList;
}

// 责编
- (VSMedia *)media {
    NSArray *users = [[VSRTC sharedInstance] getMemberList];
    if (!_media) {
        for (VSRoomUser *user in users) {
            NSDictionary *dic = user.custom;
            NSDictionary *extend = dic[@"extend"];
            NSString *room_active_role = extend[@"room_active_role"];
            // 公开聊 (准备组）
            BOOL broadcastToPrepare = [extend[@"hostRole"][@"broadcastToPrepare"] boolValue];
            // (播放组）
            BOOL broadcastToPlayout = [extend[@"hostRole"][@"broadcastToPlayout"] boolValue];
            
            if ([user stream_id] && [room_active_role isEqualToString:@"host"]) {
                VSMedia *media = [[VSRTC sharedInstance] FindRemoteMedia:[user stream_id]];
                if (!media) {
                    media = [[VSRTC sharedInstance] CreateRemoteMedia:[user stream_id] reuseExist:YES];
                }
                [media SetEventHandler:self];
                
                if ((broadcastToPrepare && [self video2prepare])
                    || (broadcastToPlayout && [self video2playout])) {
                    [media OpenWithVideo:NO andAudio:YES];
                }
                
                _media = media;
                _user  = user;
            }
        }
    }
    return _media;
}

- (void)setup {
    [self media];
}

- (void)openTalk {
    [self.media OpenWithVideo:NO andAudio:YES];
}

- (void)closeTalk {
    NSDictionary *extend = self.user.custom[@"extend"];
    // 公开聊（准备组）
    BOOL broadcastToPrepare = [extend[@"hostRole"][@"broadcastToPrepare"] boolValue];
    // 播放组
    BOOL broadcastToPlayout = [extend[@"hostRole"][@"broadcastToPlayout"] boolValue];
    
    if ((!broadcastToPrepare && !broadcastToPlayout) ||
        (![self video2prepare] && ![self video2playout])) {
        if ([self.media stream_state] == VS_MEDIA_STREAM_STARTING||
            [self.media stream_state] == VS_MEDIA_STREAM_STARTED) {
            [self.media Close];
            _media = nil;
        }
    }
}

- (void)updateTalk {
    [_media Close];
    _media = nil;
    [self openTalk];
}


// 播放组联通话
- (void)createPlayouyList {
    if (!self.playouyList.count) {
        NSArray *users = [[VSRTC sharedInstance] getMemberList];
        VSRoomUser *myuser = [[VSRTC sharedInstance] getSession];
        
        for (VSRoomUser *user in users) {
            if (![myuser.userId isEqualToString:user.userId]) {
                NSDictionary *dic = user.custom;
                NSDictionary *extend = dic[@"extend"];
                BOOL video2playout = [extend[@"video2playout"] boolValue];
                NSString *room_active_role = extend[@"room_active_role"];
                
                if ([user stream_id] && video2playout && [room_active_role isEqualToString:@"guest"]) {
                    VSMedia *media = [[VSRTC sharedInstance] FindRemoteMedia:[user stream_id]];
                    if (!media) {
                        media = [[VSRTC sharedInstance] CreateRemoteMedia:[user stream_id] reuseExist:YES];
                    }
                    [media SetEventHandler:self];
                    [media OpenWithVideo:NO andAudio:YES];
                    [self.playouyList addObject:user];
                }
            }
 
        }
    }
}

- (void)removePlayoutUser:(VSRoomUser *)user {
    VSMedia *media = [[VSRTC sharedInstance] FindRemoteMedia:[user stream_id]];
    [media Close];
    [self.playouyList removeObject:user];
}

// 更新播放组信息(退出或加入)
- (void)addPlayoutUser:(VSRoomUser *)user {
    NSDictionary *dic = user.custom;
    NSDictionary *extend = dic[@"extend"];
    NSString *room_active_role = extend[@"room_active_role"];
    BOOL video2playout = [extend[@"video2playout"] boolValue];
    
    VSMedia *media = [[VSRTC sharedInstance] FindRemoteMedia:[user stream_id]];
    if (!media) {
        media = [[VSRTC sharedInstance] CreateRemoteMedia:[user stream_id] reuseExist:YES];
    }
    if ([user stream_id] && video2playout && [room_active_role isEqualToString:@"guest"]) {
        [media SetEventHandler:self];
        [media OpenWithVideo:NO andAudio:YES];
        [self.playouyList addObject:user];
    }
}

// 播放组释放
- (void)removePlayoutList {
    for (VSRoomUser *user in self.playouyList) {
        VSMedia *media = [[VSRTC sharedInstance] FindRemoteMedia:[user stream_id]];
        [media Close];
    }
    [self.playouyList removeAllObjects];
}

- (BOOL)video2prepare {
    VSRoomUser *myuser = [[VSRTC sharedInstance] getSession];
    NSDictionary *extend = myuser.custom[@"extend"];
    // 准备组
    BOOL video2prepare = [extend[@"video2prepare"] boolValue];
    return video2prepare;
}

- (BOOL)video2playout {
    VSRoomUser *myuser = [[VSRTC sharedInstance] getSession];
    NSDictionary *extend = myuser.custom[@"extend"];
    BOOL video2playout = [extend[@"video2playout"] boolValue];
    return video2playout;
}

#pragma mark - updateStreming
- (void)updateStram {
    VSMedia *media = self.media;
    
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
        [self.playouyList enumerateObjectsUsingBlock:^(VSRoomUser * _Nonnull user, NSUInteger idx, BOOL * _Nonnull stop) {
            VSMedia *media = [[VSRTC sharedInstance] FindRemoteMedia:[user stream_id]];
            [[VSRTC sharedInstance] updateStream:media.stream_id withType:NO];
        }];
    }
}

#pragma mark - VSMediaEventHandler
- (void)OnOpening {
    
}

- (void)OnOpened {
    [self.media Subscribe];
    [self.playouyList enumerateObjectsUsingBlock:^(VSRoomUser * _Nonnull user, NSUInteger idx, BOOL * _Nonnull stop) {
        VSMedia *media = [[VSRTC sharedInstance] FindRemoteMedia:[user stream_id]];
        [media Subscribe];
    }];
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
    [self updateStram];
}

- (void)OnStreamRestarting {
    
}
- (void)OnStreamFailed {
    
}

@end
