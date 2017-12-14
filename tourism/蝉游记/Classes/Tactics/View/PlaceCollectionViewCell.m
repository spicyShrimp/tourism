//
//  PlaceCollectionViewCell.m
//  蝉游记
//
//  Created by charles on 15/7/10.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "PlaceCollectionViewCell.h"
#import "PlaceModel.h"
@implementation PlaceCollectionViewCell
{
    UIImageView *_showImageView;
    UIImageView *_cover;
    UILabel *_nameCHLabel;
    UILabel *_nameENLabel;
    UILabel *_countLabel;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}
-(void)configUI{
    _showImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (MyWidth-30)/2, 200)];
    [self.contentView addSubview:_showImageView];
    _cover=[[UIImageView alloc]initWithFrame:_showImageView.frame];
    _cover.image=[UIImage imageNamed:@"DestinationCoverMask"];
    [self.contentView addSubview:_cover];
    
    _nameCHLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 20)];
    _nameCHLabel.textColor=[UIColor whiteColor];
    _nameCHLabel.font=[UIFont boldSystemFontOfSize:19];
    [self.contentView addSubview:_nameCHLabel];
    
    _nameENLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 30, 150, 20)];
    _nameENLabel.textColor=[UIColor whiteColor];
    [self.contentView addSubview:_nameENLabel];
    
    _countLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 170, 100, 20)];
    _countLabel.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    _countLabel.layer.cornerRadius=10;
    _countLabel.clipsToBounds=YES;
    _countLabel.font=[UIFont systemFontOfSize:14];
    _countLabel.textAlignment=NSTextAlignmentCenter;
    _countLabel.textColor=[UIColor whiteColor];
    [self.contentView addSubview:_countLabel];
}
-(void)setPlaceModel:(PlaceModel *)placeModel{
    _placeModel=placeModel;
    [_showImageView sd_setImageWithURL:[NSURL URLWithString:placeModel.image_url]];
    _nameCHLabel.text=placeModel.name_zh_cn;
    _nameENLabel.text=placeModel.name_en;
    _countLabel.text=[NSString stringWithFormat:@"旅行地 %@",placeModel.poi_count];
}
@end
