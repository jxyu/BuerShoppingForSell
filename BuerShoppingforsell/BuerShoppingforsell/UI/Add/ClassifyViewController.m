//
//  ClassifyViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/5/30.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "ClassifyViewController.h"
#import "AppDelegate.h"
#import "DataProvider.h"
#import "UIImageView+WebCache.h"

@interface ClassifyViewController ()

@end

@implementation ClassifyViewController
{
    NSArray * firstMenu;
    NSArray * secondMenu;
    UIScrollView * scroll_Mnue;
    UIView * backview_SecondClassify;
    int firstSelect;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"商品分类";
    _lblTitle.textColor=[UIColor whiteColor];
    [self addLeftButton:@"Icon_Back@2x.png"];
    firstMenu=[[NSArray alloc] init];
    secondMenu=[[NSArray alloc] init];
    self.view.backgroundColor=[UIColor whiteColor];
    
    scroll_Mnue=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH/3, SCREEN_HEIGHT-65)];
    scroll_Mnue.scrollEnabled=YES;
    backview_SecondClassify=[[UIView alloc] initWithFrame:CGRectMake(scroll_Mnue.frame.size.width, scroll_Mnue.frame.origin.y, SCREEN_WIDTH-scroll_Mnue.frame.size.width, scroll_Mnue.frame.size.height)];
    backview_SecondClassify.backgroundColor=[UIColor whiteColor];
    [self LoadAllData];
}


-(void)LoadAllData
{
    DataProvider * dataprovider=[DataProvider alloc];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetClassifyBackCall:"];
    [dataprovider GetClassifywithkey:_key andgc_id:@"0" anddeep:@"1"];
}
-(void)GetClassifyBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if(![dict[@"datas"] objectForKey:@"error"])
    {
        firstMenu=dict[@"datas"][@"class_list"];
        NSArray * arrayClassList=dict[@"datas"][@"class_list"];
        [self BuildClassify];
        if (arrayClassList.count>0) {
            firstSelect=0;
            DataProvider * dataprovider=[DataProvider alloc];
            [dataprovider setDelegateObject:self setBackFunctionName:@"GetClassifyNextBackCall:"];
            [dataprovider GetClassifywithkey:_key andgc_id:arrayClassList[0][@"gc_id"] anddeep:@"2"];
        }
        
    }
}

-(void)GetClassifyNextBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if(![dict[@"datas"] objectForKey:@"error"])
    {
        secondMenu=dict[@"datas"][@"class_list"];
        [self BuildGNextClassify];
    }
}

-(void)BuildClassify
{
    
    for (int i=0; i<firstMenu.count; i++) {
        UIButton * btn_item=[[UIButton alloc] initWithFrame:CGRectMake(0,i*81, scroll_Mnue.frame.size.width, 80)];
        btn_item.tag=i;
        btn_item.backgroundColor=i==0?[UIColor whiteColor]:[UIColor colorWithRed:230/255.0 green:192/255.0 blue:253/255.0 alpha:1.0];
        [btn_item setTitle:firstMenu[i][@"gc_name"] forState:UIControlStateNormal];
        [btn_item setTitleColor:i==0?[UIColor colorWithRed:102/255.0 green:75/255.0 blue:120/255.0 alpha:1.0]:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn_item addTarget:self action:@selector(GetsecondClassify:) forControlEvents:UIControlEventTouchUpInside];
        [scroll_Mnue addSubview:btn_item];
        UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, btn_item.frame.size.height)];
        fenge.backgroundColor=[UIColor colorWithRed:230/255.0 green:192/255.0 blue:253/255.0 alpha:1.0];
        [btn_item addSubview:fenge];
        
    }
    UIView * lastview=[scroll_Mnue.subviews lastObject];
    [scroll_Mnue setContentSize:CGSizeMake(0, lastview.frame.origin.y+lastview.frame.size.height+5)];
    [self.view addSubview:scroll_Mnue];
}

-(void)GetsecondClassify:(UIButton *)sender
{
    for (UIView * items in scroll_Mnue.subviews) {
        if ([items isKindOfClass:[UIButton class]]) {
            UIButton *item=(UIButton *)items;
            item.backgroundColor=[UIColor colorWithRed:230/255.0 green:192/255.0 blue:253/255.0 alpha:1.0];
            [item setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor colorWithRed:102/255.0 green:75/255.0 blue:120/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    for (UIView * item in backview_SecondClassify.subviews) {
        [item removeFromSuperview];
    }
    firstSelect=(int)sender.tag;
    DataProvider * dataprovider=[DataProvider alloc];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetClassifyNextBackCall:"];
    [dataprovider GetClassifywithkey:_key andgc_id:firstMenu[sender.tag][@"gc_id"] anddeep:@"2"];
}

-(void)BuildGNextClassify
{
    
    CGFloat itemWidth=backview_SecondClassify.frame.size.width/3;
    for (int i=0; i<secondMenu.count; i++) {
        UIView * backView_item=[[UIView alloc] initWithFrame:CGRectMake((i%3)*itemWidth, 100*(i/3), itemWidth, 100)];
        UIImageView * img_iconClassify=[[UIImageView alloc] initWithFrame:CGRectMake(0, 10, itemWidth, itemWidth)];
        [img_iconClassify sd_setImageWithURL:[NSURL URLWithString:secondMenu[i][@"image"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [backView_item addSubview:img_iconClassify];
        UILabel * lbl_classifytitle=[[UILabel alloc] initWithFrame:CGRectMake(0, backView_item.frame.size.height-20, backView_item.frame.size.width, 20)];
        lbl_classifytitle.textAlignment=NSTextAlignmentCenter;
        lbl_classifytitle.font=[UIFont systemFontOfSize:15];
        lbl_classifytitle.text=secondMenu[i][@"gc_name"];
        [backView_item addSubview:lbl_classifytitle];
        [backview_SecondClassify addSubview:backView_item];
        UIButton * btn_senondClassify=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, backView_item.frame.size.width, backView_item.frame.size.height)];
        btn_senondClassify.tag=i;
        [btn_senondClassify addTarget:self action:@selector(SecondClassifyClick:) forControlEvents:UIControlEventTouchUpInside];
        [backView_item addSubview:btn_senondClassify];
    }
    [self.view addSubview:backview_SecondClassify];
    
}

-(void)SecondClassifyClick:(UIButton *)sender
{
    NSArray * prmarray=[[NSArray alloc] initWithObjects:firstMenu[firstSelect],secondMenu[sender.tag], nil];
    //点击准备跳转
    NSLog(@"准备跳转");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"select_classify_finish" object:prmarray];
    [self.navigationController popViewControllerAnimated:YES];
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
