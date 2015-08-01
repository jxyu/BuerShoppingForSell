//
//  RealNameViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/7/21.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "RealNameViewController.h"
#import "VPImageCropperViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ZHPickView.h"
#import "DataProvider.h"
#import "AppDelegate.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@interface RealNameViewController ()<ZHPickViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate>
@property(nonatomic,strong)ZHPickView *pickview;
@property (nonatomic, strong) UIImageView *portraitImageView;

@end

@implementation RealNameViewController
{
    NSDictionary *userinfoWithFile;
    BOOL keyboardZhezhaoShow;
    BOOL isUpLoadeImage1;
    NSMutableArray * imgarray;
    NSMutableArray * imgArray1;
    int imagecount;
    BOOL isIDCard;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"实名认证";
    _lblTitle.textColor=[UIColor whiteColor];
    [self addLeftButton:@"Icon_Back@2x.png"];
    keyboardZhezhaoShow=NO;
    isIDCard=YES;
    isUpLoadeImage1=YES;
    imagecount=0;
    imgarray=[[NSMutableArray alloc] init];
    imgArray1=[[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [self.btn_imgupload1 addTarget:self action:@selector(btn_uploadimg1Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_imgupload2 addTarget:self action:@selector(btn_uploadimg2Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_imageupload3 addTarget:self action:@selector(btn_uploadimg3Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_imgupload4 addTarget:self action:@selector(btn_uploadimg4Click:) forControlEvents:UIControlEventTouchUpInside];
    self.btn_Submit.layer.masksToBounds=YES;
    self.btn_Submit.layer.cornerRadius=5;
    [self.btn_Submit addTarget:self action:@selector(SubmitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self LoadAllView];
}
-(void)SubmitBtnClick:(UIButton *)sender
{
    [self startUploadImg];
}

-(void)startUploadImg
{
    if (_lbl_borndate.text&&_txt_Name.text&&_txt_address.text) {
        [SVProgressHUD showWithStatus:@"正在提交" maskType:SVProgressHUDMaskTypeBlack];
        ++imagecount;
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"UploadImgBackCall:"];
        NSData * imgData=UIImageJPEGRepresentation(self.btn_imgupload1.imageView.image, 1.0);
        [dataprovider UpLoadIDCardImg:imgData andkey:userinfoWithFile[@"key"] andname:@"idcard"];
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写完整信息" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
}
-(void)UploadImgBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if (!dict[@"datas"][@"error"]) {
        if (imagecount<3) {
            [imgarray addObject:dict[@"datas"][@"image_name"]];
        }
        else
        {
            [imgArray1 addObject:dict[@"datas"][@"image_name"]];
        }
        
        if (imagecount<2) {
            ++imagecount;
            DataProvider * dataprovider=[[DataProvider alloc] init];
            [dataprovider setDelegateObject:self setBackFunctionName:@"UploadImgBackCall:"];
            NSData * imgData=UIImageJPEGRepresentation(self.btn_imgupload2.imageView.image, 1.0);
            [dataprovider UpLoadIDCardImg:imgData andkey:userinfoWithFile[@"key"] andname:@"idcard"];
        }
        else if (imagecount==2)
        {
            ++imagecount;
            DataProvider * dataprovider=[[DataProvider alloc] init];
            [dataprovider setDelegateObject:self setBackFunctionName:@"UploadImgBackCall:"];
            NSData * imgData=UIImageJPEGRepresentation(self.btn_imageupload3.imageView.image, 1.0);
            [dataprovider UpLoadIDCardImg:imgData andkey:userinfoWithFile[@"key"] andname:@"license"];
        }
        else if (imagecount==3)
        {
            ++imagecount;
            DataProvider * dataprovider=[[DataProvider alloc] init];
            [dataprovider setDelegateObject:self setBackFunctionName:@"UploadImgBackCall:"];
            NSData * imgData=UIImageJPEGRepresentation(self.btn_imgupload4.imageView.image, 1.0);
            [dataprovider UpLoadIDCardImg:imgData andkey:userinfoWithFile[@"key"] andname:@"license"];
        }
        else
        {
            NSDictionary * prm=@{@"key":userinfoWithFile[@"key"],@"truename":self.txt_Name.text,@"birthday":self.lbl_borndate.text,@"address":self.txt_address.text,@"idcard":[NSString stringWithFormat:@"%@,%@",imgarray[0],imgarray[1]],@"license":[NSString stringWithFormat:@"%@,%@",imgArray1[0],imgArray1[1]]};
            DataProvider * dataprovider=[[DataProvider alloc] init];
            [dataprovider setDelegateObject:self setBackFunctionName:@"submitBackCall:"];
            [dataprovider RealNameSubmit:prm];
        }
    }
}
-(void)submitBackCall:(id)dict
{
    [SVProgressHUD dismiss];
    NSLog(@"%@",dict);
    if ([[NSString stringWithFormat:@"%@",dict[@"datas"]] isEqualToString:@"1"]) {
        [SVProgressHUD showSuccessWithStatus:@"认证信息已提交" maskType:SVProgressHUDMaskTypeBlack];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:dict[@"datas"][@"error"] maskType:SVProgressHUDMaskTypeBlack];
    }
}

-(void)LoadAllView
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    userinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Btn_Borndate:(UIButton *)sender {
    [_pickview remove];
    NSDate *date=[NSDate dateWithTimeIntervalSinceNow:9000000];
    _pickview=[[ZHPickView alloc] initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
    _pickview.delegate=self;
    [_pickview show];
}
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString
{
    self.lbl_borndate.text=resultString;
}





//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    if (!keyboardZhezhaoShow) {
        UIButton * btn_zhezhao=[[UIButton alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, SCREEN_HEIGHT-65-height)];
        [btn_zhezhao addTarget:self action:@selector(tuichuKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
        btn_zhezhao.backgroundColor=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2];
        [self.view addSubview:btn_zhezhao];
        keyboardZhezhaoShow=YES;
    }
}

-(void)tuichuKeyBoard:(UIButton *)sender
{
    keyboardZhezhaoShow=NO;
    [_txt_address resignFirstResponder];
    [_txt_Name resignFirstResponder];
    [sender removeFromSuperview];
}

/********************************上传图片开始*************************************/

-(void)btn_uploadimg1Click:(UIButton *)sender
{
    isIDCard=YES;
    isUpLoadeImage1=YES;
    [self editPortrait];
}
-(void)btn_uploadimg2Click:(UIButton *)sender
{
    isIDCard=YES;
    isUpLoadeImage1=NO;
    [self editPortrait];
}
-(void)btn_uploadimg3Click:(UIButton *)sender
{
    isIDCard=NO;
    isUpLoadeImage1=YES;
    [self editPortrait];
}
-(void)btn_uploadimg4Click:(UIButton *)sender
{
    isIDCard=NO;
    isUpLoadeImage1=NO;
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
    if (isIDCard) {
        if (isUpLoadeImage1) {
            [self.btn_imgupload1 setImage:editedImage forState:UIControlStateNormal];
        }
        else
        {
            [self.btn_imgupload2 setImage:editedImage forState:UIControlStateNormal];
        }
    }
    else
    {
        if (isUpLoadeImage1) {
            [self.btn_imageupload3 setImage:editedImage forState:UIControlStateNormal];
        }
        else
        {
            [self.btn_imgupload4 setImage:editedImage forState:UIControlStateNormal];
        }
    }
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
        [self saveImage:editedImage withName:@"avatar.jpg"];
        
        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"avatar.jpg"];
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
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}
@end
