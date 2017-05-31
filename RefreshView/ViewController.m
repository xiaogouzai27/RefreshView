//
//  ViewController.m
//  RefreshView
//
//  Created by everp2p on 17/4/1.
//  Copyright © 2017年 TangLiHua. All rights reserved.
//

#import "ViewController.h"
#import "MJRefresh.h"
#import "ConfigDataManager.h"
#import "Model.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    NSMutableArray * _dataArray;
    UITableView * tabel;
    UIButton * stateBtn;
}

@end

@implementation ViewController

//(0,0)(0,1)(1,0)(1,1)
//1.计息中是0条数据，已完结也是0条的时候，直接显示无投资记录
//2.计息中是0条数据，已完结有数据的话，直接显示已完结数据
//3.计息中有数据，已完结无数据，直接显示计息中数据，查看已完结数据  按钮不显示
//4.计息中有数据，已完结也有数据，显示计息中数据，上拉到最后数据的时候显示  查看已完结数据 按钮 ，点击查看之后接着上面的数据显示已完结数据


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[ConfigDataManager shareManager] initDataWithBearingCount:15 andFinishCount:7];
    
    [self initTabel];

    
}

- (void)initTabel{
    _dataArray = [NSMutableArray array];
    stateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    stateBtn.frame = CGRectMake(0, 0, 375, 50);
    stateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [stateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [stateBtn addTarget:self action:@selector(bottom) forControlEvents:UIControlEventTouchUpInside];
    
    tabel = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 375, 667) style:UITableViewStyleGrouped];
    tabel.separatorColor = [UIColor blackColor];
    tabel.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    tabel.tableFooterView = [[UIView alloc] init];
    tabel.delegate = self;
    tabel.dataSource = self;
    tabel.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(shuaxin) ];
    [tabel registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tabel];
    
    [self start];
    
    //下拉刷新
    //    __block __typeof (self) blockSelf = self;
    //    tabel.mj_footer  = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    //        BOOL isStop = [blockSelf bottom];
    //        if (isStop) {
    //            [tabel.mj_footer endRefreshing];
    //            tabel.mj_footer.state = MJRefreshStateNoMoreData;
    //        }
    //    }];
    //
}


//开始
- (void)start{
    _dataArray = [NSMutableArray arrayWithArray:[ConfigDataManager shareManager].start];
    [tabel reloadData];
    //需要显示
    [stateBtn setTitle:[[ConfigDataManager shareManager] getFooterTitle] forState:UIControlStateNormal];
}

//上拉
- (void)top{
    
}

//下拉
- (void)shuaxin
{
    [tabel.mj_header beginRefreshing];
    [self start];
    [tabel.mj_header endRefreshing];
}

//下拉
- (BOOL)bottom{
    NSArray * freshArray = [NSArray arrayWithArray:[ConfigDataManager shareManager].refresh];
    [_dataArray addObjectsFromArray:freshArray];
    [tabel reloadData];
    [stateBtn setTitle:[[ConfigDataManager shareManager] getFooterTitle] forState:UIControlStateNormal];
    if (freshArray.count==10) {
        return false;
    }
    return true;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Model * model = _dataArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@第%ld条",model.des,model.index];
    NSLog(@"%@",cell.textLabel.text);
    NSLog(@"total:%ld",_dataArray.count);
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 50)];
    [footer addSubview:stateBtn];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //下拉到最底部的时候80为侦测的幅度像素,越小越灵敏,但是不能小于0;
    if (scrollView.contentOffset.y > (scrollView.contentSize.height-scrollView.frame.size.height)) {
        if ([[ConfigDataManager shareManager].getFooterTitle isEqualToString:@"上拉或点击加载更多"]) {
            [self bottom];
        }
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
