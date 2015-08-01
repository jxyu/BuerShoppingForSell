//
//  ShowMapViewController.m
//  BuerShoppingforsell
//
//  Created by 于金祥 on 15/7/31.
//  Copyright (c) 2015年 zykj.BuerShoppingforsell. All rights reserved.
//

#import "ShowMapViewController.h"
#import <MAMapKit/MAPinAnnotationView.h>
#import "CCLocationManager.h"

#define APIKey @"d57667019f79800b1cac4d682465f035"

@interface ShowMapViewController ()<MAMapViewDelegate>
 @property (nonatomic,strong) MAMapView *mapView;
@end

@implementation ShowMapViewController
{
    MAPointAnnotation *pointAnnotation;
    CGFloat _lat;
    CGFloat _long;
    NSString * address;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"店铺位置";
    _lblTitle.textColor=[UIColor whiteColor];
    [self addLeftButton:@"Icon_Back@2x.png"];
    [self addRightbuttontitle:@"保存"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //配置用户Key
    [MAMapServices sharedServices].apiKey = APIKey;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64)];
    _mapView.delegate = self;
    pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.title = _Title;
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(_storelat, _storelog);
    pointAnnotation.subtitle=_address;
    [_mapView addAnnotation:pointAnnotation];
    [self.view addSubview:_mapView];
    [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        
    } withAddress:^(NSString *addressString) {
        address=addressString;
    }];
    
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view didChangeDragState:(MAAnnotationViewDragState)newState fromOldState:(MAAnnotationViewDragState)oldState
{
    _lat=pointAnnotation.coordinate.latitude;
    _long=pointAnnotation.coordinate.longitude;
    NSLog(@"%f",pointAnnotation.coordinate.latitude);
}
-(void)clickRightButton:(UIButton *)sender
{
    NSDictionary * prm=@{@"storelat":[NSString stringWithFormat:@"%f",_lat],@"storelong":[NSString stringWithFormat:@"%f",_long],@"address":address};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"select_jingwei_finish" object:prm];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
