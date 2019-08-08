//
//  SMGLiveChooseView.m
//  DSXLive
//
//  Created by 沈树亮 on 2019/8/5.
//  Copyright © 2019 xiong. All rights reserved.
//

#import "SMGLiveChooseView.h"
#import "SMGConst.h"
#import "SMGLiveChooseButton.h"

@interface SMGLiveChooseView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *titleLabel2;
@property (nonatomic, weak) UIView *line;

@property (nonatomic, weak) SMGLiveChooseButton *liveModelButton;
@property (nonatomic, weak) SMGLiveChooseButton *plyerModelButton;
@property (nonatomic, assign) NSInteger chooseModelStyle;

@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation SMGLiveChooseView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    CGFloat safeAreaInsetsHeight = 210.f;
    if (@available(iOS 11.0, *)) {
        safeAreaInsetsHeight += kSMGSafeAreaInsetsHeight;
    }
    frame = CGRectMake(0, 0, kSMGScreenWidth - 20.f, kSMGScreenHeight - safeAreaInsetsHeight);
    [super setFrame:frame];
}

#pragma mark - initView
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = SMGHEX_RGBA(0x5c6185, 1);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
        titleLabel.text = @"请选择演播室";
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (UILabel *)titleLabel2 {
    if (!_titleLabel2) {
        UILabel *titleLabel2 = [[UILabel alloc] init];
        titleLabel2.textColor = SMGHEX_RGBA(0x5c6185, 1);
        titleLabel2.textAlignment = NSTextAlignmentCenter;
        titleLabel2.font = [UIFont boldSystemFontOfSize:15.f];
        titleLabel2.text = @"请选择进入模式";
        [self addSubview:titleLabel2];
        _titleLabel2 = titleLabel2;
    }
    return _titleLabel2;
}

- (UIView *)line {
    if (!_line) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = SMGHEX_RGBA(0xdddfe7, 1);
        [self addSubview:line];
        _line = line;
    }
    return _line;
}

- (SMGLiveChooseButton *)liveModelButton {
    if (!_liveModelButton) {
        SMGLiveChooseButton *liveModelButton = [[SMGLiveChooseButton alloc] initWithTitle:@"直播模式" image:SGMImage(@"直播模式@2x")];
        liveModelButton.selected = YES;
        [liveModelButton addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:liveModelButton];
        _liveModelButton = liveModelButton;
    }
    return _liveModelButton;
}

- (SMGLiveChooseButton *)plyerModelButton {
    if (!_plyerModelButton) {
        SMGLiveChooseButton *plyerModelButton = [[SMGLiveChooseButton alloc] initWithTitle:@"返送模式" image:SGMImage(@"返送模式@2x")];
        [plyerModelButton addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plyerModelButton];
        _plyerModelButton = plyerModelButton;
    }
    return _plyerModelButton;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(kSMGScreenWidth - 40.f, 117.f);
        layout.minimumInteritemSpacing = 10.f;
        layout.minimumLineSpacing = 10.f;
        layout.sectionInset = UIEdgeInsetsMake(0.f, 10.f, 0.f, 10.f);
        UICollectionView *collect = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        collect.backgroundColor = [UIColor clearColor];
        collect.showsVerticalScrollIndicator = NO;
        collect.showsHorizontalScrollIndicator = NO;
        collect.pagingEnabled = YES;
        //代理设置
        collect.delegate = self;
        collect.dataSource = self;
        //注册item类型 这里使用系统的类型
        [collect registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
        [self addSubview:collect];
        _collectionView = collect;
    }
    return _collectionView;
}

- (void)setup {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(23.f);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(23.f);
        make.height.mas_equalTo(117.f);
        make.width.mas_equalTo(kSMGScreenWidth - 20.f);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(167.f);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kSMGScreenWidth - 64.f, 1.f));
    }];
    
    [self.titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.line.mas_bottom).offset(25.f);
    }];
    
    [self.liveModelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(43.f);
        make.top.equalTo(self.titleLabel2.mas_bottom).offset(33.f);
        make.width.height.mas_equalTo(105.f);
    }];
    
    [self.plyerModelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.line).offset(-21.f);
        make.top.height.width.equalTo(self.liveModelButton);
    }];
}

#pragma mark - Action
- (void)chooseAction:(SMGLiveChooseButton *)sender {
    sender.selected = YES;
    if (sender == self.liveModelButton) {
        self.plyerModelButton.selected = NO;
        self.chooseModelStyle = 0;
        
    } else {
        self.liveModelButton.selected = NO;
        self.chooseModelStyle = 1;
    }
}

#pragma mark UICollectionViewDelegate - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor greenColor];
    cell.layer.cornerRadius = 5.f;
    cell.clipsToBounds = YES;
    
    if (![cell.contentView viewWithTag:10]) {
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:SGMImage(@"图@2x")];
        backgroundView.tag = 10;
        backgroundView.frame = CGRectMake(0.f, 0.f, kSMGScreenWidth - 20.f, 117.f);
        backgroundView.contentMode = UIViewContentModeScaleAspectFill;
        [cell.contentView addSubview:backgroundView];
    }

    if (![cell.contentView viewWithTag:11]) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.tag = 11;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:20.f];
        titleLabel.text = @"一号演播室";
        [titleLabel sizeToFit];
        titleLabel.frame = CGRectMake(20.f, 35.f, CGRectGetWidth(titleLabel.frame), CGRectGetHeight(titleLabel.frame));
        [cell.contentView addSubview:titleLabel];
    }
    return cell;
}


@end
