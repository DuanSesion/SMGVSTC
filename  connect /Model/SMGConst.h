//
//  SMGConst.h
//  DSXLive
//
//  Created by 沈树亮 on 2019/8/5.
//  Copyright © 2019 xiong. All rights reserved.
//

#ifndef SMGConst_h
#define SMGConst_h
#import "Masonry.h"
#import <Foundation/Foundation.h>

#define PRD_APIKEY              @"o9d9fjewlsdhioiqwjioeeijlkjwlr9c"
#define PRD_TENANT_ID           @"1"
#define PRD_EVENT_ID            @"1002"
#define PRD_RMS_URL             @"https://ops.smgtech.net"
#define PRD_VRX_URL             @"https://vrx.smgtech.net"
#define PRD_ILS_URL             @"https://ils.smgtech.net"
#define PRD_VSU_URL             @"https://sfu.smgtech.net:8089/janus"

#define SGMImage(image) [UIImage imageNamed:[NSString stringWithFormat:@"SMGImages.bundle/%@", image]]
#define SMGHEX_RGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#define kSMGStatusBarHeight       [UIApplication sharedApplication].statusBarFrame.size.height
#define kSMGSafeAreaInsetsHeight  [[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom
#define kSMGScreenWidth           CGRectGetWidth([UIScreen mainScreen].bounds)
#define kSMGScreenHeight          CGRectGetHeight([UIScreen mainScreen].bounds)

 

#endif /* SMGConst_h */
