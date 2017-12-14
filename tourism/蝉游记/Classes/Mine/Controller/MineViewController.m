//
//  MineViewController.m
//  蝉游记
//
//  Created by Charles on 15/7/7.
//  Copyright (c) 2015年 Charles. All rights reserved.
//

#import "MineViewController.h"
#import "LoginViewController.h"
#import "AccountModel.h"
#import "UserModel.h"
#import "NoteDetailViewController.h"
#import "NotesTableViewCell.h"
#import "NotesModel.h"
#define tripsUrl (@"https://chanyouji.com/api/users/%@.json?page=1")
@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *_userIconImageView;
    UILabel *_nameLabel;
    UILabel *_tripCountLabel;
    
    UITableView *_tripsTableView;
    NSMutableArray *_tripsDataArray;
}
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=WhiteColor;
    self.navigationItem.title=@"我的旅行";
    
    _tripsDataArray=[NSMutableArray array];
    
    [self configMainUI];
}
-(void)viewWillAppear:(BOOL)animated{
    AccountModel *model=[AccountModel objectWithKeyValues:[Default objectForKey:@"account"]];
    if (model.accountId.length>0) {
        //用户存在
        [_userIconImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
        _nameLabel.text=model.name;
        [self loadDataWithUserId:model.accountId];
        [[self.view viewWithTag:100] removeFromSuperview];
        
    }
    else {
        //用户不存在
        LoginViewController *loginCtrl=[[LoginViewController alloc]init];
        loginCtrl.block=^(AccountModel *model){
            //获得登录信息;
            //修改主界面UI
            [_userIconImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
            _nameLabel.text=model.name;
            [self loadDataWithUserId:model.accountId];
            [[self.view viewWithTag:100] removeFromSuperview];
        };
        [self addChildViewController:loginCtrl];
        loginCtrl.view.tag=100;
        [self.view addSubview:loginCtrl.view];
    }
}

-(void)configMainUI{
    _userIconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 75, 60, 60)];
    _userIconImageView.layer.cornerRadius=30;
    _userIconImageView.clipsToBounds=YES;
    [self.view addSubview:_userIconImageView];
    
    _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 80, 150, 20)];
    [self.view addSubview:_nameLabel];
    
    _tripCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 110, 150, 20)];
    [self.view addSubview:_tripCountLabel];
    
    _tripsTableView=[[UITableView alloc]initWithFrame:CGRectMake(10, 150, MyWidth-20, MyHeight-199)];
    _tripsTableView.delegate=self;
    _tripsTableView.dataSource=self;
    _tripsTableView.rowHeight=200;
    _tripsTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tripsTableView];
}

-(void)loadDataWithUserId:(NSString *)userId{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    /**
     *  请求地址协议为https  所以添加以下代码(pch中也要添加代码)
     */
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSString *dstUrl=[NSString stringWithFormat:tripsUrl,userId];
    [manager GET:dstUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id result=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (_tripsDataArray.count>0) {
            return ;
        }
        /**
         *  解析数据
         */
        UserModel *userModel=[UserModel objectWithKeyValues:result];
        _tripCountLabel.text=[NSString stringWithFormat:@"%@ 篇游记",userModel.trips_count];
        [_tripsDataArray addObjectsFromArray:userModel.trips];
        [_tripsTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ARLog(@"数据请求失败");
    }];
}
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
    NotesModel *notesModel=_tripsDataArray[indexPath.row];
    detailCtrl.notesModel=notesModel;
    AccountModel *accountModel=[AccountModel objectWithKeyValues:[Default objectForKey:@"account"]];
    UserModel *userModel=[[UserModel alloc]init];
    userModel.userId=accountModel.accountId;
    userModel.name=accountModel.name;
    userModel.image=accountModel.image;
    detailCtrl.notesModel.user=userModel;
    [self.navigationController pushViewController:detailCtrl animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
