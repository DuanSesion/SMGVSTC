//
//  SMGRemoteMediaView.h
//  DSXLive
//
//  Created by 沈树亮 on 2019/8/6.
//  Copyright © 2019 xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VSRTC/VSRTC.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN CGFloat PLHEIGHT;
UIKIT_EXTERN CGFloat PLWIDTH;

@interface SMGRemoteMediaView : UIView

- (void)getHostVideo;

@end

NS_ASSUME_NONNULL_END
