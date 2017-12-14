//
//  RegisterViewController.m
//  蝉游记
//
//  Created by Charles on 15/7/20.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "RegisterViewController.h"
#import "AccountModel.h"

#define registerUrl (@"https://chanyouji.com/api/users.json")
@interface RegisterViewController ()<UITextFieldDelegate>
{
    UITextField *_userTextField;
    UITextField *_psdTextField;
}
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"注册";
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self configMainUI];
}
-(void)configMainUI{
    self.automaticallyAdjustsScrollViewInsets=NO;
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

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==_userTextField) {
        [_userTextField resignFirstResponder];
        [_psdTextField becomeFirstResponder];
    }
    if (textField==_psdTextField) {
        [_psdTextField resignFirstResponder];
        if (_userTextField.text.length>0&&_psdTextField.text.length>0) {
            [self registerUser];
        }
    }
    return YES;
}
-(void)registerUser{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    /**
     *  请求地址协议为https  所以添加以下代码(pch中也要添加代码)
     */
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    NSDictionary *parmters=@{@"email":_userTextField.text,@"password":_psdTextField.text};
    [manager POST:registerUrl parameters:parmters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id result=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        ARLog(@"%@",result);
        AccountModel *model=[AccountModel objectWithKeyValues:result];
        __weak RegisterViewController *registerSelf=self;
        if (_block) {
            _block(model);
            [registerSelf.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"注册失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
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
