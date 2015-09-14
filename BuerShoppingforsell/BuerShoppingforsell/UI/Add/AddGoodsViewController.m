//
//  AddGoodsViewController.m
//  BuerShoppingforsell
//
//  Created by 于金祥 on 15/7/25.
//  Copyright (c) 2015年 zykj.BuerShoppingforsell. All rights reserved.
//

#import "AddGoodsViewController.h"
#import "ZLPhoto.h"
#import "AppDelegate.h"
#import "XCMultiSortTableView.h"
#import "ClassifyViewController.h"
#import "DataProvider.h"
#import "MLTableAlert.h"
//#import "LMContainsLMComboxScrollView.h"
//#import "LMComBoxView.h"

@interface AddGoodsViewController ()<ZLPhotoPickerViewControllerDelegate,ZLPhotoPickerBrowserViewControllerDataSource,ZLPhotoPickerBrowserViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,XCMultiTableViewDataSource,UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic , strong) NSMutableArray *assets;
@property (weak,nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) MLTableAlert *alert;
@end

@implementation AddGoodsViewController
{
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
}
- (NSMutableArray *)assets{
    if (!_assets) {
        _assets = [[NSMutableArray alloc] init];
    }
    return _assets;
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
        self.assets=dict[@"datas"][@"common_info"][@"goods_image"];
        [_myTableview reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        [self initData];
        [self reloadScrollView];
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
    img_array=[[NSMutableArray alloc] init];
    request_spec=[[NSMutableArray alloc] init];
    _myTableview.delegate=self;
    _myTableview.dataSource=self;
    _myTableview.tag=1;
    spec_list=[[NSArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshTable:) name:@"select_classify_finish" object:nil];
    [self buildheaderview];
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
-(void)buildheaderview
{
    // 这个属性不能少
    backView_bottom=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    lbl_title.text=@"商品图片";
    [backView_bottom addSubview:lbl_title];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.frame = CGRectMake(10, lbl_title.frame.size.height+lbl_title.frame.origin.y+10, SCREEN_WIDTH-20,150);
    [backView_bottom addSubview:scrollView];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView = scrollView;
    // 属性scrollView
    [self reloadScrollView];
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
            if (GoodDetial) {
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
            [btn_guige1 setTitle:@"规格1" forState:UIControlStateNormal];
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
            [btn_guige1 setTitle:@"规格2" forState:UIControlStateNormal];
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

#pragma mark - select Photo Library
- (void)photoSelecte {
    // 创建控制器
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    pickerVc.minCount = 9 - self.assets.count;
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.rootvc=self;
    pickerVc.callBack = ^(NSArray *status){
        [self.assets addObjectsFromArray:status];
        [self reloadScrollView];
    };
    [self.navigationController pushViewController:pickerVc animated:YES];
    /**
     *
     传值可以用代理，或者用block来接收，以下是block的传值
     __weak typeof(self) weakSelf = self;
     pickerVc.callBack = ^(NSArray *assets){
     weakSelf.assets = assets;
     [weakSelf.tableView reloadData];
     };
     */
}
- (void)reloadScrollView{
    
    // 先移除，后添加
    [[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSUInteger column = 4;
    // 加一是为了有个添加button
    NSUInteger assetCount = self.assets.count + 1;
    
    CGFloat width = (SCREEN_WIDTH-20) / column;
    for (NSInteger i = 0; i < assetCount; i++) {
        
        NSInteger row = i / column;
        NSInteger col = i % column;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        btn.frame = CGRectMake(width * col, row * width, width, width);
        
        // UIButton
        if (i == self.assets.count){
            // 最后一个Button
            [btn setImage:[UIImage imageNamed:@"Add_img_icon"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(photoSelecte) forControlEvents:UIControlEventTouchUpInside];
        }else{
            // 如果是本地ZLPhotoAssets就从本地取，否则从网络取
            if ([[self.assets objectAtIndex:i] isKindOfClass:[ZLPhotoAssets class]]) {
                [btn setImage:[self.assets[i] thumbImage] forState:UIControlStateNormal];
                NSLog(@"%@",[self.assets[i] thumbImage]);
            }else{
                [btn sd_setImageWithURL:[NSURL URLWithString:self.assets[i % (self.assets.count)]] forState:UIControlStateNormal];
                NSLog(@"%@",self.assets[i % (self.assets.count)]);
            }
            btn.tag = i;
            [btn addTarget:self action:@selector(tapBrowser:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self.scrollView addSubview:btn];
    }
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH-20, CGRectGetMaxY([[self.scrollView.subviews lastObject] frame]));
    backView_bottom.bounds=CGRectMake(0, 0, backView_bottom.frame.size.width, CGRectGetMaxY([[self.scrollView.subviews lastObject] frame])+50);
    _myTableview.tableHeaderView=backView_bottom;
}
- (void)tapBrowser:(UIButton *)btn{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag inSection:0];
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    // 淡入淡出效果
    // pickerBrowser.status = UIViewAnimationAnimationStatusFade;
    //    pickerBrowser.toView = btn;
    // 数据源/delegate
    pickerBrowser.delegate = self;
    pickerBrowser.dataSource = self;
    // 当前选中的值
    pickerBrowser.currentIndexPath = [NSIndexPath indexPathForItem:indexPath.row inSection:0];
    // 展示控制器
    [self.navigationController pushViewController:pickerBrowser animated:YES];
}
#pragma mark - <ZLPhotoPickerBrowserViewControllerDataSource>
- (NSInteger)numberOfSectionInPhotosInPickerBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser{
    return 1;
}
- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return self.assets.count;
}
#pragma mark - 每个组展示什么图片,需要包装下ZLPhotoPickerBrowserPhoto
- (ZLPhotoPickerBrowserPhoto *) photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    ZLPhotoAssets *imageObj = [self.assets objectAtIndex:indexPath.row];
    // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
    ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:imageObj];
    
    UIButton *btn = self.scrollView.subviews[indexPath.row];
    photo.toView = btn.imageView;
    // 缩略图
    photo.thumbImage = btn.imageView.image;
    return photo;
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
    [self BuildDataAndRequest];
}
-(void)BuildDataAndRequest
{
    NSArray * imgarray=[[NSArray alloc] initWithArray:[self.scrollView subviews]];
    if ([imgarray[uplodaimage] isKindOfClass:[UIButton class]]) {
        UIButton * item=(UIButton *)imgarray[uplodaimage];
        NSData * imgData=UIImageJPEGRepresentation(item.imageView.image, 1.0);
        DataProvider * dataprovider=[[DataProvider alloc] init];
        
        [dataprovider setDelegateObject:self setBackFunctionName:@"UploadeImgBackCall:"];
        [dataprovider UpLoadGoodImg:imgData andkey:userinfoWithFile[@"key"] andname:@"good_img"];
    }
    else
    {
        ++uplodaimage;
        [self BuildDataAndRequest];
    }
}

-(void)UploadeImgBackCall:(id)dict
{
    
    NSLog(@"%@",dict);
    if (!dict[@"datas"][@"error"]) {
        [img_array addObject:dict[@"datas"][@"image_name"]];
        if (uplodaimage<self.assets.count-1) {
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
            [dataprovider SaveGoodInfo:[self GetAllPageData]];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showTabBar];
}

@end
