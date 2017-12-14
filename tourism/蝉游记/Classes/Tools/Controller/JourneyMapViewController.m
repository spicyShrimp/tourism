//
//  JourneyMapViewController.m
//  蝉游记
//
//  Created by charles on 15/7/18.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "JourneyMapViewController.h"
#import "JourneyModel.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

#define GaodeKey (@"c614dc1fdc9e8c2cf2194a5b9e07e4bf")
#define mapUrl @"http://chanyouji.com/api/destinations/attractions/%@.json?all=true"
@interface JourneyMapViewController ()<MAMapViewDelegate,AMapSearchDelegate>
{
    //地图
    MAMapView *_mapView;
    //搜索
    AMapSearchAPI *_searchAPI;
    
    NSMutableArray *_placeDataArray;
}
@end

@implementation JourneyMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"行程地图";
    self.view.backgroundColor=WhiteColor;
    
    [self configMapUI];
    
    [self prepareDataSource];
    
    if (_placeId.length>0) {
        [self loadDataWithPlaceId:_placeId];
    }

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _mapView.delegate=self;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _mapView.delegate=nil;
}
-(void)configMapUI{
    //注册key值
    [MAMapServices sharedServices].apiKey=GaodeKey;
    //创建地图
    _mapView=[[MAMapView alloc]initWithFrame:self.view.bounds];
    _mapView.mapType=MAMapTypeStandard;
    _mapView.showsCompass=NO;
    _mapView.showsScale = NO;
    //定位
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    [self.view addSubview:_mapView];
}
-(void)prepareDataSource{
    _placeDataArray=[NSMutableArray array];
}
-(void)loadDataWithPlaceId:(NSString *)placeId{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSString *dstUrl=[NSString stringWithFormat:mapUrl,placeId];
    [manager GET:dstUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id result=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        ARLog(@"%@",result);
          [_placeDataArray addObjectsFromArray:[JourneyModel objectArrayWithKeyValuesArray:result]];
        for (JourneyModel *model in _placeDataArray) {
            if ([model.attraction_type isEqualToString:@"sight"]) {
                MAPointAnnotation *anno=[[MAPointAnnotation alloc]init];
                anno.coordinate=CLLocationCoordinate2DMake([model.lat floatValue], [model.lng floatValue]);
                anno.title=model.name;
                [_mapView addAnnotation:anno];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ARLog(@"%@",error);
    }];
    
}

-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    // 自定义大头针
    MAAnnotationView *annView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"ID"];
    if ( !annView ) {
        annView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ID"];
    }
    if ([annotation isKindOfClass:[MAUserLocation class]]){
        return nil;
    }
    annView.image = [UIImage imageNamed:@"MapPinCandidateSight"];
    annView.canShowCallout = YES;
    return annView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
