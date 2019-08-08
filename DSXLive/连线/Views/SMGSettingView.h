//
//  SMGSettingView.h
//  DSXLive
//
//  Created by 沈树亮 on 2019/8/8.
//  Copyright © 2019 xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SMGSettingDelegate <NSObject>

- (void)settingDidSelectedStreamBit:(NSInteger)streambit;

@end

@interface SMGSettingView : UIView

@property (nonatomic, weak) id<SMGSettingDelegate>delegate;

- (void)setDefaultStramBit:(NSInteger)streambit;

- (void)showInView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
