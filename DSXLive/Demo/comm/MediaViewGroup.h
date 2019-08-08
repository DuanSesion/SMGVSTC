//
//  MediaViewGroup.h
//
//  Created by pliu on 21/3/2019.
//  Copyright © 2017 VSVideo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VSRTC/VSRTC.h>
#import "MediaViewInterface.h"

@interface MediaViewGroup : UIView

- (id) initWithMode:(BOOL)forLocal;
- (MediaViewInterface*)AddMediaView:(VSMedia*)media forUser:(VSRoomUser *)user;
- (MediaViewInterface*)FindMediaView:(NSString*)userId;
- (VSMedia*)FindExistMedia:(NSString*)userId ofType:(BOOL)isCapture;
- (void)RemoveMediaView:(uint64_t)mediaId;
- (void)RemoveAllMediaView;


@end
