//
//  ShopDetialViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/7/1.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "ShopDetialViewController.h"
#import "AppDelegate.h"
#import "DataProvider.h"
#import "UIImageView+WebCache.h"
#import "SDCycleScrollView.h"
//#import "CWStarRateView.h"
#import "MJRefresh.h"
#import "LoginViewController.h"
#import "ShopEditDetialViewController.h"
//#import "RoutePlanViewController.h"

#define umeng_app_key @"557e958167e58e0b720041ff"

@interface ShopDetialViewController ()

@end

@implementation ShopDetialViewController
{
    NSDictionary *userinfoWithFile;
    NSArray * arrayslider;
    NSDictionary *storeInfo;
    NSDictionary * OrderInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"首页";
    _lblTitle.textColor=[UIColor whiteColor];
    [self addRightbuttontitle:@"编辑"];
    arrayslider=[[NSArray alloc] init];
    OrderInfo=[[NSDictionary alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginBackCall) name:@"Login_success" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SaveBackCall) name:@"index_save_seccess" object:nil];
    [self LoadAllData];
    //[self InitAllView];
}

-(void)SaveBackCall
{
    [_myTableVeiw.header endRefreshing];
}
-(void)LoginBackCall
{
    [self LoadAllData];
}
-(void)LoadAllData
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    userinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    if (userinfoWithFile[@"key"]) {
        [self InitAllView];
    }
    else
    {
        LoginViewController * login=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:login animated:YES];
    }
    
}

-(void)GetStoreDetialBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if (!dict[@"datas"][@"error"]) {
        arrayslider=dict[@"datas"][@"store_info"][@"store_slide"];
        storeInfo=dict[@"datas"][@"store_info"];
        OrderInfo=dict[@"datas"][@"order_info"];
        [self BuildHeaderView];
        [_myTableVeiw reloadData];
    }
    else
    {
//        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"datas"][@"error"] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
//        [alert show];
        LoginViewController * login=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:login animated:YES];
    }
    
}

-(void)BuildHeaderView
{
    /***************************headerView 开始 **************************/
    UIView * myheaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 225)];
    myheaderView.backgroundColor=[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    UIView * jianju=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH- 20, 5)];
    jianju.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [myheaderView addSubview:jianju];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i=0; i<(arrayslider.count>0?arrayslider.count:1); i++) {
        UIImageView * img=[[UIImageView alloc] init];
        [img sd_setImageWithURL:[NSURL URLWithString:i<arrayslider.count?arrayslider[i]:@""] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        [images addObject:img];
    }
    // 创建带标题的图片轮播器
    SDCycleScrollView *_cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, myheaderView.frame.size.width, 175) imagesGroup:images ];
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    [myheaderView addSubview:_cycleScrollView];
    UIView * BackVeiw_StoreTitle=[[UIView alloc] initWithFrame:CGRectMake(0, _cycleScrollView.frame.size.height-55, myheaderView.frame.size.width, 55)];
    BackVeiw_StoreTitle.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    UILabel * lbl_StoreName=[[UILabel alloc] initWithFrame:CGRectMake(100, 7, 200, 20)];
    lbl_StoreName.text=storeInfo[@"store_name"];
    lbl_StoreName.textColor=[UIColor whiteColor];
    [BackVeiw_StoreTitle addSubview:lbl_StoreName];
//    CWStarRateView * weisheng=[[CWStarRateView alloc] initWithFrame:CGRectMake(100,lbl_StoreName.frame.size.height+5,100,15) numberOfStars:5];
//    weisheng.scorePercent = [storeInfo[@"store_credit_composite"] floatValue]/5;
//    weisheng.allowIncompleteStar = NO;
//    weisheng.hasAnimation = YES;
//    [BackVeiw_StoreTitle addSubview:weisheng];
    [myheaderView addSubview:BackVeiw_StoreTitle];
    UIImageView * img_StoreLogo=[[UIImageView alloc] initWithFrame:CGRectMake(10, _cycleScrollView.frame.size.height-80, 80, 80)];
    [img_StoreLogo sd_setImageWithURL:[NSURL URLWithString:storeInfo[@"store_label"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [myheaderView addSubview:img_StoreLogo];
    UIView * BackView_StoreInfo=[[UIView alloc] initWithFrame:CGRectMake(0, _cycleScrollView.frame.size.height+5, SCREEN_WIDTH, 50)];
    BackView_StoreInfo.backgroundColor=[UIColor whiteColor];
    UIImageView * img_location=[[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 12, 16)];
    img_location.image=[UIImage imageNamed:@"location_icon"];
    [BackView_StoreInfo addSubview:img_location];
    CGFloat x=img_location.frame.size.width+img_location.frame.origin.x;
    UILabel * lbl_address=[[UILabel alloc] initWithFrame:CGRectMake(img_location.frame.size.width+img_location.frame.origin.x+10, 1, SCREEN_WIDTH-x-76, 40)];
    lbl_address.textColor=[UIColor grayColor];
    lbl_address.text=storeInfo[@"store_address"];
    lbl_address.numberOfLines=2;
    [BackView_StoreInfo addSubview:lbl_address];
    UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(lbl_address.frame.size.width+lbl_address.frame.origin.x, 10, 1, 30)];
    fenge.backgroundColor=[UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0];
    [BackView_StoreInfo addSubview:fenge];
    [myheaderView addSubview:BackView_StoreInfo];
    UIButton * btn_location=[[UIButton alloc] initWithFrame:CGRectMake(0, BackView_StoreInfo.frame.origin.y, fenge.frame.origin.x, BackView_StoreInfo.frame.size.height)];
    [btn_location addTarget:self action:@selector(JumptoNavi:) forControlEvents:UIControlEventTouchUpInside];
    [myheaderView addSubview:btn_location];
    UIButton * btn_Tel=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-47, BackView_StoreInfo.frame.origin.y+5, 30, 30)];
    [btn_Tel setImage:[UIImage imageNamed:@"Tel_icon"] forState:UIControlStateNormal];
    [btn_Tel addTarget:self action:@selector(MakeCallForStore) forControlEvents:UIControlEventTouchUpInside];
    [myheaderView addSubview:btn_Tel];
    UIView * fenge1=[[UIView alloc] initWithFrame:CGRectMake(15, myheaderView.frame.size.height-1, SCREEN_WIDTH-13, 0.3)];
    fenge1.backgroundColor=[UIColor grayColor];
    [myheaderView addSubview:fenge1];
    _myTableVeiw.tableHeaderView=myheaderView;
}

-(void)InitAllView
{
//    btn_collect
    _myTableVeiw.delegate=self;
    _myTableVeiw.dataSource=self;
    // 下拉刷新
    [_myTableVeiw addLegendHeaderWithRefreshingBlock:^{
        
        [self TopRefresh];
        [_myTableVeiw reloadData];
        [_myTableVeiw.header endRefreshing];
    }];
    [_myTableVeiw.header beginRefreshing];
    
//    // 上拉刷新
//    [_myTableVeiw addLegendFooterWithRefreshingBlock:^{
//        if (!isfooterrefresh) {
//            isfooterrefresh=YES;
//            [self FootRefresh];
//            [_myTableVeiw reloadData];
//        }
//        // 结束刷新
//        [_myTableVeiw.footer endRefreshing];
//    }];
//    // 默认先隐藏footer
//    _myTableVeiw.footer.hidden = NO;
}
-(void)MakeCallForStore
{
    NSLog(@"打电话");
}
-(void)JumptoNavi:(UIButton * )sender
{
//    RoutePlanViewController * routeplanVC=[[RoutePlanViewController alloc] init];
//    [self.navigationController pushViewController:routeplanVC animated:YES];
}

-(void)TopRefresh
{
//    if (userinfoWithFile[@"key"]) {
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"GetStoreDetialBackCall:"];
        [dataprovider GetIndexDataWithKey:userinfoWithFile[@"key"]];
//    }
//    else
//    {
//        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"通知" message:@"请先登录" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
//        [alert show];
//    }
}

//-(void)FootRefresh
//{
//    isfooterrefresh=NO;
//    ++curpage;
////    NSDictionary * prm=@{@"store_id":@"2",@"page":@"6",@"curpage":[NSString stringWithFormat:@"%d",curpage]};
////    DataProvider * dataprovider=[[DataProvider alloc] init];
////    [dataprovider setDelegateObject:self setBackFunctionName:@"FootRefireshBackCall:"];
////    [dataprovider GetStoreGoodList:prm];
////    [_myTableVeiw.footer endRefreshing];
//}

//-(void)FootRefireshBackCall:(id)dict
//{
//    
//    NSLog(@"上拉刷新");
//    
//    NSMutableArray *itemarray=[[NSMutableArray alloc] initWithArray:goods_list];
//    if (!dict[@"datas"][@"error"]) {
//        NSArray * arrayitem=dict[@"datas"][@"goods_list"];
//        for (id item in arrayitem) {
//            [itemarray addObject:item];
//        }
//        goods_list=[[NSArray alloc] initWithArray:itemarray];
//    }
//}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    GoodDetialViewController * gooddetial=[[GoodDetialViewController alloc] initWithNibName:@"GoodDetialViewController" bundle:[NSBundle mainBundle]];
//    gooddetial.gc_id=goods_list[indexPath.row][@"goods_id"];
//    [self.navigationController pushViewController:gooddetial animated:YES];
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 60)];
    UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(15, 20, SCREEN_WIDTH/2-10, 20)];
    UILabel * lbl_num=[[UILabel alloc] initWithFrame:CGRectMake(lbl_title.frame.size.width+lbl_title.frame.origin.x, 20, SCREEN_WIDTH/2-20, 20)];
    lbl_num.textAlignment=NSTextAlignmentRight;
    switch (indexPath.row) {
        case 0:
            lbl_title.text=@"待发货订单";
            lbl_num.text=[NSString stringWithFormat:@"(今日%@/总数%@)",OrderInfo[@"pay_count"][@"today"],OrderInfo[@"pay_count"][@"all"]];
            break;
        case 1:
            lbl_title.text=@"已发货订单";
            lbl_num.text=[NSString stringWithFormat:@"(今日%@/总数%@)",OrderInfo[@"send_count"][@"today"],OrderInfo[@"send_count"][@"all"]];
            break;
        case 2:
            lbl_title.text=@"已完成订单";
            lbl_num.text=[NSString stringWithFormat:@"(今日%@/总数%@)",OrderInfo[@"eval_count"][@"today"],OrderInfo[@"eval_count"][@"all"]];

            break;
        case 3:
            lbl_title.text=@"今日订单";
            lbl_num.text=[NSString stringWithFormat:@"(总数%@)",OrderInfo[@"today_all_count"]];

            break;
        case 4:
            lbl_title.text=@"本月已完成订单";
            lbl_num.text=[NSString stringWithFormat:@"(总数%@)",OrderInfo[@"month_eval_count"]];

            break;
        case 5:
            lbl_title.text=@"历史已完成订单";
            lbl_num.text=[NSString stringWithFormat:@"(总数%@)",OrderInfo[@"history_eval_count"]];

            break;
        default:
            break;
    }
    [cell addSubview:lbl_title];
    [cell addSubview:lbl_num];
//    static NSString *CellIdentifier = @"GoodsTableViewCellIdentifier";
//    GoodsTableViewCell *cell = (GoodsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    cell.backgroundColor=[UIColor whiteColor];
//    cell.layer.masksToBounds=YES;
//    cell.layer.cornerRadius=5;
//    cell.bounds=CGRectMake(0, 0, SCREEN_WIDTH-50, cell.frame.size.height);
//    cell  = [[[NSBundle mainBundle] loadNibNamed:@"GoodsTableViewCell" owner:self options:nil] lastObject];
//    cell.layer.masksToBounds=YES;
//    cell.frame=CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tableView.frame.size.width, cell.frame.size.height);
//    cell.lbl_goodsName.text=goods_list[indexPath.row][@"goods_name"];
//    cell.lbl_goodsDetial.text=goods_list[indexPath.row][@"goods_jingle"];
//    cell.lbl_long.text=goods_list[indexPath.row][@"juli"];
//    cell.lbl_price.text=goods_list[indexPath.row][@"goods_price"];
//    [cell.img_goodsicon sd_setImageWithURL:[NSURL URLWithString:goods_list[indexPath.row][@"goods_image_url"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    //        cell.lbl_rescuncun.text=goods_like[indexPath.row][@""];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)clickRightButton:(UIButton *)sender
{
    ShopEditDetialViewController * shopedit=[[ShopEditDetialViewController alloc] initWithNibName:@"ShopEditDetialViewController" bundle:[NSBundle mainBundle]];
    shopedit.StoreInfo=storeInfo;
    shopedit.key=userinfoWithFile[@"key"];
    [self.navigationController pushViewController:shopedit animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showTabBar];
}


@end
