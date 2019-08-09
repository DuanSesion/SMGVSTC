//
//  SMGHostPrivateTalk.m
//  DSXLive
//
//  Created by 沈树亮 on 2019/8/9.
//  Copyright © 2019 xiong. All rights reserved.
//

#import "SMGHostPrivateTalk.h"
#import <VSRTC/VSRTC.h>
#import <VSRTC/VSMedia.h>
#import <VSRTC/VSRoomUser.h>

@interface SMGHostPrivateTalk ()<VSMediaEventHandler>

@property (nonatomic, strong) VSMedia *media;
@property (nonatomic, strong) VSRoomUser *user;

@end

@implementation SMGHostPrivateTalk

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)dealloc {
    [self.media Unpublish];
}

- (VSMedia *)media {
    if (!_media) {
        NSArray *users = [[VSRTC sharedInstance] getMemberList];
        //    VSRoomUser *user = [[VSRTC sharedInstance] getSession];
        for (VSRoomUser *user in users) {
            NSDictionary *dic = user.custom;
            NSDictionary *extend = dic[@"extend"];
            NSString *room_active_role = extend[@"room_active_role"];
            
            if ([user stream_id] && [room_active_role isEqualToString:@"host"]) {
                VSMedia *media = [[VSRTC sharedInstance] FindRemoteMedia:[user stream_id]];
                if (!media) {
                    media = [[VSRTC sharedInstance] CreateRemoteMedia:[user stream_id] reuseExist:YES];
                }
                [media SetEventHandler:self];
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
    [self.media Unsubscribe];
}

- (void)updateTalk {
    [_media Unsubscribe];
    _media = nil;
    [self openTalk];
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
        
    }
}

#pragma mark - VSMediaEventHandler
- (void)OnOpening {
    
}

- (void)OnOpened {
    [self.media Subscribe];
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
