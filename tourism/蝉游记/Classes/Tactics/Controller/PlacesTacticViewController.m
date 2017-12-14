//
//  PlacesTacticViewController.m
//  蝉游记
//
//  Created by charles on 15/7/10.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "PlacesTacticViewController.h"
#import "PlaceModel.h"
#import "PlaceTableViewCell.h"

#import "AttackViewController.h"
#import "TripViewController.h"
#import "TouristViewController.h"
#import "TopicViewController.h"
#define placeUrl (@"https://chanyouji.com/api/destinations/%@.json?page=1")
@interface PlacesTacticViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_placeTableView;
    NSMutableArray *_placeDataArray;
    
    PendulumView *_pendulum;
}
@end

@implementation PlacesTacticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=[NSString stringWithFormat:@"%@攻略",_placeModel.name_zh_cn];
    self.view.backgroundColor=WhiteColor;
    [self addBarButtonItem];
    
    [self configMainUI];
    
    [self addLoadingView];
    
    [self loadDataWithPlaceId:_placeModel.placeId];
    
}
-(void)addBarButtonItem{
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(pressShare) nomalImage:[UIImage imageNamed:@"ShareBarButton"] higeLightedImage:[UIImage imageNamed:@"ShareBarButtonHighlight"]];
}
-(void)pressShare{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"点击" message:@"分享按钮被点击,暂时没有编写代码" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)configMainUI{
    self.automaticallyAdjustsScrollViewInsets=NO;
    _placeTableView=[[UITableView alloc]initWithFrame:CGRectMake(10, 74, MyWidth-20, MyHeight-74) style:UITableViewStylePlain];
    _placeTableView.delegate=self;
    _placeTableView.dataSource=self;
    _placeTableView.rowHeight=245;
    _placeTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_placeTableView];
}
-(void)addLoadingView{
    _pendulum = [[PendulumView alloc] initWithFrame:self.view.bounds ballColor:ThemeColor ballDiameter:12];
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
    
    NSString *dstUrlStr=[NSString stringWithFormat:placeUrl,placeId];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:dstUrlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id result=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        /**
         *  解析数据
         */
//        ARLog(@"%@",result);
        _placeDataArray=[NSMutableArray arrayWithArray:[PlaceModel objectArrayWithKeyValuesArray:result]];
        [_placeTableView reloadData];
        [_pendulum stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_pendulum stopAnimating];
        ARLog(@"数据请求失败");
    }];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _placeDataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId=@"cellId";
    PlaceTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell=[[PlaceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.placeModel=_placeDataArray[indexPath.row];
    
    __weak PlacesTacticViewController *placeSelf=self;
    cell.itemBlock=^(NSInteger itemNO,PlaceModel *placeModel){
        if (itemNO==0) {
            AttackViewController *attackCtrl=[[AttackViewController alloc]init];
            attackCtrl.placeModel=placeModel;
            [placeSelf.navigationController pushViewController:attackCtrl animated:YES];
        }
        if (itemNO==1) {
            TripViewController *tripCtrl=[[TripViewController alloc]init];
            tripCtrl.placeModel=placeModel;
            [placeSelf.navigationController pushViewController:tripCtrl animated:YES];
        }
        if (itemNO==2) {
            TouristViewController *touristCtrl=[[TouristViewController alloc]init];
            touristCtrl.placeModel=placeModel;
            [placeSelf.navigationController pushViewController:touristCtrl animated:YES];
        }
        if (itemNO==3) {
            TopicViewController *topicCtrl=[[TopicViewController alloc]init];
            topicCtrl.placeModel=placeModel;
            [placeSelf.navigationController pushViewController:topicCtrl animated:YES];
        }
    };
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
