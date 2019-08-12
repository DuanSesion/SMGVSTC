//
//  SMGHostPrivateTalk.h
//  DSXLive
//
//  Created by 沈树亮 on 2019/8/9.
//  Copyright © 2019 xiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VSRTC/VSRoomUser.h>
#import <VSRTC/VSMedia.h>

NS_ASSUME_NONNULL_BEGIN

// 主编私聊
@interface SMGHostPrivateTalk : NSObject

// 责编
@property (nonatomic, strong) VSRoomUser *user;
@property (nonatomic, strong) VSMedia *media;

// 播放组playout联通话
- (void)createPlayouyList;
// 更新播放组信息(退出或加入)
- (void)addPlayoutUser:(id)user;
- (void)removePlayoutUser:(id)user;
// 播放组释放
- (void)removePlayoutList;

// 责编私聊管理
- (void)openTalk;
- (void)closeTalk;
- (void)updateTalk;

// 当前用户状态
- (BOOL)video2prepare;
- (BOOL)video2playout;

@end

NS_ASSUME_NONNULL_END
