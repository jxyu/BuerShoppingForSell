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
#import "UIImageView+WebCache.h"
#import "DataProvider.h"

@interface chanpinEditViewController ()<UITableViewDataSource,UITableViewDelegate,HYSegmentedControlDelegate>
@property (nonatomic,strong)HYSegmentedControl *segmentedControl;

@end

@implementation chanpinEditViewController
{
    BOOL isfooterrefresh;
    int curpage;
    NSDictionary *userinfoWithFile;
    NSMutableArray * selectdata;
    BOOL isselectAll;
    BOOL isFirstload;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"产品管理";
    _lblTitle.textColor=[UIColor whiteColor];
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self addRightbuttontitle:@"取消"];
    isfooterrefresh=NO;
    curpage=1;
    selectdata=[[NSMutableArray alloc] init];
    isselectAll=NO;
    isFirstload=YES;
    [self createSegmentedControl];
    [self InitAllView];
//    [self BuildbottomButtion];
}

-(void)InitAllView
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    userinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    [self.segmentedControl changeSegmentedControlWithIndex:_isforSell];
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
    [self buildHeaderView];
}

-(void)buildHeaderView
{
    UIView * headerview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    UIButton * btn_selectAll=[[UIButton alloc] initWithFrame:CGRectMake(0, 10, 100, 40)];
    [btn_selectAll setImage:[UIImage imageNamed:@"shoppingcar_unselect_icon@2x.png"] forState:UIControlStateNormal];
//    [btn_selectAll setTitle:@"全选" forState:UIControlStateNormal];
    [btn_selectAll setTitle:@"全选" forState:UIControlStateNormal];
    [btn_selectAll setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn_selectAll.tag=0;
    [btn_selectAll addTarget:self action:@selector(btn_selectAll:) forControlEvents:UIControlEventTouchUpInside];
    [headerview addSubview:btn_selectAll];
    _mytableView.tableHeaderView=headerview;
}
#pragma mark tableview刷新与加载
-(void)TopRefresh
{
    curpage=1;
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetOrderListBackCall:"];
    if (_isforSell==0) {
        [dataprovider GetGoodsForSell:userinfoWithFile[@"key"] andpage:@"6" andcurpage:[NSString stringWithFormat:@"%d",curpage]];
    }
    else
    {
        [dataprovider GetGoodsForOffLine:userinfoWithFile[@"key"] andpage:@"6" andcurpage:[NSString stringWithFormat:@"%d",curpage]];
    }
    //    [dataprovider GetOrderListWithKey:_key andcurpage:[NSString stringWithFormat:@"%d",curpage] andorder_state:_OrderStatus];
}
-(void)GetOrderListBackCall:(id)dict
{
    [SVProgressHUD dismiss];
    if (!dict[@"datas"][@"error"]) {
        _good_list=[[NSArray alloc] initWithArray:dict[@"datas"][@"goods_list"]];
        [_mytableView reloadData];
    }
//    [_mytableView.header endRefreshing];
}

-(void)FootRefresh
{
        curpage++;
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"FootRefireshBackCall:"];
    if (_isforSell==0) {
        [dataprovider GetGoodsForSell:userinfoWithFile[@"key"] andpage:@"6" andcurpage:[NSString stringWithFormat:@"%d",curpage]];
    }
    else
    {
        [dataprovider GetGoodsForOffLine:userinfoWithFile[@"key"] andpage:@"6" andcurpage:[NSString stringWithFormat:@"%d",curpage]];
    }

    //    [dataprovider GetOrderListWithKey:_key andcurpage:[NSString stringWithFormat:@"%d",curpage] andorder_state:_OrderStatus];
}


-(void)FootRefireshBackCall:(id)dict
{
    isfooterrefresh=NO;
    NSLog(@"上拉刷新");
        NSMutableArray *itemarray=[[NSMutableArray alloc] initWithArray:_good_list];
        if (!dict[@"datas"][@"error"]) {
            NSArray * arrayitem=dict[@"datas"][@"order_group_list"];
            for (id item in arrayitem) {
                [itemarray addObject:item];
            }
            _good_list=[[NSArray alloc] initWithArray:itemarray];
        }
    [_mytableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    [cell.img_logo sd_setImageWithURL:[NSURL URLWithString:_good_list[indexPath.section][@"goods_image"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    cell.lbl_detial.text=_good_list[indexPath.section][@"goods_jingle"];
    cell.lbl_title.text=_good_list[indexPath.section][@"goods_name"];
    cell.lbl_price.text=[NSString stringWithFormat:@"¥%@",_good_list[indexPath.section][@"goods_price"]];
    cell.lbl_xiaoliang.text=[NSString stringWithFormat:@"销量%@",_good_list[indexPath.section][@"goods_salenum"]];
    cell.lbl_kucun.text=[NSString stringWithFormat:@"库存%@",_good_list[indexPath.section][@"goods_storage"]];
    if (isselectAll) {
        cell.btn_select.tag=1;
        [cell.btn_select setImage:[UIImage imageNamed:@"shoppingcar_select_icon@2x.png"] forState:UIControlStateNormal];
        [cell.btn_select addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        cell.btn_select.tag=0;
        [cell.btn_select addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  _good_list.count;
}


-(void)cellBtnClick:(UIButton *)sender
{
    UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [_mytableView indexPathForCell:cell];
    if (sender.tag==0) {
        sender.tag=1;
        [sender setImage:[UIImage imageNamed:@"shoppingcar_select_icon@2x.png"] forState:UIControlStateNormal];
        [selectdata addObject:_good_list[indexPath.section]];
    }
    else
    {
        sender.tag=0;
        [sender setImage:[UIImage imageNamed:@"shoppingcar_unselect_icon@2x.png"] forState:UIControlStateNormal];
        for (int i=0; i<selectdata.count; i++) {
            if (_good_list[indexPath.section][@"goods_commonid"]==selectdata[i][@"goods_commonid"]) {
                [selectdata removeObjectAtIndex:i];
                break;
            }
        }
    }
    
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
//            _lblTitle.text=@"出售中";
//            break;
//        case 1:
//            _lblTitle.text=@"已下架";
//            break;
//        default:
//            break;
//    }
    //    [_myTableview.header beginRefreshing];
//    isFirstload=NO;
    _isforSell=(int)index;
    [self BuildbottomButtion];
    [_mytableView.header beginRefreshing];
    isFirstload=NO;
}
-(void)clickRightButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)BuildbottomButtion
{
    for (UIView * item in _bottomBackView.subviews) {
        [item removeFromSuperview];
    }
    UIButton * btn_shangjia=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, _bottomBackView.frame.size.width/2, _bottomBackView.frame.size.height)];
    btn_shangjia.backgroundColor=[UIColor colorWithRed:255/255.0 green:204/255.0 blue:3/255.0 alpha:1.0];
    [btn_shangjia addTarget:self action:@selector(showorunshowGoods:) forControlEvents:UIControlEventTouchUpInside];
    if (_isforSell==0) {
        [btn_shangjia setTitle:@"下架商品" forState:UIControlStateNormal];
    }
    else
    {
        [btn_shangjia setTitle:@"上架商品" forState:UIControlStateNormal];
    }
    
    [btn_shangjia setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (isFirstload) {
        UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(0, 15, btn_shangjia.frame.size.width, 20)];
        if (_isforSell==0) {
            lbl_title.text=@"下架商品";
        }
        else
        {
            lbl_title.text=@"上架商品";
        }
        
        lbl_title.textAlignment=NSTextAlignmentCenter;
        lbl_title.textColor=[UIColor whiteColor];
        [btn_shangjia addSubview:lbl_title];
    }
    [_bottomBackView addSubview:btn_shangjia];
    UIButton * btn_del=[[UIButton alloc] initWithFrame:CGRectMake(btn_shangjia.frame.size.width, 0, _bottomBackView.frame.size.width/2, _bottomBackView.frame.size.height)];
    btn_del.backgroundColor=[UIColor colorWithRed:255/255.0 green:152/255.0 blue:3/255.0 alpha:1.0];
    [btn_del setTitle:@"删除" forState:UIControlStateNormal];
    [btn_del setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_del addTarget:self action:@selector(DelGoods:) forControlEvents:UIControlEventTouchUpInside];
    if (isFirstload) {
        UILabel * lbl_title1=[[UILabel alloc] initWithFrame:CGRectMake(0, 15, btn_del.frame.size.width, 20)];
        lbl_title1.text=@"删除";
        lbl_title1.textColor=[UIColor whiteColor];
        lbl_title1.textAlignment=NSTextAlignmentCenter;
        [btn_del addSubview:lbl_title1];
    }
    [_bottomBackView addSubview:btn_del];
}

-(void)btn_selectAll:(UIButton *)sender
{
    if (sender.tag==0) {
        sender.tag=1;
        [sender setImage:[UIImage imageNamed:@"shoppingcar_select_icon@2x.png"] forState:UIControlStateNormal];
        isselectAll=YES;
        if (_good_list) {
            for (int i=0; i<_good_list.count; i++) {
                [selectdata addObject:_good_list[i]];
            }
        }
    }
    else
    {
        isselectAll=NO;
        sender.tag=0;
        [sender setImage:[UIImage imageNamed:@"shoppingcar_unselect_icon@2x.png"] forState:UIControlStateNormal];
        [selectdata removeAllObjects];
    }
    [_mytableView reloadData];
}

-(NSString *)BuildRequestPrm
{
    NSString *strprm=@"";
    for (int i=0; i<selectdata.count; i++) {
        strprm=[strprm stringByAppendingString:[NSString stringWithFormat:i==0?@"%@":@",%@",selectdata[i][@"goods_commonid"]]];
    }
    return strprm;
}
-(void)showorunshowGoods:(UIButton *)sender
{
    if (selectdata.count) {
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"showorunshowBackCall:"];
        if (_isforSell==0) {
            [dataprovider UnshowGoodsWithKey:userinfoWithFile[@"key"] andcommonid:[self BuildRequestPrm]];
        }
        else
        {
            [dataprovider showGoodsWithKey:userinfoWithFile[@"key"] andcommonid:[self BuildRequestPrm]];
        }
        
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择商品" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)showorunshowBackCall:(id)dict
{
    NSLog(@"%@",dict);
    [_mytableView.header beginRefreshing];
}
-(void)DelGoods:(UIButton *)sender
{
    if (selectdata.count) {
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"showorunshowBackCall:"];
        [dataprovider DelgoodsWithKey:userinfoWithFile[@"key"] andcommonid:[self BuildRequestPrm]];
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择商品" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
