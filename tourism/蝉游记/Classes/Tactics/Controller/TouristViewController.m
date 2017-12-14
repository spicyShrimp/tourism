//
//  TouristViewController.m
//  蝉游记
//
//  Created by charles on 15/7/11.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "TouristViewController.h"
#import "PlaceModel.h"
#import "TouristModel.h"
#import "TouristTableViewCell.h"
#import "TouristDetailViewController.h"
#import "JourneyMapViewController.h"

#define touristUrl (@"https://chanyouji.com/api/destinations/attractions/%@.json?per_page=20&page=%ld")
@interface TouristViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    UITableView *_touristTableview;
    NSMutableArray *_touristDataArray;
    NSInteger _currentPage;
    MJRefreshFooterView *_footer;
    PendulumView *_pendulum;
}
@end

@implementation TouristViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=[NSString stringWithFormat:@"%@旅游地",_placeModel.name_zh_cn];
    self.view.backgroundColor=WhiteColor;
    
    [self addBarButtonItem];
    
    [self configMainUI];
    
    [self prepareDataSource];
    
    [self addFooterRefresh];
    
    [self addLoadingView];
    
    [self loadDataWithId:_placeModel.placeId page:_currentPage];
}

-(void)addBarButtonItem{
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(pressMap) nomalImage:[UIImage imageNamed:@"MapBarButton"] higeLightedImage:[UIImage imageNamed:@"MapBarButtonHighlight"]];
}
-(void)pressMap{
    JourneyMapViewController *mapCtrl=[[JourneyMapViewController alloc]init];
    mapCtrl.placeId=_placeModel.placeId;
    [self.navigationController pushViewController:mapCtrl animated:YES];
}
-(void)configMainUI{
    self.automaticallyAdjustsScrollViewInsets=NO;
    _touristTableview=[[UITableView alloc]initWithFrame:CGRectMake(10, 70, MyWidth-20, MyHeight-70) style:UITableViewStylePlain];
    _touristTableview.delegate=self;
    _touristTableview.dataSource=self;
    _touristTableview.rowHeight=100;
    _touristTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_touristTableview];
}
-(void)prepareDataSource{
    _touristDataArray=[NSMutableArray array];
    _currentPage=1;
}
-(void)addFooterRefresh{
    _footer=[MJRefreshFooterView footer];
    _footer.delegate=self;
    _footer.scrollView=_touristTableview;
}
-(void)dealloc{
    [_footer free];
}
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    _currentPage++;
    [self loadDataWithId:_placeModel.placeId page:_currentPage];
}
-(void)addLoadingView{
    _pendulum = [[PendulumView alloc] initWithFrame:self.view.bounds ballColor:ThemeColor ballDiameter:12];
    [self.view addSubview:_pendulum];
}
-(void)loadDataWithId:(NSString *)Id page:(NSInteger)page{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    /**
     *  请求地址协议为https  所以添加以下代码(pch中也要添加代码)
     */
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    NSString *dstUrlStr=[NSString stringWithFormat:touristUrl,Id,(long)page];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:dstUrlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id result=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        /**
         *  解析数据
         */
//        ARLog(@"%@",result);
        [_touristDataArray addObjectsFromArray:[TouristModel objectArrayWithKeyValuesArray:result]];
        [_touristTableview reloadData];
        _touristTableview.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        [_pendulum stopAnimating];
        [_footer endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_pendulum stopAnimating];
        ARLog(@"数据请求失败");
    }];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _touristDataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId=@"cellId";
    TouristTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell=[[TouristTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.touristModel=_touristDataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TouristDetailViewController *detailCtrl=[[TouristDetailViewController alloc]init];
    detailCtrl.touristModel=_touristDataArray[indexPath.row];
    [self.navigationController pushViewController:detailCtrl animated:YES];
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
