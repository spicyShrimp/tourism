//
//  ChooseViewController.m
//  蝉游记
//
//  Created by Charles on 15/7/16.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "ChooseViewController.h"

@interface ChooseViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_titleArray;
    NSArray *_languageArray;
}
@end

@implementation ChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=WhiteColor;
    self.navigationItem.title=@"选择语种";
    _titleArray=@[@"中文",@"英语",@"日语",@"韩语",@"西班牙语",@"法语",@"泰语",@"阿拉伯语",@"俄罗斯语",@"葡萄牙语",@"粤语",@"德语",@"意大利语",@"荷兰语",@"希腊语"];
    _languageArray=@[@"zh",@"en",@"jp",@"kor",@"spa",@"fra",@"th",@"ara",@"ru",@"pt",@"yue",@"de",@"it",@"nl",@"el"];
    self.automaticallyAdjustsScrollViewInsets=NO;
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, MyWidth, MyHeight-64) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID=@"ID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text=_titleArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_block) {
        _block(_titleArray[indexPath.row],_languageArray[indexPath.row]);
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
