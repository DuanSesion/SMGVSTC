//
//  RemoteMediaView.h
//
//  Created by pliu on 21/3/2019.
//  Copyright © 2017 VSVideo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VSRTC/VSRTC.h>

#import "MediaViewInterface.h"

@interface RemoteMediaView : MediaViewInterface
- (id)initWithMedia:(VSMedia *)media andUser:(VSRoomUser*)user;
- (BOOL)isMatchUser:(NSString*)userId;
- (BOOL)isMatchUser:(NSString*)userId andType:(BOOL)isCapture;
- (VSMedia*)media;
- (void)updateUser:(VSRoomUser *)user;
@end
