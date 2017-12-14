//
//  OffLineViewController.m
//  蝉游记
//
//  Created by Charles on 15/7/7.
//  Copyright (c) 2015年 Charles. All rights reserved.
//

#import "OffLineViewController.h"
#import "DBManager.h"
#import "NotesModel.h"
#import "OfflineNotesTableViewCell.h"
#import "OfflineDetailViewController.h"
@interface OffLineViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_notesTableView;
    NSMutableArray *_notesDataArray;
}
@end

@implementation OffLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=WhiteColor;
    self.navigationItem.title=@"离线游记";

    [self configMainUI];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _notesDataArray=[NSMutableArray arrayWithArray:[[DBManager sharedInstance]selectAllNotesList]];
}
-(void)configMainUI{
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    _notesTableView=[[UITableView alloc]initWithFrame:CGRectMake(10, 70, MyWidth-20, MyHeight-119)];
    _notesTableView.delegate=self;
    _notesTableView.dataSource=self;
    _notesTableView.rowHeight=200;
    _notesTableView.separatorStyle=UITableViewCellSelectionStyleNone;
    [self.view addSubview:_notesTableView];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _notesDataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID=@"ID";
    OfflineNotesTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[OfflineNotesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.notesModel=_notesDataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OfflineDetailViewController *detailCtrl=[[OfflineDetailViewController alloc]init];
    detailCtrl.notesModel=_notesDataArray[indexPath.row];
    [self.navigationController pushViewController:detailCtrl animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        //数据库删除
        NotesModel *notesModel=_notesDataArray[indexPath.row];
        [[DBManager sharedInstance]deleteNotesWithId:notesModel.notesId];
        //当前数据库删除数据
        [_notesDataArray removeObjectAtIndex:indexPath.row];
        //ui刷新
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
