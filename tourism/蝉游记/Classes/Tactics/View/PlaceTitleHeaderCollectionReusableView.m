//
//  PlaceTitleHeaderCollectionReusableView.m
//  蝉游记
//
//  Created by charles on 15/7/10.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "PlaceTitleHeaderCollectionReusableView.h"

@implementation PlaceTitleHeaderCollectionReusableView
{
    UIView *_line;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}
-(void)configUI{
    _line=[[UIView alloc]initWithFrame:CGRectMake(0, 24, MyWidth-20, 1)];
    _line.backgroundColor=[UIColor lightGrayColor];
    [self addSubview:_line];
    
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake((MyWidth-80)/2, 15, 60, 20)];
    _titleLabel.backgroundColor=[UIColor whiteColor];
    _titleLabel.textColor=[UIColor lightGrayColor];
    _titleLabel.font=[UIFont systemFontOfSize:14];
    _titleLabel.textAlignment=NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
}
-(void)setTitleLabel:(UILabel *)titleLabel{
    _titleLabel = titleLabel;
}
@end
