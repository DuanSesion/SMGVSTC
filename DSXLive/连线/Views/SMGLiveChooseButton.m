//
//  SMGLiveChooseButton.m
//  DSXLive
//
//  Created by 沈树亮 on 2019/8/5.
//  Copyright © 2019 xiong. All rights reserved.
//

#import "SMGLiveChooseButton.h"
#import "SMGConst.h"

@interface SMGLiveChooseButton ()
@property (nonatomic, weak) UIImageView *centerImageView;
@property (nonatomic, weak) UIButton *iconButton;
@property (nonatomic, weak) UILabel *titleLab;

@end

@implementation SMGLiveChooseButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title
              image:(UIImage *)image {
    SMGLiveChooseButton *btn = [[SMGLiveChooseButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 105.f, 105.f)];
    btn.centerImageView.image = image;
    btn.titleLab.text = title;
    return btn;
}

#pragma mark - initView
- (UIImageView *)centerImageView {
    if (!_centerImageView) {
        UIImageView *centerImageView = [[UIImageView alloc] init];
        centerImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:centerImageView];
        _centerImageView = centerImageView;
    }
    return _centerImageView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.textColor = SMGHEX_RGBA(0x5c6185, 1);
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = [UIFont boldSystemFontOfSize:12.f];
        [self addSubview:titleLab];
        _titleLab = titleLab;
    }
    return _titleLab;
}

- (UIButton *)iconButton {
    if (!_iconButton) {
        UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [iconButton setImage:[UIImage new] forState:UIControlStateNormal];
        [iconButton setImage:SGMImage(@"smg_selected@2x") forState:UIControlStateSelected];
        iconButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        iconButton.userInteractionEnabled = NO;
        iconButton.backgroundColor = [UIColor colorWithRed:127.f/255.f green:127.f/255.f blue:127.f/255.f alpha:1];
        iconButton.layer.cornerRadius = 9.f;
        iconButton.clipsToBounds = YES;
        [self addSubview:iconButton];
        _iconButton = iconButton;
    }
    return _iconButton;
}

- (void)setup {
    self.layer.cornerRadius = 5.f;
    self.layer.borderWidth = 1.f;
    self.layer.borderColor = SMGHEX_RGBA(0xdcdcdc, 1).CGColor;
    
    [self.centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(33.f);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.centerImageView.mas_bottom).offset(15.f);
    }];
    
    [self.iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10.f);
        make.right.equalTo(self).offset(-10.f);
        make.size.mas_equalTo(CGSizeMake(18.f, 18.f));
    }];
}

#pragma mark - sset
- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.layer.borderColor = SMGHEX_RGBA(0x41b48c, 1).CGColor;
        self.iconButton.backgroundColor = [UIColor clearColor];
        
    } else {
        self.layer.borderColor = SMGHEX_RGBA(0xdcdcdc, 1).CGColor;
        self.iconButton.backgroundColor = [UIColor colorWithRed:127.f/255.f green:127.f/255.f blue:127.f/255.f alpha:1];
    }
    self.iconButton.selected = selected;
    [super setSelected:selected];
}

@end
