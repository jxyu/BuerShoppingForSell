//
//  chanpinEditViewController.m
//  BuerShoppingforsell
//
//  Created by 于金祥 on 15/7/27.
//  Copyright (c) 2015年 zykj.BuerShoppingforsell. All rights reserved.
//

#import "chanpinEditViewController.h"
#import "MJRefresh.h"
#import "chanpinEditTableViewCell.h"
#import "HYSegmentedControl.h"

@interface chanpinEditViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)HYSegmentedControl *segmentedControl;

@end

@implementation chanpinEditViewController
{
    BOOL isfooterrefresh;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"产品管理";
    _lblTitle.textColor=[UIColor whiteColor];
    [self addRightbuttontitle:@"取消"];
    isfooterrefresh=NO;
    [self createSegmentedControl];
    [self InitAllView];
    [self BuildbottomButtion];
}

-(void)InitAllView
{
    _mytableView.delegate=self;
    _mytableView.dataSource=self;
    // 下拉刷新
    [_mytableView addLegendHeaderWithRefreshingBlock:^{
        
        [self TopRefresh];
        [_mytableView reloadData];
        [_mytableView.header endRefreshing];
    }];
    [_mytableView.header beginRefreshing];
    
    // 上拉刷新
    [_mytableView addLegendFooterWithRefreshingBlock:^{
        if (!isfooterrefresh) {
            isfooterrefresh=YES;
            [self FootRefresh];
        }
        // 结束刷新
        [_mytableView.footer endRefreshing];
    }];
    // 默认先隐藏footer
    _mytableView.footer.hidden = NO;
}

#pragma mark tableview刷新与加载
-(void)TopRefresh
{
    //    curpage=1;
    //    DataProvider * dataprovider=[[DataProvider alloc] init];
    //    [dataprovider setDelegateObject:self setBackFunctionName:@"GetOrderListBackCall:"];
    //    [dataprovider GetOrderListWithKey:_key andcurpage:[NSString stringWithFormat:@"%d",curpage] andorder_state:_OrderStatus];
}
-(void)GetOrderListBackCall:(id)dict
{
    [SVProgressHUD dismiss];
    if (!dict[@"datas"][@"error"]) {
        //        orderListArray=dict[@"datas"][@"order_group_list"];
//        [_mytableView reloadData];
    }
//    [_mytableView.header endRefreshing];
}

-(void)FootRefresh
{
    //    curpage++;
    //    DataProvider * dataprovider=[[DataProvider alloc] init];
    //    [dataprovider setDelegateObject:self setBackFunctionName:@"FootRefireshBackCall:"];
    //    [dataprovider GetOrderListWithKey:_key andcurpage:[NSString stringWithFormat:@"%d",curpage] andorder_state:_OrderStatus];
}


-(void)FootRefireshBackCall:(id)dict
{
    isfooterrefresh=NO;
    NSLog(@"上拉刷新");
    //    NSMutableArray *itemarray=[[NSMutableArray alloc] initWithArray:orderListArray];
    //    if (!dict[@"datas"][@"error"]) {
    //        NSArray * arrayitem=dict[@"datas"][@"order_group_list"];
    //        for (id item in arrayitem) {
    //            [itemarray addObject:item];
    //        }
    ////        orderListArray=[[NSArray alloc] initWithArray:itemarray];
    //    }
    [_mytableView reloadData];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 107;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"chanpineditTableViewCellIdentifier";
    chanpinEditTableViewCell *cell = (chanpinEditTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.backgroundColor=[UIColor whiteColor];
    cell.layer.masksToBounds=YES;
    cell.layer.cornerRadius=5;
    cell.bounds=CGRectMake(0, 0, SCREEN_WIDTH-50, cell.frame.size.height);
    cell  = [[[NSBundle mainBundle] loadNibNamed:@"chanpinEditTableViewCell" owner:self options:nil] lastObject];
    cell.layer.masksToBounds=YES;
    cell.frame=CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tableView.frame.size.width, cell.frame.size.height);
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  5;
}

//
//  init SegmentedControl
//
- (void)createSegmentedControl
{
    self.segmentedControl = [[HYSegmentedControl alloc] initWithOriginY:64 Titles:@[@"出售中", @"已下架"] delegate:self] ;
    [self.view addSubview:_segmentedControl];
}

//
//  HYSegmentedControlDelegate method
//
- (void)hySegmentedControlSelectAtIndex:(NSInteger)index
{
    NSLog(@"%ld",(long)index);
    switch (index) {
        case 0:
            _lblTitle.text=@"出售中";
            break;
        case 1:
            _lblTitle.text=@"已下架";
            break;
        default:
            break;
    }
    //    [_myTableview.header beginRefreshing];
}
-(void)clickRightButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)BuildbottomButtion
{
    UIButton * btn_shangjia=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, _bottomBackView.frame.size.width/2, _bottomBackView.frame.size.height)];
    btn_shangjia.backgroundColor=[UIColor colorWithRed:255/255.0 green:204/255.0 blue:3/255.0 alpha:1.0];
    [btn_shangjia setTitle:@"上架商品" forState:UIControlStateNormal];
    [btn_shangjia setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(0, 15, btn_shangjia.frame.size.width, 20)];
    lbl_title.text=@"上架商品";
    lbl_title.textAlignment=NSTextAlignmentCenter;
    lbl_title.textColor=[UIColor whiteColor];
    [btn_shangjia addSubview:lbl_title];
    [_bottomBackView addSubview:btn_shangjia];
    UIButton * btn_del=[[UIButton alloc] initWithFrame:CGRectMake(btn_shangjia.frame.size.width, 0, _bottomBackView.frame.size.width/2, _bottomBackView.frame.size.height)];
    btn_del.backgroundColor=[UIColor colorWithRed:255/255.0 green:152/255.0 blue:3/255.0 alpha:1.0];
    [btn_del setTitle:@"删除" forState:UIControlStateNormal];
    [btn_del setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UILabel * lbl_title1=[[UILabel alloc] initWithFrame:CGRectMake(0, 15, btn_del.frame.size.width, 20)];
    lbl_title1.text=@"删除";
    lbl_title1.textColor=[UIColor whiteColor];
    lbl_title1.textAlignment=NSTextAlignmentCenter;
    [btn_del addSubview:lbl_title1];
    [_bottomBackView addSubview:btn_del];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
