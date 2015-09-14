//
//  DataProvider.h
//  BuerShopping
//
//  Created by 于金祥 on 15/5/30.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataProvider : NSObject
{
    id CallBackObject;
    NSString * callBackFunctionName;
}
/**
 *  获取首页数据
 *
 *  @param key <#key description#>
 */
-(void)GetIndexDataWithKey:(NSString *)key;
/**
 *  商家登录
 *
 *  @param username <#username description#>
 *  @param pwd      <#pwd description#>
 */
-(void)Login:(NSString *)username andpwd:(NSString *)pwd;
/**
 *  获取分类
 */
-(void)GetClassifywithkey:(NSString *)key andgc_id:(NSString *)gc_id anddeep:(NSString *)deep;

/**
 *  出售中的商品
 *
 *  @param key     <#key description#>
 *  @param page    每页数量
 *  @param curpage <#curpage description#>
 */
-(void)GetGoodsForSell:(NSString *)key andpage:(NSString *)page andcurpage:(NSString *)curpage;
/**
 *  获取已下架商品
 *
 *  @param key     <#key description#>
 *  @param page    <#page description#>
 *  @param curpage <#curpage description#>
 */
-(void)GetGoodsForOffLine:(NSString *)key andpage:(NSString *)page andcurpage:(NSString *)curpage;
/**
 *  商家退出登录
 *
 *  @param key    <#key description#>
 *  @param mobile <#mobile description#>
 */
-(void)EixtLogin:(NSString *)key andmobile:(NSString *)mobile;
/**
 *  商品下架
 *
 *  @param key      <#key description#>
 *  @param commonid <#commonid description#>
 */
-(void)UnshowGoodsWithKey:(NSString *)key andcommonid:(NSString *)commonid;
/**
 *  商品上架
 *
 *  @param key      <#key description#>
 *  @param commonid <#commonid description#>
 */
-(void)showGoodsWithKey:(NSString *)key andcommonid:(NSString *)commonid;
/**
 *  删除商品
 *
 *  @param key      <#key description#>
 *  @param commonid <#commonid description#>
 */
-(void)DelgoodsWithKey:(NSString *)key andcommonid:(NSString *)commonid;
/**
 *  获取订单列表
 *
 *  @param key         <#key description#>
 *  @param curpage     <#curpage description#>
 *  @param order_state 订单状态（0:已取消,待发货:20,已发货:30,已完成:40）
 */
-(void)GetSellOrderWithkey:(NSString *)key andcurpage:(NSString *)curpage andorder_state:(NSString *)order_state;
/**
 *  接单
 *
 *  @param key                  <#key description#>
 *  @param order_id             <#order_id description#>
 *  @param order_seller_message 留言：物流订单号
 */
-(void)jiedanWithKey:(NSString *)key andorder_id:(NSString *)order_id andorder_seller_message:(NSString *)order_seller_message;
/**
 *  取消订单
 *
 *  @param key      <#key description#>
 *  @param order_id <#order_id description#>
 */
-(void)CancelOrderWithkey:(NSString *)key andorder_id:(NSString *)order_id;
/**
 *  删除订单
 *
 *  @param key      <#key description#>
 *  @param order_id <#order_id description#>
 */
-(void)DelOrderWithkey:(NSString *)key andorder_id:(NSString *)order_id;
/**
 *  获取订单详情
 *
 *  @param key      <#key description#>
 *  @param order_id <#order_id description#>
 */
-(void)GetOrderDetialwithkey:(NSString *)key andorder_id:(NSString *)order_id;
/**
 *  获取商品编辑详情
 *
 *  @param key      <#key description#>
 *  @param commonid <#commonid description#>
 */
-(void)GetGoodDetialWithkey:(NSString *)key andcommonid:(NSString *)commonid;
/**
 *  获取商品规格
 *
 *  @param key   <#key description#>
 *  @param gc_id 二级分类gc_id
 */
-(void)GetGuiGeData:(NSString *)key andgc_id:(NSString *)gc_id;
/**
 *  上传身份证照片
 *
 *  @param imagedata <#imagedata description#>
 *  @param key       <#key description#>
 *  @param name      <#name description#>
 */
-(void)UpLoadIDCardImg:(NSData *)imagedata andkey:(NSString *)key andname:(NSString *)name;
/**
 *  认证
 *
 *  @param prm <#prm description#>
 */
-(void)RealNameSubmit:(id)prm;
/**
 *  获取省市区
 *
 *  @param areaid <#areaid description#>
 */
-(void)GetArrayListwithareaid:(NSString *)areaid;
/**
 *  上传商家轮播图与logo
 *
 *  @param imagedata <#imagedata description#>
 *  @param key       <#key description#>
 *  @param name      <#name description#>
 */
-(void)UpLoadStoreImg:(NSData *)imagedata andkey:(NSString *)key andname:(NSString *)name;
/**
 *  首页编辑保存
 *
 *  @param prm <#prm description#>
 */
-(void)indexEditSave:(id)prm;
/**
 *  获取商品规格值
 *
 *  @param key   <#key description#>
 *  @param name  规格名称逗号分割
 *  @param gc_id <#gc_id description#>
 *  @param sp_id <#sp_id description#>
 */
-(void)GetGuigeValueWtihkey:(NSString *)key andname:(NSString *)name andgc_id:(NSString *)gc_id andsp_id:(NSString *)sp_id;
/**
 *  商品图片上传
 *
 *  @param imagedata <#imagedata description#>
 *  @param key       <#key description#>
 *  @param name      <#name description#>
 */
-(void)UpLoadGoodImg:(NSData *)imagedata andkey:(NSString *)key andname:(NSString *)name;
/**
 *  商品发布
 *
 *  @param prm <#prm description#>
 */
-(void)SaveGoodInfo:(id)prm;






/**
 *  设置回调函数
 *
 *  @param cbobject     回调对象
 *  @param selectorName 回调函数
 */
- (void)setDelegateObject:(id)cbobject setBackFunctionName:(NSString *)selectorName;

@end
