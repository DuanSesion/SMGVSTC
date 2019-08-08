//
//  SMGShowHudView.m
//  DSXLive
//
//  Created by 沈树亮 on 2019/8/6.
//  Copyright © 2019 xiong. All rights reserved.
//

#import "SMGShowHudView.h"
#import "SMGConst.h"

@interface SMGShowHudView ()

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation SMGShowHudView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = SMGHEX_RGBA(0x5c6185, 1);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
        titleLabel.text = @"连接中...";
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [self loadingGIFImage];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        _imageView = imageView;
    }
    return _imageView;
}

- (void)setup {
    self.frame = CGRectMake(0, 0, 120.f, 120.f);
    self.layer.cornerRadius = 5.f;
    self.backgroundColor = [UIColor whiteColor];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(20.f);
        make.size.mas_equalTo(CGSizeMake(40.f, 40.f));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(10.f);
        make.right.equalTo(self).offset(-10.f);
        make.top.equalTo(self.imageView.mas_bottom).offset(15);
    }];
    
}

+ (id)smgShowHandelWithView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    SMGShowHudView *hud = [[SMGShowHudView alloc] init];
    hud.frame = CGRectMake(0, 0, 157.f, 140.f);
    hud.imageView.animationImages = nil;
    [hud.imageView stopAnimating];
    hud.imageView.image = SGMImage(@"举手成功@2x");
    hud.backgroundColor = SMGHEX_RGBA(0x00000, 0.7f);
    hud.center = view.center;
    hud.titleLabel.numberOfLines = 0;
    hud.titleLabel.text = @"举手成功\n请等待责编联系";
    hud.titleLabel.textColor = [UIColor whiteColor];
    [view addSubview:hud];
    [hud mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
        make.size.mas_equalTo(hud.frame.size);
    }];
    [hud performSelector:@selector(hideAnimated) withObject:nil afterDelay:2];
    return hud;
}

+ (id)smgShowMsg:(NSString *)text view:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    SMGShowHudView *hud = [[SMGShowHudView alloc] init];
    [hud.imageView removeFromSuperview];
    hud.backgroundColor = SMGHEX_RGBA(0x00000, 0.7f);
    hud.center = view.center;
    hud.titleLabel.text = text;
    hud.titleLabel.textColor = [UIColor whiteColor];
    [view addSubview:hud];
    [hud mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
    }];
    
    [hud.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(hud).offset(10.f);
        make.right.bottom.equalTo(hud).offset(-10.f);
    }];
    
    [hud performSelector:@selector(hideAnimated) withObject:nil afterDelay:3];
    return hud;
}

+ (id)smgShow:(NSString *)text view:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    SMGShowHudView *hud = [[SMGShowHudView alloc] init];
    hud.center = view.center;
    hud.titleLabel.text = text;
    [view addSubview:hud];
    [hud mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.centerY.equalTo(view).offset(-50.f);
    }];
    return hud;
}

+ (id)smgShowLoading:(NSString *)text view:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    SMGShowHudView *hud = [[SMGShowHudView alloc] init];
    hud.center = view.center;
    hud.titleLabel.text = text;
    hud.titleLabel.textColor = [UIColor whiteColor];
    [view addSubview:hud];
    [hud mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.centerY.equalTo(view).offset(-50.f);
    }];
    return hud;
}


- (UIImageView *)loadingGIFImage {
    NSString *dataPath = [[NSBundle mainBundle]pathForResource:@"SMGImages.bundle/smg_loading_icon.gif" ofType:@""];
    CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:dataPath], NULL);
    size_t count = CGImageSourceGetCount(source);
    float allTime = 0;
    
    //5.定义一个可变数组存放所有图片
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    
    //6.定义一个可变数组存放每一帧播放的时间
    NSMutableArray *timeArray = [[NSMutableArray alloc] init];
    
    
    //遍历gif
    
    for (size_t i=0; i<count; i++) {
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        
        UIImage *img = [UIImage imageWithCGImage:image];
        [imageArray addObject:[self TransformtoSize:CGSizeMake(40.f, 40.f) image:img]];
        CGImageRelease(image);
        
        // 获取图片信息
        NSDictionary *info = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
        
        
        // 统计时间
        NSDictionary *timeDic = [info objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
        CGFloat time = [[timeDic objectForKey:(__bridge NSString *)kCGImagePropertyGIFDelayTime] floatValue];
        [timeArray addObject:[NSNumber numberWithFloat:time]];
        
    }
    
    
    NSMutableArray *times = [[NSMutableArray alloc] init];
    float currentTime = 0;
    
    //设置每一帧的时间占比
    
    for (int i=0; i<imageArray.count; i++) {
        [times addObject:[NSNumber numberWithFloat:currentTime/allTime]];
        currentTime +=[timeArray[i] floatValue];
    }
    
    //Layer层添加
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40.f, 40.f)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.animationImages = imageArray;
    imageView.animationDuration = currentTime;
    [imageView startAnimating];
    return imageView;
}

- (UIImage*)TransformtoSize:(CGSize)Newsize image:(UIImage *)image {
    UIGraphicsBeginImageContext(Newsize);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0,0, Newsize.width, Newsize.height)];
    UIImage*TransformedImg=UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    return TransformedImg;
}

- (void)hideAnimated {
    [self removeFromSuperview];
}

@end
