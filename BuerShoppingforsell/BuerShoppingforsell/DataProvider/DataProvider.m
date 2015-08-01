//
//  DataProvider.m
//  BuerShopping
//
//  Created by 于金祥 on 15/5/30.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "DataProvider.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFURLRequestSerialization.h"
//#import "HttpRequest.h"

#define Url @"http://115.28.21.137/mobile/"

@implementation DataProvider

#pragma mark 赋值回调
- (void)setDelegateObject:(id)cbobject setBackFunctionName:(NSString *)selectorName
{
    CallBackObject = cbobject;
    callBackFunctionName = selectorName;
}

-(void)GetIndexDataWithKey:(NSString *)key
{
    if (key) {
        NSString *url=[NSString stringWithFormat:@"%@index.php?act=store_setting&op=index",Url];
        NSDictionary * prm=@{@"key":key};
        [self PostRequest:url andpram:prm];
    }
}
-(void)Login:(NSString *)username andpwd:(NSString *)pwd
{
    if (username&&pwd) {
        NSString *url=[NSString stringWithFormat:@"%@index.php?act=seller_login",Url];
        NSDictionary * prm=@{@"mobile":username,@"password":pwd,@"client":@"ios"};
        [self PostRequest:url andpram:prm];
    }
}

-(void)GetClassifywithkey:(NSString *)key andgc_id:(NSString *)gc_id anddeep:(NSString *)deep
{
    if (key&&gc_id&&deep) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=seller_goods_class&op=class_list",Url];
        NSDictionary * prm=@{@"key":key,@"gc_id":gc_id,@"deep":deep};
        [self PostRequest:url andpram:prm];
    }
    
}


-(void)GetGoodsForSell:(NSString *)key andpage:(NSString *)page andcurpage:(NSString *)curpage
{
    if (key&&page&&curpage) {
        NSString *url=[NSString stringWithFormat:@"%@index.php?act=seller_goods&op=goods_online",Url];
        NSDictionary * prm=@{@"key":key,@"page":page,@"curpage":curpage};
        [self GetRequest:url andpram:prm];
    }
}
-(void)GetGoodsForOffLine:(NSString *)key andpage:(NSString *)page andcurpage:(NSString *)curpage
{
    if (key&&page&&curpage) {
        NSString *url=[NSString stringWithFormat:@"%@index.php?act=seller_goods&op=goods_offline",Url];
        NSDictionary * prm=@{@"key":key,@"page":page,@"curpage":curpage};
        [self GetRequest:url andpram:prm];
    }
}

-(void)EixtLogin:(NSString *)key andmobile:(NSString *)mobile
{
    if (key&&mobile) {
        NSString *url=[NSString stringWithFormat:@"%@index.php?act=seller_login",Url];
        NSDictionary * prm=@{@"mobile":mobile,@"key":key,@"client":@"ios"};
        [self PostRequest:url andpram:prm];
    }
}
-(void)UnshowGoodsWithKey:(NSString *)key andcommonid:(NSString *)commonid
{
    if (key&&commonid) {
        NSString *url=[NSString stringWithFormat:@"%@index.php?act=seller_goods&op=goods_unshow",Url];
        NSDictionary * prm=@{@"commonid":commonid,@"key":key};
        [self GetRequest:url andpram:prm];
    }
}
-(void)showGoodsWithKey:(NSString *)key andcommonid:(NSString *)commonid
{
    if (key&&commonid) {
        NSString *url=[NSString stringWithFormat:@"%@index.php?act=seller_goods&op=goods_show",Url];
        NSDictionary * prm=@{@"commonid":commonid,@"key":key};
        [self GetRequest:url andpram:prm];
    }
}
-(void)DelgoodsWithKey:(NSString *)key andcommonid:(NSString *)commonid
{
    if (key&&commonid) {
        NSString *url=[NSString stringWithFormat:@"%@index.php?act=seller_goods&op=drop_goods",Url];
        NSDictionary * prm=@{@"commonid":commonid,@"key":key};
        [self GetRequest:url andpram:prm];
    }
}

-(void)GetSellOrderWithkey:(NSString *)key andcurpage:(NSString *)curpage andorder_state:(NSString *)order_state
{
    if (key&&curpage&&order_state) {
        NSString *url=[NSString stringWithFormat:@"%@index.php?act=seller_order&op=index",Url];
        NSDictionary * prm=@{@"curpage":curpage,@"key":key,@"order_state":order_state};
        [self GetRequest:url andpram:prm];
    }
}

-(void)jiedanWithKey:(NSString *)key andorder_id:(NSString *)order_id andorder_seller_message:(NSString *)order_seller_message
{
    if (key&&order_id&&order_seller_message) {
        NSString *url=[NSString stringWithFormat:@"%@index.php?act=seller_order&op=jiedan",Url];
        NSDictionary * prm=@{@"order_id":order_id,@"key":key,@"order_seller_message":order_seller_message};
        [self PostRequest:url andpram:prm];
    }
}

-(void)CancelOrderWithkey:(NSString *)key andorder_id:(NSString *)order_id
{
    if (key&&order_id) {
        NSString *url=[NSString stringWithFormat:@"%@index.php?act=seller_order&op=cancle",Url];
        NSDictionary * prm=@{@"order_id":order_id,@"key":key};
        [self PostRequest:url andpram:prm];
    }
}

-(void)DelOrderWithkey:(NSString *)key andorder_id:(NSString *)order_id
{
    if (key&&order_id) {
        NSString *url=[NSString stringWithFormat:@"%@index.php?act=seller_order&op=order_delete",Url];
        NSDictionary * prm=@{@"order_id":order_id,@"key":key};
        [self PostRequest:url andpram:prm];
    }
}

-(void)GetOrderDetialwithkey:(NSString *)key andorder_id:(NSString *)order_id
{
    if (key&&order_id) {
        NSString *url=[NSString stringWithFormat:@"%@index.php?act=seller_order&op=show_order",Url];
        NSDictionary * prm=@{@"order_id":order_id,@"key":key};
        [self GetRequest:url andpram:prm];
    }
}
-(void)GetGoodDetialWithkey:(NSString *)key andcommonid:(NSString *)commonid
{
    if (key&&commonid) {
        NSString *url=[NSString stringWithFormat:@"%@index.php?act=seller_goods&op=edit_goods",Url];
        NSDictionary * prm=@{@"commonid":commonid,@"key":key};
        [self GetRequest:url andpram:prm];
    }
}
-(void)GetGuiGeData:(NSString *)key andgc_id:(NSString *)gc_id
{
    if (key&&gc_id) {
        NSString *url=[NSString stringWithFormat:@"%@index.php?act=seller_goods_class&op=type_info",Url];
        NSDictionary * prm=@{@"gc_id":gc_id,@"key":key};
        [self PostRequest:url andpram:prm];
    }
}

-(void)UpLoadIDCardImg:(NSData *)imagedata andkey:(NSString *)key andname:(NSString *)name
{
    if (imagedata&&key) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=seller_identification&op=image_upload",Url];
        NSDictionary * prm=@{@"key":key,@"name":name};
        [self ShowOrderuploadImageWithImage:imagedata andurl:url andprm:prm andkey:key andname:name];
    }
}

-(void)RealNameSubmit:(id)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=seller_identification&op=save",Url];
        [self PostRequest:url andpram:prm];
    }
}
-(void)GetArrayListwithareaid:(NSString *)areaid
{
    if (areaid) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=area&op=area_list",Url];
        NSDictionary * prm=@{@"area_id":areaid};
        [self GetRequest:url andpram:prm];
    }
}
-(void)UpLoadStoreImg:(NSData *)imagedata andkey:(NSString *)key andname:(NSString *)name
{
    if (imagedata&&key) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=store_setting&op=upload_image",Url];
        NSDictionary * prm=@{@"key":key,@"name":name};
        [self ShowOrderuploadImageWithImage:imagedata andurl:url andprm:prm andkey:key andname:name];
    }
}
-(void)indexEditSave:(id)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=store_setting&op=save",Url];
        [self PostRequest:url andpram:prm];
    }
}

-(void)GetGuigeValueWtihkey:(NSString *)key andname:(NSString *)name andgc_id:(NSString *)gc_id andsp_id:(NSString *)sp_id
{
    if (name&&key&&gc_id&&sp_id) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=seller_goods&op=add_spec",Url];
        NSDictionary * prm=@{@"key":key,@"name":name,@"gc_id":gc_id,@"sp_id":sp_id};
        [self PostRequest:url andpram:prm];
    }
}




-(void)PostRequest:(NSString *)url andpram:(NSDictionary *)pram
{
    AFHTTPRequestOperationManager * manage=[[AFHTTPRequestOperationManager alloc] init];
    manage.responseSerializer=[AFHTTPResponseSerializer serializer];
    manage.requestSerializer=[AFHTTPRequestSerializer serializer];
    manage.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/html"];//可接收到的数据类型
    manage.requestSerializer.timeoutInterval=10;//设置请求时限
    NSDictionary * prm =[[NSDictionary alloc] init];
    if (pram!=nil) {
        prm=pram;
    }
    [manage POST:url parameters:prm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSDictionary * dict =responseObject;
        NSString *str=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData * data =[str dataUsingEncoding:NSUTF8StringEncoding];
        id dict =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        SEL func_selector = NSSelectorFromString(callBackFunctionName);
        if ([CallBackObject respondsToSelector:func_selector]) {
            NSLog(@"回调成功...");
            [CallBackObject performSelector:func_selector withObject:dict];
        }else{
            NSLog(@"回调失败...");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
        [SVProgressHUD dismiss];
    }];
}




-(void)GetRequest:(NSString *)url andpram:(NSDictionary *)pram
{
    AFHTTPRequestOperationManager * manage=[[AFHTTPRequestOperationManager alloc] init];
    manage.responseSerializer=[AFHTTPResponseSerializer serializer];
    manage.requestSerializer=[AFHTTPRequestSerializer serializer];
    manage.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/html"];//可接收到的数据类型
    manage.requestSerializer.timeoutInterval=10;//设置请求时限
    NSDictionary * prm =[[NSDictionary alloc] init];
    if (pram!=nil) {
        prm=pram;
    }
    [manage GET:url parameters:prm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData * data =[str dataUsingEncoding:NSUTF8StringEncoding];
        id dict =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        SEL func_selector = NSSelectorFromString(callBackFunctionName);
        if ([CallBackObject respondsToSelector:func_selector]) {
            NSLog(@"回调成功...");
            [CallBackObject performSelector:func_selector withObject:dict];
        }else{
            NSLog(@"回调失败...");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
}

- (void)uploadImageWithImage:(NSString *)imagePath andurl:(NSString *)url andprm:(NSDictionary *)prm andkey:(NSString *)key
{
    NSData *data=[NSData dataWithContentsOfFile:imagePath];
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:prm constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"avatar" fileName:@"avatar.jpg" mimeType:@"image/jpg"];
    }];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData * data =[str dataUsingEncoding:NSUTF8StringEncoding];
        id dict =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        SEL func_selector = NSSelectorFromString(callBackFunctionName);
        if ([CallBackObject respondsToSelector:func_selector]) {
            NSLog(@"回调成功...");
            [CallBackObject performSelector:func_selector withObject:dict];
        }else{
            NSLog(@"回调失败...");
        }
        NSLog(@"上传完成");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传失败->%@", error);
        [SVProgressHUD dismiss];
    }];
    
    //执行
    NSOperationQueue * queue =[[NSOperationQueue alloc] init];
    [queue addOperation:op];
//    FileDetail *file = [FileDetail fileWithName:@"avatar.jpg" data:data];
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
//                            file,@"FILES",
//                            @"avatar",@"name",
//                            key, @"key", nil];
//    NSDictionary *result = [HttpRequest upload:[NSString stringWithFormat:@"%@index.php?act=member_index&op=avatar_upload",Url] widthParams:params];
//    NSLog(@"%@",result);
}

- (void)ShowOrderuploadImageWithImage:(NSData *)imagedata andurl:(NSString *)url andprm:(NSDictionary *)prm andkey:(NSString *)key andname:(NSString *)name
{
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:prm constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imagedata name:name fileName:[NSString stringWithFormat:@"%@.jpg",name] mimeType:@"image/jpg"];
    }];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData * data =[str dataUsingEncoding:NSUTF8StringEncoding];
        id dict =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        SEL func_selector = NSSelectorFromString(callBackFunctionName);
        if ([CallBackObject respondsToSelector:func_selector]) {
            NSLog(@"回调成功...");
            [CallBackObject performSelector:func_selector withObject:dict];
        }else{
            NSLog(@"回调失败...");
        }
        NSLog(@"上传完成");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传失败->%@", error);
        [SVProgressHUD dismiss];
    }];
    
    //执行
    NSOperationQueue * queue =[[NSOperationQueue alloc] init];
    [queue addOperation:op];
    //    FileDetail *file = [FileDetail fileWithName:@"avatar.jpg" data:data];
    //    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
    //                            file,@"FILES",
    //                            @"avatar",@"name",
    //                            key, @"key", nil];
    //    NSDictionary *result = [HttpRequest upload:[NSString stringWithFormat:@"%@index.php?act=member_index&op=avatar_upload",Url] widthParams:params];
    //    NSLog(@"%@",result);
}



@end
