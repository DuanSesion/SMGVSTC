//
//  SMGMassageView.m
//  DSXLive
//
//  Created by 沈树亮 on 2019/8/7.
//  Copyright © 2019 xiong. All rights reserved.
//

#import "SMGMassageView.h"
#import "SMGConst.h"
#import "SMGMassageCell.h"

@interface SMGMassageView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation SMGMassageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.separatorColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.estimatedRowHeight = 44.f;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.dataSource = self;
        tableView.delegate = self;
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10.f)];
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10.f)];
        tableView.tableHeaderView = headView;
        tableView.tableFooterView = footView;
        
        [tableView registerClass:[SMGMassageCell class] forCellReuseIdentifier:@"SMGCELL"];
        [self addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (void)setup {
    self.userInteractionEnabled = YES;
    self.backgroundColor = SMGHEX_RGBA(0x010101, 0.7f);
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)addMassage:(NSDictionary *)msgDic {
    NSString *msgSender = [msgDic objectForKey:@"from"];
    NSString *msgContent = [msgDic objectForKey:@"text"];
    NSNumber *isWhisper = [msgDic objectForKey:@"whisper"];
    
    NSString *text = @"";
    UIColor *color = SMGHEX_RGBA(0xe4ee78, 1);
    UIColor *nameClolor = SMGHEX_RGBA(0x73d9b5, 1);
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    if (isWhisper && isWhisper.boolValue) {
        NSString *privateMsg = [NSString stringWithFormat:@"%@：%@", msgSender, msgContent];
        text = privateMsg;
        dic[@"private"] = @(YES);
        
    } else {
        NSString *publicMsg = [NSString stringWithFormat:@"%@：%@", msgSender, msgContent];
        text = publicMsg;
        color = SMGHEX_RGBA(0xffffff, 1);
        dic[@"private"] = @(NO);
    }
    
    NSMutableAttributedString *attributedString =
    [[NSMutableAttributedString alloc] initWithString:text
     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f],
                  NSForegroundColorAttributeName:color}];
    [attributedString addAttributes:@{NSForegroundColorAttributeName:nameClolor} range:NSMakeRange(0, msgSender.length+1)];
    
    dic[@"massage"] = attributedString;
    [self.datas addObject:dic];
    [self.tableView reloadData];
    
    [self performSelector:@selector(reloadInbottom) withObject:nil afterDelay:0.5];
}

- (void)reloadInbottom {
    if (self.datas.count) {
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.datas.count-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SMGMassageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SMGCELL" forIndexPath:indexPath];
    if (self.datas.count > indexPath.row) {
        NSMutableDictionary *dic = self.datas[indexPath.row];
        cell.dic = dic;
    }
    return cell;
}

@end
