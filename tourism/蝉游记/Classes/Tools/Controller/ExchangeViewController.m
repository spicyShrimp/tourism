//
//  ExchangeViewController.m
//  蝉游记
//
//  Created by Charles on 15/7/13.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "ExchangeViewController.h"
#import "PlaceInfoModel.h"

#define exchangeUrl (@"http://chanyouji.com/api/currency_exchanges.json")
@interface ExchangeViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}
@end

@implementation ExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"实时汇率";
    self.view.backgroundColor=WhiteColor;
    
    [self prepareDataSource];
    [self loadData];
    
    [self configMainUI];
    
}
-(void)configMainUI{
    self.automaticallyAdjustsScrollViewInsets=NO;
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, MyWidth, MyHeight-64) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.rowHeight=60;
    [self.view addSubview:_tableView];
}
-(void)prepareDataSource{
    _dataArray=[NSMutableArray array];
}

-(void)loadData{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:exchangeUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id result=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        ARLog(@"%@",result);
        if ([result isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in result) {
                if ([dict[@"currency_from"] isEqualToString:_placeInfoModel.currency_code]) {
                    NSString *rate=dict[@"exchange_rate"];
                    [_dataArray addObject:rate];
                }
                if ([dict[@"currency_to"] isEqualToString:_placeInfoModel.currency_code]) {
                    NSString *rate=dict[@"exchange_rate"];
                    [_dataArray addObject:rate];
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ARLog(@"%@",error);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId=@"cellId";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //移除子视图
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (indexPath.row==0) {
        cell.imageView.image=[UIImage imageNamed:_placeInfoModel.currency_code];
        cell.textLabel.text=[NSString stringWithFormat:@"%@(%@)",_placeInfoModel.currency_code,_placeInfoModel.currency_display];
    }
    if (indexPath.row==1) {
        cell.imageView.image=[UIImage imageNamed:@"CNY"];
        cell.textLabel.text=@"CNY(元)";
    }
    if (indexPath.row==2) {
        cell.imageView.image=[UIImage imageNamed:@"USD"];
        cell.textLabel.text=@"USD(美元)";
    }
    if (indexPath.row==3) {
        cell.imageView.image=[UIImage imageNamed:@"EUR"];
        cell.textLabel.text=@"EUR(欧元)";
    }
    //创建TextFiled
    UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(MyWidth/2-10, 10, MyWidth/2, 40)];
    textField.delegate=self;
    textField.textAlignment=NSTextAlignmentRight;
    textField.font=[UIFont boldSystemFontOfSize:18];
    textField.tag=indexPath.row+100;
    textField.placeholder=@"0.00";
    textField.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    [cell.contentView addSubview:textField];
    return cell;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
       return [textField resignFirstResponder];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.text=nil;
    textField.textColor=[UIColor colorWithRed:18.0/255 green:135.0/255 blue:217.0/255 alpha:1.0];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:textField];
}
-(void)textChange:(NSNotification *)noti{
    UITextField *textFiled1=(UITextField *)[self.view viewWithTag:100];
    UITextField *textFiled2=(UITextField *)[self.view viewWithTag:101];
    UITextField *textFiled3=(UITextField *)[self.view viewWithTag:102];
    UITextField *textFiled4=(UITextField *)[self.view viewWithTag:103];
    
    UITextField *notiTextField=[noti object];
    if (notiTextField==textFiled1) {
        textFiled2.text=[NSString stringWithFormat:@"%.2f",[notiTextField.text floatValue]*[_dataArray[0] floatValue]];
        textFiled3.text=[NSString stringWithFormat:@"%.2f",[notiTextField.text floatValue]*[_dataArray[1] floatValue]];
        textFiled4.text=[NSString stringWithFormat:@"%.2f",[notiTextField.text floatValue]*[_dataArray[2] floatValue]];
        
        textFiled2.textColor=[UIColor blackColor];
        textFiled3.textColor=[UIColor blackColor];
        textFiled4.textColor=[UIColor blackColor];
        
    }
    if (notiTextField==textFiled2) {
        textFiled1.text=[NSString stringWithFormat:@"%.2f",[notiTextField.text floatValue]*[_dataArray[3] floatValue]];
        textFiled3.text=[NSString stringWithFormat:@"%.2f",[notiTextField.text floatValue]*[_dataArray[3] floatValue]*[_dataArray[1] floatValue]];
        textFiled4.text=[NSString stringWithFormat:@"%.2f",[notiTextField.text floatValue]*[_dataArray[3] floatValue]*[_dataArray[2]floatValue]];
        
        textFiled1.textColor=[UIColor blackColor];
        textFiled3.textColor=[UIColor blackColor];
        textFiled4.textColor=[UIColor blackColor];
    }
    if (notiTextField==textFiled3) {
        textFiled1.text=[NSString stringWithFormat:@"%.2f",[notiTextField.text floatValue]*[_dataArray[4] floatValue]];
        textFiled2.text=[NSString stringWithFormat:@"%.2f",[notiTextField.text floatValue]*[_dataArray[4] floatValue]*[_dataArray[0] floatValue]];
        textFiled4.text=[NSString stringWithFormat:@"%.2f",[notiTextField.text floatValue]*[_dataArray[4] floatValue]*[_dataArray[2] floatValue]];
        
        textFiled1.textColor=[UIColor blackColor];
        textFiled2.textColor=[UIColor blackColor];
        textFiled4.textColor=[UIColor blackColor];
    }
    if (notiTextField==textFiled4) {
        textFiled1.text=[NSString stringWithFormat:@"%.2f",[notiTextField.text floatValue]*[_dataArray[5] floatValue]];
        textFiled2.text=[NSString stringWithFormat:@"%.2f",[notiTextField.text floatValue]*[_dataArray[5] floatValue]*[_dataArray[0] floatValue]];
        textFiled3.text=[NSString stringWithFormat:@"%.2f",[notiTextField.text floatValue]*[_dataArray[5] floatValue]*[_dataArray[1] floatValue]];
        
        textFiled1.textColor=[UIColor blackColor];
        textFiled2.textColor=[UIColor blackColor];
        textFiled3.textColor=[UIColor blackColor];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
