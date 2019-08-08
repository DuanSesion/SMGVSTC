//
//  SMGLiveChooseView.h
//  DSXLive
//
//  Created by 沈树亮 on 2019/8/5.
//  Copyright © 2019 xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMGLiveChooseView : UIScrollView
// 0 直播模式 1 返送模式
@property (nonatomic, assign, readonly) NSInteger chooseModelStyle;

@end

NS_ASSUME_NONNULL_END
