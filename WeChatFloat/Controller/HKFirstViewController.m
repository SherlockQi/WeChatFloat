//
//  HKFirstViewController.m
//  WeChatFloat
//
//  Created by HeiKki on 2018/5/31.
//  Copyright © 2018年 HeiKki. All rights reserved.
//

#import "HKFirstViewController.h"
#import "HKSecondViewController.h"


@interface HKFirstViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray<NSString *> *names;

@end

@implementation HKFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    self.title = @"One Piece";
    [self.view addSubview:self.tableView];

    self.names = @[
        @"爱吃棉花糖的驯鹿 -- 乔巴",
        @"草帽 -- 蒙奇·D·路飞",
        @"灵魂之王 -- 布鲁克",
        @"小贼猫 -- 娜美",
        @"黑足 -- 山治",
        @"火拳 -- 艾斯",
        @"女帝 -- 汉库克",
        @"改造人 -- 弗兰奇",
        @"恶魔之子 -- 罗宾",
        @"海贼猎人 -- 索隆"
    ];
}

#pragma <UITableViewDelegate, UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"FIRSTCELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];

    }
    cell.textLabel.text = self.names[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%d", indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HKSecondViewController *vc = [[HKSecondViewController alloc] init];
    vc.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d", indexPath.row]];
    vc.title = self.names[indexPath.row];
    vc.hk_iconImage = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%d", indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    };
    return _tableView;
}

@end
