//
//  TripDetailViewController.m
//  蝉游记
//
//  Created by charles on 15/7/11.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "TripDetailViewController.h"
#import "TripModel.h"
#import "PlanDayModel.h"
#import "PlanNodeModel.h"
#import "TripDetailTableViewCell.h"
#import "TouristDetailViewController.h"
#import "TouristModel.h"
#define tripDetailUrl (@"https://chanyouji.com/api/plans/%@.json?page=1")
@interface TripDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *_cover;
    CGFloat _oldContentOffsetY;
    UITableView *_tripDetailTableView;
    NSMutableArray *_tripDetailDataArray;
    
    PendulumView *_pendulum;
}

@end

@implementation TripDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /**
     *  设定导航栏为透明
     */
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[self createImageWithColor:[UIColor clearColor]]];
    _cover=[[UIView alloc]initWithFrame:CGRectMake(0, 0, MyWidth, 64)];
    _cover.backgroundColor=ThemeColor;
    [self.view addSubview:_cover];
    _cover.hidden=YES;
}
/**
 *  使用颜色生成一个图片
 */
-(UIImage *) createImageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=WhiteColor;
    
    [self addBarButtonItem];
    
    [self configMainUI];
    
    [self prepareDataSource];
    
    [self addLoadingView];
    
    [self loadDataWithTripId:_tripModel.tripId];
}
-(void)addBarButtonItem{
    
}
-(void)configMainUI{
    self.automaticallyAdjustsScrollViewInsets=NO;
    _tripDetailTableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tripDetailTableView.delegate=self;
    _tripDetailTableView.dataSource=self;
    _tripDetailTableView.bounces=NO;
    _tripDetailTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tripDetailTableView];
    
    [self addHeadView];
    
    
}
-(void)addHeadView{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, MyWidth, 200)];
    
    UIImageView *showImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MyWidth, 200)];
    [showImageView sd_setImageWithURL:[NSURL URLWithString:_tripModel.image_url]];
    [view addSubview:showImageView];
    UIImageView *cover=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MyWidth, 200)];
    cover.image=[UIImage imageNamed:@"TripCellCoverMask"];
    [view addSubview:cover];
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 150, MyWidth-20, 20)];
    nameLabel.textColor=[UIColor whiteColor];
    nameLabel.font=[UIFont systemFontOfSize:15];
    nameLabel.text=_tripModel.name;
    [view addSubview:nameLabel];
    
    UILabel *countLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 170, MyWidth-20, 20)];
    countLabel.textColor=[UIColor whiteColor];
    countLabel.font=[UIFont systemFontOfSize:14];
    countLabel.text=[NSString stringWithFormat:@"%@ 天 / %@ 个旅游地",_tripModel.plan_days_count,_tripModel.plan_nodes_count];
    [view addSubview:countLabel];
    
    _tripDetailTableView.tableHeaderView=view;
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _oldContentOffsetY=scrollView.contentOffset.y;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat newContentOffsetY=scrollView.contentOffset.y;
    if (newContentOffsetY>_oldContentOffsetY&&newContentOffsetY>=136) {
        _cover.hidden=NO;
        self.navigationItem.title=_tripModel.name;
        _tripDetailTableView.contentInset=UIEdgeInsetsMake(64, 0, 0, 0);
    }
    else if(newContentOffsetY<_oldContentOffsetY&&newContentOffsetY<136){
        _cover.hidden=YES;
        self.navigationItem.title=nil;
        _tripDetailTableView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

-(void)prepareDataSource{
    _tripDetailDataArray=[NSMutableArray array];
}
-(void)addLoadingView{
    _pendulum = [[PendulumView alloc] initWithFrame:self.view.bounds ballColor:ThemeColor ballDiameter:12];
    [self.view addSubview:_pendulum];
}
-(void)loadDataWithTripId:(NSString *)tripId{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    /**
     *  请求地址协议为https  所以添加以下代码(pch中也要添加代码)
     */
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    NSString *dstUrlStr=[NSString stringWithFormat:tripDetailUrl,tripId];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:dstUrlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id result=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        /**
         *  解析数据
         */
//        ARLog(@"%@",result);
        NSArray *planDaysArray=result[@"plan_days"];
        [_tripDetailDataArray addObjectsFromArray:[PlanDayModel objectArrayWithKeyValuesArray:planDaysArray]];
        [_tripDetailTableView reloadData];
        [_pendulum stopAnimating];
        _tripDetailTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_pendulum stopAnimating];
        ARLog(@"数据请求失败");
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _tripDetailDataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    PlanDayModel *dayModel=_tripDetailDataArray[section];
    return dayModel.plan_nodes.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID=@"ID";
    TripDetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[TripDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    PlanDayModel *dayModel=_tripDetailDataArray[indexPath.section];
    cell.planNodeModel=dayModel.plan_nodes[indexPath.row];
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"第 %i 天",section+1];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PlanDayModel *dayModel=_tripDetailDataArray[indexPath.section];
    return [TripDetailTableViewCell heightWithModel:dayModel.plan_nodes[indexPath.row]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
