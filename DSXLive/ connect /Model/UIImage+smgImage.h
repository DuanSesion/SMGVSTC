//
//  UIImage+smgImage.h
//  DSXLive
//
//  Created by 沈树亮 on 2019/8/7.
//  Copyright © 2019 xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (smgImage)

+ (UIImage*)imageFromColor:(UIColor*)color size:(CGSize)size;

- (UIImage *)drawRudio;

@end

NS_ASSUME_NONNULL_END
