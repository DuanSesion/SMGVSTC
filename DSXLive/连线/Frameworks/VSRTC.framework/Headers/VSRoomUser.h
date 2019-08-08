//
//  VSRoomUser.h
//  VSVideo
//
//  Created by pliu on 21/03/2019.
//

#import <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

#define VSV_COMMON_EXPORT __attribute__((visibility("default")))

VSV_COMMON_EXPORT
@interface VSRoomUser : NSObject
@property (readonly, strong) NSString* userId;
@property (readonly, strong) NSString* clientId;
@property (readonly, strong) NSString* sessionId;
@property (readonly, strong) NSString* roomId;
@property (readonly, assign) BOOL muted;
@property (readonly, assign) BOOL blind;
@property (readonly, strong) NSString* streamId;
@property (readonly, strong) NSString* coursewareStreamId;
@property (readonly, strong) NSDictionary *custom;

- (uint64_t)stream_id;
- (uint64_t)course_stream_id;
@end

