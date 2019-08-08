//
//  SMGLiveHomeBackgroundView.m
//  DSXLive
//
//  Created by 沈树亮 on 2019/8/5.
//  Copyright © 2019 xiong. All rights reserved.
//

#import "SMGLiveHomeBackgroundView.h"
#import "SMGConst.h"


@interface SMGLiveHomeBackgroundView ()

@property (nonatomic, weak) UIImageView *backgroundView;
@property (nonatomic, weak) UIButton *backButton;
@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation SMGLiveHomeBackgroundView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    frame = CGRectMake(0, 0, kSMGScreenWidth, kSMGScreenHeight);
    [super setFrame:frame];
}

#pragma mark - initView
- (UIImageView *)backgroundView {
    if (!_backgroundView) {
        UIImageView *backgroundView = [[UIImageView alloc] init];
        backgroundView.contentMode = UIViewContentModeScaleAspectFill;
        backgroundView.image = SGMImage(@"头部@2x.png");
        [self addSubview:backgroundView];
        _backgroundView = backgroundView;
    }
    return _backgroundView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:SGMImage(@"smg_nav_back@2x") forState:UIControlStateNormal];
        backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backButton];
        _backButton = backButton;
    }
    return _backButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
        titleLabel.text = @"连线";
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(295.f);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.f);
        make.top.equalTo(self).offset(kSMGStatusBarHeight);
        make.height.width.mas_equalTo(44.f);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backButton);
        make.centerX.equalTo(self);
    }];
}

#pragma mark - Action Method
- (void)backAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(popViewController)]) {
        [self.delegate popViewController];
    }
}

@end
