//
//  SMGLiveHomeBackgroundView.h
//  DSXLive
//
//  Created by 沈树亮 on 2019/8/5.
//  Copyright © 2019 xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SMGLiveHomeBackgroundDelegate <NSObject>

- (void)popViewController;

@end

@interface SMGLiveHomeBackgroundView : UIView

@property (nonatomic, weak) id<SMGLiveHomeBackgroundDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
