//
//  AddBookViewController.m
//  蝉游记
//
//  Created by Charles on 15/7/17.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "AddBookViewController.h"

@interface AddBookViewController ()<UITextFieldDelegate>
{
    UITextField *_MoneyTextFiled;
    NSString *_projectStr;
    NSString *_moneyStr;
}
@end

@implementation AddBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"添加消费记录";
    self.view.backgroundColor=WhiteColor;
    
    [self addBarButtonItem];
    
    [self prepareDataSource];
    
    [self configMainUI];
    
}
-(void)addBarButtonItem{
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(pressSave) nomalImage:[UIImage imageNamed:@"SaveBarButton"] higeLightedImage:[UIImage imageNamed:@"SaveBarButtonHighlight"]];
}
-(void)pressSave{
    _moneyStr=_MoneyTextFiled.text;
    
    //获取当前时间
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    [dict setObject:_projectStr forKey:@"project"];
    [dict setObject:_moneyStr forKey:@"money"];
    [dict setObject:dateString forKey:@"date"];
    if (_block) {
        _block(dict);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)prepareDataSource{
    _moneyStr=@"0.00";
    _projectStr=@"其他";
}
-(void)configMainUI{
    _MoneyTextFiled=[[UITextField alloc]initWithFrame:CGRectMake(10, 70, MyWidth-20, 40)];
    _MoneyTextFiled.borderStyle=UITextBorderStyleRoundedRect;
    _MoneyTextFiled.placeholder=@"请输入消费金额";
    _MoneyTextFiled.delegate=self;
    _MoneyTextFiled.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    _MoneyTextFiled.textAlignment=NSTextAlignmentRight;
    [self.view addSubview:_MoneyTextFiled];
    CGFloat btnWH=MyWidth/4;
    NSArray *titleArray=@[@"交通",@"餐饮",@"住宿",@"门票",@"购物",@"娱乐",@"电影",@"其他"];
    for (int i=0; i<titleArray.count; i++) {
        UIButton *btn=[UIButton buttonWithFrame:CGRectMake(i%4*btnWH, 110+i/4*btnWH, btnWH, btnWH) title:titleArray[i] titleColor:[UIColor blackColor] target:self action:@selector(btnClicked:)];
        btn.tag=60+i;
        if (i==7) {
            [btn setTitleColor:ThemeColor forState:UIControlStateNormal];
        }
        [self.view addSubview:btn];
    }
}
-(void)btnClicked:(UIButton *)btn{
    for (int i=60; i<68; i++) {
        UIButton *otherBtn=(UIButton *)[self.view viewWithTag:i];
        [otherBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [btn setTitleColor:ThemeColor forState:UIControlStateNormal];
    
    _projectStr=btn.currentTitle;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.text=nil;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
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
