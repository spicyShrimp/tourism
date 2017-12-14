//
//  ToolsViewController.m
//  蝉游记
//
//  Created by Charles on 15/7/7.
//  Copyright (c) 2015年 Charles. All rights reserved.
//

#import "ToolsViewController.h"
#import "DestViewController.h"
#import "PlaceModel.h"
#import "PlaceInfoModel.h"
#import "TransLationViewController.h"
#import "ExchangeViewController.h"
#import "AccountBookViewController.h"
#import "JourneyMapViewController.h"
#define weatherUrl (@"https://chanyouji.com/api/wiki/destinations/infos/%@.json?page=1")
@interface ToolsViewController ()
{
    UIView *_line;
    UILabel *_weatherMinLabel;
    UILabel *_weatherMaxLabel;
    UILabel *_timeLabel;
    UILabel *_rightBtnLabel;
    
    PendulumView *_pendulum;
    
    NSString *_placeId;
}
@end

@implementation ToolsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=WhiteColor;
    self.navigationItem.title=@"旅行工具箱";
    
    [self addBarButtonItem];
    
    [self configWeatherUI];
    
    [self configToolButton];
    
    _placeId=[[NSUserDefaults standardUserDefaults]objectForKey:@"placeId"];
    
    if (![_rightBtnLabel.text isEqualToString:@"选择目的地"]) {
        [self addLoadingView];
        [self loadDataWithPlaceId:_placeId];
    }
}
-(void)addBarButtonItem{
    _rightBtnLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    NSString *name=[[NSUserDefaults standardUserDefaults]objectForKey:@"name_zh_cn"];
    _rightBtnLabel.text=name.length>0?name:@"选择目的地";
    _rightBtnLabel.userInteractionEnabled=YES;
    _rightBtnLabel.textAlignment=NSTextAlignmentRight;
    _rightBtnLabel.textColor=[UIColor whiteColor];
    _rightBtnLabel.font=[UIFont systemFontOfSize:14];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pressAddress)];
    [_rightBtnLabel addGestureRecognizer:tap];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:_rightBtnLabel];
}
-(void)pressAddress{
    DestViewController *destCtrl=[[DestViewController alloc]init];
    destCtrl.placeBlock=^(PlaceModel *placeModel){
        _rightBtnLabel.text=placeModel.name_zh_cn;
        _placeId=placeModel.placeId;
        [Default setObject:placeModel.placeId forKey:@"placeId"];
        [Default setObject:placeModel.name_zh_cn forKey:@"name_zh_cn"];
        [Default synchronize];
        [self loadDataWithPlaceId:placeModel.placeId];
    };
    [self.navigationController pushViewController:destCtrl animated:YES];
}

-(void)configWeatherUI{
    _line=[[UIView alloc]init];
    _line.size=CGSizeMake(20, 2);
    _line.center=CGPointMake(self.view.centerX, 141);
    _line.backgroundColor=[UIColor lightGrayColor];
    _line.hidden=YES;
    [self.view addSubview:_line];
    
    _weatherMinLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 100, 140, 80)];
    _weatherMinLabel.font=[UIFont systemFontOfSize:40];
    _weatherMinLabel.backgroundColor=[UIColor whiteColor];
    _weatherMinLabel.textColor=[UIColor colorWithRed:18.0/255 green:135.0/255 blue:217.0/255 alpha:1.0];
    _weatherMinLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_weatherMinLabel];
    
    _weatherMaxLabel=[[UILabel alloc]initWithFrame:CGRectMake(MyWidth-150, 100, 140, 80)];
    _weatherMaxLabel.font=[UIFont systemFontOfSize:40];
    _weatherMaxLabel.backgroundColor=[UIColor whiteColor];
    _weatherMaxLabel.textColor=[UIColor redColor];
    _weatherMaxLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_weatherMaxLabel];
    
    _timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(40, 180, MyWidth-80, 20)];
    _timeLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_timeLabel];
}

-(void)configToolButton{
    CGFloat spaceW=(MyWidth-120)/3;
    CGFloat spaceH=(MyHeight-369)/3;
    NSArray *titleArray=@[@"语音翻译",@"实时汇率",@"旅行记账",@"行程地图"];
    for (int i=0; i<2; i++) {
        for (int j=0; j<2; j++) {
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(spaceW+j*(60+spaceW), 260+spaceH+i*(60+spaceH), 60, 20)];
            label.text=titleArray[i*2+j];
            label.font=[UIFont systemFontOfSize:14];
            label.textAlignment=NSTextAlignmentCenter;
            [self.view addSubview:label];
            
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(spaceW+j*(60+spaceW), 200+spaceH+i*(60+spaceH), 60, 60);
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ToolboxItem%i_Normal",i*2+j]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ToolboxItem%i_Pressed",i*2+j]] forState:UIControlStateHighlighted];
            btn.tag=100+(i*2+j);
            [btn addTarget:self action:@selector(toolBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btn];
        }
    }
}
-(void)toolBtnClicked:(UIButton *)btn{
    if (btn.tag==100) {
        TransLationViewController *transCtrl=[[TransLationViewController alloc]init];
        [self.navigationController pushViewController:transCtrl animated:YES];
    }
    if (btn.tag==101) {
        ExchangeViewController *exchangeCtrl=[[ExchangeViewController alloc]init];
        exchangeCtrl.placeInfoModel=_placeInfoModel;
        [self.navigationController pushViewController:exchangeCtrl animated:YES];
    }
    if (btn.tag==102) {
        AccountBookViewController *bookCtrl=[[AccountBookViewController alloc]init];
        [self.navigationController pushViewController:bookCtrl animated:YES];
    }
    if (btn.tag==103) {
        JourneyMapViewController *mapCtrl=[[JourneyMapViewController alloc]init];
        mapCtrl.placeId=_placeId;
        [self.navigationController pushViewController:mapCtrl animated:YES];
    }
}

-(void)addLoadingView{
    _pendulum = [[PendulumView alloc] initWithFrame:CGRectMake(0, 64, MyWidth, 200) ballColor:[UIColor colorWithRed:18.0/255 green:135.0/255 blue:217.0/255 alpha:1.0] ballDiameter:12];
    [self.view addSubview:_pendulum];
}
-(void)loadDataWithPlaceId:(NSString *)placeId{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    /**
     *  请求地址协议为https  所以添加以下代码(pch中也要添加代码)
     */
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    NSString *dstUrlStr=[NSString stringWithFormat:weatherUrl,placeId];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:dstUrlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id result=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        ARLog(@"%@",result);
        PlaceInfoModel *model=[PlaceInfoModel objectWithKeyValues:result];
        _placeInfoModel=model;
        //解析数据
        _weatherMinLabel.text=[NSString stringWithFormat:@"%@°C",model.temp_min];
        _weatherMaxLabel.text=[NSString stringWithFormat:@"%@°C",model.temp_max];
        _line.hidden=NO;
        _timeLabel.text=[NSString stringWithFormat:@"当地时间 %@",model.current_time];
        [_pendulum stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_pendulum stopAnimating];
        ARLog(@"数据请求失败");
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
