//
//  DestViewController.m
//  蝉游记
//
//  Created by Charles on 15/7/13.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "DestViewController.h"
#import "RegionModel.h"
#import "PlaceModel.h"

#define destUrl (@"https://chanyouji.com/api/wiki/destinations.json?page=1")
@interface DestViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NYSegmentedControl *_segment;
    
    UIScrollView *_scrollView;
    
    UITableView *_foreignTableView;
    NSMutableArray *_foreignArray;
    
    UITableView *_domesticTableView;
    NSMutableArray *_domesticArray;
    
    PendulumView *_pendulum;

}

@end

@implementation DestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"选择目的地";
    self.view.backgroundColor=WhiteColor;
    
    [self addBarButtonItem];
    
    [self configSegment];
    
    [self configMainUI];
    
    [self prepaerDataSource];
    
    [self addLoadingView];
    
    [self loadData];
}
-(void)addBarButtonItem{
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(pressClose) nomalImage:[UIImage imageNamed:@"CloseBarButton"] higeLightedImage:[UIImage imageNamed:@"CloseBarButtonHighlight"]];
}
-(void)pressClose{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)configSegment{
    _segment=[[NYSegmentedControl alloc]initWithItems:@[@"国外",@"国内"]];
    _segment.frame=CGRectMake(10, 75, MyWidth-20, 30);
    _segment.segmentIndicatorBackgroundColor=[UIColor whiteColor];
    _segment.titleTextColor= [UIColor blackColor];
    _segment.selectedTitleTextColor=[UIColor colorWithRed:53.0/255 green:152.0/255 blue:222.0/255 alpha:1.0];
    [_segment addTarget:self action:@selector(segmentChanege:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segment];
}
-(void)segmentChanege:(NYSegmentedControl *)segment{
    [UIView animateWithDuration:0.4f animations:^{
        _scrollView.contentOffset=CGPointMake(segment.selectedSegmentIndex*MyWidth, 0);
    }];
}
-(void)configMainUI{
    self.automaticallyAdjustsScrollViewInsets=NO;
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 115, MyWidth, MyHeight-125)];
    _scrollView.delegate=self;
    _scrollView.contentSize=CGSizeMake(2*MyWidth, 0);
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.pagingEnabled=YES;
    _scrollView.bounces=NO;
    [self.view addSubview:_scrollView];
    
    _foreignTableView=[[UITableView alloc]initWithFrame:CGRectMake(10, 0, MyWidth-20, _scrollView.height)style:UITableViewStylePlain];
    _foreignTableView.delegate=self;
    _foreignTableView.dataSource=self;
    _foreignTableView.sectionHeaderHeight=20;
    _foreignTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_foreignTableView];
    
    _domesticTableView=[[UITableView alloc]initWithFrame:CGRectMake(MyWidth+10, 0, MyWidth-20, _scrollView.height)style:UITableViewStylePlain];
    _domesticTableView.delegate=self;
    _domesticTableView.dataSource=self;
    _domesticTableView.sectionHeaderHeight=20;
    _domesticTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_domesticTableView];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==_scrollView) {
        [UIView animateWithDuration:0.2f animations:^{
            _segment.selectedSegmentIndex=(int)(scrollView.contentOffset.x/MyWidth+0.5);
        }];
    }
}
-(void)prepaerDataSource{
    _foreignArray=[NSMutableArray array];
    _domesticArray=[NSMutableArray array];
}
-(void)addLoadingView{
    _pendulum = [[PendulumView alloc] initWithFrame:self.view.bounds ballColor:[UIColor colorWithRed:18.0/255 green:135.0/255 blue:217.0/255 alpha:1.0] ballDiameter:12];
    [self.view addSubview:_pendulum];
}

-(void)loadData{
    AFHTTPRequestOperationManager  *manager=[AFHTTPRequestOperationManager manager];
    /**
     *  请求地址协议为https  所以添加以下代码(pch中也要添加代码)
     */
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:destUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //请求成功
        id result=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//                ARLog(@"%@",result);
        NSArray *tempArray=[RegionModel objectArrayWithKeyValuesArray:result];
            NSArray *destArray=[tempArray subarrayWithRange:NSMakeRange(0, 2)];
            for (RegionModel *RegionModel in destArray) {
                for (PlaceModel *placeModel in RegionModel.destinations) {
                    [_foreignArray addObject:placeModel];
                }
            }
            destArray=[tempArray subarrayWithRange:NSMakeRange(2, 2)];
            for (RegionModel *RegionModel in destArray) {
                for (PlaceModel *placeModel in RegionModel.destinations) {
                    [_domesticArray addObject:placeModel];
                }
            }
        [_foreignTableView reloadData];
        [_domesticTableView reloadData];
        _foreignTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        _domesticTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        [_pendulum stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_pendulum stopAnimating];
        //数据请求失败
    }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger sectionNumber=0;
    if (tableView==_foreignTableView) {
        sectionNumber=_foreignArray.count;
    }
    if (tableView==_domesticTableView) {
        sectionNumber=_domesticArray.count;
    }
    return sectionNumber;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowsNumber=0;
    if (tableView==_foreignTableView) {
        PlaceModel *placeModel=_foreignArray[section];
        rowsNumber=placeModel.children.count;
    }
    if (tableView==_domesticTableView) {
        PlaceModel *placeModel=_domesticArray[section];
        rowsNumber=placeModel.children.count;
    }
    return rowsNumber;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==_foreignTableView) {
        static NSString *foreignID=@"foreignID";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:foreignID];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:foreignID];
        }
        PlaceModel *placeModel=_foreignArray[indexPath.section];
        PlaceModel *subPlaceModel=placeModel.children[indexPath.row];
        cell.textLabel.text=subPlaceModel.name_zh_cn;
        return cell;

    }
    if (tableView==_domesticTableView) {
        static NSString *domesticID=@"domesticID";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:domesticID];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:domesticID];
        }
        PlaceModel *placeModel=_domesticArray[indexPath.section];
        PlaceModel *subPlaceModel=placeModel.children[indexPath.row];
        cell.textLabel.text=subPlaceModel.name_zh_cn;
        return cell;
        
    }
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, MyWidth-20, 20)];
    if (tableView==_foreignTableView) {
        PlaceModel *placeModel=_foreignArray[section];
        label.text=placeModel.name_zh_cn;
    }
    if (tableView==_domesticTableView) {
        PlaceModel *placeModel=_domesticArray[section];
        label.text=placeModel.name_zh_cn;
    }
    label.backgroundColor=WhiteColor;
    label.textAlignment=NSTextAlignmentCenter;
    return label;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PlaceModel *placeModel=nil;
    if (tableView==_foreignTableView) {
        PlaceModel *tempModel=_foreignArray[indexPath.section];
        placeModel=tempModel.children[indexPath.row];
    }
    if (tableView==_domesticTableView) {
        PlaceModel *tempModel=_domesticArray[indexPath.section];
        placeModel=tempModel.children[indexPath.row];
    }
    if (_placeBlock) {
        _placeBlock(placeModel);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
