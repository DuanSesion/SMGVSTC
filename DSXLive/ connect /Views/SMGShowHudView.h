//
//  SMGShowHudView.h
//  DSXLive
//
//  Created by 沈树亮 on 2019/8/6.
//  Copyright © 2019 xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMGShowHudView : UIView

+ (id)smgShow:(NSString *)text view:(UIView *)view;

+ (id)smgShowLoading:(NSString *)text view:(UIView *)view;

+ (id)smgShowMsg:(NSString *)text view:(UIView *)view;

+ (id)smgShowHandelWithView:(UIView *)view;

- (void)hideAnimated;

@end

NS_ASSUME_NONNULL_END
