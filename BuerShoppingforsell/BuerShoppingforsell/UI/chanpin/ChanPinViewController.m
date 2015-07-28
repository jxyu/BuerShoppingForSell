//
//  ChanPinViewController.m
//  BuerShoppingforsell
//
//  Created by 于金祥 on 15/7/25.
//  Copyright (c) 2015年 zykj.BuerShoppingforsell. All rights reserved.
//

#import "ChanPinViewController.h"
#import "HYSegmentedControl.h"
#import "ChanPinCellTableViewCell.h"
#import "MJRefresh.h"
#import "chanpinEditViewController.h"

@interface ChanPinViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) HYSegmentedControl *segmentedControl;
@end

@implementation ChanPinViewController
{
    BOOL isfooterrefresh;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"产品管理";
    _lblTitle.textColor=[UIColor whiteColor];
    isfooterrefresh=NO;
    [self addRightbuttontitle:@"编辑"];
    [self createSegmentedControl];
    [self InitAllView];
}

-(void)InitAllView
{
    _myTableview.delegate=self;
    _myTableview.dataSource=self;
    // 下拉刷新
    [_myTableview addLegendHeaderWithRefreshingBlock:^{
        
        [self TopRefresh];
        [_myTableview reloadData];
        [_myTableview.header endRefreshing];
    }];
    [_myTableview.header beginRefreshing];
    
    // 上拉刷新
    [_myTableview addLegendFooterWithRefreshingBlock:^{
        if (!isfooterrefresh) {
            isfooterrefresh=YES;
            [self FootRefresh];
        }
        // 结束刷新
        [_myTableview.footer endRefreshing];
    }];
    // 默认先隐藏footer
    _myTableview.footer.hidden = NO;
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
        [_myTableview reloadData];
    }
    [_myTableview.header endRefreshing];
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
    [_myTableview reloadData];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 107;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"chanpinTableViewCellIdentifier";
    ChanPinCellTableViewCell *cell = (ChanPinCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.backgroundColor=[UIColor whiteColor];
    cell.layer.masksToBounds=YES;
    cell.layer.cornerRadius=5;
    cell.bounds=CGRectMake(0, 0, SCREEN_WIDTH-50, cell.frame.size.height);
    cell  = [[[NSBundle mainBundle] loadNibNamed:@"ChanPinCellTableViewCell" owner:self options:nil] lastObject];
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
    chanpinEditViewController * edit=[[chanpinEditViewController alloc] initWithNibName:@"chanpinEditViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:edit animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
