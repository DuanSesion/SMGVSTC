//
//  SMGSettingView.m
//  DSXLive
//
//  Created by 沈树亮 on 2019/8/8.
//  Copyright © 2019 xiong. All rights reserved.
//

#import "SMGSettingView.h"
#import "SMGConst.h"

@interface SMGSettingView ()

@property(nonatomic, weak) UIView *contentView;
@property(nonatomic, weak) UIButton *button;
@property(nonatomic, weak) UIButton *button1;
@property(nonatomic, weak) UIView *line;

@end

@implementation SMGSettingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:CGRectMake(0.f, 0.f, kSMGScreenWidth, kSMGScreenHeight)];
}

- (UIButton *)button {
    if (!_button) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"自动（默认720p)" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15.f];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.clipsToBounds = YES;
        [self.contentView addSubview:button];
        _button = button;
    }
    return _button;
}

- (UIButton *)button1 {
    if (!_button1) {
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button1 setTitle:@"最佳画质" forState:UIControlStateNormal];
        [button1 setTitleColor:SMGHEX_RGBA(0x41b48c, 1) forState:UIControlStateNormal];
        button1.titleLabel.font = [UIFont systemFontOfSize:15.f];
        button1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button1.clipsToBounds = YES;
        [button1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button1];
        _button1 = button1;
    }
    return _button1;
}

- (UIView *)contentView {
    if (!_contentView) {
        UIView *contentView = [[UIView alloc] init];
        contentView.frame = CGRectMake(0.f, 0, 182.f, 114.f);
        contentView.backgroundColor = SMGHEX_RGBA(0x000000, 0.55f);
        [self addSubview:contentView];
        _contentView = contentView;
    }
    return _contentView;
}

- (UIView *)line {
    if (!_line) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [[UIColor groupTableViewBackgroundColor] colorWithAlphaComponent:0.1f];
        [self.contentView addSubview:line];
        _line = line;
    }
    return _line;
}

- (void)setup {
    self.userInteractionEnabled = YES;
    self.backgroundColor = SMGHEX_RGBA(0x000000, 0.1);

    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(55.f);
        make.bottom.equalTo(self).offset(-10.f);
        make.size.mas_equalTo(CGSizeMake(182.f, 114.f));
    }];
    
    [self.button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(29.f);
        make.height.mas_equalTo(57.f);
    }];
    
    [self.button1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.button.mas_bottom);
        make.size.equalTo(self.button);
    }];
    
    [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.right.equalTo(self.button);
        make.height.mas_equalTo(0.5f);
    }];
}

- (void)showInView:(UIView *)view {
    [view addSubview:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (self.contentView != touches.anyObject.view) {
        [self removeFromSuperview];
    }
}

- (void)buttonAction:(id)sender {
    NSInteger stramBit = 720;
    if (sender == self.button1) {
        stramBit = 1080;
    }
    
    if ([self.delegate respondsToSelector:@selector(settingDidSelectedStreamBit:)]) {
        [self.delegate settingDidSelectedStreamBit:stramBit];
    }
    
    [self removeFromSuperview];
}

#pragma mark -public
- (void)setDefaultStramBit:(NSInteger)streambit {
    if (streambit != 720.f) {
        [self.button setTitleColor:SMGHEX_RGBA(0x41b48c, 1) forState:UIControlStateNormal];
        [self.button1 setTitleColor:SMGHEX_RGBA(0xffffff, 1) forState:UIControlStateNormal];
    }
}

@end
