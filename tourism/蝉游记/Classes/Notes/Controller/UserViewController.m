//
//  UserViewController.m
//  蝉游记
//
//  Created by Charles on 15/7/9.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "UserViewController.h"
#import "UserModel.h"
#import "NotesModel.h"
#import "NotesTableViewCell.h"
#import "NoteDetailViewController.h"

#import "CustomLayout.h"
#import "FavoriteCollectionViewCell.h"
#import "FavoriteModel.h"

#define userUrl (@"https://chanyouji.com/api/users/%@.json?page=1")
#define favoriteUrl (@"https://chanyouji.com/api/users/likes/%@.json?per_page=18&page=1")
@interface UserViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,CustomLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    UILabel *_tripsCountLabel;
    
    NYSegmentedControl *_segment;
    UIScrollView *_scrollView;
    
    UITableView *_tripsTableView;
    NSMutableArray *_tripsDataArray;
    
    UICollectionView *_favoriteCollectionView;
    NSMutableArray *_favoriteDataArray;
    
    PendulumView *_pendulum;
}
@end

@implementation UserViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, MyWidth, 64)];
    view.backgroundColor=ThemeColor;
    [self.view addSubview:view];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=WhiteColor;
    self.navigationItem.title=_userModel.name;
    
    [self configUserInfo];
    
    [self configSegment];
    
    [self configMainUI];
    
    [self prepareDataSource];
    
    [self addLoadingView];
    
    [self loadDataWithUrl:userUrl userId:_userModel.userId withView:_tripsTableView];
    [self loadDataWithUrl:favoriteUrl userId:_userModel.userId withView:_favoriteCollectionView];
    
}
/**
 *  用户信息
 */
-(void)configUserInfo{
    UIImageView *userIconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 75, 60, 60)];
    userIconImageView.layer.cornerRadius=30;
    userIconImageView.layer.borderWidth=2;
    userIconImageView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    userIconImageView.clipsToBounds=YES;
    [userIconImageView sd_setImageWithURL:[NSURL URLWithString:_userModel.image]];
    [self.view addSubview:userIconImageView];
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(90, 85, 150, 20)];
    nameLabel.text=_userModel.name;
    [self.view addSubview:nameLabel];
    
    _tripsCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(90, 115, 150, 20)];
    [self.view addSubview:_tripsCountLabel];
    
    [self addButton];
}
/**
 *  关注\私信按钮
 */
-(void)addButton{
    CGFloat btnW=(MyWidth-30)/2;
    NSArray *titleArray=@[@"关注",@"发私信"];
    for (int i=0; i<2; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(10+i*(btnW+10), 140, btnW, 30);
        btn.layer.cornerRadius=5;
        btn.clipsToBounds=YES;
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.backgroundColor=[UIColor colorWithRed:224.0/255 green:231.0/255 blue:299.0/255 alpha:1.0f];
        btn.tag=200+i;
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}
-(void)btnClicked:(UIButton *)btn{
    if (btn.tag==200) {
        ARLog(@"关注");
    }
    if (btn.tag==201) {
        ARLog(@"发私信");
    }
}
/**
 *  选择按钮
 */
-(void)configSegment{
    _segment=[[NYSegmentedControl alloc]initWithItems:@[@"游记",@"喜欢"]];
    _segment.frame=CGRectMake(10, 180, MyWidth-20, 30);
    _segment.segmentIndicatorBackgroundColor=WhiteColor;
    _segment.titleTextColor= [UIColor blackColor];
    _segment.selectedTitleTextColor=ThemeColor;
    [_segment addTarget:self action:@selector(segmentChaneg:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segment];
}
-(void)segmentChaneg:(NYSegmentedControl *)segment{
    [UIView animateWithDuration:0.4f animations:^{
        _scrollView.contentOffset=CGPointMake(segment.selectedSegmentIndex*MyWidth, 0);
    }];
}
/**
 *  主界面UI
 */
-(void)configMainUI{
    self.automaticallyAdjustsScrollViewInsets=NO;
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 220, MyWidth, MyHeight-220)];
    _scrollView.delegate=self;
    _scrollView.contentSize=CGSizeMake(2*MyWidth, 0);
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.pagingEnabled=YES;
    _scrollView.bounces=NO;
    [self.view addSubview:_scrollView];
    
    _tripsTableView=[[UITableView alloc]initWithFrame:CGRectMake(10, 0, MyWidth-20, _scrollView.height)];
    _tripsTableView.delegate=self;
    _tripsTableView.dataSource=self;
    _tripsTableView.rowHeight=200;
    _tripsTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_tripsTableView];
    
    //布局对象
    CustomLayout *layout=[[CustomLayout alloc]initWithSectionInsets:UIEdgeInsetsMake(5, 0, 10, 0) itemSpace:5 lineSpace:10];
    //设置代理
    layout.delegate=self;
    //创建网格视图
    _favoriteCollectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(MyWidth+10, 0, MyWidth-20, _scrollView.height) collectionViewLayout:layout];
    _favoriteCollectionView.delegate=self;
    _favoriteCollectionView.dataSource=self;
    //注册cell
    [_favoriteCollectionView registerClass:[FavoriteCollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewCellID"];
    _favoriteCollectionView.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:_favoriteCollectionView];


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
    _tripsDataArray=[NSMutableArray array];
    _favoriteDataArray=[NSMutableArray array];
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
-(void)loadDataWithUrl:(NSString *)url userId:(NSString *)userId withView:(UIView *)view{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    /**
     *  请求地址协议为https  所以添加以下代码(pch中也要添加代码)
     */
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    NSString *dstUrlStr=[NSString stringWithFormat:url,userId];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:dstUrlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id result=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//                ARLog(@"%@",result);
        /**
         *  解析数据
         */
        if (view==_tripsTableView) {
            UserModel *userModel=[UserModel objectWithKeyValues:result];
            _tripsCountLabel.text=[NSString stringWithFormat:@"%@ 篇游记",userModel.trips_count];
            [_tripsDataArray addObjectsFromArray:userModel.trips];
            [_tripsTableView reloadData];
        }
        if (view==_favoriteCollectionView) {
            [_favoriteDataArray addObjectsFromArray:[FavoriteModel objectArrayWithKeyValuesArray:result]];
            [_favoriteCollectionView reloadData];
        }
        [_pendulum stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_pendulum stopAnimating];
        ARLog(@"数据请求失败");
    }];

}
/**
 *  数据表格代理
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tripsDataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *tabelViewCellID=@"tabelViewCellID";
    NotesTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tabelViewCellID];
    if (!cell) {
        cell=[[NotesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tabelViewCellID];
    }
    cell.notesModel=_tripsDataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoteDetailViewController *detailCtrl=[[NoteDetailViewController alloc]init];
    detailCtrl.notesModel=_tripsDataArray[indexPath.row];
    detailCtrl.notesModel.user=_userModel;
    [self.navigationController pushViewController:detailCtrl animated:YES];
}

/**
 *  collectionView代理
 */
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _favoriteDataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FavoriteCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCellID" forIndexPath:indexPath];
    cell.model=_favoriteDataArray[indexPath.item];
    return cell;
}
/**
 *  CustomLayout代理
 */
-(NSInteger)numberOfColumns{
    return 2;
}
-(CGFloat)heightAtIndexPath:(NSIndexPath *)indexPath{
    FavoriteModel *model=_favoriteDataArray[indexPath.item];
    CGFloat rightH=((MyWidth-25)/2)/model.width.floatValue*model.height.floatValue;
    return rightH;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
