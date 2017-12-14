//
//  OfflineDetailViewController.m
//  蝉游记
//
//  Created by Charles on 15/7/24.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "OfflineDetailViewController.h"
#import "NotesModel.h"
#import "CExpandHeader.h"
#import "NoteModel.h"
#import "NodeModel.h"
#import "TripDayModel.h"
#import "OfflineNoteDetailTableViewCell.h"
#import "NoteDetailHeader.h"
#import "DBManager.h"
#define noteDetailUrl (@"https://chanyouji.com/api/trips/%@.json")
@interface OfflineDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    CExpandHeader *_header;
    UIImageView *_showImageView;
    UIView *_cover;
    CGFloat _oldContentOffsetY;
    
    UILabel *_nameLabel;
    UILabel *_timeandpicturesLabel;
    
    UIButton *_userIconButton;
    
    
    UITableView *_noteDetailTabaleView;
    NSMutableArray *_noteDetailDataArray;
    
    NSArray *_offlineNoteArray;
    
    PendulumView *_pendulum;
    
}

@end

@implementation OfflineDetailViewController

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
    
    
    _offlineNoteArray=[[DBManager sharedInstance]selectAllNote];
}
/**
 *  使用颜色生成一个图片
 */
-(UIImage *) createImageWithColor:(UIColor *)color
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

    [self configMainUI];
    
    [self prepareDataSource];
    
    [self addLoadingView];
    
    [self loadDataWithNoteId:_notesModel.notesId];
    
}

-(void)configMainUI{
    self.automaticallyAdjustsScrollViewInsets=NO;
    _noteDetailTabaleView=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _noteDetailTabaleView.delegate=self;
    _noteDetailTabaleView.dataSource=self;
    _noteDetailTabaleView.showsVerticalScrollIndicator=NO;
    _noteDetailTabaleView.sectionHeaderHeight=60;
    [self.view addSubview:_noteDetailTabaleView];
    
    
    [self addHeadView];
    
    _header = [CExpandHeader expandWithScrollView:_noteDetailTabaleView expandView:_showImageView];
}
-(void)addHeadView{
    /**
     展示大图
     */
    _showImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MyWidth, 200)];
    _showImageView.image=_notesModel.photoImage;
    UIImageView *cover=[[UIImageView alloc]initWithFrame:self.view.frame];
    cover.image=[UIImage imageNamed:@"ArticleCoverMask"];
    cover.userInteractionEnabled=YES;
    [_showImageView addSubview:cover];
    /**
     *  游记名
     */
    _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 120, 300, 30)];
    _nameLabel.textColor=[UIColor whiteColor];
    _nameLabel.font=[UIFont boldSystemFontOfSize:20];
    _nameLabel.text=_notesModel.name;
    [_showImageView addSubview:_nameLabel];
    /**
     *  时间和图片数
     */
    _timeandpicturesLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 150, 300, 30)];
    _timeandpicturesLabel.textColor=[UIColor whiteColor];
    _timeandpicturesLabel.font=[UIFont systemFontOfSize:16];
    _timeandpicturesLabel.text=[NSString stringWithFormat:@"%@ / %@天 / %@图",_notesModel.start_date,_notesModel.days,_notesModel.photos_count];
    [_showImageView addSubview:_timeandpicturesLabel];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _oldContentOffsetY=scrollView.contentOffset.y;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat newContentOffsetY=scrollView.contentOffset.y;
    if (newContentOffsetY>_oldContentOffsetY&&newContentOffsetY>-64) {
        _cover.hidden=NO;
        self.navigationItem.title=_notesModel.name;
    }
    else if(newContentOffsetY<_oldContentOffsetY&&newContentOffsetY<=-64){
        _cover.hidden=YES;
        self.navigationItem.title=nil;
    }
}
-(void)prepareDataSource{
    _noteDetailDataArray=[NSMutableArray array];
}

-(void)addLoadingView{
    _pendulum = [[PendulumView alloc] initWithFrame:self.view.bounds ballColor:ThemeColor ballDiameter:12];
    [self.view addSubview:_pendulum];
}
-(void)loadDataWithNoteId:(NSString *)noteId{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    /**
     *  请求地址协议为https  所以添加以下代码(pch中也要添加代码)
     */
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    NSString *dstUrlStr=[NSString stringWithFormat:noteDetailUrl,noteId];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:dstUrlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id result=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        /**
         *  解析数据
         */
        //        ARLog(@"%@",result);
        NotesModel *noteModel=[NotesModel objectWithKeyValues:result];
        NSArray *tripDaysArray=noteModel.trip_days;
        for (TripDayModel *tripDayModel in tripDaysArray) {
            NSArray *nodesArray=tripDayModel.nodes;
            [_noteDetailDataArray addObjectsFromArray:nodesArray];
        }
        [_noteDetailTabaleView reloadData];
        [_pendulum stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_pendulum stopAnimating];
        ARLog(@"数据请求失败");
    }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _noteDetailDataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NodeModel *node=_noteDetailDataArray[section];
    NSArray *notes=node.notes;
    return notes.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID=@"ID";
    OfflineNoteDetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[OfflineNoteDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NodeModel *nodeModel=_noteDetailDataArray[indexPath.section];
    NoteModel *noteModel=nodeModel.notes[indexPath.row];
    for (NoteModel *item in _offlineNoteArray) {
        if ([item.noteId isEqualToString:noteModel.noteId]) {
            cell.noteModel=item;
        }
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *headId=@"headId";
    NoteDetailHeader *head=[tableView dequeueReusableCellWithIdentifier:headId];
    if (!head) {
        head=[[NoteDetailHeader alloc]initWithReuseIdentifier:headId];
    }
    head.nodeModel=_noteDetailDataArray[section];
    return head;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NodeModel *nodeModel=_noteDetailDataArray[indexPath.section];
    NoteModel *noteModel=nodeModel.notes[indexPath.row];
    return [OfflineNoteDetailTableViewCell heightWithModel:noteModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
