//
//  VSMedia.h
//  VASDK
//
//  Created by pliu on 21/03/2019.
//

#import <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, VSMediaType) {
  VS_MEDIA_CAPTURE,
  VS_MEDIA_SCREEN,
  VS_MEDIA_FILE,
  VS_MEDIA_REMOTE,
};

typedef NS_ENUM(NSInteger, VSMediaState) {
  VS_MEDIA_CLOSED,
  VS_MEDIA_OPENING,
  VS_MEDIA_OPENED,
  VS_MEDIA_ERROR,
};

typedef NS_ENUM(NSInteger, VSMediaStreamState) {
  VS_MEDIA_STREAM_IDLE,
  VS_MEDIA_STREAM_STARTING,
  VS_MEDIA_STREAM_STARTED,
  VS_MEDIA_STREAM_RESTARTING,
  VS_MEDIA_STREAM_FAILED,
};


@protocol VSMediaEventHandler <NSObject>
- (void)OnOpening;
- (void)OnOpened;
- (void)OnClose;
- (void)OnError:(NSString *)errDesc;

- (void)OnStreamIdle;
- (void)OnStreamStarting;
- (void)OnStreamStarted:(uint64_t)streamId;
- (void)OnStreamRestarting;
- (void)OnStreamFailed;
@end

@interface VSVideoFormat : NSObject
- (NSUInteger)width;
- (NSUInteger)height;
- (NSUInteger)fps;
- (BOOL)front;
@end

@interface VSMedia : NSObject

- (NSDictionary*)getStats;

- (uint64_t)mid;
- (uint64_t)stream_id;
- (VSMediaType)type;
- (VSMediaState)state;
- (VSMediaStreamState)stream_state;
- (NSString *)stream_label;
- (NSString *)error;
- (long)stream_err;
- (BOOL)has_video;
- (BOOL)has_audio;
- (UIView *)render_view;

- (void)SetEventHandler:(id<VSMediaEventHandler>)handler;

- (NSArray<VSVideoFormat *>*)GetVideoFormats;
- (void)SetPreferVideoFormat:(VSVideoFormat *)format;

- (BOOL)OpenWithVideo:(BOOL)has_video andAudio:(BOOL)has_audio;
- (BOOL)Close;
- (BOOL)EnableVideo:(BOOL)enable;
- (BOOL)EnableAudio:(BOOL)enable;

- (BOOL)Publish:(BOOL)scale streamBitrate:(int)bitrate stramLabel:(NSString*)label;
- (BOOL)Unpublish;
- (BOOL)Subscribe;
- (BOOL)Unsubscribe;
- (void)Restart;

@end

NS_ASSUME_NONNULL_END
