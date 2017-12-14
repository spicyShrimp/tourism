//
//  SearchViewController.m
//  蝉游记
//
//  Created by Charles on 15/7/16.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchNotesViewController.h"
#import "SearchResultViewController.h"
@interface SearchViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITextField *_searchTextField;
    NYSegmentedControl *_segment;
    
    UIScrollView *_scrollView;
    
    UITableView *_foreignTableView;
    NSMutableArray *_foreignArray;
    
    UITableView *_domesticTableView;
    NSMutableArray *_domesticArray;
    
    UITableView *_monthTableView;
    NSMutableArray *_monthArray;

}
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=WhiteColor;
    
    [self addSearchBar];
    
    [self configSegment];
    
    [self prepareDataSource];
    
    [self configMainUI];
}
/**
 *  搜索栏
 */
-(void)addSearchBar{
    _searchTextField=[[UITextField alloc]initWithFrame:CGRectMake(10, 25, MyWidth-70, 30)];
    _searchTextField.font = [UIFont systemFontOfSize:15];
    _searchTextField.placeholder = @"搜索游记、旅行地和用户";
    _searchTextField.borderStyle=UITextBorderStyleRoundedRect;
    _searchTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _searchTextField.delegate=self;
    [_searchTextField becomeFirstResponder];
    self.navigationItem.titleView=_searchTextField;
    
    UIBarButtonItem *leftBtn=[UIBarButtonItem itemWithTarget:self action:@selector(btnClicked) nomalImage:[UIImage imageNamed:@"ButtonClose_normal"] higeLightedImage:[UIImage imageNamed:@"ButtonClose_pressed"]];
    self.navigationItem.leftBarButtonItem=leftBtn;
}
-(void)btnClicked{
    [_searchTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  选择按钮
 */
-(void)configSegment{
    _segment=[[NYSegmentedControl alloc]initWithItems:@[@"国外",@"国内",@"四季"]];
    _segment.frame=CGRectMake(10, 75, MyWidth-20, 30);
    _segment.segmentIndicatorBackgroundColor=[UIColor whiteColor];
    _segment.titleTextColor= [UIColor blackColor];
    _segment.selectedTitleTextColor=[UIColor colorWithRed:53.0/255 green:152.0/255 blue:222.0/255 alpha:1.0];
    [_segment addTarget:self action:@selector(segmentChanege:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segment];
}
-(void)segmentChanege:(NYSegmentedControl *)segment{
    [UIView animateWithDuration:0.4f animations:^{
        _scrollView.contentOffset=CGPointMake(segment.selectedSegmentIndex*MyWidth, 0);
    }];
}
/**
 *  初始化数据源
 */
-(void)prepareDataSource{
    NSString *path=[[NSBundle mainBundle]pathForResource:@"Country" ofType:@"plist"];
    NSDictionary *dict=[[NSDictionary alloc]initWithContentsOfFile:path];
    _foreignArray=[NSMutableArray arrayWithArray:dict[@"other_destinations"]];
    _domesticArray=[NSMutableArray arrayWithArray:dict[@"china_destinations"]];
    _monthArray=[NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12", nil];
}
/**
 *  主界面UI
 */
-(void)configMainUI{
    self.automaticallyAdjustsScrollViewInsets=NO;
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 115, MyWidth, MyHeight-125)];
    _scrollView.delegate=self;
    _scrollView.contentSize=CGSizeMake(3*MyWidth, 0);
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.pagingEnabled=YES;
    _scrollView.bounces=NO;
    [self.view addSubview:_scrollView];
    
    _foreignTableView=[[UITableView alloc]initWithFrame:CGRectMake(10, 0, MyWidth-20, _scrollView.height)style:UITableViewStylePlain];
    _foreignTableView.delegate=self;
    _foreignTableView.dataSource=self;
    [_scrollView addSubview:_foreignTableView];
    
    _domesticTableView=[[UITableView alloc]initWithFrame:CGRectMake(MyWidth+10, 0, MyWidth-20, _scrollView.height)style:UITableViewStylePlain];
    _domesticTableView.delegate=self;
    _domesticTableView.dataSource=self;
    [_scrollView addSubview:_domesticTableView];
    
    _monthTableView=[[UITableView alloc]initWithFrame:CGRectMake(2*MyWidth+10, 0, MyWidth-20, _scrollView.height)style:UITableViewStylePlain];
    _monthTableView.delegate=self;
    _monthTableView.dataSource=self;
    [_scrollView addSubview:_monthTableView];

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==_scrollView) {
        [UIView animateWithDuration:0.2f animations:^{
            _segment.selectedSegmentIndex=(int)(scrollView.contentOffset.x/MyWidth+0.5);
        }];
    }
}
/**
 *  文本框代理
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
       return [textField resignFirstResponder];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length>0) {
        SearchResultViewController *searchResultCtrl=[[SearchResultViewController alloc]init];
        searchResultCtrl.question=textField.text;
        [self addChildViewController:searchResultCtrl];
        [self.view addSubview:searchResultCtrl.view];
    }
}
/**
 *  状态栏风格
 */
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
/**
 *  数据表格代理
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_foreignTableView) {
        return _foreignArray.count;
    }
    if (tableView==_domesticTableView) {
        return _domesticArray.count;
    }
    if (tableView==_monthTableView) {
        return _monthArray.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_foreignTableView) {
        static NSString *foreignID=@"foreignID";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:foreignID];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:foreignID];
        }
        cell.textLabel.text=((NSDictionary *)(_foreignArray[indexPath.row]))[@"name"];
        return cell;
    }
    if (tableView==_domesticTableView) {
        static NSString *domesticID=@"domesticID";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:domesticID];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:domesticID];
        }
        cell.textLabel.text=((NSDictionary *)(_domesticArray[indexPath.row]))[@"name"];
        return cell;
    }
    if (tableView==_monthTableView) {
        static NSString *monthID=@"monthID";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:monthID];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:monthID];
        }
        cell.textLabel.text=[NSString  stringWithFormat:@"%@月",_monthArray[indexPath.row]];
        return cell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_searchTextField resignFirstResponder];
    NSString *placeId=nil;
    NSString *name=nil;
    NSString *month=nil;
    if (tableView==_foreignTableView) {
        placeId=((NSDictionary *)(_foreignArray[indexPath.row]))[@"id"];
        name=((NSDictionary *)(_foreignArray[indexPath.row]))[@"name"];
    }
    if (tableView==_domesticTableView) {
        placeId=((NSDictionary *)(_domesticArray[indexPath.row]))[@"id"];
        name=((NSDictionary *)(_domesticArray[indexPath.row]))[@"name"];
    }
    if (tableView==_monthTableView) {
        month=_monthArray[indexPath.row];
    }
    SearchNotesViewController *searchNotesCtrl=[[SearchNotesViewController alloc]init];
    searchNotesCtrl.placeId=placeId;
    searchNotesCtrl.name=name;
    searchNotesCtrl.month=month;
    [self.navigationController pushViewController:searchNotesCtrl animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
