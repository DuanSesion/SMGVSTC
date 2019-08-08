//
//  LoginView.h
//
//  Created by pliu on 20/9/2017.
//  Copyright © 2017 VSVideo. All rights reserved.
//
#define APIKEY_KEY          @"VSV_APIKEY_KEY"
#define TENANT_ID_KEY       @"VSV_TENANT_ID_KEY"
#define EVENT_ID_KEY        @"VSV_EVENT_ID_KEY"
#define RMS_URL_KEY         @"VSV_RMS_URL_KEY"
#define VRX_URL_KEY         @"VSV_VRX_URL_KEY"
#define ILS_URL_KEY         @"VSV_ILS_URL_KEY"
#define VSU_URL_KEY         @"VSV_VSU_URL_KEY"
#define USER_ID_KEY         @"VSV_USER_ID_KEY"
#define NICK_NAME_KEY       @"VSV_NICK_NAME_KEY"

#import <UIKit/UIKit.h>
@protocol LoginViewDelegate
- (void) onJoinClicked;
- (void) onScanClicked;
@end

@interface LoginView : UIView
@property (nonatomic, weak) id<LoginViewDelegate> delegate;

@property (nonatomic, strong, readonly) NSString* apiKey;
@property (nonatomic, strong, readonly) NSString* tenantId;
@property (nonatomic, strong, readonly) NSString* eventId;
@property (nonatomic, strong, readonly) NSString* rmsUrl;
@property (nonatomic, strong, readonly) NSString* vrxUrl;
@property (nonatomic, strong, readonly) NSString* ilsUrl;
@property (nonatomic, strong, readonly) NSString* vsuUrl;
@property (nonatomic, strong, readonly) NSString* userId;
@property (nonatomic, strong, readonly) NSString* nickName;

- (void)saveParam;

@end
