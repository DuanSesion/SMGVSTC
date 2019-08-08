//
//  VSVideoConfig.h
//  VSVideo
//
//  Created by pliu on 12/06/2019.
//

#import <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

#define VSV_COMMON_EXPORT __attribute__((visibility("default")))

VSV_COMMON_EXPORT
@interface VSVideoConfig : NSObject

- (BOOL)isUseFrontCamera;
- (void)SwitchCamera:(BOOL)front;

- (BOOL)torch;
- (void)setTorch:(BOOL)open;

- (float)focusScale;
- (void)setFocusScale:(float)ratio;

- (BOOL)isFaceBeauty;
- (void)setFaceBeauty:(BOOL)enable;

@end

