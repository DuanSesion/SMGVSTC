#import "MediaViewGroup.h"
#import "Masonry/Masonry.h"
#import "MaterialDesignSymbol.h"
#import "EntypoSymbol.h"
#import <VSRTC/VSRTC.h>

#import "LocalMediaView.h"
#import "RemoteMediaView.h"

#define _GRIDCOUNT 9
#define _COLUMECOUNT 3
#define _ROWCOUNT 3

@interface MediaViewGroup ()
{
  NSMutableDictionary* _viewDict;
}
@property (nonatomic, assign) BOOL forLocal_;
@end

@implementation MediaViewGroup

- (void)dealloc{
  NSLog(@"MediaViewGroup destroy");
}

- (id) initWithMode:(BOOL)forLocal {
  self = [super init];
  self.forLocal_ = forLocal;
  _viewDict = [NSMutableDictionary new];
  
  return self;
}

- (void) relayoutSubviews {
  NSMutableArray *viewArr = [NSMutableArray new];
  for (NSString *key in _viewDict) {
    [viewArr addObject:_viewDict[key]];
  }
  
  [self removeConstraints:self.constraints];
  
  int columeCount = 1;
  int rowCount = 1;
  if (NO /*self.forLocal_*/) {
    columeCount = viewArr.count > 2 ? viewArr.count : 2;
    rowCount = 1;
  } else {
    if (viewArr.count == 1) {
      columeCount = rowCount = 1;
    } else if (viewArr.count == 2) {
      columeCount = 2;
      rowCount = 1;
    } else if(viewArr.count > 2 && viewArr.count <= 4) {
      columeCount = 2;
      rowCount = 2;
    } else if (viewArr.count > 4 && viewArr.count <=6) {
      columeCount = 3;
      rowCount = 2;
    } else if (viewArr.count > 6 && viewArr.count <=9) {
      columeCount = 3;
      rowCount = 3;
    }
  }
  
  for (unsigned long i=0; i < viewArr.count; ++i) {
    [viewArr[i] mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.equalTo(self).multipliedBy(1.0/columeCount);
      make.height.equalTo(self).multipliedBy(1.0/rowCount);
      float hRation = i%columeCount == 0 ? 1e-5 : i%columeCount/(float)columeCount;
      float vRation = (i)/columeCount == 0 ? 1e-5 : (i)/columeCount/(float)rowCount;
      make.left.mas_equalTo(self.mas_right).multipliedBy(hRation);
      make.top.mas_equalTo(self.mas_bottom).multipliedBy(vRation);
    } ];
  }
  [UIView animateWithDuration:0.3 animations:^{
    [self layoutIfNeeded];
  }];
}

- (MediaViewInterface*)AddMediaView:(VSMedia*)media forUser:(VSRoomUser *)user {
  NSString *identity = [NSString stringWithFormat:@"%llu", [media mid]];
  MediaViewInterface *view = [_viewDict objectForKey:identity];
  if(view != nil) {
    return view;
  }
  MediaViewInterface* newView = nil;
  if (self.forLocal_) {
    newView = [[LocalMediaView alloc] initWithMedia:media andUser:user];
  } else {
    newView = [[RemoteMediaView alloc] initWithMedia:media andUser:user];
  }
  [_viewDict setObject:newView forKey:identity];
  
  [self addSubview:newView];
  
  newView.userInteractionEnabled =  YES;
  [self relayoutSubviews];
  return newView;
}

- (MediaViewInterface*)FindMediaView:(NSString*)userId {
  for (MediaViewInterface *mediaView in _viewDict.allValues) {
    if ([mediaView isMatchUser:userId]) {
      return mediaView;
    }
  }
  return nil;
}

- (VSMedia*)FindExistMedia:(NSString*)userId ofType:(BOOL)isCapture {
  for (MediaViewInterface *mediaView in _viewDict.allValues) {
    if ([mediaView isMatchUser:userId andType:isCapture]) {
      return [mediaView media];
    }
  }
  return nil;
}

- (void)RemoveMediaView:(uint64_t)mediaId {
  NSString *identity = [NSString stringWithFormat:@"%llu", mediaId];
  MediaViewInterface* displayView = [_viewDict objectForKey:identity];
  [displayView removeFromSuperview];
  
  [_viewDict removeObjectForKey:identity];
  [self relayoutSubviews];
}

- (void)RemoveAllMediaView {
  for (NSString *identity in _viewDict) {
    MediaViewInterface* displayView = [_viewDict objectForKey:identity];
    [displayView removeFromSuperview];
  }
  [_viewDict removeAllObjects];
  _viewDict = nil;
}


@end
