//
//  NoteDetailViewController.m
//  蝉游记
//
//  Created by Charles on 15/7/9.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "NoteDetailViewController.h"

#import "NotesModel.h"
#import "UserModel.h"
#import "TripDayModel.h"
#import "NodeModel.h"
#import "NoteModel.h"
#import "NoteDetailTableViewCell.h"
#import "NoteDetailHeader.h"
#import "CExpandHeader.h"
#import "UserViewController.h"
#import "TopicDetailViewController.h"
#import "DBManager.h"

#define noteDetailUrl (@"https://chanyouji.com/api/trips/%@.json")
@interface NoteDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
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
    
    PendulumView *_pendulum;

    UIBarButtonItem *_offlineBtn;
}
@end

@implementation NoteDetailViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /**
     *  设定导航栏为透明
     */
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[self createImageWithColor:[UIColor clearColor]]];
    /**
     蒙版(上拉时显示)
     */
    _cover=[[UIView alloc]initWithFrame:CGRectMake(0, 0, MyWidth, 64)];
    _cover.backgroundColor=ThemeColor;
    [self.view addSubview:_cover];
    _cover.hidden=YES;
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
    
    [self addBarButtonItem];
    
    [self configMainUI];
    
    [self prepareDataSource];
    
    [self addLoadingView];
    
    [self loadDataWithNoteId:_notesModel.notesId];

}
/**
 *  下载按钮
 */
-(void)addBarButtonItem{
    _offlineBtn=[UIBarButtonItem itemWithTarget:self action:@selector(pressOffline) nomalImage:[UIImage imageNamed:@"OfflineBorderBarButton"] higeLightedImage:[UIImage imageNamed:@"OfflineBorderBarButtonHighlight"]];
    self.navigationItem.rightBarButtonItem=_offlineBtn;
}
/**
 *  下载按钮事件
 */
-(void)pressOffline{
    /**
     改变按钮
     */
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    label.textColor=WhiteColor;
    label.textAlignment=NSTextAlignmentRight;
    label.text=@"下载中";
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:label];
    self.navigationItem.rightBarButtonItem=item;
    
    /**
     *  线程下载
     */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        //插入头部数据
        [[DBManager sharedInstance]insertNotesList:_notesModel];
        
        //插入游记数据
        for (NodeModel *nodeModel in _noteDetailDataArray) {
            for (NoteModel *noteModel in nodeModel.notes) {
                [[DBManager sharedInstance]insertNote:noteModel];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            /**
             *  下载完成,返回主线程修改UI
             */
            [label removeFromSuperview];
            self.navigationItem.rightBarButtonItem=_offlineBtn;
            /**
             *  通知用户下载完成
             */
            [self addNotification];
        });
    });
}
-(void)addNotification{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"下载完成" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}


/**
 *  主界面UI
 */
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
/**
 *  头部内容
 */
-(void)addHeadView{
    /**
     展示大图
     */
    _showImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MyWidth, 200)];
    [_showImageView sd_setImageWithURL:[NSURL URLWithString:_notesModel.front_cover_photo_url]];
    _showImageView.userInteractionEnabled=YES;
    UIImageView *cover=[[UIImageView alloc]initWithFrame:self.view.frame];
    cover.image=[UIImage imageNamed:@"ArticleCoverMask"];
    cover.userInteractionEnabled=YES;
    [_showImageView addSubview:cover];
    /**
     *  头像按钮
     */
    _userIconButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _userIconButton.frame=CGRectMake(10, 120, 50, 50);
    _userIconButton.layer.cornerRadius=25;
    _userIconButton.layer.borderWidth=2;
    _userIconButton.clipsToBounds=YES;
    _userIconButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [_userIconButton sd_setImageWithURL:[NSURL URLWithString:_notesModel.user.image] forState:UIControlStateNormal];
    [_userIconButton addTarget:self action:@selector(iconClicked) forControlEvents:UIControlEventTouchUpInside];
    [_showImageView addSubview:_userIconButton];
    /**
     *  游记名
     */
    _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(70, 120, 300, 20)];
    _nameLabel.textColor=[UIColor whiteColor];
    _nameLabel.font=[UIFont boldSystemFontOfSize:15];
    _nameLabel.text=_notesModel.name;
    [_showImageView addSubview:_nameLabel];
    /**
     *  时间和图片数
     */
    _timeandpicturesLabel=[[UILabel alloc]initWithFrame:CGRectMake(70, 150, 300, 20)];
    _timeandpicturesLabel.textColor=[UIColor whiteColor];
    _timeandpicturesLabel.font=[UIFont systemFontOfSize:13];
    _timeandpicturesLabel.text=[NSString stringWithFormat:@"%@ / %@天 / %@图",_notesModel.start_date,_notesModel.days,_notesModel.photos_count];
    [_showImageView addSubview:_timeandpicturesLabel];
}
/**
 *   用户按钮(跳转到用户界面)
 */
-(void)iconClicked{

    UserViewController *userCtrl=[[UserViewController alloc]init];
    userCtrl.userModel=_notesModel.user;
    [self.navigationController pushViewController:userCtrl animated:YES];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _oldContentOffsetY=scrollView.contentOffset.y;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    /**
     *  计算滑动方向和滑动偏移量,实现下拉放大,上拉出现导航栏
     */
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

/**
 *  初始化数据源
 */
-(void)prepareDataSource{
    _noteDetailDataArray=[NSMutableArray array];
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
/**
 *  数据表格代理
 */
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
    NoteDetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[NoteDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NodeModel *nodeModel=_noteDetailDataArray[indexPath.section];
    cell.noteModel=nodeModel.notes[indexPath.row];
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
    return [NoteDetailTableViewCell heightWithModel:noteModel];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
