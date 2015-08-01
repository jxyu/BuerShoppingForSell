//
//  ShopEditDetialViewController.m
//  BuerShoppingforsell
//
//  Created by 于金祥 on 15/7/31.
//  Copyright (c) 2015年 zykj.BuerShoppingforsell. All rights reserved.
//

#import "ShopEditDetialViewController.h"
#import "ZLPhoto.h"
#import "DataProvider.h"
#import "AppDelegate.h"
#import "ShopDetialTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ShowMapViewController.h"
#import "VPImageCropperViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "CCLocationManager.h"


#define ORIGINAL_MAX_WIDTH 640.0f


@interface ShopEditDetialViewController ()<ZLPhotoPickerViewControllerDelegate,ZLPhotoPickerBrowserViewControllerDataSource,ZLPhotoPickerBrowserViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,VPImageCropperDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIActionSheetDelegate >
@property (nonatomic , strong) NSMutableArray *assets;
@property (weak,nonatomic) UIScrollView *scrollView;
@property(nonatomic,strong)UIPickerView * mypicker;
@property (nonatomic, strong) UIImageView *portraitImageView;

@end

@implementation ShopEditDetialViewController
{
    NSMutableDictionary * prm;
    UIButton * btn_avaer;
    UIView * backView_bottom;
    
    NSArray * firstAreaArray;
    NSArray * secondAreaArray;
    NSArray * thirdAreaArray;
    UIView * BackView;
    NSString *province_id;
    NSString * provient;
    NSString * city;
    NSString * city_id;
    NSString * xianqu_id;
    NSString * xianqu;
    NSString * _lat;
    NSString * _long;
    int uplodaimage;
    NSMutableArray * img_array;
    NSString *images;
    NSString * avatarImg;
    UIImage *img_avatarimg;
}
- (NSMutableArray *)assets{
    if (!_assets) {
        _assets = [[NSMutableArray alloc] init];
    }
    return _assets;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"店铺详情";
    _lblTitle.textColor=[UIColor whiteColor];
    prm=[[NSMutableDictionary alloc] initWithDictionary:_StoreInfo];
    [self addRightbuttontitle:@"取消"];
    uplodaimage=0;
    images=@"";
    img_array=[[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Getjingweidu:) name:@"select_jingwei_finish" object:nil];
    [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        _lat=[NSString stringWithFormat:@"%f",locationCorrrdinate.latitude];
        _long=[NSString stringWithFormat:@"%f",locationCorrrdinate.longitude];
    }];
    [self loadAddresData];
    [self InitAllView];
    [self buildheaderview];
}
-(void)Getjingweidu:(NSNotification *)notice
{
    NSDictionary * dict=[notice object];
    _lat=dict[@"storelat"];
    _long=dict[@"storelong"];
    [prm setObject:dict[@"address"] forKey:@"location"];
}

-(void)loadAddresData
{
    
    firstAreaArray=[[NSArray alloc] init];
    secondAreaArray=[[NSArray alloc] init];
    thirdAreaArray=[[NSArray alloc] init];
    province_id=@"";
    provient=@"";
    city=@"";
    city_id=@"";
    xianqu_id=@"";
    xianqu=@"";
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetAreaListbackCall:"];
    [dataprovider GetArrayListwithareaid:@""];
}


-(void)InitAllView
{
    _myTableview.dataSource=self;
    _myTableview.delegate=self;
    
    BackView=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-250, SCREEN_WIDTH, 50)];
    [BackView setBackgroundColor:[UIColor whiteColor]];
    UIButton * btn_cancel=[[UIButton alloc] initWithFrame:CGRectMake(10, 0, 60, 50)];
    [btn_cancel setTitle:@"取消" forState:UIControlStateNormal];
    [btn_cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_cancel addTarget:self action:@selector(cancelSelect:) forControlEvents:UIControlEventTouchUpInside];
    UIButton * btn_sure=[[UIButton alloc] initWithFrame:CGRectMake(BackView.frame.size.width-70, 0, 60, 50)];
    [btn_sure setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_sure setTitle:@"确定" forState:UIControlStateNormal];
    [btn_sure addTarget:self action:@selector(sureForSelect:) forControlEvents:UIControlEventTouchUpInside];
    UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(0, BackView.frame.size.height-1, BackView.frame.size.width, 1)];
    fenge.backgroundColor=[UIColor grayColor];
    [BackView addSubview:btn_sure];
    [BackView addSubview:btn_cancel];
    [BackView addSubview:fenge];
    [self.view addSubview:BackView];
    _mypicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-200, SCREEN_WIDTH, 200)];
    _mypicker.delegate=self;
    _mypicker.dataSource=self;
    _mypicker.backgroundColor=[UIColor grayColor];
}

-(void)buildheaderview
{
    // 这个属性不能少
    backView_bottom=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 120, 20)];
    lbl_title.text=@"店铺轮播图片";
    lbl_title.font=[UIFont systemFontOfSize:15];
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



#pragma mark tableview delgate and datasource

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1&&indexPath.row==1) {
        [self showpicker];
    }
    if (indexPath.section==1&&indexPath.row==3) {
        ShowMapViewController * map=[[ShowMapViewController alloc] init];
        map.Title=prm[@"store_name"];
        map.address=prm[@"store_address"];
        map.storelat=[_lat floatValue];
        map.storelog=[_long floatValue];
        [self.navigationController pushViewController:map animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height=80;
    if (indexPath.section==4) {
        height=60;
    }
    return height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"shopdetialTableViewCellIdentifier";
    ShopDetialTableViewCell *cell = (ShopDetialTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.backgroundColor=[UIColor whiteColor];
    cell.layer.masksToBounds=YES;
    cell.layer.cornerRadius=5;
    cell.bounds=CGRectMake(0, 0, SCREEN_WIDTH-50, cell.frame.size.height);
    cell  = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetialTableViewCell" owner:self options:nil] lastObject];
    cell.frame=CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tableView.frame.size.width, cell.frame.size.height);
    if (indexPath.section==0) {
        cell.lbl_title.text=@"店铺图标";
        cell.txt_filed.hidden=YES;
        btn_avaer=[[UIButton alloc] initWithFrame:CGRectMake(cell.frame.size.width-70, 10, 60, 60)];
        if (img_avatarimg) {
            [btn_avaer setImage:img_avatarimg forState:UIControlStateNormal];
        }
        else
        {
            if (!([prm[@"store_label"] isKindOfClass:[NSNull class]]||[prm[@"store_label"] isEqualToString:@""])) {
                [btn_avaer.imageView sd_setImageWithURL:[NSURL URLWithString:prm[@"store_label"]] placeholderImage:[UIImage imageNamed:@"Add_img_icon"]];
            }
            else
            {
                [btn_avaer setImage:[UIImage imageNamed:@"Add_img_icon"] forState:UIControlStateNormal];
            }
        }
        [btn_avaer addTarget:self action:@selector(btn_uploadimg1Click:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn_avaer];
    }
    if (indexPath.section==1) {
        switch (indexPath.row) {
            case 0:
                cell.lbl_title.text=@"店铺名称";
                
                if (!([prm[@"store_name"] isEqualToString:@""]||[prm[@"store_name"] isEqualToString:@"<null>"])) {
                    cell.txt_filed.text=prm[@"store_name"];
                }
                else
                {
                    cell.txt_filed.placeholder=@"店铺名称";
                }
                cell.txt_filed.tag=1;
                cell.txt_filed.delegate=self;
                break;
            case 1:
                cell.lbl_title.text=@"省 市 区";
                if (!([prm[@"area_info"] isEqualToString:@""]||[prm[@"area_info"] isEqualToString:@"<null>"])) {
                    cell.txt_filed.text=prm[@"area_info"];
                }
                cell.txt_filed.enabled=NO;
                break;
            case 2:
                cell.lbl_title.text=@"详细店铺地址";
                if (!([prm[@"store_address"] isEqualToString:@""]||[prm[@"store_address"] isEqualToString:@"<null>"])) {
                    cell.txt_filed.text=prm[@"store_address"];
                }
                else
                {
                    cell.txt_filed.placeholder=@"店铺地址";
                }
                cell.txt_filed.tag=2;
                cell.txt_filed.delegate=self;
                break;
            case 3:
                cell.lbl_title.text=@"添加店铺GPS定位";
                if (![prm[@"location"] isKindOfClass:[NSNull class]]) {
                    cell.txt_filed.text=prm[@"location"];
                }
                cell.txt_filed.enabled=NO;
                break;
            default:
                break;
        }
    }
    if (indexPath.section==2) {
        cell.lbl_title.text=@"店铺电话";
        if (![prm[@"store_phone"] isKindOfClass:[NSNull class]]) {
            cell.txt_filed.text=prm[@"store_phone"];
        }
        else
        {
            cell.txt_filed.placeholder=@"店铺电话";
        }
        cell.txt_filed.tag=3;
        cell.txt_filed.delegate=self;
    }
    if (indexPath.section==3) {
        cell.lbl_title.text=@"快递费用";
        if (!([prm[@"store_freight_price"] isEqualToString:@""]||[prm[@"store_freight_price"] isEqualToString:@"<null>"])) {
            cell.txt_filed.text=prm[@"store_freight_price"];
        }
        else
        {
            cell.txt_filed.placeholder=@"快递费用";
        }
        cell.txt_filed.tag=4;
        cell.txt_filed.delegate=self;
    }
    if (indexPath.section==4) {
        cell.lbl_title.hidden=YES;
        cell.txt_filed.hidden=YES;
        UIButton * btn_save=[[UIButton alloc] initWithFrame:CGRectMake(20, 10, cell.frame.size.width-40, 40)];
        [btn_save setTitle:@"保存" forState:UIControlStateNormal];
        [btn_save setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn_save.backgroundColor=[UIColor colorWithRed:115/255.0 green:73/255.0 blue:139/255.0 alpha:1.0];
        btn_save.layer.masksToBounds=YES;
        btn_save.layer.cornerRadius=5;
        [btn_save addTarget:self action:@selector(SaveAllData:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn_save];
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1) {
        return 4;
    }
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==1) {
        [prm setObject:textField.text forKey:@"store_name"];
    }
    if (textField.tag==2) {
        [prm setObject:textField.text forKey:@"store_address"];
    }
    if (textField.tag==3) {
        [prm setObject:textField.text forKey:@"store_phone"];
    }
    if (textField.tag==4) {
        [prm setObject:textField.text forKey:@"store_freight_price"];
    }
    NSLog(@"%@",textField.text);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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



#pragma mark pickerview
-(void)showpicker
{
    [self.view addSubview:BackView];
    [self.view addSubview:_mypicker];
}
-(void)cancelSelect:(UIButton * )sender
{
    [BackView removeFromSuperview];
    [_mypicker removeFromSuperview];
}
-(void)sureForSelect:(UIButton *)sender
{
    [prm setObject:[NSString stringWithFormat:@"%@%@%@",provient,city,xianqu] forKey:@"area_info"];
    [_myTableview reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    [BackView removeFromSuperview];
    [_mypicker removeFromSuperview];
}
#pragma mark--UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        return [firstAreaArray count];
    }
    if (component==1) {
        return [secondAreaArray count];
    }
    if (component==2) {
        return [thirdAreaArray count];
    }
    return 0;
}
#pragma mark--UIPickerViewDelegate
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component==0) {
        return [firstAreaArray objectAtIndex:row][@"area_name"];
    }
    if (component==1) {
        return [secondAreaArray objectAtIndex:row][@"area_name"];;
    }
    if (component==2) {
        return [thirdAreaArray objectAtIndex:row][@"area_name"];;
    }
    return nil;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"row is %ld,Component is %ld",(long)row,(long)component);
    if (component==0) {
        provient=firstAreaArray[row][@"area_name"];
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"GetAreaCityListBackCall:"];
        [dataprovider GetArrayListwithareaid:firstAreaArray[row][@"area_id"]];
    }
    if (component==1) {
        city=secondAreaArray[row][@"area_name"];
        city_id=secondAreaArray[row][@"area_id"];
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"GetAreaxianchengListBackCall:"];
        [dataprovider GetArrayListwithareaid:secondAreaArray[row][@"area_id"]];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
    }
    //    [pickerView reloadComponent:2];
    if (component==2) {
        xianqu=thirdAreaArray[row][@"area_name"];
        xianqu_id=thirdAreaArray[row][@"area_id"];
    }
    
}
-(void)GetAreaListbackCall:(id)dict
{
    NSLog(@"%@",dict);
    firstAreaArray=dict[@"datas"][@"area_list"];
    provient=firstAreaArray[0][@"area_name"];
    province_id=firstAreaArray[0][@"area_id"];
    [_mypicker reloadComponent:0];
}
-(void)GetAreaCityListBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if (!dict[@"datas"][@"error"]) {
        secondAreaArray=dict[@"datas"][@"area_list"];
        city=secondAreaArray[0][@"area_name"];
        city_id=secondAreaArray[0][@"area_id"];
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"GetAreaxianchengListBackCall:"];
        [dataprovider GetArrayListwithareaid:secondAreaArray[0][@"area_id"]];
        
        [_mypicker selectedRowInComponent:1];
        [_mypicker reloadComponent:1];
        [_mypicker selectedRowInComponent:2];
    }
}
-(void)GetAreaxianchengListBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if (!dict[@"datas"][@"error"]) {
        thirdAreaArray=dict[@"datas"][@"area_list"];
        xianqu=thirdAreaArray[0][@"area_name"];
        xianqu_id=thirdAreaArray[0][@"area_id"];
        [_mypicker reloadComponent:2];
    }
}


/********************************上传图片开始*************************************/

-(void)btn_uploadimg1Click:(UIButton *)sender
{
    [self editPortrait];
}
- (void)editPortrait {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.portraitImageView.image = editedImage;
    img_avatarimg=editedImage;
    [btn_avaer setImage:editedImage forState:UIControlStateNormal];
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
        [self saveImage:editedImage withName:@"avatar.jpg"];
        
        NSString * fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"avatar.jpg"];
        NSLog(@"选择完成");
        //        [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeBlack];
        //        NSData* imageData = UIImagePNGRepresentation(editedImage);
        //        DataProvider * dataprovider=[[DataProvider alloc] init];
        //        [dataprovider setDelegateObject:self setBackFunctionName:@"UploadBackCall:"];
        //        [dataprovider UpLoadImage:fullPath andkey:userinfoWithFile[@"key"]];
    }];
}

#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
    {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}
#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}
- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
-(void)UploadBackCall:(id)dict
{
    NSLog(@"%@",dict);
    //    [img_touxiang setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURL,dict[@"data"][@"url"]]]]]
    //     ];
    [SVProgressHUD dismiss];
    if (![dict[@"datas"] objectForKey:@"error"]&&dict[@"datas"][@"avatar"]) {
        //        DataProvider * dataprovider=[[DataProvider alloc] init];
        //        [dataprovider setDelegateObject:self setBackFunctionName:@"ChangeAvatarBackCall:"];
        //        [dataprovider SaveAvatarWithAvatarName:dict[@"datas"][@"avatar"] andkey:userinfoWithFile[@"key"]];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[dict[@"datas"] objectForKey:@"error"] maskType:SVProgressHUDMaskTypeBlack];
    }
    
}


/*************************************上传图片结束******************************************/


-(void)clickRightButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)SaveAllData:(UIButton *)sender
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
        [dataprovider UpLoadStoreImg:imgData andkey:_key andname:@"slide"];
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
            
            DataProvider *dataprovider=[[DataProvider alloc] init];
            [dataprovider setDelegateObject:self setBackFunctionName:@"UploadAvatarBackCall:"];
            NSData * imgData=UIImageJPEGRepresentation(btn_avaer.imageView.image, 1.0);
            [dataprovider UpLoadStoreImg:imgData andkey:_key andname:@"avatar"];
            
        }
    }
}
-(void)UploadAvatarBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if (!dict[@"datas"][@"error"]) {
        avatarImg=dict[@"datas"][@"image_name"];
        NSMutableDictionary *requestPrm=[[NSMutableDictionary alloc] init];
        [requestPrm setObject:_key forKey:@"key"];
        [requestPrm setObject:images forKey:@"slide"];
        [requestPrm setObject:avatarImg forKey:@"avatar"];
        [requestPrm setObject:prm[@"store_name"] forKey:@"store_name"];
        [requestPrm setObject:province_id forKey:@"province_id"];
        [requestPrm setObject:city_id forKey:@"city_id"];
        [requestPrm setObject:prm[@"area_info"] forKey:@"area_info"];
        [requestPrm setObject:prm[@"store_address"] forKey:@"store_address"];
        [requestPrm setObject:_lat forKey:@"lat"];
        [requestPrm setObject:_long forKey:@"lng"];
        [requestPrm setObject:prm[@"location"] forKey:@"location"];
        [requestPrm setObject:prm[@"store_phone"] forKey:@"store_phone"];
        [requestPrm setObject:prm[@"store_freight_price"] forKey:@"store_freight_price"];
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"SaveBackCall:"];
        [dataprovider indexEditSave:requestPrm];
    }
}
-(void)SaveBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if ([dict[@"datas"]isEqualToString:@"1"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"index_save_seccess" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
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
