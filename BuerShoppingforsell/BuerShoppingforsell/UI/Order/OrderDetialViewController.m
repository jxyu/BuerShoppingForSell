//
//  OrderDetialViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/7/22.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "OrderDetialViewController.h"
#import "DataProvider.h"
#import "OrderCellTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

@interface OrderDetialViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@end

@implementation OrderDetialViewController
{
    NSDictionary *extend_order_common;
    NSDictionary * order_info;
    NSArray * goods_list;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"订单详情";
    _lblTitle.textColor=[UIColor whiteColor];
    [self addLeftButton:@"Icon_Back@2x.png"];
    extend_order_common=[[NSDictionary alloc] init];
    order_info=[[NSDictionary alloc] init];
    goods_list=[[NSArray alloc] init];
    [self RequestData];
    [self InitAllView];
}

-(void)InitAllView
{
    
    _myTableVeiw.delegate=self;
    _myTableVeiw.dataSource=self;
}

-(void)RequestData
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"RequestDataBackCall:"];
    [dataprovider GetOrderDetialwithkey:_key andorder_id:_orderid];
}
-(void)RequestDataBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if (!dict[@"datas"][@"error"])
    {
        order_info=dict[@"datas"][@"order_info"];
        extend_order_common=dict[@"datas"][@"order_info"][@"extend_order_common"];
        goods_list=dict[@"datas"][@"order_info"][@"goods_list"];
        [_myTableVeiw reloadData];
        [self buildHeaderview];
        [self BuildBottombutton];
    }
}

#pragma mark 构建tableview
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * sectionHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    sectionHeaderView.backgroundColor=[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
    sectionHeaderView.backgroundColor=[UIColor whiteColor];
    
    UIImageView * img_icon=[[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 20, 20)];
    img_icon.image=[UIImage imageNamed:@"dianpu_gray_icon"];
    [sectionHeaderView addSubview:img_icon];
    UILabel * lbl_StoreTitle=[[UILabel alloc] initWithFrame:CGRectMake(img_icon.frame.size.width+img_icon.frame.origin.x+10, 15, 100, 20)];
    lbl_StoreTitle.text=order_info[@"store_name"];
    [sectionHeaderView addSubview:lbl_StoreTitle];
    UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(10, sectionHeaderView.frame.size.height-1, sectionHeaderView.frame.size.width-20, 1)];
    fenge.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [sectionHeaderView addSubview:fenge];
    return sectionHeaderView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height=60;
    if (indexPath.row==0) {
        height=105;
    }
    if (indexPath.row==goods_list.count+1) {
        height=100;
    }
    return height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<goods_list.count) {
        static NSString *CellIdentifier = @"orderTableViewCellIdentifier";
        OrderCellTableViewCell *cell = (OrderCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.backgroundColor=[UIColor whiteColor];
        cell.layer.masksToBounds=YES;
        cell.layer.cornerRadius=5;
        cell.bounds=CGRectMake(0, 0, SCREEN_WIDTH-50, cell.frame.size.height);
        cell  = [[[NSBundle mainBundle] loadNibNamed:@"OrderCellTableViewCell" owner:self options:nil] lastObject];
        cell.layer.masksToBounds=YES;
        cell.frame=CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tableView.frame.size.width, cell.frame.size.height);
        cell.lbl_orderTitle.text=[NSString stringWithFormat:@"%@",goods_list[indexPath.row][@"goods_name"]];
        cell.lbl_price.text=[NSString stringWithFormat:@"¥%@",goods_list[indexPath.row][@"goods_price"]];
        cell.lbl_num.text=[NSString stringWithFormat:@"x%@",goods_list[indexPath.row][@"goods_num"]];
        cell.lbl_guige.text=[goods_list[indexPath.row][@"goods_spec"] isKindOfClass:[NSNull class]]?@"":goods_list[indexPath.row][@"goods_spec"];
        [cell.img_log sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",goods_list[indexPath.row][@"image_60_url"]]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        //        cell.lbl_rescuncun.text=goods_like[indexPath.row][@""];
        return cell;
    }else if (indexPath.row==goods_list.count)
    {
        
        UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        UILabel * lbl_price=[[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width-80, 20, 70, 20)];
        lbl_price.text=[NSString stringWithFormat:@"¥%@", order_info[@"order_amount"]];
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
        lbl_num.text=[NSString stringWithFormat:@"共%@件商品",order_info[@"goods_count"]];
        [cell addSubview:lbl_num];
        return cell;
    }
    else if(indexPath.row==goods_list.count+1)
    {
        UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
        UILabel * lbl_cellTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, 20)];
        lbl_cellTitle.text=@"运费";
        lbl_cellTitle.textColor=[UIColor grayColor];
        [cell addSubview:lbl_cellTitle];
        UILabel * lbl_cellTitleitem=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-160, 10, 150, 20)];
        lbl_cellTitleitem.text=[NSString stringWithFormat:@"¥%@",order_info[@"shipping_fee"]];
        lbl_cellTitleitem.textAlignment=NSTextAlignmentRight;
        [cell addSubview:lbl_cellTitleitem];
        UILabel * lbl_payWay=[[UILabel alloc] initWithFrame:CGRectMake(10, lbl_cellTitle.frame.size.height+lbl_cellTitle.frame.origin.y+10, 150, 20)];
        lbl_payWay.text=@"付款方式";
        lbl_payWay.textColor=[UIColor grayColor];
        [cell addSubview:lbl_payWay];
        UILabel * lbl_payWayitem=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-160, lbl_payWay.frame.origin.y, 150, 20)];
        lbl_payWayitem.text=[NSString stringWithFormat:@"%@",order_info[@"payment_name"]];
        lbl_payWayitem.textAlignment=NSTextAlignmentRight;
        [cell addSubview:lbl_payWayitem];
        UILabel * lbl_senderway=[[UILabel alloc] initWithFrame:CGRectMake(10, lbl_payWay.frame.size.height+lbl_payWay.frame.origin.y+10, 150, 20)];
        lbl_senderway.text=@"收货方式";
        lbl_senderway.textColor=[UIColor grayColor];
        [cell addSubview:lbl_senderway];
        UILabel * lbl_senderwayitem=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-160, lbl_senderway.frame.origin.y, 150, 20)];
        lbl_senderwayitem.text=[NSString stringWithFormat:@"%@",extend_order_common[@"dlyo_pickup_type"]];
        lbl_senderwayitem.textAlignment=NSTextAlignmentRight;
        [cell addSubview:lbl_senderwayitem];
        return cell;
    }
    else if(indexPath.row==goods_list.count+2)
    {
        UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        UILabel * lbl_cellTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 20, 150, 20)];
        lbl_cellTitle.text=@"订单编号";
        lbl_cellTitle.textColor=[UIColor grayColor];
        [cell addSubview:lbl_cellTitle];
        CGFloat x=lbl_cellTitle.frame.size.width+lbl_cellTitle.frame.origin.x+10;
        UILabel * lbl_sendWay=[[UILabel alloc] initWithFrame:CGRectMake(x, 20, SCREEN_WIDTH-x-10, 20)];
        lbl_sendWay.textColor=[UIColor grayColor];
        lbl_sendWay.text=order_info[@"order_sn"];
        lbl_sendWay.textAlignment=NSTextAlignmentRight;
        [cell addSubview:lbl_sendWay];
        return cell;

    }
    else
    {
        UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        UILabel * lbl_cellTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 20, 150, 20)];
        lbl_cellTitle.text=@"买家留言";
        lbl_cellTitle.textColor=[UIColor grayColor];
        [cell addSubview:lbl_cellTitle];
        CGFloat x=lbl_cellTitle.frame.size.width+lbl_cellTitle.frame.origin.x+10;
        UILabel * lbl_sendWay=[[UILabel alloc] initWithFrame:CGRectMake(x, 20, SCREEN_WIDTH-x-10, 20)];
        lbl_sendWay.textColor=[UIColor grayColor];
        lbl_sendWay.text=[extend_order_common[@"order_seller_message"] isKindOfClass:[NSNull class]]?@"":extend_order_common[@"order_seller_message"];
        lbl_sendWay.textAlignment=NSTextAlignmentRight;
        [cell addSubview:lbl_sendWay];
        return cell;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (goods_list) {
        return goods_list.count+4;
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)BuildBottombutton
{
    if ([_orderStatus isEqualToString:@"0"]) {
        UIButton * btn_pay=[[UIButton alloc] initWithFrame:CGRectMake(_bottomVeiw.frame.size.width-80, 10, 70, 40)];
        btn_pay.layer.masksToBounds=YES;
        btn_pay.layer.cornerRadius=5;
        btn_pay.layer.borderWidth=1;
        btn_pay.layer.borderColor=[[UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1.0] CGColor];
        [btn_pay setTitle:@"接单" forState:UIControlStateNormal];
        [btn_pay addTarget:self action:@selector(payforOrder:) forControlEvents:UIControlEventTouchUpInside];
        [btn_pay setTitleColor:[UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1.0] forState:UIControlStateNormal];
        btn_pay.titleLabel.font=[UIFont systemFontOfSize:15];
        [_bottomVeiw addSubview:btn_pay];
        UIButton * btn_cancelOrder=[[UIButton alloc] initWithFrame:CGRectMake(btn_pay.frame.origin.x-80, 10, 70, 40)];
        btn_cancelOrder.layer.masksToBounds=YES;
        btn_cancelOrder.layer.cornerRadius=5;
        btn_cancelOrder.layer.borderWidth=1;
        btn_cancelOrder.layer.borderColor=[[UIColor blackColor] CGColor];
        [btn_cancelOrder setTitle:@"取消订单" forState:UIControlStateNormal];
        [btn_cancelOrder addTarget:self action:@selector(CancelOrderClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn_cancelOrder setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn_cancelOrder.titleLabel.font=[UIFont systemFontOfSize:15];
        [_bottomVeiw addSubview:btn_cancelOrder];
    }
    if ([_orderStatus isEqualToString:@"20"]) {
        UIButton * btn_cancelOrder=[[UIButton alloc] initWithFrame:CGRectMake(_bottomVeiw.frame.size.width-80, 10, 70, 40)];
        btn_cancelOrder.layer.masksToBounds=YES;
        btn_cancelOrder.layer.cornerRadius=5;
        btn_cancelOrder.layer.borderWidth=1;
        btn_cancelOrder.layer.borderColor=[[UIColor blackColor] CGColor];
        [btn_cancelOrder setTitle:@"取消订单" forState:UIControlStateNormal];
        [btn_cancelOrder setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_cancelOrder addTarget:self action:@selector(CancelOrderClick:) forControlEvents:UIControlEventTouchUpInside];
        btn_cancelOrder.titleLabel.font=[UIFont systemFontOfSize:15];
        [_bottomVeiw addSubview:btn_cancelOrder];
    }
    if ([_orderStatus isEqualToString:@"30"]) {
        UIButton * btn_cancelOrder=[[UIButton alloc] initWithFrame:CGRectMake(_bottomVeiw.frame.size.width-80, 10, 70, 40)];
        btn_cancelOrder.layer.masksToBounds=YES;
        btn_cancelOrder.layer.cornerRadius=5;
        btn_cancelOrder.layer.borderWidth=1;
        btn_cancelOrder.layer.borderColor=[[UIColor blackColor] CGColor];
        [btn_cancelOrder setTitle:@"删除订单" forState:UIControlStateNormal];
        [btn_cancelOrder setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn_cancelOrder.titleLabel.font=[UIFont systemFontOfSize:15];
        [btn_cancelOrder addTarget:self action:@selector(delOrder:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomVeiw addSubview:btn_cancelOrder];
    }
    if ([_orderStatus isEqualToString:@"40"]) {
        UIButton * btn_cancelOrder=[[UIButton alloc] initWithFrame:CGRectMake(_bottomVeiw.frame.size.width-80, 10, 70, 40)];
        btn_cancelOrder.layer.masksToBounds=YES;
        btn_cancelOrder.layer.cornerRadius=5;
        btn_cancelOrder.layer.borderWidth=1;
        btn_cancelOrder.layer.borderColor=[[UIColor blackColor] CGColor];
        [btn_cancelOrder setTitle:@"删除订单" forState:UIControlStateNormal];
        [btn_cancelOrder setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_cancelOrder addTarget:self action:@selector(delOrder:) forControlEvents:UIControlEventTouchUpInside];
        btn_cancelOrder.titleLabel.font=[UIFont systemFontOfSize:15];
        [_bottomVeiw addSubview:btn_cancelOrder];
    }
    
}

#pragma mark 订单按钮操作

/**
 *  接单
 *
 *  @param sender <#sender description#>
 */
-(void)payforOrder:(UIButton *)sender
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"jiedanBackCall:"];
    [dataprovider jiedanWithKey:_key andorder_id:_orderid andorder_seller_message:@""];
    
}

-(void)jiedanBackCall:(id)dict
{
    NSLog(@"接单%@",dict);
    if ([[NSString stringWithFormat:@"%@",dict[@"datas"]] isEqualToString:@"1"]) {
    }
}

-(void)CancelOrderClick:(UIButton * )sender
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"CanCelOrderBackCall:"];
    [dataprovider CancelOrderWithkey:_key andorder_id:_orderid];
}
-(void)CanCelOrderBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if ([[NSString stringWithFormat:@"%@",dict[@"datas"]] isEqualToString:@"1"]) {
    }
}

-(void)delOrder:(UIButton * )sender
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"CanCelOrderBackCall:"];
    [dataprovider DelOrderWithkey:_key andorder_id:_orderid];
}

-(void)PingjiaVCJumpTo:(UIButton *)sender
{
//    PingJiaViewController * pingjiaVC=[[PingJiaViewController alloc] initWithNibName:@"PingJiaViewController" bundle:[NSBundle mainBundle]];
//    pingjiaVC.key=_key;
//    pingjiaVC.orderData=itemarray[0];
//    [self.navigationController pushViewController:pingjiaVC animated:YES];
}



#pragma mark headerview逻辑
-(void)buildHeaderview
{
    UIView * headerview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    if (extend_order_common) {
        UIImageView * img_location=[[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 15, 20)];
        img_location.image=[UIImage imageNamed:@"location_icon"];
        [headerview addSubview:img_location];
        UILabel * lbl_addressTitle=[[UILabel alloc] initWithFrame:CGRectMake(img_location.frame.origin.x+img_location.frame.size.width+10, 10, 120, 20)];
        lbl_addressTitle.text=[NSString stringWithFormat:@"收货人:%@",[extend_order_common[@"reciver_name"] isKindOfClass:[NSNull class]]?@"":extend_order_common[@"reciver_name"]];
        [headerview addSubview:lbl_addressTitle];
        UILabel * lbl_phone=[[UILabel alloc] initWithFrame:CGRectMake(lbl_addressTitle.frame.origin.x+lbl_addressTitle.frame.size.width, 10, headerview.frame.size.width-lbl_addressTitle.frame.origin.x-lbl_addressTitle.frame.size.width-20, 20)];
        lbl_phone.text=[extend_order_common[@"reciver_info"][@"mob_phone"] isKindOfClass:[NSNull class]]?@"4":extend_order_common[@"reciver_info"][@"mob_phone"];
        [headerview addSubview:lbl_phone];
        UILabel * lbl_address=[[UILabel alloc] initWithFrame:CGRectMake(lbl_addressTitle.frame.origin.x, lbl_addressTitle.frame.origin.y+lbl_addressTitle.frame.size.height+5, lbl_phone.frame.size.width+lbl_phone.frame.origin.x-lbl_addressTitle.frame.origin.x, 40)];
        lbl_address.text=[NSString stringWithFormat:@"收货地址:%@",[extend_order_common[@"reciver_info"][@"address"] isKindOfClass:[NSNull class]]?@"":extend_order_common[@"reciver_info"][@"address"]];
        lbl_address.numberOfLines=2;
        lbl_address.font=[UIFont systemFontOfSize:14];
        [headerview addSubview:lbl_address];
//        UIImageView * img_go=[[UIImageView alloc] initWithFrame:CGRectMake(lbl_address.frame.origin.x+lbl_address.frame.size.width+3, 34, 7, 12)];
//        img_go.image=[UIImage imageNamed:@"index_go"];
//        [headerview addSubview:img_go];
//        UIButton *btn_JumptoAddressManager=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerview.frame.size.height)];
//        [btn_JumptoAddressManager addTarget:self action:@selector(JumpToAddressManager:) forControlEvents:UIControlEventTouchUpInside];
//        [headerview addSubview:btn_JumptoAddressManager];
        UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(10, headerview.frame.size.height-1, headerview.frame.size.width-20, 1)];
        fenge.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        [headerview addSubview:fenge];
    }
    _myTableVeiw.tableHeaderView=headerview;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

@end
