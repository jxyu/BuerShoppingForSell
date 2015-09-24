//
//  ShopEditDetialViewController.m
//  BuerShoppingforsell
//
//  Created by 于金祥 on 15/7/31.
//  Copyright (c) 2015年 zykj.BuerShoppingforsell. All rights reserved.
//

#import "ShopEditDetialViewController.h"
#import "DataProvider.h"
#import "AppDelegate.h"
#import "ShopDetialTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ShowMapViewController.h"
#import "VPImageCropperViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "CCLocationManager.h"

#import "JKImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoCell.h"


#define ORIGINAL_MAX_WIDTH 640.0f


@interface ShopEditDetialViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,VPImageCropperDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIActionSheetDelegate,JKImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate >


@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray   *assetsArray;
@property(nonatomic,strong)UIPickerView * mypicker;
@property (nonatomic, strong) UIImageView *portraitImageView;

@end

@implementation ShopEditDetialViewController
{
    UIScrollView *scrollView;
    NSMutableDictionary * prm;
    UIButton * btn_avaer;
    UIView * backView_bottom;
    UIImageView * img_image;
    
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
    
    int sliderIndex;
    
    NSMutableArray* sliderImg;//商品已存在的轮播图
    NSMutableArray *sliderSelectArray;
}
- (NSMutableArray *)assetsArray{
    if (!_assetsArray) {
        _assetsArray = [[NSMutableArray alloc] init];
    }
    return _assetsArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"店铺详情";
    _lblTitle.textColor=[UIColor whiteColor];
    prm=[[NSMutableDictionary alloc] initWithDictionary:_StoreInfo];
    sliderImg=[[NSMutableArray alloc] initWithArray:_StoreInfo[@"store_slide"]];
    sliderSelectArray=[[NSMutableArray alloc] init];
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
    UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(15, backView_bottom.frame.size.height-1, SCREEN_WIDTH-15, 0.5)];
    fenge.backgroundColor=[UIColor grayColor];
    [backView_bottom addSubview:fenge];
    [backView_bottom addSubview:_collectionView];
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
    CGFloat height=44;
    if (indexPath.section==0&&indexPath.row==0) {
        height=80;
    }
    if (indexPath.section==4) {
        height=44;
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
            img_image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, btn_avaer.frame.size.width, btn_avaer.frame.size.height)];
            img_image.image=img_avatarimg;
            [btn_avaer addSubview:img_image];
        }
        else
        {
            if (!([prm[@"store_label"] isKindOfClass:[NSNull class]]||[prm[@"store_label"] isEqualToString:@""])) {
                
                img_image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, btn_avaer.frame.size.width, btn_avaer.frame.size.height)];
                [img_image sd_setImageWithURL:[NSURL URLWithString:prm[@"store_label"]] placeholderImage:[UIImage imageNamed:@"Add_img_icon"]];
                [btn_avaer addSubview:img_image];
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
        UIButton * btn_save=[[UIButton alloc] initWithFrame:CGRectMake(20, 0, cell.frame.size.width-40, 44)];
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
    
    
    
    img_image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, btn_avaer.frame.size.width, btn_avaer.frame.size.height)];
    img_image.image=editedImage;
    [btn_avaer addSubview:img_image];
    
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
    [self BuildSliderData];
}
-(void)BuildDataAndRequest
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"UploadeImgBackCall:"];
    [dataprovider UpLoadGoodImg:sliderSelectArray[uplodaimage] andkey:_key andname:@"good_img"];
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
            DataProvider *dataprovider=[[DataProvider alloc] init];
            [dataprovider setDelegateObject:self setBackFunctionName:@"UploadAvatarBackCall:"];
            NSData * imgData=UIImageJPEGRepresentation(img_image.image, 1.0);
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

//- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
//{
//    [imagePicker dismissViewControllerAnimated:YES completion:^{
//        
//    }];
//}

static NSString *kPhotoCellIdentifier = @"kPhotoCellIdentifier";

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.assetsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = (PhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellIdentifier forIndexPath:indexPath];
    cell.tag=indexPath.row;
    
    
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
        for (int i=0; i<_assetsArray.count; i++) {
//            UIImage * itemimg=[UIImage imageWithCGImage:[[self.assetsArray[i] defaultRepresentation] fullScreenImage]];
            
            
//            if (uplodaimage<_assetsArray.count) {
//                JKAssets * itemasset=(JKAssets *)_assetsArray[i];
//                ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
//                [lib assetForURL:itemasset.assetPropertyURL resultBlock:^(ALAsset *asset) {
//                    if (asset) {
//                        [sliderSelectArray addObject:UIImageJPEGRepresentation([UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]], 1.0)];
//                    }
//                } failureBlock:^(NSError *error) {
//                    NSLog(@"%@",error);
//                }];
                
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
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

@end
