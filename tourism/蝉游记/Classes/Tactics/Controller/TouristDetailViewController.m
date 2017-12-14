//
//  TouristDetailViewController.m
//  蝉游记
//
//  Created by charles on 15/7/11.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "TouristDetailViewController.h"
#import "TouristModel.h"
#import "ToursitDetailModel.h"
#import "AttractionTripTagModel.h"
#import "AttractionContentModel.h"
#import "NotesModel.h"
#import "NoteModel.h"
#import "TouristDetailTableViewCell.h"

#define touristDetailUrl (@"https://chanyouji.com/api/attractions/%@.json?page=1")
@interface TouristDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *_cover;
    CGFloat _oldContentOffsetY;
    UITableView *_touristDetailTableView;
    NSMutableArray *_touristDetailDataArray;
    UILabel *_descLabel;
    
    PendulumView *_pendulum;
}
@end

@implementation TouristDetailViewController
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
    
    [self loadDataWithTouristDetailId:_touristModel.touristId];
}
-(void)addBarButtonItem{
   
}
-(void)configMainUI{
    self.automaticallyAdjustsScrollViewInsets=NO;
    _touristDetailTableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _touristDetailTableView.delegate=self;
    _touristDetailTableView.dataSource=self;
    _touristDetailTableView.bounces=NO;
    _touristDetailTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_touristDetailTableView];
    
    [self addHeadView];
    
    
}
-(void)addHeadView{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, MyWidth, 300)];
    
    UIImageView *showImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MyWidth, 200)];
    [showImageView sd_setImageWithURL:[NSURL URLWithString:_touristModel.image_url]];
    [view addSubview:showImageView];
    UIImageView *cover=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MyWidth, 200)];
    cover.image=[UIImage imageNamed:@"TripCellCoverMask"];
    [view addSubview:cover];
    
    UIImageView *iconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 155, 30, 30)];
    iconImageView.image=[UIImage imageNamed:@"NodeIconAttraction25nb"];
    [view addSubview:iconImageView];
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 150, MyWidth-60, 20)];
    nameLabel.textColor=[UIColor whiteColor];
    nameLabel.font=[UIFont systemFontOfSize:15];
    nameLabel.text=_touristModel.name;
    [view addSubview:nameLabel];
    
    UILabel *nameEnLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 170, MyWidth-60, 20)];
    nameEnLabel.textColor=[UIColor whiteColor];
    nameEnLabel.font=[UIFont systemFontOfSize:14];
    nameEnLabel.text=_touristModel.name_en;
    [view addSubview:nameEnLabel];
    _touristDetailTableView.tableHeaderView=view;
    
    _descLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 200, MyWidth-20, 100)];
    _descLabel.numberOfLines=0;
    _descLabel.font=[UIFont systemFontOfSize:15];
    [view addSubview:_descLabel];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _oldContentOffsetY=scrollView.contentOffset.y;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat newContentOffsetY=scrollView.contentOffset.y;
    if (newContentOffsetY>_oldContentOffsetY&&newContentOffsetY>=136) {
        _cover.hidden=NO;
        self.navigationItem.title=_touristModel.name;
        _touristDetailTableView.contentInset=UIEdgeInsetsMake(64, 0, 0, 0);
    }
    else if(newContentOffsetY<_oldContentOffsetY&&newContentOffsetY<136){
        _cover.hidden=YES;
        self.navigationItem.title=nil;
        _touristDetailTableView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

-(void)prepareDataSource{
    _touristDetailDataArray=[NSMutableArray array];
}

-(void)addLoadingView{
    _pendulum = [[PendulumView alloc] initWithFrame:self.view.bounds ballColor:[UIColor colorWithRed:18.0/255 green:135.0/255 blue:217.0/255 alpha:1.0] ballDiameter:12];
    [self.view addSubview:_pendulum];
}
-(void)loadDataWithTouristDetailId:(NSString *)touristDetailId{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    /**
     *  请求地址协议为https  所以添加以下代码(pch中也要添加代码)
     */
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    NSString *dstUrlStr=[NSString stringWithFormat:touristDetailUrl,touristDetailId];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:dstUrlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id result=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        /**
         *  解析数据
         */
//        ARLog(@"%@",result);
        ToursitDetailModel *model=[ToursitDetailModel objectWithKeyValues:result];
        _descLabel.text=model.touristDetailDesc;
        [_touristDetailDataArray addObjectsFromArray:model.attraction_trip_tags];
        [_touristDetailTableView reloadData];
        [_pendulum stopAnimating];
        _touristDetailTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_pendulum stopAnimating];
        ARLog(@"数据请求失败");
    }];
    

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _touristDetailDataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    AttractionTripTagModel *model=_touristDetailDataArray[section];
    return model.attraction_contents.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID=@"ID";
    TouristDetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[TouristDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    AttractionTripTagModel *tagModel=_touristDetailDataArray[indexPath.section];
    cell.model=tagModel.attraction_contents[indexPath.row];
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    AttractionTripTagModel *model=_touristDetailDataArray[section];
    return model.name;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AttractionTripTagModel *tagModel=_touristDetailDataArray[indexPath.section];
    return [TouristDetailTableViewCell heightWithModel:tagModel.attraction_contents[indexPath.row]];
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
