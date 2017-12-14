//
//  PlaceTableViewCell.m
//  蝉游记
//
//  Created by charles on 15/7/11.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "PlaceTableViewCell.h"
#import "PlaceModel.h"
@implementation PlaceTableViewCell
{
    UIImageView *_showImageView;
    UIImageView *_cover;
    UILabel *_nameCHLabel;
    UILabel *_nameENLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUI];
    }
    return self;
}
-(void)configUI{
    _showImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MyWidth-20, 180)];
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
    
    for (UIView *subView in self.contentView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            [subView removeFromSuperview];
        }
        if ([subView isKindOfClass:[UILabel class]]) {
            UILabel *label=(UILabel *)subView;
            if (label!=_nameCHLabel&&label!=_nameENLabel) {
                [label removeFromSuperview];
            }
        }
    }
    NSArray *titleArray=@[@"攻略",@"行程",@"旅游地",@"专题"];
    CGFloat btnW=(MyWidth-20)/4;
    for (int i=0; i<4; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(i*btnW, 215, btnW, 20)];
        label.text=titleArray[i];
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:13];
        [self.contentView addSubview:label];
        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(i*btnW, 180, btnW, 48);
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"DestinationMenuIcon%i",i]] forState:UIControlStateNormal];
        btn.tag=100+i;
        [btn addTarget:self action:@selector(pressItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
    }
}
-(void)setPlaceModel:(PlaceModel *)placeModel{
    _placeModel=placeModel;
    [_showImageView sd_setImageWithURL:[NSURL URLWithString:_placeModel.image_url]];
    _nameCHLabel.text=placeModel.name_zh_cn;
    _nameENLabel.text=placeModel.name_en;
}

-(void)pressItem:(UIButton *)btn{
    if (_itemBlock) {
        _itemBlock(btn.tag-100,_placeModel);
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
