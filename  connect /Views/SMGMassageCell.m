//
//  SMGMassageCell.m
//  DSXLive
//
//  Created by 沈树亮 on 2019/8/8.
//  Copyright © 2019 xiong. All rights reserved.
//

#import "SMGMassageCell.h"
#import "SMGConst.h"

@interface SMGMassageCell ()

@property (nonatomic, weak) UIImageView *icon;
@property (nonatomic, weak) UILabel *label;

@end


@implementation SMGMassageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (UIImageView *)icon {
    if (!_icon) {
        UIImageView *icon = [[UIImageView alloc] init];
        icon.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:icon];
        _icon = icon;
    }
    return _icon;
}

- (UILabel *)label {
    if (!_label) {
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12.f];
        [self.contentView addSubview:label];
        _label = label;
    }
    return _label;
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle  = UITableViewCellSelectionStyleNone;
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12.f);
        make.top.equalTo(self.contentView).offset(10.f);
        make.size.mas_equalTo(CGSizeMake(12.f, 12.f));
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(7.f);
        make.top.equalTo(self.icon).offset(-1.f);
        make.right.equalTo(self.contentView).offset(-25.f);
        make.bottom.equalTo(self.contentView).offset(-10.f);
    }];
}

- (void)setDic:(NSDictionary *)dic {
    _dic = dic;
    
    self.icon.image = SGMImage(@"广播@2x");
    if ([dic[@"private"] boolValue]) {
        self.icon.image = SGMImage(@"私信@2x");
    }
    self.label.attributedText = dic[@"massage"];
}
 
@end
