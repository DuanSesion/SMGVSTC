//
//  VSRTC.h
//  VSVideo
//
//  Created by pliu on 27/05/2018.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class VSRoomUser;
@class VSMedia;
@class VSVideoConfig;
@class VSChat;

typedef NS_ENUM(NSInteger, VideoRenderMode) {
  VRM_FIT,
  VRM_FILL,
  VRM_FULL,
};

@protocol VSRTCDelegate <NSObject>
- (void)onSessionInit:(VSRoomUser*)session;
- (void)onSessionUpdate:(VSRoomUser*)session;
- (void)onSessionError:(int)errCode andDesc:(NSString *)errMsg;
- (void)onSessionQuit;

- (void)onRoomInfoRefresh:(NSString*)data;

- (void)onMemberJoin:(VSRoomUser*)user;
- (void)onMemberUpdate:(VSRoomUser*)user;
- (void)onMemberLeave:(VSRoomUser*)user;

- (void)onPartnerScanedScode;
- (void)onAppMessage:(NSString*)msg;

- (void)onMediaServiceReady;
- (void)onMediaServiceLost;

@end

#define VSV_EXPORT __attribute__((visibility("default")))

VSV_EXPORT
@interface VSRTC : NSObject
+(NSString*)version;
+(int)versionNumber;
+(instancetype) sharedInstance;

- (void)startup:(NSString*)logUri;
- (void)shutdown;
- (void)setObserver:(id<VSRTCDelegate>)observer;
- (NSString*)eventId;

- (void)joinRoomWithApiKey:(NSString*)apiKey
                 andTenant:(NSString*)tenantId
                  andEvent:(NSString*)eventId
                    andRms:(NSString*)rmsUrl
                    andVrx:(NSString*)vrxUrl
                    andIls:(NSString*)ilsUrl
                    andVsu:(NSString*)vsuUrl
                   andUser:(NSString*)userId
                andDisplay:(NSString*)nickName
                 andExtend:(NSDictionary*)info
                   andRoom:(NSDictionary*)roomInfo
                completion:(void (^)(NSError *error))block;
- (void)leaveRoom;

- (BOOL)getMediaServiceMode;
- (void)setMediaServiceMode:(BOOL)isManual;
- (void)connectMediaService:(NSString*)mediaUrl host:(NSString*)entry room:(NSInteger)roomNumber;
- (void)disconnectMediaService;

- (void)updateStream:(uint64_t)streamId withType:(BOOL)isCapture;
- (void)updateMicState:(BOOL)mute;
- (void)updateCameraState:(BOOL)blind;
- (void)updateNickName:(NSString*)name;
- (void)updateCustomExtendData:(NSDictionary*)extData;

- (void)updateMember:(NSString*)userId MicState:(BOOL)mute;
- (void)updateMember:(NSString*)userId CameraState:(BOOL)blind;
- (void)updateMember:(NSString*)userId CustomExtendData:(NSDictionary*)extData;

- (void)updateRoomInfo:(NSString*)data;

- (void)sendMessage:(NSString*)msgContent toUser:(NSString*)userId;

- (void)kickUser:(NSString*)userId;

- (NSString*)getRoomId;
- (NSString*)getRoomInfo;
- (NSString*)getRoomAddition;
- (VSRoomUser*)getSession;
- (NSArray*)getMemberList;

- (VSMedia *)CreateCaptureMedia;
- (void)DestroyCaptureMedia;
- (VSMedia *)CreateScreenMedia;
- (void)DestroyScreenMedia;
- (VSMedia *)CreateFileMedia:(NSString *)filePath;
- (void)DestroyFileMedia;

- (VSVideoConfig*)QueryVideoConfiger:(VSMedia*)media;
- (void)EnableSpeakerPhone:(BOOL)enable;

- (VSMedia *)CreateRemoteMedia:(uint64_t)streamId reuseExist:(BOOL)reuse;
- (VSMedia *)FindRemoteMedia:(uint64_t)streamId;
- (void)DestroyRemoteMedia:(uint64_t)mediaId;

- (void)DestroyAllMedia;

- (void)SwitchRemoteMedia:(uint64_t)mediaId toStream:(uint64_t)newStreamId;

- (VSChat*)CreateChat;
- (void)DestroyChat;

- (void)fakeException:(BOOL)isObjc;

- (void)startFileLog:(NSString*)logPath;
- (void)stopFileLog;

@end
