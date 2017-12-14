//
//  TopicViewController.m
//  蝉游记
//
//  Created by charles on 15/7/11.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "TopicViewController.h"
#import "PlaceModel.h"
#import "TopicModel.h"
#import "TopicTableViewCell.h"
#import "TopicDetailViewController.h"

#define topicUrl (@"https://chanyouji.com/api/articles.json?destination_id=%@&page=1")
@interface TopicViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_topicTableView;
    NSMutableArray *_topicDataArray;
    
    PendulumView *_pendulum;
}
@end

@implementation TopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=[NSString stringWithFormat:@"%@专题",_placeModel.name_zh_cn];
    self.view.backgroundColor=WhiteColor;
    [self configMainUI];
    
    [self addLoadingView];
    
    [self loadDataWithId:_placeModel.placeId];
}
-(void)configMainUI{
    self.automaticallyAdjustsScrollViewInsets=NO;
    _topicTableView=[[UITableView alloc]initWithFrame:CGRectMake(10, 70, MyWidth-20, MyHeight-70) style:UITableViewStylePlain];
    _topicTableView.delegate=self;
    _topicTableView.dataSource=self;
    _topicTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _topicTableView.rowHeight=200;
    [self.view addSubview:_topicTableView];
}
-(void)addLoadingView{
    _pendulum = [[PendulumView alloc] initWithFrame:self.view.bounds ballColor:ThemeColor ballDiameter:12];
    [self.view addSubview:_pendulum];
}
-(void)loadDataWithId:(NSString *)Id{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    /**
     *  请求地址协议为https  所以添加以下代码(pch中也要添加代码)
     */
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    NSString *dstUrlStr=[NSString stringWithFormat:topicUrl,Id];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:dstUrlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id result=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        /**
         *  解析数据
         */
//        ARLog(@"%@",result);
        _topicDataArray=[NSMutableArray arrayWithArray:[TopicModel objectArrayWithKeyValuesArray:result]];
        [_topicTableView reloadData];
        [_pendulum stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_pendulum stopAnimating];
        ARLog(@"数据请求失败");
    }];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _topicDataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId=@"cellId";
    TopicTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell=[[TopicTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.topicModel=_topicDataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TopicDetailViewController *detailCtrl=[[TopicDetailViewController alloc]init];
    detailCtrl.topicModel=_topicDataArray[indexPath.row];
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
