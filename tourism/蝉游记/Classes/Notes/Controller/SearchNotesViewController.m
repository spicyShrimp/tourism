//
//  SearchNotesViewController.m
//  蝉游记
//
//  Created by Charles on 15/7/20.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "SearchNotesViewController.h"
#import "NotesModel.h"
#import "NotesTableViewCell.h"
#import "UserViewController.h"
#import "NoteDetailViewController.h"
#define searchPlaceUrl (@"https://chanyouji.com/api/destinations/trips/%@.json?month=0&page=%ld")
#define searchMonthUrl (@"https://chanyouji.com/api/trips/month/%@.json?month=0&page=%ld")
@interface SearchNotesViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    NSString *_url;
    NSString *_param;
    UITableView *_notesTableView;
    NSMutableArray *_notesArray;
    NSInteger _currentNotesPage;
    MJRefreshFooterView *_notesFooter;
    
    PendulumView *_pendulum;
}
@end

@implementation SearchNotesViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_name.length>0) {
        //地区
        self.navigationItem.title=[NSString stringWithFormat:@"%@游记",_name];
        _url=searchPlaceUrl;
        _param=_placeId;
    }
    else if (_month.length>0){
        //月份
        self.navigationItem.title=[NSString stringWithFormat:@"%@月游记",_month];
        _url=searchMonthUrl;
        _param=_month;
    }
    
    self.view.backgroundColor=WhiteColor;
    [self configBarButtonItem];
    
    [self configMainUI];
    
    [self prepareDataSource];
    
    [self addFooterRefresh];
    
    [self addLoadingView];
    

    [self loadDataWithUrl:_url param:_param page:_currentNotesPage];
}
/**
 *  导航栏按钮
 */
-(void)configBarButtonItem{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(pressBack) nomalImage:[UIImage imageNamed:@"BackBarButton"] higeLightedImage:[UIImage imageNamed:@"BackBarButtonHighlight"]];
}
-(void)pressBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
/**
 *  主界面UI
 */
-(void)configMainUI{
    self.automaticallyAdjustsScrollViewInsets=NO;
    _notesTableView=[[UITableView alloc]initWithFrame:CGRectMake(10, 70, MyWidth-20, MyHeight-70)];
    _notesTableView.delegate=self;
    _notesTableView.dataSource=self;
    _notesTableView.rowHeight=200;
    _notesTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_notesTableView];
}
/**
 *  初始化数据源
 */
-(void)prepareDataSource{
    _currentNotesPage=1;
    _notesArray=[NSMutableArray array];
}
/**
 *  刷新视图
 */
-(void)addFooterRefresh{
    _notesFooter=[MJRefreshFooterView footer];
    _notesFooter.delegate=self;
    _notesFooter.scrollView=_notesTableView;
}
-(void)dealloc{
    [_notesFooter free];
}
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    _currentNotesPage++;
    [self loadDataWithUrl:_url param:_param page:_currentNotesPage];
}
/**
 *  加载视图
 */
-(void)addLoadingView{
    _pendulum = [[PendulumView alloc] initWithFrame:self.view.bounds ballColor:ThemeColor ballDiameter:12];
    [self.view addSubview:_pendulum];
}
/**
 *  加载数据
 */
-(void)loadDataWithUrl:(NSString *)url param:(NSString *)param page:(NSInteger)page{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    /**
     *  请求地址协议为https  所以添加以下代码(pch中也要添加代码)
     */
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    NSString *dstUrlStr=[NSString stringWithFormat:url,param,page];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:dstUrlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id result=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //        ARLog(@"%@",result);
        /**
         *  解析数据
         */
        [_notesArray addObjectsFromArray:[NotesModel objectArrayWithKeyValuesArray:result]];
        [_notesTableView reloadData];
        [_pendulum stopAnimating];
        [_notesFooter endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_pendulum stopAnimating];
        ARLog(@"数据请求失败");
    }];

}
/**
 *  数据表格代理
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _notesArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *notesId=@"notesId";
    NotesTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:notesId];
    if (!cell) {
        cell=[[NotesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:notesId];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.notesModel=_notesArray[indexPath.row];
    /**
     *  用户按钮跳转事件
     */
    __weak SearchNotesViewController *searchNotesSelf = self;
    cell.userIconBlock=^(UserModel *userModel){
        UserViewController *userCtrl=[[UserViewController alloc]init];
        userCtrl.userModel=userModel;
        [searchNotesSelf.navigationController pushViewController:userCtrl animated:YES];
    };
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoteDetailViewController *detailCtrl=[[NoteDetailViewController alloc]init];
    detailCtrl.notesModel=_notesArray[indexPath.row];
    [self.navigationController pushViewController:detailCtrl animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
