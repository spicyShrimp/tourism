//
//  SearchResultViewController.m
//  蝉游记
//
//  Created by Charles on 15/7/23.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "SearchResultViewController.h"
#import "NotesModel.h"
#import "NotesTableViewCell.h"
#import "UserViewController.h"
#import "NoteDetailViewController.h"

#import "TouristModel.h"
#import "TouristTableViewCell.h"
#import "TouristDetailViewController.h"

#import "UserModel.h"
#import "UserTableViewCell.h"
#define notesSearchUrl (@"https://chanyouji.com/api/search/trips.json?q=%@&page=%ld")
#define touristSearchUrl (@"https://chanyouji.com/api/search/attractions.json?q=%@&page=%ld")
#define userSearchUrl (@"https://chanyouji.com/api/search/users.json?q=%@&page=%ld")

@interface SearchResultViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    NYSegmentedControl *_segment;
    
    UIScrollView *_scrollView;
    
    UITableView *_notesTableView;
    NSMutableArray *_notesDataArray;
    NSInteger _currentNotesPage;
    MJRefreshFooterView *_notesFooter;
    
    UITableView *_touristTableview;
    NSMutableArray *_touristDataArray;
    NSInteger _currentTouristPage;
    MJRefreshFooterView *_touristFooter;
    
    UITableView *_userTableView;
    NSMutableArray *_userDataArray;
    NSInteger _currentUserPage;
    MJRefreshFooterView *_userFooter;
    
    PendulumView *_pendulum;
}
@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=WhiteColor;
    
    [self configSegment];
    
    [self configMainUI];
    
    [self prepareDataSource];
    
    [self addFooterRefresh];
    
    [self addLoadingView];
    
    [self loadDataWithUrl:notesSearchUrl page:_currentNotesPage forTableView:_notesTableView];
    
    [self loadDataWithUrl:touristSearchUrl page:_currentTouristPage forTableView:_touristTableview];
    
    [self loadDataWithUrl:userSearchUrl page:_currentUserPage forTableView:_userTableView];
    
}

/**
 *  选择按钮
 */
-(void)configSegment{
    _segment=[[NYSegmentedControl alloc]initWithItems:@[@"游记",@"旅行地",@"用户"]];
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
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 115, MyWidth, MyHeight-115)];
    _scrollView.delegate=self;
    _scrollView.contentSize=CGSizeMake(3*MyWidth, 0);
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
    
    
    _touristTableview=[[UITableView alloc]initWithFrame:CGRectMake(MyWidth+10, 0, MyWidth-20, _scrollView.height)];
    _touristTableview.delegate=self;
    _touristTableview.dataSource=self;
    _touristTableview.rowHeight=100;
    _touristTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_touristTableview];
    
    _userTableView=[[UITableView alloc]initWithFrame:CGRectMake(2*MyWidth+10, 0, MyWidth-20, _scrollView.height)];
    _userTableView.delegate=self;
    _userTableView.dataSource=self;
    _userTableView.rowHeight=60;
    _userTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_userTableView];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==_scrollView) {
        [UIView animateWithDuration:0.2f animations:^{
            _segment.selectedSegmentIndex=(int)(scrollView.contentOffset.x/MyWidth+0.5);
        }];
    }
}
/**
 *  初始化数据源
 */
-(void)prepareDataSource{
    _currentNotesPage=1;
    _notesDataArray=[NSMutableArray array];
    
    _currentTouristPage=1;
    _touristDataArray=[NSMutableArray array];
    
    _currentUserPage=1;
    _userDataArray=[NSMutableArray array];
}
/**
 *  刷新视图
 */
-(void)addFooterRefresh{
    _notesFooter=[MJRefreshFooterView footer];
    _notesFooter.delegate=self;
    _notesFooter.scrollView=_notesTableView;
    
    _touristFooter=[MJRefreshFooterView footer];
    _touristFooter.delegate=self;
    _touristFooter.scrollView=_touristTableview;
    
    _userFooter=[MJRefreshFooterView footer];
    _userFooter.delegate=self;
    _userFooter.scrollView=_userTableView;
}
-(void)dealloc{
    [_notesFooter free];
    [_touristFooter free];
    [_userFooter free];
}
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    if (refreshView==_notesFooter) {
        _currentNotesPage++;
        [self loadDataWithUrl:notesSearchUrl page:_currentNotesPage forTableView:_notesTableView];
    }
    if (refreshView==_touristFooter) {
        _currentTouristPage++;
        [self loadDataWithUrl:touristSearchUrl page:_currentTouristPage forTableView:_touristTableview];
    }
    if (refreshView==_userFooter) {
        _currentUserPage++;
        [self loadDataWithUrl:userSearchUrl page:_currentUserPage forTableView:_userTableView];
    }
}
/**
 *  加载视图
 */
-(void)addLoadingView{
    _pendulum = [[PendulumView alloc] initWithFrame:self.view.bounds ballColor:ThemeColor ballDiameter:12];
    [self.view addSubview:_pendulum];
}

-(void)loadDataWithUrl:(NSString *)url page:(NSInteger)page forTableView:(UITableView *)tableView{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    /**
     *  请求地址协议为https  所以添加以下代码(pch中也要添加代码)
     */
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    NSString *dstUrlStr=[NSString stringWithFormat:url,[_question stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],page];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:dstUrlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id result=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //        ARLog(@"%@",result);
        /**
         *  解析数据
         */
        if (tableView==_notesTableView) {
            [_notesDataArray addObjectsFromArray:[NotesModel objectArrayWithKeyValuesArray:result]];
            if (_notesDataArray.count==0) {
                UIImageView *cover=[[UIImageView alloc]init];
                cover.image=[UIImage imageNamed:@"EmptyPlaceholder"];
                [cover sizeToFit];
                cover.center=_notesTableView.center;
                [_notesTableView addSubview:cover];
            }
        }
        if (tableView==_touristTableview) {
            [_touristDataArray addObjectsFromArray:[TouristModel objectArrayWithKeyValuesArray:result]];
            if (_touristDataArray.count==0) {
                UIImageView *cover=[[UIImageView alloc]init];
                cover.image=[UIImage imageNamed:@"EmptyPlaceholder"];
                [cover sizeToFit];
                cover.center=_touristTableview.center;
                [_scrollView addSubview:cover];
            }
        }
        if (tableView==_userTableView) {
            [_userDataArray addObjectsFromArray:[UserModel objectArrayWithKeyValuesArray:result]];
            if (_userDataArray.count==0) {
                UIImageView *cover=[[UIImageView alloc]init];
                cover.image=[UIImage imageNamed:@"EmptyPlaceholder"];
                [cover sizeToFit];
                cover.center=_userTableView.center;
                [_userTableView addSubview:cover];
            }
        }
        [tableView reloadData];
        [_pendulum stopAnimating];
        [_notesFooter endRefreshing];
        [_touristFooter endRefreshing];
        [_userFooter endRefreshing];
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
        return _notesDataArray.count;
    }
    if (tableView==_touristTableview) {
        return _touristDataArray.count;
    }
    if (tableView==_userTableView) {
        return _userDataArray.count;
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
        cell.notesModel=_notesDataArray[indexPath.row];
        /**
         *  用户按钮点击事件
         */
        __weak SearchResultViewController *notesSearchSelf = self;
        cell.userIconBlock=^(UserModel *userModel){
            UserViewController *userCtrl=[[UserViewController alloc]init];
            userCtrl.userModel=userModel;
            [notesSearchSelf.navigationController pushViewController:userCtrl animated:YES];
        };
        return cell;
    }
    
    if (tableView==_touristTableview) {
        static NSString *touristID=@"touristID";
        TouristTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:touristID];
        if (!cell) {
            cell=[[TouristTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:touristID];
        }
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.touristModel=_touristDataArray[indexPath.row];
        return cell;
    }
    
    if (tableView==_userTableView) {
        static NSString *userID=@"userID";
        UserTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:userID];
        if (!cell) {
            cell=[[UserTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:userID];
        }
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.userModel=_userDataArray[indexPath.row];
        return cell;
    }
    
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_notesTableView) {
        NoteDetailViewController *detailCtrl=[[NoteDetailViewController alloc]init];
        detailCtrl.notesModel=_notesDataArray[indexPath.row];
        [self.navigationController pushViewController:detailCtrl animated:YES];
    }
    if (tableView==_touristTableview) {
        TouristDetailViewController *detailCtrl=[[TouristDetailViewController alloc]init];
        detailCtrl.touristModel=_touristDataArray[indexPath.row];
        [self.navigationController pushViewController:detailCtrl animated:YES];
    }
    if (tableView==_userTableView) {
        UserViewController *detailCtrl=[[UserViewController alloc]init];
        detailCtrl.userModel=_userDataArray[indexPath.row];
        [self.navigationController pushViewController:detailCtrl animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
