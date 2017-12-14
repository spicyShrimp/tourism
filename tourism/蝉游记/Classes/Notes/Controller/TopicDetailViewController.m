//
//  TopicDetailViewController.m
//  蝉游记
//
//  Created by Charles on 15/7/9.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "TopicDetailViewController.h"
#import "TopicModel.h"
#import "ArticleModel.h"
#import "CExpandHeader.h"
#import "TopicDetailTableViewCell.h"
#define topicDetailUrl (@"https://chanyouji.com/api/articles/%@.json?page=1")
@interface TopicDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    CExpandHeader *_header;
    UIImageView *_showImageView;
    UIView *_cover;
    UILabel *_nameLabel;
    UILabel *_titleLabel;
    
    CGFloat _oldContentOffsetY;
    
    UITableView *_topicDetailTableView;
    NSMutableArray *_topicDetailDataArray;
    
    PendulumView *_pendulum;
}
@end

@implementation TopicDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /**
     *  设定导航栏为透明
     */
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[self createImageWithColor:[UIColor clearColor]]];
    /**
     导航栏蒙版
     */
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
    
    [self loadDataWithTopicId:_topicModel.topicId];
}
/**
 *  导航栏按钮()
 */
-(void)addBarButtonItem{
    
}
/**
 *  主界面UI
 */
-(void)configMainUI{
    self.automaticallyAdjustsScrollViewInsets=NO;
    _topicDetailTableView=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _topicDetailTableView.delegate=self;
    _topicDetailTableView.dataSource=self;
    _topicDetailTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _topicDetailTableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_topicDetailTableView];
    
    
    [self createHeader];
    
    _header = [CExpandHeader expandWithScrollView:_topicDetailTableView expandView:_showImageView];
}
/**
 *  头部大图
 */
-(void)createHeader{
    /**
     展示大图
     */
    _showImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MyWidth, 200)];
    [_showImageView sd_setImageWithURL:[NSURL URLWithString:_topicModel.image_url]];
    _showImageView.userInteractionEnabled=YES;
    UIImageView *cover=[[UIImageView alloc]initWithFrame:self.view.frame];
    cover.image=[UIImage imageNamed:@"ArticleCoverMask"];
    cover.userInteractionEnabled=YES;
    [_showImageView addSubview:cover];
    /**
     游记名
     */
    _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 75, MyWidth-100, 34)];
    _nameLabel.textColor=[UIColor whiteColor];
    _nameLabel.textAlignment=NSTextAlignmentCenter;
    _nameLabel.font=[UIFont boldSystemFontOfSize:25];
    _nameLabel.text=_topicModel.name;
    [_showImageView addSubview:_nameLabel];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(50, 109, MyWidth-100, 1)];
    line.backgroundColor=[UIColor whiteColor];
    [_showImageView addSubview:line];
    
    /**
     小标题
     */
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 110, MyWidth-100, 34)];
    _titleLabel.textColor=[UIColor whiteColor];
    _titleLabel.textAlignment=NSTextAlignmentCenter;
    _titleLabel.text=_topicModel.title;
    [_showImageView addSubview:_titleLabel];

}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _oldContentOffsetY=scrollView.contentOffset.y;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat newContentOffsetY=scrollView.contentOffset.y;
    if (newContentOffsetY>_oldContentOffsetY&&newContentOffsetY>-64) {
        _cover.hidden=NO;
        self.navigationItem.title=_topicModel.name;
    }
    else if(newContentOffsetY<_oldContentOffsetY&&newContentOffsetY<=-64){
        _cover.hidden=YES;
        self.navigationItem.title=nil;
    }
}
/**
 *  初始化数据源
 */
-(void)prepareDataSource{
    _topicDetailDataArray=[NSMutableArray array];
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
-(void)loadDataWithTopicId:(NSString *)topicId{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    /**
     *  请求地址协议为https  所以添加以下代码(pch中也要添加代码)
     */
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    NSString *dstUrlStr=[NSString stringWithFormat:topicDetailUrl,topicId];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:dstUrlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id result=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        /**
         *  解析数据
         */
//                ARLog(@"%@",result);
        TopicModel *topicModel=[TopicModel objectWithKeyValues:result];
        [_topicDetailDataArray addObjectsFromArray:topicModel.article_sections];
        [_topicDetailTableView reloadData];
        _topicDetailTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
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
    return _topicDetailDataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID=@"ID";
    TopicDetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[TopicDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.articleModel=_topicDetailDataArray[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [TopicDetailTableViewCell heightWithModel:_topicDetailDataArray[indexPath.row]];
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
