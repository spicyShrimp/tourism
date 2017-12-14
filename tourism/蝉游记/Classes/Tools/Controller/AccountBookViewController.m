//
//  AccountBookViewController.m
//  蝉游记
//
//  Created by Charles on 15/7/17.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "AccountBookViewController.h"
#import "AddBookViewController.h"
@interface AccountBookViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_bookTableView;
    NSMutableArray *_bookDataArray;
    float _sumMoney;
}
@end

@implementation AccountBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"旅行记账";
    self.view.backgroundColor=WhiteColor;
    
    [self addBarButtonItem];
    
    [self prepareDataSource];
    
    [self configMainUI];
    
}
-(void)addBarButtonItem{
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(pressAdd) nomalImage:[UIImage imageNamed:@"AddBarButton"] higeLightedImage:[UIImage imageNamed:@"AddBarButtonHighlight"]];
}
-(void)pressAdd{
    AddBookViewController *addCtrl=[[AddBookViewController alloc]init];
    addCtrl.block=^(NSDictionary *dict){
        [_bookDataArray insertObject:dict atIndex:0];
        _sumMoney+=[dict[@"money"] floatValue];
        [Default setObject:_bookDataArray forKey:@"bookDataArray"];
        [Default synchronize];
        
        [_bookTableView reloadData];
    };
    [self.navigationController pushViewController:addCtrl animated:YES];
}
-(void)prepareDataSource{
    _bookDataArray=[NSMutableArray arrayWithArray:[Default objectForKey:@"bookDataArray"]];
    for (NSDictionary *dict in _bookDataArray) {
        _sumMoney+=[dict[@"money"] floatValue];
    }
}
-(void)configMainUI{
    self.automaticallyAdjustsScrollViewInsets=NO;
    _bookTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, MyWidth, MyHeight-64)style:UITableViewStyleGrouped];
    _bookTableView.delegate=self;
    _bookTableView.dataSource=self;
    _bookTableView.rowHeight=50;
    [self.view addSubview:_bookTableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    if (section==1&&_bookDataArray.count>0) {
        return _bookDataArray.count;
    }
    if (section==2&&_bookDataArray.count>0) {
        return 1;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID=@"ID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //清除cell内容
    cell.textLabel.text=nil;
    cell.detailTextLabel.text=nil;
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    //第一组
    if(indexPath.section==0){
        if (_bookDataArray.count>0) {
            cell.textLabel.text=[NSString stringWithFormat:@"共计: %.2f 元",_sumMoney];
        }
        else{
            cell.textLabel.text=@"暂无消费记录";
        }
    }
    //第二组
    if (indexPath.section==1) {
        NSDictionary *dict=_bookDataArray[indexPath.row];
        cell.textLabel.text=[NSString stringWithFormat:@"%@ : %.2f 元",dict[@"project"],[dict[@"money"] floatValue]];
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",dict[@"date"]];
    }
    //第三组
    if (indexPath.section==2) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, MyWidth, 50)];
        label.text=@"清除消费记录";
        label.textAlignment=NSTextAlignmentCenter;
        label.textColor=[UIColor redColor];
        [cell.contentView addSubview:label];
    }
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *headStr=nil;
    if (section==0) {
        headStr=@"消费总账";
    }
    if (section==1&&_bookDataArray.count>0) {
        headStr=@"消费明细";
    }
    return headStr;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2) {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:@"你确定清除全部消费记录吗?" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //取消
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"清除" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [_bookDataArray removeAllObjects];
            _sumMoney=0;
            [Default setObject:_bookDataArray forKey:@"bookDataArray"];
            [Default synchronize];
            [_bookTableView reloadData];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        return YES;
    }
    return NO;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        NSDictionary *dict=_bookDataArray[indexPath.row];
         _sumMoney-=[dict[@"money"] floatValue];
        [_bookDataArray removeObjectAtIndex:indexPath.row];
        [Default setObject:_bookDataArray forKey:@"bookDataArray"];
        [Default synchronize];
        [_bookTableView reloadData];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
