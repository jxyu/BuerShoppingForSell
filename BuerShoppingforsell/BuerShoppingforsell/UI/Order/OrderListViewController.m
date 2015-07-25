//
//  OrderListViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/7/13.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "OrderListViewController.h"
#import "HYSegmentedControl.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
//#import "DataProvider.h"
#import "OrderCellTableViewCell.h"
#import "UIImageView+WebCache.h"
//#import "Pingpp.h"
//#import "PingJiaViewController.h"
#import "OrderDetialViewController.h"

@interface OrderListViewController ()<HYSegmentedControlDelegate>
@property (strong, nonatomic)HYSegmentedControl *segmentedControl;
@end

@implementation OrderListViewController
{
    BOOL isfooterrefresh;
    int curpage;
    NSArray * orderListArray;
    int actionIndex;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"我的订单";
    _lblTitle.textColor=[UIColor whiteColor];
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self createSegmentedControl];
    isfooterrefresh=NO;
    curpage=1;
    actionIndex=0;
    orderListArray=[[NSArray alloc] init];
//    [self changeIndex];
//    [self InitAllView];
    
}

-(void)InitAllView
{
    _myTableview.dataSource=self;
    _myTableview.delegate=self;
    // 下拉刷新
    [_myTableview addLegendHeaderWithRefreshingBlock:^{
        
        [self TopRefresh];
        
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


#pragma mark 构建tableview
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footerview=[[UIView alloc] init];
    footerview.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    return footerview;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray * itemarray=[[NSArray alloc] initWithArray:orderListArray[section][@"order_list"]];
    UIView * sectionHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    sectionHeaderView.backgroundColor=[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
    sectionHeaderView.backgroundColor=[UIColor whiteColor];
    
    UIImageView * img_icon=[[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 20, 20)];
    img_icon.image=[UIImage imageNamed:@"dianpu_gray_icon"];
    [sectionHeaderView addSubview:img_icon];
    UILabel * lbl_StoreTitle=[[UILabel alloc] initWithFrame:CGRectMake(img_icon.frame.size.width+img_icon.frame.origin.x+10, 15, 100, 20)];
    lbl_StoreTitle.text=itemarray[0][@"store_name"];
    [sectionHeaderView addSubview:lbl_StoreTitle];
    UIImageView * img_go=[[UIImageView alloc] initWithFrame:CGRectMake(lbl_StoreTitle.frame.origin.x+lbl_StoreTitle.frame.size.width+3, 19, 7, 12)];
    img_go.image=[UIImage imageNamed:@"index_go"];
    [sectionHeaderView addSubview:img_go];
    UILabel * lbl_status=[[UILabel alloc] initWithFrame:CGRectMake(sectionHeaderView.frame.size.width-150, 0, 140, sectionHeaderView.frame.size.height)];
    lbl_status.textAlignment=NSTextAlignmentRight;
    lbl_status.textColor=[UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1.0];
    lbl_status.text=itemarray[0][@"state_desc"];
    lbl_status.font=[UIFont systemFontOfSize:14];
    [sectionHeaderView addSubview:lbl_status];
    UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(10, sectionHeaderView.frame.size.height-1, sectionHeaderView.frame.size.width-20, 1)];
    fenge.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [sectionHeaderView addSubview:fenge];
    return sectionHeaderView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * itemarray=[[NSArray alloc] initWithArray:orderListArray[indexPath.section][@"order_list"]];
    NSArray * goodlist=[[NSArray alloc] initWithArray:itemarray[0][@"extend_order_goods"]];
    CGFloat height=60;
    if (indexPath.row<goodlist.count) {
        height=105;
    }
    return height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * itemarray=[[NSArray alloc] initWithArray:orderListArray[indexPath.section][@"order_list"]];
    NSArray * goodlist=[[NSArray alloc] initWithArray:itemarray[0][@"extend_order_goods"]];
    if (indexPath.row<goodlist.count) {
        OrderDetialViewController * orderdetial=[[OrderDetialViewController alloc] initWithNibName:@"OrderDetialViewController" bundle:[NSBundle mainBundle]];
        orderdetial.key=_key;
        orderdetial.orderid=itemarray[0][@"order_id"];
        [self.navigationController pushViewController:orderdetial animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * itemarray=[[NSArray alloc] initWithArray:orderListArray[indexPath.section][@"order_list"]];
    NSArray * goodlist=[[NSArray alloc] initWithArray:itemarray[0][@"extend_order_goods"]];
    NSLog(@"%ld,%lu",(long)indexPath.row,(unsigned long)goodlist.count);
    if (indexPath.row<goodlist.count) {
        static NSString *CellIdentifier = @"orderTableViewCellIdentifier";
        OrderCellTableViewCell *cell = (OrderCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.backgroundColor=[UIColor whiteColor];
        cell.layer.masksToBounds=YES;
        cell.layer.cornerRadius=5;
        cell.bounds=CGRectMake(0, 0, SCREEN_WIDTH-50, cell.frame.size.height);
        cell  = [[[NSBundle mainBundle] loadNibNamed:@"OrderCellTableViewCell" owner:self options:nil] lastObject];
        cell.layer.masksToBounds=YES;
        cell.frame=CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tableView.frame.size.width, cell.frame.size.height);
        cell.lbl_orderTitle.text=[NSString stringWithFormat:@"%@",goodlist[indexPath.row][@"goods_name"]];
        cell.lbl_price.text=[NSString stringWithFormat:@"¥%@",goodlist[indexPath.row][@"goods_price"]];
        cell.lbl_num.text=[NSString stringWithFormat:@"x%@",goodlist[indexPath.row][@"goods_num"]];
        cell.lbl_guige.text=goodlist[indexPath.row][@"goods_spec"];
        [cell.img_log sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",goodlist[indexPath.row][@"goods_image_url"]]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        //        cell.lbl_rescuncun.text=goods_like[indexPath.row][@""];
        return cell;
    }else if (indexPath.row==goodlist.count)
    {
        UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        UILabel * lbl_price=[[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width-80, 20, 70, 20)];
        lbl_price.text=[NSString stringWithFormat:@"¥%@",itemarray[0][@"order_amount"]];
        lbl_price.font=[UIFont systemFontOfSize:15];
        [cell addSubview:lbl_price];
        UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(lbl_price.frame.origin.x-50, 20, 50, 20)];
        lbl_title.text=@"实付:";
        lbl_title.textColor=[UIColor grayColor];
        lbl_title.textAlignment=NSTextAlignmentRight;
        lbl_title.font=[UIFont systemFontOfSize:15];
        [cell addSubview:lbl_title];
        UILabel * lbl_num=[[UILabel alloc] initWithFrame:CGRectMake(lbl_title.frame.origin.x-100, 20, 100, 20)];
        lbl_num.textAlignment=NSTextAlignmentCenter;
        lbl_num.font=[UIFont systemFontOfSize:15];
        lbl_num.text=[NSString stringWithFormat:@"共%lu件商品",(unsigned long)goodlist.count];
        [cell addSubview:lbl_num];
        return cell;
    }
    else
    {
        UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        if ([_OrderStatus isEqualToString:@"10"]) {
            UIButton * btn_pay=[[UIButton alloc] initWithFrame:CGRectMake(cell.frame.size.width-80, 10, 70, 40)];
            btn_pay.layer.masksToBounds=YES;
            btn_pay.layer.cornerRadius=5;
            btn_pay.layer.borderWidth=1;
            btn_pay.layer.borderColor=[[UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1.0] CGColor];
            [btn_pay setTitle:@"付款" forState:UIControlStateNormal];
            btn_pay.tag=indexPath.section;
            [btn_pay addTarget:self action:@selector(payforOrder:) forControlEvents:UIControlEventTouchUpInside];
            [btn_pay setTitleColor:[UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1.0] forState:UIControlStateNormal];
            btn_pay.titleLabel.font=[UIFont systemFontOfSize:15];
            [cell addSubview:btn_pay];
            UIButton * btn_cancelOrder=[[UIButton alloc] initWithFrame:CGRectMake(btn_pay.frame.origin.x-80, 10, 70, 40)];
            btn_cancelOrder.layer.masksToBounds=YES;
            btn_cancelOrder.layer.cornerRadius=5;
            btn_cancelOrder.layer.borderWidth=1;
            btn_cancelOrder.layer.borderColor=[[UIColor blackColor] CGColor];
            [btn_cancelOrder setTitle:@"取消订单" forState:UIControlStateNormal];
            btn_cancelOrder.tag=indexPath.section;
            [btn_cancelOrder addTarget:self action:@selector(CancelOrderClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn_cancelOrder setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn_cancelOrder.titleLabel.font=[UIFont systemFontOfSize:15];
            [cell addSubview:btn_cancelOrder];
        }
        if ([_OrderStatus isEqualToString:@"20"]) {
            UIButton * btn_cancelOrder=[[UIButton alloc] initWithFrame:CGRectMake(cell.frame.size.width-80, 10, 70, 40)];
            btn_cancelOrder.layer.masksToBounds=YES;
            btn_cancelOrder.layer.cornerRadius=5;
            btn_cancelOrder.layer.borderWidth=1;
            btn_cancelOrder.layer.borderColor=[[UIColor blackColor] CGColor];
            [btn_cancelOrder setTitle:@"取消订单" forState:UIControlStateNormal];
            btn_cancelOrder.tag=indexPath.section;
            [btn_cancelOrder setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn_cancelOrder addTarget:self action:@selector(CancelOrderClick:) forControlEvents:UIControlEventTouchUpInside];
            btn_cancelOrder.titleLabel.font=[UIFont systemFontOfSize:15];
            [cell addSubview:btn_cancelOrder];
        }
        if ([_OrderStatus isEqualToString:@"30"]) {
            UIButton * btn_pay=[[UIButton alloc] initWithFrame:CGRectMake(cell.frame.size.width-80, 10, 70, 40)];
            btn_pay.layer.masksToBounds=YES;
            btn_pay.layer.cornerRadius=5;
            btn_pay.layer.borderWidth=1;
            btn_pay.layer.borderColor=[[UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1.0] CGColor];
            [btn_pay setTitle:@"确认收货" forState:UIControlStateNormal];
            [btn_pay setTitleColor:[UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1.0] forState:UIControlStateNormal];
            btn_pay.titleLabel.font=[UIFont systemFontOfSize:15];
            btn_pay.tag=indexPath.section;
            [btn_pay addTarget:self action:@selector(OrderForSure:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn_pay];
            UIButton * btn_cancelOrder=[[UIButton alloc] initWithFrame:CGRectMake(btn_pay.frame.origin.x-80, 10, 70, 40)];
            btn_cancelOrder.layer.masksToBounds=YES;
            btn_cancelOrder.layer.cornerRadius=5;
            btn_cancelOrder.layer.borderWidth=1;
            btn_cancelOrder.layer.borderColor=[[UIColor blackColor] CGColor];
            [btn_cancelOrder setTitle:@"退/换货" forState:UIControlStateNormal];
            [btn_cancelOrder setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn_cancelOrder.titleLabel.font=[UIFont systemFontOfSize:15];
            btn_cancelOrder.tag=indexPath.section;
            [btn_cancelOrder addTarget:self action:@selector(ChangeGoodsClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn_cancelOrder];
        }
        if ([_OrderStatus isEqualToString:@"40"]) {
            if ([[NSString stringWithFormat:@"%@",itemarray[0][@"if_evaluation"]] isEqualToString:@"1"]) {
                UIButton * btn_pay=[[UIButton alloc] initWithFrame:CGRectMake(cell.frame.size.width-80, 10, 70, 40)];
                btn_pay.layer.masksToBounds=YES;
                btn_pay.layer.cornerRadius=5;
                btn_pay.layer.borderWidth=1;
                btn_pay.layer.borderColor=[[UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1.0] CGColor];
                [btn_pay setTitle:@"评价" forState:UIControlStateNormal];
                btn_pay.tag=indexPath.section;
                [btn_pay setTitleColor:[UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1.0] forState:UIControlStateNormal];
                btn_pay.titleLabel.font=[UIFont systemFontOfSize:15];
                [btn_pay addTarget:self action:@selector(PingjiaVCJumpTo:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn_pay];
            }
            UIView * lastview=[cell.subviews lastObject];
            UIButton * btn_ChangeGoods=[[UIButton alloc] initWithFrame:CGRectMake([[cell.subviews lastObject] isKindOfClass:[UIButton class]]?lastview.frame.origin.x-80:cell.frame.size.width-80, 10, 70, 40)];
            btn_ChangeGoods.layer.masksToBounds=YES;
            btn_ChangeGoods.layer.cornerRadius=5;
            btn_ChangeGoods.layer.borderWidth=1;
            btn_ChangeGoods.layer.borderColor=[[UIColor blackColor] CGColor];
            [btn_ChangeGoods setTitle:@"退/换货" forState:UIControlStateNormal];
            [btn_ChangeGoods setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn_ChangeGoods.tag=indexPath.section;
            [btn_ChangeGoods addTarget:self action:@selector(ChangeGoodsClick:) forControlEvents:UIControlEventTouchUpInside];
            btn_ChangeGoods.titleLabel.font=[UIFont systemFontOfSize:15];
            [cell addSubview:btn_ChangeGoods];
            UIButton * btn_cancelOrder=[[UIButton alloc] initWithFrame:CGRectMake(btn_ChangeGoods.frame.origin.x-80, 10, 70, 40)];
            btn_cancelOrder.layer.masksToBounds=YES;
            btn_cancelOrder.layer.cornerRadius=5;
            btn_cancelOrder.layer.borderWidth=1;
            btn_cancelOrder.layer.borderColor=[[UIColor blackColor] CGColor];
            [btn_cancelOrder setTitle:@"删除订单" forState:UIControlStateNormal];
            [btn_cancelOrder setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn_cancelOrder.tag=indexPath.section;
            [btn_cancelOrder addTarget:self action:@selector(delOrder:) forControlEvents:UIControlEventTouchUpInside];
            btn_cancelOrder.titleLabel.font=[UIFont systemFontOfSize:15];
            [cell addSubview:btn_cancelOrder];
        }
        return cell;
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * itemarray=[[NSArray alloc] initWithArray:orderListArray[section][@"order_list"]];
    NSArray * goodlist=[[NSArray alloc] initWithArray:itemarray[0][@"extend_order_goods"]];
    return goodlist.count+2;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return orderListArray.count;
}

#pragma mark tableview刷新与加载
-(void)TopRefresh
{
    curpage=1;
//    DataProvider * dataprovider=[[DataProvider alloc] init];
//    [dataprovider setDelegateObject:self setBackFunctionName:@"GetOrderListBackCall:"];
//    [dataprovider GetOrderListWithKey:_key andcurpage:[NSString stringWithFormat:@"%d",curpage] andorder_state:_OrderStatus];
}
-(void)GetOrderListBackCall:(id)dict
{
    [SVProgressHUD dismiss];
    if (!dict[@"datas"][@"error"]) {
        orderListArray=dict[@"datas"][@"order_group_list"];
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
    NSMutableArray *itemarray=[[NSMutableArray alloc] initWithArray:orderListArray];
    if (!dict[@"datas"][@"error"]) {
        NSArray * arrayitem=dict[@"datas"][@"order_group_list"];
        for (id item in arrayitem) {
            [itemarray addObject:item];
        }
        orderListArray=[[NSArray alloc] initWithArray:itemarray];
    }
    [_myTableview reloadData];
}

#pragma mark segmentcontroll
//
//  切换
//
- (void)changeIndex
{
    int status=0;
    if (_OrderStatus) {
        status=[_OrderStatus intValue];
    }
    switch (status) {
        case 10:
            [self.segmentedControl changeSegmentedControlWithIndex:0];
            _lblTitle.text=@"待付款";
            break;
        case 20:
            [self.segmentedControl changeSegmentedControlWithIndex:1];
            _lblTitle.text=@"待发货";
            break;
        case 30:
            [self.segmentedControl changeSegmentedControlWithIndex:2];
            _lblTitle.text=@"待收货";
            break;
        case 40:
            [self.segmentedControl changeSegmentedControlWithIndex:3];
            _lblTitle.text=@"已收货";
            break;
        default:
            break;
    }
}

//
//  init SegmentedControl
//
- (void)createSegmentedControl
{
    self.segmentedControl = [[HYSegmentedControl alloc] initWithOriginY:65 Titles:@[@"待付款", @"待发货", @"待收货", @"已收货"] delegate:self] ;
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
            _OrderStatus=@"10";
            _lblTitle.text=@"待付款";
            break;
        case 1:
            _OrderStatus=@"20";
            _lblTitle.text=@"待发货";
            break;
        case 2:
            _OrderStatus=@"30";
            _lblTitle.text=@"待收货";
            break;
        case 3:
            _OrderStatus=@"40";
            _lblTitle.text=@"已收货";
            break;
        default:
            break;
    }
    [_myTableview.header beginRefreshing];
}

#pragma mark 订单按钮操作

/**
 *  付款
 *
 *  @param sender <#sender description#>
 */
-(void)payforOrder:(UIButton *)sender
{
    actionIndex=sender.tag;
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"支付宝充值", @"微信充值", nil];
    
    choiceSheet.tag=1;
    [choiceSheet showInView:self.view];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSArray * itemarray=[[NSArray alloc] initWithArray:orderListArray[actionIndex][@"order_list"]];
    if (actionSheet.tag==1) {
        
        NSLog(@"%ld",(long)buttonIndex);
        NSString *payWay=@"";
        if (buttonIndex==0) {
            payWay=@"alipay";
            if (itemarray[0][@"order_amount"]) {
//                NSDictionary * prm=@{@"key":_key,@"pdramount":itemarray[0][@"order_amount"],@"channel":payWay};
//                DataProvider * dataprovider=[[DataProvider alloc] init];
//                [dataprovider setDelegateObject:self setBackFunctionName:@"GetChargeBackCall:"];
//                [dataprovider GetChargeObject:prm];
            }
        }else if(buttonIndex ==1)
        {
            payWay=@"wx";
            if (itemarray[0][@"order_amount"]) {
//                NSDictionary * prm=@{@"key":_key,@"pdramount":itemarray[0][@"order_amount"],@"channel":payWay};
//                DataProvider * dataprovider=[[DataProvider alloc] init];
//                [dataprovider setDelegateObject:self setBackFunctionName:@"GetChargeBackCall:"];
//                [dataprovider GetChargeObject:prm];
            }
        }
        

    }
    else
    {
        if (buttonIndex==0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",itemarray[0][@"store_phone"]]]];
        }
    }
    
}
-(void)GetChargeBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if (!dict[@"datas"][@"error"]) {
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString* str_data = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            }
}

-(void)CancelOrderClick:(UIButton * )sender
{
//    NSArray * itemarray=[[NSArray alloc] initWithArray:orderListArray[sender.tag][@"order_list"]];
//    DataProvider * dataprovider=[[DataProvider alloc] init];
//    [dataprovider setDelegateObject:self setBackFunctionName:@"CanCelOrderBackCall:"];
//    if ([_OrderStatus isEqualToString:@"10"]) {
//        [dataprovider CancalOrderWithOutPay:itemarray[0][@"order_id"] andkey:_key];
//    }else
//    {
//        [dataprovider CancalOrderPayAlready:itemarray[0][@"order_id"] andkey:_key];
//    }
}
-(void)CanCelOrderBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if ([[NSString stringWithFormat:@"%@",dict[@"datas"]] isEqualToString:@"1"]) {
        [_myTableview.header beginRefreshing];
    }
}
-(void)OrderForSure:(UIButton *)sender
{
    NSArray * itemarray=[[NSArray alloc] initWithArray:orderListArray[sender.tag][@"order_list"]];
//    DataProvider * dataprovider=[[DataProvider alloc] init];
//    [dataprovider setDelegateObject:self setBackFunctionName:@"CanCelOrderBackCall:"];
//    [dataprovider OrderForSure:itemarray[0][@"order_id"] andkey:_key];
}

-(void)ChangeGoodsClick:(UIButton *)sender
{
    actionIndex=sender.tag;
    NSArray * itemarray=[[NSArray alloc] initWithArray:orderListArray[sender.tag][@"order_list"]];
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:[NSString stringWithFormat:@"店铺电话:%@",itemarray[0][@"store_phone"]], nil];
    
    choiceSheet.tag=2;
    [choiceSheet showInView:self.view];

}

-(void)delOrder:(UIButton * )sender
{
    NSArray * itemarray=[[NSArray alloc] initWithArray:orderListArray[sender.tag][@"order_list"]];
//    DataProvider * dataprovider=[[DataProvider alloc] init];
//    [dataprovider setDelegateObject:self setBackFunctionName:@"CanCelOrderBackCall:"];
//    [dataprovider DelOrder:itemarray[0][@"order_id"] andkey:_key];
}

-(void)PingjiaVCJumpTo:(UIButton *)sender
{
//    NSArray * itemarray=[[NSArray alloc] initWithArray:orderListArray[sender.tag][@"order_list"]];
//    PingJiaViewController * pingjiaVC=[[PingJiaViewController alloc] initWithNibName:@"PingJiaViewController" bundle:[NSBundle mainBundle]];
//    pingjiaVC.key=_key;
//    pingjiaVC.orderData=itemarray[0];
//    [self.navigationController pushViewController:pingjiaVC animated:YES];
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
