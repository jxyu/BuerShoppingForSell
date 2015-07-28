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

@interface AddGoodsViewController ()<ZLPhotoPickerViewControllerDelegate,ZLPhotoPickerBrowserViewControllerDataSource,ZLPhotoPickerBrowserViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,XCMultiTableViewDataSource,UITextFieldDelegate>
@property (nonatomic , strong) NSMutableArray *assets;
@property (weak,nonatomic) UIScrollView *scrollView;
@end

@implementation AddGoodsViewController
{
    UIView * backView_bottom;
    NSMutableArray *headData;
    NSMutableArray *leftTableData;
    NSMutableArray *rightTableData;
}
- (NSMutableArray *)assets{
    if (!_assets) {
        _assets = [[NSMutableArray alloc] init];
    }
    return _assets;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"商品详情编辑";
    _lblTitle.textColor=[UIColor whiteColor];
    [self addLeftbuttontitle:@"取消"];
    [self addRightbuttontitle:@"保存"];
    [self initData];
    _myTableview.delegate=self;
    _myTableview.dataSource=self;
    _myTableview.tag=1;
    [self buildheaderview];
}

- (void)initData {
    headData = [NSMutableArray arrayWithCapacity:10];
    [headData addObject:@"规格1"];
    [headData addObject:@"规格2"];
    [headData addObject:@"价格"];
    [headData addObject:@"库存"];
    [headData addObject:@"天天特价价格(选填)"];
    leftTableData = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *one = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < 3; i++) {
        [one addObject:[NSString stringWithFormat:@"ki-%d", i]];
    }
    [leftTableData addObject:one];
    NSMutableArray *two = [NSMutableArray arrayWithCapacity:10];
    for (int i = 3; i < 10; i++) {
        [two addObject:[NSString stringWithFormat:@"ki-%d", i]];
    }
    [leftTableData addObject:two];
    
    
    
    rightTableData = [NSMutableArray arrayWithCapacity:10];
    
    NSMutableArray *oneR = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < 3; i++) {
        NSMutableArray *ary = [NSMutableArray arrayWithCapacity:10];
        for (int j = 0; j < 5; j++) {
            if (j == 1) {
                [ary addObject:[NSNumber numberWithInt:random() % 5]];
            }else if (j == 2) {
                [ary addObject:[NSNumber numberWithInt:random() % 10]];
            }
            else {
                [ary addObject:[NSString stringWithFormat:@"column %d %d", i, j]];
            }
        }
        [oneR addObject:ary];
    }
    [rightTableData addObject:oneR];
    
    NSMutableArray *twoR = [NSMutableArray arrayWithCapacity:10];
    for (int i = 3; i < 10; i++) {
        NSMutableArray *ary = [NSMutableArray arrayWithCapacity:10];
        for (int j = 0; j < 5; j++) {
            if (j == 1) {
                [ary addObject:[NSNumber numberWithInt:random() % 5]];
            }else if (j == 2) {
                [ary addObject:[NSNumber numberWithInt:random() % 5]];
            }else {
                [ary addObject:[NSString stringWithFormat:@"column %d %d", i, j]];
            }
        }
        [twoR addObject:ary];
    }
    [rightTableData addObject:twoR];
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
    if (indexPath.section==3) {
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
            txt_name.placeholder=@"请输入产品名称";
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
            [cell addSubview:txtview_detial];
        }
    }
    if (indexPath.section==1) {
        UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(10,15, 200, 20)];
        lbl_title.text=@"一级分类/二级分类";
        [cell addSubview:lbl_title];
        UIImageView * img_go=[[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width-20, 17.5, 8, 15)];
        img_go.image=[UIImage imageNamed:@"index_go"];
        [cell addSubview:img_go];
    }
    if (indexPath.section==2) {
        if (indexPath.row==0) {
            UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(10,15, 60, 20)];
            lbl_title.text=@"规格1";
            [cell addSubview:lbl_title];
            CGFloat x=lbl_title.frame.size.width+lbl_title.frame.origin.x+10;
            UITextField * txt_name=[[UITextField alloc] initWithFrame:CGRectMake(x, 10, cell.frame.size.width-x-10, 30)];
//            txt_name.textAlignment=NSTextAlignmentRight;
            txt_name.placeholder=@"格式如下：红色，粉色，绿色";
            [cell addSubview:txt_name];
        }else
        {
            UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(10,15, 60, 20)];
            lbl_title.text=@"规格2";
            [cell addSubview:lbl_title];
            CGFloat x=lbl_title.frame.size.width+lbl_title.frame.origin.x+10;
            UITextField * txt_name=[[UITextField alloc] initWithFrame:CGRectMake(x, 10, cell.frame.size.width-x-10, 30)];
//            txt_name.textAlignment=NSTextAlignmentRight;
            txt_name.placeholder=@"格式如下：XL，2XL，M";
            [cell addSubview:txt_name];
        }
    }
    if (indexPath.section==3) {
        XCMultiTableView *tableView = [[XCMultiTableView alloc] initWithFrame:CGRectInset(cell.bounds, 5.0f, 5.0f)];
        tableView.leftHeaderEnable = NO;
        tableView.datasource = self;
        tableView.tag=2;
        [cell addSubview:tableView];
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
        return 4;
    }
    else
    {
        return 1;
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
    if (row == 1 && section == 0) {
        return [UIColor redColor];
    }
    return [UIColor clearColor];
}

- (UIColor *)tableView:(XCMultiTableView *)tableView headerBgColorInColumn:(NSUInteger)column {
    if (column == -1) {
        return [UIColor redColor];
    }else if (column == 1) {
        return [UIColor grayColor];
    }
    return [UIColor clearColor];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
