//
//  AddGoodsViewController.m
//  BuerShoppingforsell
//
//  Created by 于金祥 on 15/7/25.
//  Copyright (c) 2015年 zykj.BuerShoppingforsell. All rights reserved.
//

#import "AddGoodsViewController.h"
#import "AppDelegate.h"
#import "XCMultiSortTableView.h"
#import "ClassifyViewController.h"
#import "DataProvider.h"
#import "MLTableAlert.h"
#import "UIImageView+WebCache.h"

#import "JKImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoCell.h"

//#import "LMContainsLMComboxScrollView.h"
//#import "LMComBoxView.h"

@interface AddGoodsViewController ()<UITableViewDelegate,UITableViewDataSource,XCMultiTableViewDataSource,UITextFieldDelegate,UITextViewDelegate,JKImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate>

@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray   *assetsArray;


@property (strong, nonatomic) MLTableAlert *alert;
@end

@implementation AddGoodsViewController
{
    
    UIScrollView *scrollView;
    NSString * GoodName;
    NSString * GoodDetial;
    NSString * classifyTitle;
    NSString * classifyOne;
    NSString * classifyTwo;
    UIView * backView_bottom;
    NSMutableArray *headData;
    NSMutableArray *leftTableData;
    NSMutableArray *rightTableData;
    
    NSMutableArray *priceMutableArray;
    NSMutableArray *kucunMutableArray;
    NSMutableArray *specpriceMutableArray;
    
    
    NSDictionary * userinfoWithFile;
    XCMultiTableView *biaogetableView;
    
    NSArray * spec_list;
    NSString * type_id;
    
    NSString * guige1;
    NSString * guige2;
    NSString * guigename1;
    NSString * guigename2;
    NSString * guigetext1;
    NSString * guigetext2;
    NSArray * GuigeValueid1;
    NSArray * GuigeValueid2;
    NSArray * priceArray;
    NSArray * kuncunArray;
    NSArray * specPriceArray;
    
    NSString * g_price;
    NSString * goods_promotion_price;
    NSString * g_storage;
    NSString * images;
    int uplodaimage;
    NSMutableArray * img_array;
    NSMutableArray * request_spec;
    
    NSArray *array1;//分割字符串后
    NSArray *array2;
    
    NSMutableArray * sliderImg;//商品已存在的轮播图
    NSDictionary * ios_goods_spec_list;
    int sliderIndex;
    BOOL sliderUploadFinish;
    NSMutableArray * sliderSelectArray;
    NSDictionary * spec_value;
}
- (NSMutableArray *)assetsArray{
    if (!_assetsArray) {
        _assetsArray = [[NSMutableArray alloc] init];
    }
    return _assetsArray;
}

-(void)LoadAllData
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    userinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"RequestDataBackCall:"];
    [dataprovider GetGoodDetialWithkey:userinfoWithFile[@"key"] andcommonid:_commonid];
}
-(void)RequestDataBackCall:(id)dict
{
    NSLog(@"商品详情:%@",dict);
    if (!dict[@"datas"][@"error"]) {
        GoodName=dict[@"datas"][@"common_info"][@"goods_name"];
        GoodDetial=dict[@"datas"][@"common_info"][@"goods_jingle"];
        g_price=dict[@"datas"][@"common_info"][@"goods_price"];
        goods_promotion_price=dict[@"datas"][@"common_info"][@"goods_promotion_price"];
        g_storage=dict[@"datas"][@"common_info"][@"goods_storage"];
        sliderImg =[[NSMutableArray alloc] initWithArray:dict[@"datas"][@"common_info"][@"goods_image"]];
        ios_goods_spec_list=dict[@"datas"][@"ios_goods_spec_list"];
        spec_value=dict[@"datas"][@"common_info"][@"spec_value"];
        if (dict[@"datas"][@"common_info"][@"goods_storage"]) {
            NSArray * arraySpec=[[NSArray alloc] initWithArray:dict[@"datas"][@"common_info"][@"spec_name"]];
            if (arraySpec.count==1) {
                guige1=arraySpec[0][@"spec_id"];
                guigename1=arraySpec[0][@"spec_name"];
            }
            else if (arraySpec.count==2)
            {
                guige1=arraySpec[0][@"spec_id"];
                guigename1=arraySpec[0][@"spec_name"];
                guige2=arraySpec[1][@"spec_id"];
                guigename2=arraySpec[1][@"spec_name"];
            }
        }
        type_id=dict[@"datas"][@"type_id"];
        classifyTitle=[NSString stringWithFormat:@"%@/%@",dict[@"datas"][@"common_info"][@"gc_name_1"],dict[@"datas"][@"common_info"][@"gc_name_2"]];
        classifyOne=[NSString stringWithFormat:@"%@",dict[@"datas"][@"common_info"][@"gc_id_1"]];
        classifyTwo=[NSString stringWithFormat:@"%@",dict[@"datas"][@"common_info"][@"gc_id_2"]];
        [_myTableview reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        
        [_myTableview reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
        [self buildheaderview];
        [self BuildExcelData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"商品详情编辑";
    _lblTitle.textColor=[UIColor whiteColor];
    g_price=@"0.00";
    goods_promotion_price=@"0.00";
    g_storage=@"0.00";
    [self addLeftbuttontitle:@"取消"];
    [self addRightbuttontitle:@"保存"];
    [self LoadAllData];
    [self initData];
    uplodaimage=0;
    sliderUploadFinish=NO;
    sliderImg=[[NSMutableArray alloc] init];
    spec_value=[[NSDictionary alloc] init];
    sliderSelectArray=[[NSMutableArray alloc] init];
    ios_goods_spec_list=[[NSDictionary alloc] init];
    img_array=[[NSMutableArray alloc] init];
    request_spec=[[NSMutableArray alloc] init];
    _myTableview.delegate=self;
    _myTableview.dataSource=self;
    _myTableview.tag=1;
    spec_list=[[NSArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshTable:) name:@"select_classify_finish" object:nil];
    if (!_commonid) {
        [self buildheaderview];
    }
    
}

- (void)initData {
    @try {
        headData = [NSMutableArray arrayWithCapacity:10];
        [headData addObject:guigename1?guigename1:@"规格1"];
        [headData addObject:guigename2?guigename2:@"规格2"];
        [headData addObject:@"价格"];
        [headData addObject:@"库存"];
        [headData addObject:@"天天特价价格(选填)"];
        array1=[[NSArray alloc] init];
        array2=[[NSArray alloc] init];
        int rowsNumber=1;
        if (guigetext1.length>0) {
            NSRange range=[guigetext1 rangeOfString:@","];
            if (range.length>0) {
                array1= [guigetext1 componentsSeparatedByString:@","];
            }
            else
            {
                array1= [guigetext1 componentsSeparatedByString:@"，"];
            }
            
            if (guigetext2.length>0) {
                NSRange range1=[guigetext1 rangeOfString:@","];
                if (range1.length>0) {
                    array2= [guigetext2 componentsSeparatedByString:@","];
                }
                else
                {
                    array2= [guigetext2 componentsSeparatedByString:@"，"];
                }
                rowsNumber=(int)array1.count*(int)array2.count;
            }
            else
            {
                rowsNumber=(int)array1.count;
            }
        }
        
        
        priceMutableArray = [NSMutableArray arrayWithCapacity:rowsNumber];
        
        kucunMutableArray = [NSMutableArray arrayWithCapacity:rowsNumber];
        specpriceMutableArray = [NSMutableArray arrayWithCapacity:rowsNumber];
        for (int i=0; i<rowsNumber; i++) {
            [priceMutableArray setObject:[NSString stringWithFormat:@"0"] atIndexedSubscript:i];
            [kucunMutableArray setObject:[NSString stringWithFormat:@"0"] atIndexedSubscript:i];
            [specpriceMutableArray setObject:[NSString stringWithFormat:@"0"] atIndexedSubscript:i];
        }
        leftTableData = [NSMutableArray arrayWithCapacity:10];
        NSMutableArray *one = [NSMutableArray arrayWithCapacity:10];
        for (int i = 0; i < rowsNumber; i++) {
            [one addObject:[NSString stringWithFormat:@"ki-%d", i]];
        }
        [leftTableData addObject:one];
        
        rightTableData = [NSMutableArray arrayWithCapacity:10];
        NSMutableArray *oneR = [NSMutableArray arrayWithCapacity:10];
        for (int i = 0; i < rowsNumber; i++) {
            NSMutableArray *ary = [NSMutableArray arrayWithCapacity:10];
            for (int j = 0; j < 5; j++) {
                if (j == 0) {
                    [ary addObject:[NSString stringWithFormat:@"%@",array1.count>0?array1[i/(array1.count)]:@"无"]];
                }else if (j == 1) {
                    [ary addObject:[NSString stringWithFormat:@"%@",array2.count>0?array2[i%(array2.count)]:@"无"]];
                }
                else if (j == 2) {
                    [ary addObject:g_price];
                }
                else if (j == 3) {
                    [ary addObject:g_storage];
                }
                else {
                    [ary addObject:goods_promotion_price];
                }
                
            }
            [oneR addObject:ary];
            if (GuigeValueid1) {
                if (GuigeValueid2) {
                    NSDictionary * item=@{GuigeValueid1[i/(array1.count)]:array1[i/(array1.count)],GuigeValueid2[i%(array2.count)]:array2[i%(array2.count)]};
                    NSDictionary * requsetitem=@{@"sp_value":item,@"zuhe_id":[NSString stringWithFormat:@"i_%@%@",GuigeValueid1[i/(array1.count)],GuigeValueid2[i%(array2.count)]]};
                    [request_spec addObject:requsetitem];
                }
                else
                {
                    NSDictionary * item=@{GuigeValueid1[i/(array1.count)]:array1[i/(array1.count)]};
                    NSDictionary * requsetitem=@{@"sp_value":item,@"zuhe_id":[NSString stringWithFormat:@"i_%@",GuigeValueid1[i/(array1.count)]]};
                    [request_spec addObject:requsetitem];
                }
            }
        }
        [rightTableData addObject:oneR];
    }
    @catch (NSException *exception) {
        NSLog(@"建立表格时出错");
        NSLog(@"%@",exception);
    }
    @finally {
        
    }
    
}


-(void)BuildExcelData
{
    @try {
        headData = [NSMutableArray arrayWithCapacity:10];
        [headData addObject:guigename1?guigename1:@"规格1"];
        [headData addObject:guigename2?guigename2:@"规格2"];
        [headData addObject:@"价格"];
        [headData addObject:@"库存"];
        [headData addObject:@"天天特价价格(选填)"];
        
        int rowsNumber=1;
        if (spec_value.count>0) {
            if (spec_value.count==1) {
                NSArray * itemarray=[[NSArray alloc] initWithArray:spec_value[guige1]];
                NSMutableArray * idarray=[[NSMutableArray alloc] init];
                NSMutableArray * namearray=[[NSMutableArray alloc] init];
                for (int i=0; i<itemarray.count; i++) {
                    [idarray addObject:itemarray[i][@"spec_value_id"]] ;
                    [namearray addObject:itemarray[i][@"spec_value_name"]];
                    if (i==0) {
                        guigetext1=[NSString stringWithFormat:@"%@",itemarray[i][@"spec_value_name"]];
                    }
                    else
                    {
                        guigetext1=[NSString stringWithFormat:@"%@,%@",guigetext1,itemarray[i][@"spec_value_name"]];
                    }
                }
                GuigeValueid1=[[NSArray alloc] initWithArray:idarray];
                array1=[[NSArray alloc] initWithArray:namearray];
                rowsNumber=(int)GuigeValueid1.count;
            }
            else
            {
                NSArray * itemarray=[[NSArray alloc] initWithArray:spec_value[[NSString stringWithFormat:@"%@",guige1]]];
                NSMutableArray * idarray=[[NSMutableArray alloc] init];
                NSMutableArray * namearray=[[NSMutableArray alloc] init];
                for (int i=0; i<itemarray.count; i++) {
                    [idarray addObject:itemarray[i][@"spec_value_id"]] ;
                    [namearray addObject:itemarray[i][@"spec_value_name"]];
                    if (i==0) {
                        guigetext1=[NSString stringWithFormat:@"%@",itemarray[i][@"spec_value_name"]];
                    }
                    else
                    {
                        guigetext1=[NSString stringWithFormat:@"%@,%@",guigetext1,itemarray[i][@"spec_value_name"]];
                    }
                }
                GuigeValueid1=[[NSArray alloc] initWithArray:idarray];
                array1=[[NSArray alloc] initWithArray:namearray];
                
                
                NSArray * itemarray1=[[NSArray alloc] initWithArray:spec_value[[NSString stringWithFormat:@"%@",guige2]]];
                NSMutableArray * idarray1=[[NSMutableArray alloc] init];
                NSMutableArray * namearray1=[[NSMutableArray alloc] init];
                for (int i=0; i<itemarray1.count; i++) {
                    [idarray1 addObject:itemarray1[i][@"spec_value_id"]] ;
                    [namearray1 addObject:itemarray1[i][@"spec_value_name"]];
                    if (i==0) {
                        guigetext2=[NSString stringWithFormat:@"%@",itemarray1[i][@"spec_value_name"]];
                    }
                    else
                    {
                        guigetext2=[NSString stringWithFormat:@"%@,%@",guigetext2,itemarray1[i][@"spec_value_name"]];
                    }
                    
                }
                GuigeValueid2=[[NSArray alloc] initWithArray:idarray1];
                array2=[[NSArray alloc] initWithArray:namearray1];
                rowsNumber=(int)GuigeValueid1.count*(int)GuigeValueid2.count;
            }
            [_myTableview reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
            
        }
        
        
        
        
        
//        if (guigetext1.length>0) {
//            NSRange range=[guigetext1 rangeOfString:@","];
//            if (range.length>0) {
//                array1= [guigetext1 componentsSeparatedByString:@","];
//            }
//            else
//            {
//                array1= [guigetext1 componentsSeparatedByString:@"，"];
//            }
//            
//            if (guigetext2.length>0) {
//                NSRange range1=[guigetext1 rangeOfString:@","];
//                if (range1.length>0) {
//                    array2= [guigetext2 componentsSeparatedByString:@","];
//                }
//                else
//                {
//                    array2= [guigetext2 componentsSeparatedByString:@"，"];
//                }
//                rowsNumber=(int)array1.count*(int)array2.count;
//            }
//            else
//            {
//                rowsNumber=(int)array1.count;
//            }
//        }
        
        int indexnum=0;
        priceMutableArray = [NSMutableArray arrayWithCapacity:rowsNumber];
        
        kucunMutableArray = [NSMutableArray arrayWithCapacity:rowsNumber];
        specpriceMutableArray = [NSMutableArray arrayWithCapacity:rowsNumber];
        if (GuigeValueid2.count>0) {
            for (int i=0; i<GuigeValueid1.count; i++) {
                for (int j=0; j<GuigeValueid2.count; j++) {
                    [priceMutableArray setObject:[NSString stringWithFormat:@"%@",ios_goods_spec_list[[NSString stringWithFormat:@"%@|%@",GuigeValueid1[i],GuigeValueid2[j]]][@"price"]] atIndexedSubscript:indexnum];
                    [kucunMutableArray setObject:[NSString stringWithFormat:@"%@",ios_goods_spec_list[[NSString stringWithFormat:@"%@|%@",GuigeValueid1[i],GuigeValueid2[j]]][@"storage"]] atIndexedSubscript:indexnum];
                    [specpriceMutableArray setObject:[NSString stringWithFormat:@"%@",ios_goods_spec_list[[NSString stringWithFormat:@"%@|%@",GuigeValueid1[i],GuigeValueid2[j]]][@"goods_promotion_price"]] atIndexedSubscript:indexnum];
                    ++indexnum;
                }
                
            }
        }
        else
        {
            if (GuigeValueid1.count>0) {
                for (int i=0; i<GuigeValueid1.count; i++) {
                    [priceMutableArray setObject:[NSString stringWithFormat:@"%@",ios_goods_spec_list[[NSString stringWithFormat:@"%@",GuigeValueid1[i]]][@"price"]] atIndexedSubscript:indexnum];
                    [kucunMutableArray setObject:[NSString stringWithFormat:@"%@",ios_goods_spec_list[[NSString stringWithFormat:@"%@",GuigeValueid1[i]]][@"storage"]] atIndexedSubscript:indexnum];
                    [specpriceMutableArray setObject:[NSString stringWithFormat:@"%@",ios_goods_spec_list[[NSString stringWithFormat:@"%@",GuigeValueid1[i]]][@"goods_promotion_price"]] atIndexedSubscript:indexnum];
                    ++indexnum;
                }
            }
        }
        
        leftTableData = [NSMutableArray arrayWithCapacity:10];
        NSMutableArray *one = [NSMutableArray arrayWithCapacity:10];
        for (int i = 0; i < rowsNumber; i++) {
            [one addObject:[NSString stringWithFormat:@"ki-%d", i]];
        }
        [leftTableData addObject:one];
        
        rightTableData = [NSMutableArray arrayWithCapacity:10];
        NSMutableArray *oneR = [NSMutableArray arrayWithCapacity:10];
        for (int i = 0; i < rowsNumber; i++) {
            NSMutableArray *ary = [NSMutableArray arrayWithCapacity:10];
            for (int j = 0; j < 5; j++) {
                if (j == 0) {
                    [ary addObject:[NSString stringWithFormat:@"%@",array1.count>0?array1[i/(array1.count)]:@"无"]];
                }else if (j == 1) {
                    [ary addObject:[NSString stringWithFormat:@"%@",array2.count>0?array2[i%(array2.count)]:@"无"]];
                }
                else if (j == 2) {
                    [ary addObject:priceMutableArray[i]];
                }
                else if (j == 3) {
                    [ary addObject:kucunMutableArray[i]];
                }
                else {
                    [ary addObject:specpriceMutableArray[i]];
                }
                
            }
            [oneR addObject:ary];
            if (GuigeValueid1) {
                if (GuigeValueid2) {
                    NSDictionary * item=@{GuigeValueid1[i/(array1.count)]:array1[i/(array1.count)],GuigeValueid2[i%(array2.count)]:array2[i%(array2.count)]};
                    NSDictionary * requsetitem=@{@"sp_value":item,@"zuhe_id":[NSString stringWithFormat:@"i_%@%@",GuigeValueid1[i/(array1.count)],GuigeValueid2[i%(array2.count)]]};
                    [request_spec addObject:requsetitem];
                }
                else
                {
                    NSDictionary * item=@{GuigeValueid1[i/(array1.count)]:array1[i/(array1.count)]};
                    NSDictionary * requsetitem=@{@"sp_value":item,@"zuhe_id":[NSString stringWithFormat:@"i_%@",GuigeValueid1[i/(array1.count)]]};
                    [request_spec addObject:requsetitem];
                }
            }
        }
        [rightTableData addObject:oneR];
    }
    @catch (NSException *exception) {
        NSLog(@"建立表格时出错");
        NSLog(@"%@",exception);
        [self initData];
    }
    @finally {
        
    }
}
-(void)buildheaderview
{
    // 这个属性不能少
    backView_bottom=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    lbl_title.text=@"商品图片";
    [backView_bottom addSubview:lbl_title];
    self.automaticallyAdjustsScrollViewInsets = NO;
    scrollView = [[UIScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.frame = CGRectMake(95, lbl_title.frame.size.height+lbl_title.frame.origin.y+5, SCREEN_WIDTH-9,65);
    
    if (sliderImg.count>0) {
        UIView * lastview=[scrollView.subviews lastObject];
        for (int i=0; i<sliderImg.count; i++) {
            lastview=[scrollView.subviews lastObject];
            UIButton * btn_itembtn=[[UIButton alloc] initWithFrame:CGRectMake(lastview.frame.origin.x+lastview.frame.size.width+5, 0, 65, 65)];
            btn_itembtn.layer.masksToBounds=YES;
            btn_itembtn.layer.cornerRadius=5;
            [btn_itembtn addTarget:self action:@selector(ShowUIAlertViewFordel:) forControlEvents:UIControlEventTouchUpInside];
            UIImageView * item_img=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
            item_img.tag=1;
            [item_img sd_setImageWithURL:[NSURL URLWithString:sliderImg[i]] placeholderImage:[UIImage imageNamed:@""]];
            [btn_itembtn addSubview:item_img];
//            [btn_itembtn.imageView sd_setImageWithURL:[NSURL URLWithString:sliderImg[i]] placeholderImage:[UIImage imageNamed:@""]];
            [scrollView addSubview:btn_itembtn];
        }
        lastview=[scrollView.subviews lastObject];
        scrollView.contentSize=CGSizeMake(lastview.frame.size.width+lastview.frame.origin.x+30, 0);
    }
    [backView_bottom addSubview:scrollView];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
    
    UIImage  *img = [UIImage imageNamed:@"Add_img_icon"];
    UIButton   *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, lbl_title.frame.size.height+lbl_title.frame.origin.y+5, 65,65);
    [button setBackgroundImage:img forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"Add_img_icon"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(composePicAdd) forControlEvents:UIControlEventTouchUpInside];
    [backView_bottom addSubview:button];
    [backView_bottom addSubview:_collectionView];
    _myTableview.tableHeaderView=backView_bottom;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        ClassifyViewController * classify=[[ClassifyViewController alloc] initWithNibName:@"ClassifyViewController" bundle:[NSBundle mainBundle]];
        classify.key=userinfoWithFile[@"key"];
        [self.navigationController pushViewController:classify animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height=50;
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            height= 50;
        }
        else
        {
            height=110;
        }
    }
    if (indexPath.section==4) {
        height=400;
    }
    return height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(10,15, 80, 20)];
            lbl_title.text=@"产品名称";
            [cell addSubview:lbl_title];
            CGFloat x=lbl_title.frame.size.width+lbl_title.frame.origin.x+10;
            UITextField * txt_name=[[UITextField alloc] initWithFrame:CGRectMake(x, 10, cell.frame.size.width-x-10, 30)];
            txt_name.textAlignment=NSTextAlignmentRight;
            txt_name.tag=1000;
            txt_name.delegate=self;
            if (GoodName) {
                txt_name.text=GoodName;
            }
            else
            {
                txt_name.placeholder=@"请输入产品名称";
            }
            [cell addSubview:txt_name];
        }else
        {
            UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(10,15, 80, 20)];
            lbl_title.text=@"产品简介";
            [cell addSubview:lbl_title];
            CGFloat x=lbl_title.frame.size.width+lbl_title.frame.origin.x+10;
            UITextView * txtview_detial=[[UITextView alloc] initWithFrame:CGRectMake(x, 15, SCREEN_WIDTH-x-10, 80)];
            txtview_detial.scrollEnabled=YES;
            txtview_detial.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            if (![GoodDetial isKindOfClass:[NSNull class]]) {
                txtview_detial.text=GoodDetial;
            }
            txtview_detial.delegate=self;
            [cell addSubview:txtview_detial];
        }
    }
    if (indexPath.section==1) {
        UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(10,15, 200, 20)];
        lbl_title.text=classifyTitle?classifyTitle:@"一级分类/二级分类";
        [cell addSubview:lbl_title];
        UIImageView * img_go=[[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width-20, 17.5, 8, 15)];
        img_go.image=[UIImage imageNamed:@"index_go"];
        [cell addSubview:img_go];
    }
    if (indexPath.section==2) {
        if (indexPath.row==0) {
            UIButton * btn_guige1=[[UIButton alloc] initWithFrame:CGRectMake(10,10, 60, 30)];
            [btn_guige1 setTitle:guigename1?guigename1:@"规格1" forState:UIControlStateNormal];
            [btn_guige1 addTarget:self action:@selector(btn_selectGuige:) forControlEvents:UIControlEventTouchUpInside];
            [btn_guige1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn_guige1.tag=1;
            [cell addSubview:btn_guige1];
            CGFloat x=btn_guige1.frame.size.width+btn_guige1.frame.origin.x+10;
            UITextField * txt_name=[[UITextField alloc] initWithFrame:CGRectMake(x, 10, cell.frame.size.width-x-10, 30)];
//            txt_name.textAlignment=NSTextAlignmentRight;
            if (guigetext1) {
                txt_name.text=guigetext1;
            }
            else
            {
                txt_name.placeholder=@"格式如下：红色，粉色";
            }
            txt_name.tag=1001;
            txt_name.delegate=self;
            [cell addSubview:txt_name];
        }else
        {
            UIButton * btn_guige1=[[UIButton alloc] initWithFrame:CGRectMake(10,10, 60, 30)];
            [btn_guige1 setTitle:guigename2?guigename2:@"规格2" forState:UIControlStateNormal];
            [btn_guige1 addTarget:self action:@selector(btn_selectGuige:) forControlEvents:UIControlEventTouchUpInside];
            [btn_guige1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn_guige1.tag=2;
            [cell addSubview:btn_guige1];
            CGFloat x=btn_guige1.frame.size.width+btn_guige1.frame.origin.x+10;
            UITextField * txt_name=[[UITextField alloc] initWithFrame:CGRectMake(x, 10, cell.frame.size.width-x-10, 30)];
//            txt_name.textAlignment=NSTextAlignmentRight;
            if (guigetext2) {
                txt_name.text=guigetext2;
            }
            else
            {
                txt_name.placeholder=@"格式如下：XL，2XL，M";
            }
            txt_name.delegate=self;
            txt_name.tag=1002;
            [cell addSubview:txt_name];
        }
    }
    if (indexPath.section==3) {
        UIButton * btn_BuildExcel=[[UIButton alloc] initWithFrame:CGRectMake(10, 5, cell.frame.size.width-20, 40)];
        [btn_BuildExcel setTitle:@"生成表格" forState:UIControlStateNormal];
        [btn_BuildExcel setTitleColor:[UIColor colorWithRed:155/255.0 green:73/255.0 blue:139/255.0 alpha:1.0] forState:UIControlStateNormal];
        btn_BuildExcel.layer.cornerRadius=5;
        btn_BuildExcel.layer.borderWidth=1;
        btn_BuildExcel.layer.borderColor=[[UIColor colorWithRed:155/255.0 green:73/255.0 blue:139/255.0 alpha:1.0] CGColor];
        [btn_BuildExcel addTarget:self action:@selector(btn_buildExcelClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn_BuildExcel];
    }
    if (indexPath.section==4) {
        biaogetableView = [[XCMultiTableView alloc] initWithFrame:CGRectInset(cell.bounds, 5.0f, 5.0f)];
        biaogetableView.leftHeaderEnable = NO;
        biaogetableView.datasource = self;
        biaogetableView.tag=2;
        [cell addSubview:biaogetableView];
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }
    if (section==2) {
        return 2;
    }
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag==1) {
        return 5;
    }
    else
    {
        return leftTableData.count;
    }
}


#pragma mark - XCMultiTableViewDataSource


- (NSArray *)arrayDataForTopHeaderInTableView:(XCMultiTableView *)tableView {
    return [headData copy];
}
- (NSArray *)arrayDataForLeftHeaderInTableView:(XCMultiTableView *)tableView InSection:(NSUInteger)section {
    return [leftTableData objectAtIndex:section];
}

- (NSArray *)arrayDataForContentInTableView:(XCMultiTableView *)tableView InSection:(NSUInteger)section {
    return [rightTableData objectAtIndex:section];
}


- (CGFloat)tableView:(XCMultiTableView *)tableView contentTableCellWidth:(NSUInteger)column {
    if (column == 0) {
        return 320/4;
    }
    return 80;
}

- (CGFloat)tableView:(XCMultiTableView *)tableView cellHeightInRow:(NSUInteger)row InSection:(NSUInteger)section {
    if (section == 0) {
        return 60.0f;
    }else {
        return 30.0f;
    }
}

- (UIColor *)tableView:(XCMultiTableView *)tableView bgColorInSection:(NSUInteger)section InRow:(NSUInteger)row InColumn:(NSUInteger)column {
//    if (row == 1 && section == 0) {
//        return [UIColor redColor];
//    }
    return [UIColor clearColor];
}

- (UIColor *)tableView:(XCMultiTableView *)tableView headerBgColorInColumn:(NSUInteger)column {
//    if (column == -1) {
//        return [UIColor redColor];
//    }else if (column == 1) {
//        return [UIColor grayColor];
//    }
    return [UIColor clearColor];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    GoodDetial=textView.text;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag<1000) {
        int chu=(int)textField.tag/10;
        
        int yu=(int)textField.tag%10;
        switch (yu) {
            case 2:
                
                [priceMutableArray setObject:textField.text atIndexedSubscript:chu];
                g_price=textField.text;
                break;
            case 3:
                [kucunMutableArray setObject:textField.text atIndexedSubscript:chu];
                g_storage=textField.text;
                break;
            case 4:
                [specpriceMutableArray setObject:textField.text atIndexedSubscript:chu];
                goods_promotion_price=textField.text;
                break;
            default:
                break;
        }
    }
    else
    {
        if (textField.tag==1001) {
            guigetext1=textField.text;
        }
        if (textField.tag==1002) {
            guigetext2=textField.text;
        }
        if (textField.tag==1000) {
            GoodName=textField.text;
        }
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag>=1000) {
        if (textField.tag==1001) {
            guigetext1=textField.text;
            return YES;
        }
        if (textField.tag==1002) {
            guigetext2=textField.text;
            return YES;
        }
        if (textField.tag==1000) {
            GoodName=textField.text;
            return YES;
        }
    }
    
    NSLog(@"%@",string);
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"表格tag%ld",(long)textField.tag);
    [textField resignFirstResponder];
    return YES;
}
- (void)RefreshTable:(NSNotification *)notification {
    NSArray *array = notification.object;
    classifyTitle=[NSString stringWithFormat:@"%@/%@",array[0][@"gc_name"],array[1][@"gc_name"]];
    classifyOne=array[0][@"gc_id"];
    classifyTwo=array[1][@"gc_id"];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetGuigeBackCall:"];
    [dataprovider GetGuiGeData:userinfoWithFile[@"key"] andgc_id:array[1][@"gc_id"]];
}
-(void)GetGuigeBackCall:(id)dict
{
    NSLog(@"获取规格%@",dict);
    if (!dict[@"datas"][@"error"]) {
        type_id=dict[@"datas"][@"type_id"];
        spec_list=[[NSArray alloc] initWithArray:dict[@"datas"][@"spec_list"]];
        [_myTableview reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    }
}

/**
 *  规格选择
 *
 *  @param sender <#sender description#>
 */
-(void)btn_selectGuige:(UIButton *)sender
{
    if (spec_list.count>0) {
        // create the alert
        self.alert = [MLTableAlert tableAlertWithTitle:@"选择规格" cancelButtonTitle:@"取消" numberOfRows:^NSInteger (NSInteger section)
                      {
                          return spec_list.count;
                      }
                                              andCells:^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath)
                      {
                          static NSString *CellIdentifier = @"CellIdentifier";
                          UITableViewCell *cell = [anAlert.table dequeueReusableCellWithIdentifier:CellIdentifier];
                          if (cell == nil)
                              cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                          
                          cell.textLabel.text = [NSString stringWithFormat:@"%@", spec_list[indexPath.row][@"sp_name"]];
                          
                          return cell;
                      }];
        
        // Setting custom alert height
        self.alert.height = 350;
        
        // configure actions to perform
        [self.alert configureSelectionBlock:^(NSIndexPath *selectedIndex){
            if (sender.tag==1) {
                guige1=spec_list[selectedIndex.row][@"sp_id"];
                guigename1=spec_list[selectedIndex.row][@"sp_name"];
            }
            else
            {
                guige2=spec_list[selectedIndex.row][@"sp_id"];
                guigename2=spec_list[selectedIndex.row][@"sp_name"];
            }
            [sender setTitle:[NSString stringWithFormat:@"%@",spec_list[selectedIndex.row][@"sp_name"]] forState:UIControlStateNormal];
        } andCompletionBlock:^{
            //        [sender setTitle:@"规格" forState:UIControlStateNormal];
        }];
        
        // show the alert
        [self.alert show];
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请先选择分类" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
    
    
}

-(void)btn_buildExcelClick:(UIButton *)sender
{
    if (guige1) {
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"GetGuigeWalueBackCall:"];
        guigetext1=[guigetext1 stringByReplacingOccurrencesOfString:@"，" withString:@","];
        [dataprovider GetGuigeValueWtihkey:userinfoWithFile[@"key"] andname:guigetext1 andgc_id:classifyTwo andsp_id:guige1];
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择规格" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
}
-(void)GetGuigeWalueBackCall:(id)dict
{
    NSLog(@"dict,%@",dict);
    if (!dict[@"datas"][@"error"]) {
        GuigeValueid1=[[NSArray alloc] initWithArray:dict[@"datas"][@"value_id"]];
        if (guige2) {
            DataProvider * dataprovider=[[DataProvider alloc] init];
            [dataprovider setDelegateObject:self setBackFunctionName:@"GetGuiGe2BackCall:"];
            guigetext2=[guigetext2 stringByReplacingOccurrencesOfString:@"，" withString:@","];
            [dataprovider GetGuigeValueWtihkey:userinfoWithFile[@"key"] andname:guigetext2 andgc_id:classifyTwo andsp_id:guige2];
        }
        else
        {
            [self initData];
            [_myTableview reloadSections:[NSIndexSet indexSetWithIndex:4] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}
-(void)GetGuiGe2BackCall:(id)dict
{
    NSLog(@"%@",dict);
    if (!dict[@"datas"][@"error"]) {
        GuigeValueid2=[[NSArray alloc] initWithArray:dict[@"datas"][@"value_id"]];
        [self initData];
        [_myTableview reloadSections:[NSIndexSet indexSetWithIndex:4] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)clickRightButton:(UIButton *)sender
{
    [self BuildSliderData];
}
-(void)BuildDataAndRequest
{
    
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"UploadeImgBackCall:"];
    [dataprovider UpLoadGoodImg:sliderSelectArray[uplodaimage] andkey:userinfoWithFile[@"key"] andname:@"good_img"];
    
}

-(void)UploadeImgBackCall:(id)dict
{
    
    NSLog(@"%@",dict);
    if (!dict[@"datas"][@"error"]) {
        [img_array addObject:dict[@"datas"][@"image_name"]];
        if (uplodaimage<sliderSelectArray.count-1) {
            ++uplodaimage;
            [self BuildDataAndRequest];
        }
        else
        {
            [SVProgressHUD dismiss];
            
            for (int i=0; i<img_array.count; i++) {
                if (i==0) {
                    images=[NSString stringWithFormat:@"%@",img_array[i]];
                }
                else
                {
                    images=[images stringByAppendingString:[NSString stringWithFormat:@",%@",img_array[i]]];
                }
            }
            DataProvider * dataprovider=[[DataProvider alloc] init];
            [dataprovider setDelegateObject:self setBackFunctionName:@"SaveGoodInfoBackCall:"];
            if (_isEdit) {
                [dataprovider SaveEditGoodInfo:[self GetAllPageData]];
            }
            else
            {
                [dataprovider SaveGoodInfo:[self GetAllPageData]];
            }
            
        }
    }
}
-(NSMutableDictionary *)GetAllPageData
{
    NSMutableDictionary * requestPrm=[[NSMutableDictionary alloc] init];
    if ((!guige1)&&(!guige2)) {
        //没有规格
        [requestPrm setObject:userinfoWithFile[@"key"] forKey:@"key"];
        [requestPrm setObject:classifyTwo forKey:@"cate_id"];
        [requestPrm setObject:classifyTitle forKey:@"cate_name"];
        [requestPrm setObject:GoodName forKey:@"g_name"];
        [requestPrm setObject:type_id forKey:@"type_id"];
        [requestPrm setObject:g_price forKey:@"g_price"];
        [requestPrm setObject:goods_promotion_price forKey:@"goods_promotion_price"];
        [requestPrm setObject:g_storage forKey:@"g_storage"];
        [requestPrm setObject:GoodDetial forKey:@"goods_jingle"];
        [requestPrm setObject:images forKey:@"image_all"];
        [requestPrm setValue:img_array[0] forKey:@"image_path"];
        if (_commonid) {
            [requestPrm setValue:_commonid forKey:@"goods_commonid"];
        }
    }
    else
    {
        [requestPrm setObject:userinfoWithFile[@"key"] forKey:@"key"];
        [requestPrm setObject:classifyTwo forKey:@"cate_id"];
        [requestPrm setObject:classifyTitle forKey:@"cate_name"];
        [requestPrm setObject:GoodName forKey:@"g_name"];
        [requestPrm setObject:type_id forKey:@"type_id"];
        [requestPrm setObject:GoodDetial forKey:@"goods_jingle"];
        [requestPrm setObject:images forKey:@"image_all"];
        [requestPrm setObject:img_array[0] forKey:@"image_path"];
        [requestPrm setObject:[self buileExcleData] forKey:@"spec"];
        
        [requestPrm setObject:g_price forKey:@"g_price"];
        [requestPrm setObject:goods_promotion_price forKey:@"goods_promotion_price"];
        [requestPrm setObject:g_storage forKey:@"g_storage"];
        [requestPrm setObject:GoodDetial forKey:@"goods_jingle"];
        if (_commonid) {
            [requestPrm setValue:_commonid forKey:@"goods_commonid"];
        }
        if (guige2) {
            NSMutableDictionary * sp_name=[[NSMutableDictionary alloc] init];
            [sp_name setObject:guigename1 forKeyedSubscript:guige1];
            [sp_name setObject:guigename2 forKeyedSubscript:guige2];
            [requestPrm setObject:sp_name forKey:@"sp_name"];
        }
        else
        {
            NSMutableDictionary * sp_name=[[NSMutableDictionary alloc] init];
            [sp_name setObject:guigename1 forKeyedSubscript:guige1];
            [requestPrm setObject:sp_name forKey:@"sp_name"];
        }
        [requestPrm setObject:[self buildsp_value] forKeyedSubscript:@"sp_value"];
    }
    return requestPrm;
}
-(NSMutableDictionary *)buildsp_value
{
    
    NSMutableDictionary * sp_value=[[NSMutableDictionary alloc] init];
    for (int i=0; i<array1.count; i++) {
        NSDictionary * itemdict=@{GuigeValueid1[i]:array1[i]};
        [sp_value setObject:itemdict forKeyedSubscript:guige1];
    }
    if (guige2) {
        for (int i=0; i<array2.count; i++) {
            NSDictionary * itemdict=@{GuigeValueid2[i]:array2[i]};
            [sp_value setObject:itemdict forKeyedSubscript:guige2];
        }
    }
    return sp_value;
}
-(NSMutableDictionary *)buileExcleData
{
    NSMutableDictionary * spec=[[NSMutableDictionary alloc] init];
    @try {
        NSArray * price1=[[NSArray alloc] initWithArray:priceMutableArray];
        NSArray * specprice1=[[NSArray alloc] initWithArray:specpriceMutableArray];
        NSArray * kucun1=[[NSArray alloc] initWithArray:kucunMutableArray];
        NSArray * requestspec=[[NSArray alloc] initWithArray:request_spec];
        for (int i=0; i<price1.count; i++) {
            
            NSDictionary * itemdict=@{@"price":price1[i],@"goods_promotion_price":specprice1[i],@"stock":kucun1[i],@"sp_value":request_spec[i][@"sp_value"]};
            [spec setObject:itemdict forKey:requestspec[i][@"zuhe_id"]];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
        NSLog(@"建立表格请求数据时出错");
    }
    @finally {
        return spec;
    }
    
}
-(void)SaveGoodInfoBackCall:(id)dict
{
    NSLog(@"保存返回:%@",dict);
    if (dict[@"datas"][@"common_id"]) {
        [SVProgressHUD showSuccessWithStatus:@"发布成功" maskType:SVProgressHUDMaskTypeBlack];
        
    }
}

#pragma mark 新浪图片多选


- (void)composePicAdd
{
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 9;
    imagePickerController.selectedAssetArray = self.assetsArray;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
    self.assetsArray = [NSMutableArray arrayWithArray:assets];
    
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        [self.collectionView reloadData];
    }];
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

static NSString *kPhotoCellIdentifier = @"kPhotoCellIdentifier";

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.assetsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = (PhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellIdentifier forIndexPath:indexPath];
    
    cell.asset = [self.assetsArray objectAtIndex:[indexPath row]];
    
    return cell;
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 80);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)[indexPath row]);
    
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5.0;
        layout.minimumInteritemSpacing = 5.0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 105, SCREEN_WIDTH-20, 80) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:kPhotoCellIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        [backView_bottom addSubview:_collectionView];
        
    }
    return _collectionView;
}

-(void)ShowUIAlertViewFordel:(UIButton *)sender
{
    sliderIndex=(int)sender.tag;
    UIAlertView * alert1=[[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    [alert1 show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        if (sliderImg.count>sliderIndex) {
            [sliderImg removeObjectAtIndex:sliderIndex];
            [self buildheaderview];
        }
    }
}


-(void)BuildSliderData
{
    [SVProgressHUD showWithStatus:@"正在保存数据" maskType:SVProgressHUDMaskTypeBlack];
    @try {
        NSArray * array=[[NSArray alloc] initWithArray:scrollView.subviews];
        for (int i=0; i<array.count; i++) {
            if ([array[i] isKindOfClass:[UIButton class]]) {
                UIButton * btn_item=(UIButton *)array[i];
                NSArray * itemarray=btn_item.subviews;
                for (int j=0; j<itemarray.count; j++) {
                    UIView * itemview=itemarray[j];
                    if (itemview.tag==1) {
                        UIImageView * itemImgView=(UIImageView *)itemview;
                        [sliderSelectArray addObject:UIImageJPEGRepresentation(itemImgView.image, 1.0)];
                    }
                }
            }
        }
        NSUserDefaults * userdefaults=[NSUserDefaults standardUserDefaults];
        for (int i=0; i<self.assetsArray.count; i++) {
//            UIImage * itemimg=[UIImage imageWithCGImage:[[self.assetsArray[i] defaultRepresentation] fullScreenImage]];
            
//            if (uplodaimage<self.assetsArray.count) {
//                JKAssets * itemasset=(JKAssets *)self.assetsArray[i];
//                ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
//                [lib assetForURL:itemasset.assetPropertyURL resultBlock:^(ALAsset *asset) {
//                    if (asset) {
//                        [sliderSelectArray addObject:UIImageJPEGRepresentation([UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]], 1.0)];
//                    }
//                } failureBlock:^(NSError *error) {
//                    
//                }];
//                
//            }
            [sliderSelectArray addObject:[userdefaults objectForKey:[NSString stringWithFormat:@"%d",i]]];
        }

    }
    @catch (NSException *exception) {
        NSLog(@"构造轮播图数据出错");
    }
    @finally {
        [self BuildDataAndRequest];
    }
    
    
    
    
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
