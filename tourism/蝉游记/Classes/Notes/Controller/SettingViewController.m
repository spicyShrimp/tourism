//
//  SettingViewController.m
//  蝉游记
//
//  Created by charles on 15/7/10.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "SettingViewController.h"
#import "AccountModel.h"
#import "LoginViewController.h"
@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_titleArray;
}
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"设置";
    self.view.backgroundColor=WhiteColor;
    _titleArray=@[@"给蝉游记提意见",@"去AppStore评价蝉游记",@"连接社交网络",@"消息推送设置",@"清除浏览缓存"];
    [self configMainUI];
}
/**
 *  主界面UI
 */
-(void)configMainUI{
    self.automaticallyAdjustsScrollViewInsets=NO;
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, MyWidth, MyHeight-64) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
}
/**
 *  数据表格代理
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 5;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId=@"cellId";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    if (indexPath.section==0) {
        cell.textLabel.text=_titleArray[indexPath.row];
        cell.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"IconSetting%li",(long)indexPath.row]];
        if (indexPath.row==4) {
            //拿到图片缓存的单例
            int size=(int)[[SDImageCache sharedImageCache]getSize];
            NSString *sizeStr;
            if (size<=1024) {
                sizeStr=[NSString stringWithFormat:@"%iB",size];
            }else if (size>1024&&size<=1024*1024){
                sizeStr=[NSString stringWithFormat:@"%gKB",size/1024*1.0];
            }else if (size>1024*1024&&size<=1024*1024*1024){
                sizeStr=[NSString stringWithFormat:@"%gMB",size/1024/1024*1.0];
            }else{
                sizeStr=[NSString stringWithFormat:@"%gGB",size/1024/1024/1024*1.0];
            }
            cell.detailTextLabel.text=sizeStr;

        }
    }
    if (indexPath.section==1) {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, MyWidth, cell.height)];
        AccountModel *model=[AccountModel objectWithKeyValues:[Default objectForKey:@"account"]];
        if (model.accountId.length>0) {
            [btn setTitle:@"退出登录" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        else{
            [btn setTitle:@"登录" forState:UIControlStateNormal];
            [btn setTitleColor:ThemeColor forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==4) {
        [[SDImageCache sharedImageCache]clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:NO];
    }
}

/**
 *  cell内按钮点击事件
 */
-(void)btnClicked:(UIButton *)btn{
    if ([btn.currentTitle isEqualToString:@"登录"]) {
        //没有账号
        LoginViewController *loginCtrl=[[LoginViewController alloc]init];
        loginCtrl.block=^(AccountModel *model){
            //已经登录成功
            [Default setObject:model.keyValues forKey:@"account"];
            [Default synchronize];
            [btn setTitle:@"退出登录" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        };
        [self.navigationController pushViewController:loginCtrl animated:YES];
    }
    else{
        //有账号
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"您确定登出账户吗?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [Default setObject:nil forKey:@"account"];
            [Default synchronize];
            [btn setTitle:@"登录" forState:UIControlStateNormal];
            [btn setTitleColor:ThemeColor forState:UIControlStateNormal];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
