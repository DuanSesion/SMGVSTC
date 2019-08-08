#import "MediaViewInterface.h"

@interface MediaViewInterface() <VSMediaEventHandler>
{
}
@end


@implementation MediaViewInterface

- (void)dealloc{
  NSLog(@"MediaViewInterface dealloc");
}

@end
