//
//  TacticsViewController.m
//  蝉游记
//
//  Created by Charles on 15/7/7.
//  Copyright (c) 2015年 Charles. All rights reserved.
//

#import "TacticsViewController.h"
#import "RegionModel.h"
#import "PlaceModel.h"
#import "PlaceCollectionViewCell.h"
#import "PlaceTitleHeaderCollectionReusableView.h"

#import "PlacesTacticViewController.h"

#define foreignCellId (@"foreignCellId")
#define domesticCellId (@"domesticCellId")
#define headId (@"headerId")
#define TacticsUrl (@"https://chanyouji.com/api/destinations.json?page=1")
@interface TacticsViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    NYSegmentedControl *_segment;
    
    UIScrollView *_scrollView;
    UICollectionView *_foreignCollectionView;
    NSMutableArray *_foreignArray;
    UICollectionView *_domesticCollectionView;
    NSMutableArray *_domesticArray;
    
    PendulumView *_pendulum;
}
@end

@implementation TacticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=WhiteColor;
    self.navigationItem.title=@"旅行攻略";
    
    [self configSegment];
    
    [self configMainUI];
    
    [self addLoadingView];
    
    [self loadData];
    
}
-(void)configSegment{
    _segment=[[NYSegmentedControl alloc]initWithItems:@[@"国外",@"国内",@"附近"]];
    _segment.frame=CGRectMake(10, 75, MyWidth-20, 30);
    _segment.segmentIndicatorBackgroundColor=WhiteColor;
    _segment.titleTextColor= [UIColor blackColor];
    _segment.selectedTitleTextColor=ThemeColor;
    [_segment addTarget:self action:@selector(segmentChanege:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segment];
}
-(void)segmentChanege:(NYSegmentedControl *)segment{
    [UIView animateWithDuration:0.4f animations:^{
        _scrollView.contentOffset=CGPointMake(segment.selectedSegmentIndex*MyWidth, 0);
    }];
}-(void)configMainUI{
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 115, MyWidth, MyHeight-164)];
    _scrollView.delegate=self;
    _scrollView.contentSize=CGSizeMake(3*MyWidth, 0);
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.pagingEnabled=YES;
    _scrollView.bounces=NO;
    [self.view addSubview:_scrollView];
    
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset=UIEdgeInsetsMake(10, 0, 10, 0);
    layout.itemSize=CGSizeMake((MyWidth-30)/2, 200);
    layout.minimumInteritemSpacing=5;
    layout.minimumLineSpacing=10;
    [layout setHeaderReferenceSize:CGSizeMake(MyWidth-20, 41)];
    //创建网格视图
    _foreignCollectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(10, 0, MyWidth-20, _scrollView.height) collectionViewLayout:layout];
    _foreignCollectionView.delegate=self;
    _foreignCollectionView.dataSource=self;
    _foreignCollectionView.backgroundColor=[UIColor whiteColor];
    //注册cell
    [_foreignCollectionView registerClass:[PlaceCollectionViewCell class] forCellWithReuseIdentifier:foreignCellId];
    [_foreignCollectionView registerClass:[PlaceTitleHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headId];
    [_scrollView addSubview:_foreignCollectionView];
    
    
    
    
    UICollectionViewFlowLayout *layout2=[[UICollectionViewFlowLayout alloc]init];
    layout2.sectionInset=UIEdgeInsetsMake(10, 0, 10, 0);
    layout2.itemSize=CGSizeMake((MyWidth-30)/2, 200);
    layout2.minimumInteritemSpacing=5;
    layout2.minimumLineSpacing=10;
    [layout2 setHeaderReferenceSize:CGSizeMake(MyWidth-20, 41)];
    //创建网格视图
    _domesticCollectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(MyWidth+10, 0, MyWidth-20, _scrollView.height) collectionViewLayout:layout2];
    _domesticCollectionView.delegate=self;
    _domesticCollectionView.dataSource=self;
    _domesticCollectionView.backgroundColor=[UIColor whiteColor];
    //注册cell
    [_domesticCollectionView registerClass:[PlaceCollectionViewCell class] forCellWithReuseIdentifier:domesticCellId];
    [_domesticCollectionView registerClass:[PlaceTitleHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headId];
    [_scrollView addSubview:_domesticCollectionView];
    
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==_scrollView) {
        [UIView animateWithDuration:0.2f animations:^{
            _segment.selectedSegmentIndex=(int)(scrollView.contentOffset.x/MyWidth+0.5);
        }];
    }
}
-(void)addLoadingView{
    _pendulum = [[PendulumView alloc] initWithFrame:self.view.bounds ballColor:ThemeColor ballDiameter:12];
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
    [manager GET:TacticsUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //请求成功
        id result=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        ARLog(@"%@",result);
        NSArray *tempArray=[RegionModel objectArrayWithKeyValuesArray:result];
        _foreignArray=[NSMutableArray arrayWithArray:[tempArray subarrayWithRange:NSMakeRange(0, 3)]];
        _domesticArray=[NSMutableArray arrayWithArray:[tempArray subarrayWithRange:NSMakeRange(3, 2)]];
        [_foreignCollectionView reloadData];
        [_domesticCollectionView reloadData];
        [_pendulum stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_pendulum stopAnimating];
        //数据请求失败
    }];
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (collectionView==_foreignCollectionView) {
        return _foreignArray.count;
    }
    else if(collectionView==_domesticCollectionView){
        return _domesticArray.count;
    }
    return 0;
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView==_foreignCollectionView) {
        return ((RegionModel *)_foreignArray[section]).destinations.count;
    }
    if (collectionView==_domesticCollectionView) {
        return ((RegionModel *)_domesticArray[section]).destinations.count;
    }
    return 0;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==_foreignCollectionView) {
        PlaceCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:foreignCellId forIndexPath:indexPath];
        RegionModel *regionModel=_foreignArray[indexPath.section];
        cell.placeModel=regionModel.destinations[indexPath.item];
        return cell;
    }
    if (collectionView==_domesticCollectionView) {
        PlaceCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:domesticCellId forIndexPath:indexPath];
        RegionModel *regionModel=_domesticArray[indexPath.section];
        cell.placeModel=regionModel.destinations[indexPath.item];
        return cell;
    }
    return nil;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    PlaceTitleHeaderCollectionReusableView *head=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headId forIndexPath:indexPath];
    if (collectionView==_foreignCollectionView) {
        NSArray *array= @[@"亚洲",@"欧洲",@"其它洲"];
        head.titleLabel.text = array[indexPath.section];
    }
    else if (collectionView==_domesticCollectionView){
        NSArray *array= @[@"台港澳",@"大陆"];
        head.titleLabel.text = array[indexPath.section];
    }
    return head;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    RegionModel *regionModel=nil;
    PlaceModel *placeModel=nil;
    if (collectionView==_foreignCollectionView) {
        regionModel=_foreignArray[indexPath.section];
    }
    else if (collectionView==_domesticCollectionView){
        regionModel=_domesticArray[indexPath.section];
    }
    placeModel=regionModel.destinations[indexPath.item];
    
    PlacesTacticViewController *placesTCtrl=[[PlacesTacticViewController alloc]init];
    placesTCtrl.placeModel=placeModel;
    [self.navigationController pushViewController:placesTCtrl animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
