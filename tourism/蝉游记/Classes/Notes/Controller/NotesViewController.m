//
//  NotesViewController.m
//  蝉游记
//
//  Created by Charles on 15/7/7.
//  Copyright (c) 2015年 Charles. All rights reserved.
//

#import "NotesViewController.h"

#import "NotesModel.h"
#import "UserModel.h"
#import "NotesTableViewCell.h"
#import "TopicModel.h"
#import "TopicTableViewCell.h"
#import "NoteDetailViewController.h"
#import "UserViewController.h"
#import "TopicDetailViewController.h"
#import "SettingViewController.h"
#import "SearchViewController.h"

#define notesUrl (@"https://chanyouji.com/api/trips/featured.json?page=%ld")
#define topicUrl (@"https://chanyouji.com/api/articles.json?page=%ld")

@interface NotesViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    NYSegmentedControl *_segment;
    
    UIScrollView *_scrollView;
    
    UITableView *_notesTableView;
    NSMutableArray *_notesArray;
    NSInteger _currentNotesPage;
    MJRefreshFooterView *_notesFooter;
    
    UITableView *_topicsTableView;
    NSMutableArray *_topicsArray;
    NSInteger _currentTopicsPage;
    MJRefreshFooterView *_topicsFooter;
    
    PendulumView *_pendulum;
}
@end

@implementation NotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=WhiteColor;
    self.navigationItem.title=@"蝉游记";
    
    [self addBarButtonItem];
    
    [self configSegment];
    
    [self configMainUI];
    
    [self prepareDataSource];
    
    [self addFooterRefresh];

    [self addLoadingView];

    [self loadDataWithUrl:notesUrl page:_currentNotesPage forTableView:_notesTableView];
    [self loadDataWithUrl:topicUrl page:_currentTopicsPage forTableView:_topicsTableView];

    
}
/**
 *  导航按钮
 */
-(void)addBarButtonItem{

    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(pressSetting) nomalImage:[UIImage imageNamed:@"SettingBarButton"] higeLightedImage:[UIImage imageNamed:@"SettingBarButtonHighlight"]];
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(pressSearch) nomalImage:[UIImage imageNamed:@"SearchBarButton"] higeLightedImage:[UIImage imageNamed:@"SearchBarButtonHighlight"]];
}
/**
 *  按钮事件
 */
-(void)pressSetting{
    SettingViewController *settingCtrl=[[SettingViewController alloc]init];
    [self.navigationController pushViewController:settingCtrl animated:YES];
}
-(void)pressSearch{
    SearchViewController *searchCtrl=[[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchCtrl animated:YES];
}

/**
 *  选择按钮
 */
-(void)configSegment{
    _segment=[[NYSegmentedControl alloc]initWithItems:@[@"游记",@"专题"]];
    _segment.frame=CGRectMake(10, 75, MyWidth-20, 30);
    _segment.segmentIndicatorBackgroundColor=[UIColor whiteColor];
    _segment.titleTextColor= [UIColor blackColor];
    _segment.selectedTitleTextColor=ThemeColor;
    [_segment addTarget:self action:@selector(segmentChanege:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segment];
}
-(void)segmentChanege:(NYSegmentedControl *)segment{
    [UIView animateWithDuration:0.4f animations:^{
        _scrollView.contentOffset=CGPointMake(segment.selectedSegmentIndex*MyWidth, 0);
    }];
}
/**
 *  主界面UI
 */
-(void)configMainUI{
    self.automaticallyAdjustsScrollViewInsets=NO;
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 115, MyWidth, MyHeight-164)];
    _scrollView.delegate=self;
    _scrollView.contentSize=CGSizeMake(2*MyWidth, 0);
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.pagingEnabled=YES;
    _scrollView.bounces=NO;
    [self.view addSubview:_scrollView];
    
    _notesTableView=[[UITableView alloc]initWithFrame:CGRectMake(10, 0, MyWidth-20, _scrollView.height)];
    _notesTableView.delegate=self;
    _notesTableView.dataSource=self;
    _notesTableView.rowHeight=200;
    _notesTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_notesTableView];
    
    _topicsTableView=[[UITableView alloc]initWithFrame:CGRectMake(MyWidth+10, 0, MyWidth-20, _scrollView.height)];
    _topicsTableView.delegate=self;
    _topicsTableView.dataSource=self;
    _topicsTableView.rowHeight=200;
    _topicsTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_topicsTableView];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==_scrollView) {
        [UIView animateWithDuration:0.2f animations:^{
            _segment.selectedSegmentIndex=(int)(scrollView.contentOffset.x/MyWidth+0.5);
        }];
    }
}

/**
 *  初始化数据
 */
-(void)prepareDataSource{
    _currentNotesPage=1;
    _currentTopicsPage=1;
    _notesArray=[NSMutableArray array];
    _topicsArray=[NSMutableArray array];
}
/**
 *  刷新视图
 */
-(void)addFooterRefresh{
    _notesFooter=[MJRefreshFooterView footer];
    _notesFooter.delegate=self;
    _notesFooter.scrollView=_notesTableView;
    
    _topicsFooter=[MJRefreshFooterView footer];
    _topicsFooter.delegate=self;
    _topicsFooter.scrollView=_topicsTableView;
}
-(void)dealloc{
    [_notesFooter free];
    [_topicsFooter free];
}
/**
 *  刷新事件
 */
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    if (refreshView==_notesFooter) {
        _currentNotesPage++;
        [self loadDataWithUrl:notesUrl page:_currentNotesPage forTableView:_notesTableView];
    }
    if (refreshView==_topicsFooter) {
        _currentTopicsPage++;
        [self loadDataWithUrl:topicUrl page:_currentTopicsPage forTableView:_topicsTableView];
    }
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
-(void)loadDataWithUrl:(NSString *)url page:(NSInteger)page forTableView:(UITableView *)tableView{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    /**
     *  请求地址协议为https  所以添加以下代码(pch中也要添加代码)
     */
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    NSString *dstUrlStr=[NSString stringWithFormat:url,page];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:dstUrlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id result=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        ARLog(@"%@",result);
        /**
         *  解析数据
         */
        if (tableView==_notesTableView) {
            [_notesArray addObjectsFromArray:[NotesModel objectArrayWithKeyValuesArray:result]];
        }
        else if (tableView==_topicsTableView){
            [_topicsArray addObjectsFromArray:[TopicModel objectArrayWithKeyValuesArray:result]];
        }
        [tableView reloadData];
        [_pendulum stopAnimating];
        [_notesFooter endRefreshing];
        [_topicsFooter endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_pendulum stopAnimating];
        ARLog(@"数据请求失败");
    }];
}
/**
 *  数据表格代理
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_notesTableView) {
        return _notesArray.count;
    }
    else if(tableView==_topicsTableView){
        return _topicsArray.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (tableView==_notesTableView) {
        static NSString *notesId=@"notesId";
        NotesTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:notesId];
        if (!cell) {
            cell=[[NotesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:notesId];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.notesModel=_notesArray[indexPath.row];
        
        /**
         *  cell内部用户按钮跳转事件
         */
        __weak NotesViewController *notesSelf = self;
        cell.userIconBlock=^(UserModel *userModel){
            UserViewController *userCtrl=[[UserViewController alloc]init];
            userCtrl.userModel=userModel;
            [notesSelf.navigationController pushViewController:userCtrl animated:YES];
        };
        
        return cell;
    }
    else if (tableView==_topicsTableView){
        static NSString *topicsId=@"topicsId";
        TopicTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:topicsId];
        if (!cell) {
            cell=[[TopicTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:topicsId];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.topicModel=_topicsArray[indexPath.row];
        return cell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_notesTableView) {
        NoteDetailViewController *detailCtrl=[[NoteDetailViewController alloc]init];
        detailCtrl.notesModel=_notesArray[indexPath.row];
        [self.navigationController pushViewController:detailCtrl animated:YES];
    }
    else if (tableView==_topicsTableView){
        TopicDetailViewController *detailCtrl=[[TopicDetailViewController alloc]init];
        detailCtrl.topicModel=_topicsArray[indexPath.row];
        [self.navigationController pushViewController:detailCtrl animated:YES];
    }
    
}
@end
