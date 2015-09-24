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
#import "DataProvider.h"
#import "UIImageView+WebCache.h"
#import "AddGoodsViewController.h"

@interface ChanPinViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) HYSegmentedControl *segmentedControl;
@end

@implementation ChanPinViewController
{
    BOOL isfooterrefresh;
    int curpage;
    NSDictionary *userinfoWithFile;
    NSArray * goodList;
    int isForSell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"产品管理";
    _lblTitle.textColor=[UIColor whiteColor];
    isfooterrefresh=NO;
    curpage=0;
    goodList=[[NSArray alloc] init];
    [self addRightbuttontitle:@"编辑"];
    [self createSegmentedControl];
    [self InitAllView];
    isForSell=0;
}

-(void)InitAllView
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    userinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
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
    curpage=1;
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetOrderListBackCall:"];
    if (isForSell==0) {
        [dataprovider GetGoodsForSell:userinfoWithFile[@"key"] andpage:@"6" andcurpage:[NSString stringWithFormat:@"%d",curpage]];
    }
    else
    {
        [dataprovider GetGoodsForOffLine:userinfoWithFile[@"key"] andpage:@"6" andcurpage:[NSString stringWithFormat:@"%d",curpage]];
    }
    
}
-(void)GetOrderListBackCall:(id)dict
{
    [SVProgressHUD dismiss];
    if (!dict[@"datas"][@"error"]) {
        goodList=dict[@"datas"][@"goods_list"];
        [_myTableview reloadData];
    }
    [_myTableview.header endRefreshing];
}

-(void)FootRefresh
{
        curpage++;
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"FootRefireshBackCall:"];
    if (isForSell==0) {
        [dataprovider GetGoodsForSell:userinfoWithFile[@"key"] andpage:@"6" andcurpage:[NSString stringWithFormat:@"%d",curpage]];
    }
    else
    {
        [dataprovider GetGoodsForOffLine:userinfoWithFile[@"key"] andpage:@"6" andcurpage:[NSString stringWithFormat:@"%d",curpage]];
    }
}


-(void)FootRefireshBackCall:(id)dict
{
    isfooterrefresh=NO;
    NSLog(@"上拉刷新");
    NSMutableArray *itemarray=[[NSMutableArray alloc] initWithArray:goodList];
    if (!dict[@"datas"][@"error"]) {
        NSArray * arrayitem=dict[@"datas"][@"goods_list"];
        for (id item in arrayitem) {
            [itemarray addObject:item];
        }
        goodList=[[NSArray alloc] initWithArray:itemarray];
    }
    [_myTableview reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddGoodsViewController * addgoods=[[AddGoodsViewController alloc] initWithNibName:@"AddGoodsViewController" bundle:[NSBundle mainBundle]];
    addgoods.commonid=goodList[indexPath.section][@"goods_commonid"];
    addgoods.isEdit=YES;
    [self.navigationController pushViewController:addgoods animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
    [cell.img_logo sd_setImageWithURL:[NSURL URLWithString:goodList[indexPath.section][@"goods_image"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    cell.lbl_Detial.text=[goodList[indexPath.section][@"goods_jingle"] isKindOfClass:[NSNull class]]?@"":goodList[indexPath.section][@"goods_jingle"];
    cell.lbl_title.text=goodList[indexPath.section][@"goods_name"];
    cell.lbl_price.text=[NSString stringWithFormat:@"¥%@",goodList[indexPath.section][@"goods_price"]];
    cell.lbl_xiaolaing.text=[NSString stringWithFormat:@"销量%@",goodList[indexPath.section][@"goods_salenum"]];
    cell.lbl_kucun.text=[NSString stringWithFormat:@"库存%@",goodList[indexPath.section][@"goods_storage"]];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  goodList.count;
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
//    switch (index) {
//        case 0:
//            isForSell=(int)index;
//            [self TopRefresh];
//            
//            break;
//        case 1:
//            _lblTitle.text=@"已下架";
//            break;
//        default:
//            break;
//    }
    isForSell=(int)index;
    [_myTableview.header beginRefreshing];
}

-(void)clickRightButton:(UIButton *)sender
{
    chanpinEditViewController * edit=[[chanpinEditViewController alloc] initWithNibName:@"chanpinEditViewController" bundle:[NSBundle mainBundle]];
    edit.isforSell=isForSell;
    edit.good_list=goodList;
    [self.navigationController pushViewController:edit animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
