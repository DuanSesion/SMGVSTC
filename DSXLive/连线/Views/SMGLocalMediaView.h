//
//  SMGLocalMediaView.h
//  DSXLive
//
//  Created by 沈树亮 on 2019/8/6.
//  Copyright © 2019 xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SMGLocalMediaDelegate <NSObject>

- (void)getlocalMediaSteambit:(NSString *)streambits;

@end

@interface SMGLocalMediaView : UIView

@property (nonatomic, weak)id<SMGLocalMediaDelegate>delegate;

- (void)remove;

@end

NS_ASSUME_NONNULL_END
