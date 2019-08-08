//
//  MediaView.h
//
//  Created by pliu on 21/3/2019.
//  Copyright © 2017 VSVideo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VSRTC/VSRTC.h>
#import <VSRTC/VSRoomUser.h>
#import <VSRTC/VSMedia.h>

@interface MediaViewInterface : UIView
- (BOOL)isMatchUser:(NSString*)userId;
- (BOOL)isMatchUser:(NSString*)userId andType:(BOOL)isCapture;
- (VSMedia*)media;
- (void)updateUser:(VSRoomUser *)user;
@end
