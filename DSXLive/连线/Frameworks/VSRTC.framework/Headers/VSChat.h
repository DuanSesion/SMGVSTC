//
//  VSChat.h
//  VASDK
//
//  Created by pliu on 02/05/2019.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol VSChatHandler <NSObject>
- (void)OnChatOpen;
- (void)OnChatClose;
- (void)OnChatMessage:(NSDictionary *)msgDic;
@end

@interface VSChat : NSObject

- (void)SetMessageHandler:(id<VSChatHandler>)handler;

- (void)Open;
- (void)Close;

- (void)SendMessage:(NSString *)content toUser:(NSString*)userId;

@end

NS_ASSUME_NONNULL_END
