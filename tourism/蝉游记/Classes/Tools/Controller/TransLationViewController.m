//
//  TransLationViewController.m
//  蝉游记
//
//  Created by Charles on 15/7/16.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "TransLationViewController.h"
#import "ChooseViewController.h"
#import "TranslationModel.h"
#import "TranslationTableViewCell.h"

#define translationUrl (@"http://openapi.baidu.com/public/2.0/bmt/translate?client_id=jxmbjt5uVUhh1e9VGN2AuyuY&from=%@&q=%@&to=%@")
@interface TransLationViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    
    UIButton *_fromBtn;
    UIButton *_changeBtn;
    UIButton *_toBtn;
    
    UIView *_bgView;
    UITextField *_textField;
    
    NSString *_fromCountry;
    NSString *_toCountry;
    NSString *_question;
    
}
@end

@implementation TransLationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"语音翻译";
    self.view.backgroundColor=WhiteColor;
    
    [self prepareDataSource];
    
    [self addButton];
    
    [self configMainUI];
    

}
-(void)addButton{
    
    _fromBtn=[UIButton buttonWithFrame:CGRectMake(0, 70, (MyWidth-2)/3, 50) title:@"中文" titleColor:[UIColor blackColor] target:self action:@selector(btnClicked:)];
    [self.view addSubview:_fromBtn];
    
    _changeBtn=[UIButton buttonWithFrame:CGRectMake((MyWidth-2)/3, 70, MyWidth/3, 50) title:@"<-->" titleColor:[UIColor blackColor] target:self action:@selector(btnClicked:)];
    [self.view addSubview:_changeBtn];
    
    _toBtn=[UIButton buttonWithFrame:CGRectMake(2*MyWidth/3, 70, MyWidth/3, 50) title:@"英语" titleColor:[UIColor blackColor] target:self action:@selector(btnClicked:)];
    [self.view addSubview:_toBtn];
    
}
-(void)btnClicked:(UIButton *)btn{
    if (btn==_fromBtn) {
        ChooseViewController *chooseCtrl=[[ChooseViewController alloc]init];
        chooseCtrl.block=^(NSString *title,NSString *langauge){
            [btn setTitle:title forState:UIControlStateNormal];
            _fromCountry=langauge;
        };
        [self.navigationController pushViewController:chooseCtrl animated:YES];
        
    }
    if (btn==_changeBtn) {
        //交换语种
        NSString  *tempLanguage=_fromCountry;
        _fromCountry=_toCountry;
        _toCountry=tempLanguage;
        //交换显示
        NSString *tempTitle=_fromBtn.currentTitle;
        [_fromBtn setTitle:_toBtn.currentTitle forState:UIControlStateNormal];
        [_toBtn setTitle:tempTitle forState:UIControlStateNormal];
    }
    if (btn==_toBtn) {
        ChooseViewController *chooseCtrl=[[ChooseViewController alloc]init];
        chooseCtrl.block=^(NSString *title,NSString *langauge){
            [btn setTitle:title forState:UIControlStateNormal];
            _toCountry=langauge;
        };
        [self.navigationController pushViewController:chooseCtrl animated:YES];
    }
}
-(void)prepareDataSource{
    _dataArray=[NSMutableArray array];
    _fromCountry=@"zh";
    _toCountry=@"en";
}

-(void)configMainUI{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 120, MyWidth, MyHeight-160) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
    
    _bgView=[[UIView alloc]initWithFrame:CGRectMake(0, MyHeight-40, MyWidth, 40)];
    _bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_bgView];
    
    _textField=[[UITextField alloc]initWithFrame:CGRectMake(10, 5, MyWidth-20, 30)];
    _textField.borderStyle=UITextBorderStyleRoundedRect;
    _textField.delegate=self;
    _textField.clearsOnBeginEditing=YES;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.placeholder=@"输入要翻译的内容";
    _textField.returnKeyType = UIReturnKeyGo;
    [_bgView addSubview:_textField];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    _bgView.frame=CGRectMake(0, MyHeight-40-height,MyWidth, 40);
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    _bgView.frame=CGRectMake(0, MyHeight-40, MyWidth, 40);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
      return [_textField resignFirstResponder];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    _question=[textField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self loadDataWithFrom:_fromCountry question:_question to:_toCountry];
    textField.text=nil;
}
-(void)loadDataWithFrom:(NSString *)from question:(NSString *)question to:(NSString *)to{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSString *destUrl=[NSString stringWithFormat:translationUrl,from,question,to];
    [manager GET:destUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id result=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        ARLog(@"%@",result);
        NSArray *resultArray=result[@"trans_result"];
        for (NSDictionary *resultDict in resultArray) {
            TranslationModel *model=[TranslationModel objectWithKeyValues:resultDict];
            [_dataArray insertObject:model atIndex:0];
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //请求失败
        ARLog(@"%@",error);
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID=@"ID";
    TranslationTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[TranslationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.model=_dataArray[indexPath.row];
    return cell;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        [_dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     return [TranslationTableViewCell heightWithModel:_dataArray[indexPath.row]];
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
