//
//  LoginViewController.m
//  蝉游记
//
//  Created by Charles on 15/7/20.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AccountModel.h"

#define loginUrl (@"https://chanyouji.com/api/tokens")
@interface LoginViewController ()<UITextFieldDelegate>
{
    UITextField *_userTextField;
    UITextField *_psdTextField;
    
    PendulumView *_pendulum;
    
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=WhiteColor;
    self.navigationItem.title=@"登录";
    
    [self addLoginButton];
    
    [self addLoginTextField];

}
-(void)addLoginButton{
    
    CGFloat btnW=(MyWidth-30)/2;
    for (int i=0; i<2; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(10+i*(btnW+10), 80, btnW, 40);
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"LoginButton%d",i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"LoginButtonHighlight%d",i]] forState:UIControlStateHighlighted];
        [self.view addSubview:btn];
    }
}
-(void)addLoginTextField{
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 150, MyWidth, 20)];
    label.text=@"或直接使用邮箱登录";
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:label];
    
    _userTextField=[[UITextField alloc]initWithFrame:CGRectMake(10, 170, MyWidth-20, 40)];
    _userTextField.delegate=self;
    _userTextField.placeholder=@"电子邮箱";
    _userTextField.keyboardType=UIKeyboardTypeEmailAddress;
    _userTextField.returnKeyType=UIReturnKeyNext;
    _userTextField.borderStyle=UITextBorderStyleRoundedRect;
    [self.view addSubview:_userTextField];
    
    _psdTextField=[[UITextField alloc]initWithFrame:CGRectMake(10, 220, MyWidth-20, 40)];
    _psdTextField.delegate=self;
    _psdTextField.placeholder=@"密码";
    _psdTextField.secureTextEntry=YES;
    _psdTextField.returnKeyType=UIReturnKeyGo;
    _psdTextField.borderStyle=UITextBorderStyleRoundedRect;
    [self.view addSubview:_psdTextField];
    
    UIButton *resignBtn=[UIButton buttonWithFrame:CGRectMake(MyWidth-150, 270, 150, 30) title:@"没有账号? 立即注册 >" titleColor:ThemeColor target:self action:@selector(addResign)];
    resignBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:resignBtn];
    
}
-(void)addResign{
    RegisterViewController *registerCtrl=[[RegisterViewController alloc]init];
    registerCtrl.block=^(AccountModel *model){
        if (_block) {
            _block(model);
            [Default setObject:model.keyValues forKey:@"account"];
            [Default synchronize];
        }
    };
    [self.navigationController pushViewController:registerCtrl animated:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==_userTextField) {
        [_userTextField resignFirstResponder];
        [_psdTextField becomeFirstResponder];
    }
    if (textField==_psdTextField) {
        if (_userTextField.text.length>0&&_psdTextField.text.length>0) {
            [self addLoadingView];
            [self userLogin];
        }
        [_psdTextField resignFirstResponder];
    }
    return YES;
}

-(void)addLoadingView{
    _pendulum = [[PendulumView alloc] initWithFrame:self.view.bounds ballColor:ThemeColor ballDiameter:12];
    [self.view addSubview:_pendulum];
}
-(void)userLogin{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    NSDictionary *parmters=@{@"email":_userTextField.text,@"password":_psdTextField.text};
    [manager POST:loginUrl parameters:parmters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id result=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        ARLog(@"%@",result);
        AccountModel *model=[AccountModel objectWithKeyValues:result];
        [_pendulum stopAnimating];
        __weak LoginViewController *loginSelf=self;
        if (_block) {
            _block(model);
            [Default setObject:model.keyValues forKey:@"account"];
            [Default synchronize];            
            [loginSelf.navigationController popViewControllerAnimated:YES];
        }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_pendulum stopAnimating];
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"登录失败" message:@"请检测网络状态或邮箱密码是否正确" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }];

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
