//
//  TouristTableViewCell.m
//  蝉游记
//
//  Created by charles on 15/7/11.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "TouristTableViewCell.h"
#import "TouristModel.h"
@implementation TouristTableViewCell
{
    UIImageView *_showImageView;
    UILabel *_countLabel;
    UILabel *_nameLabel;
    UILabel *_descLabel;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUI];
    }
    return  self;
}
-(void)configUI{
    _showImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 110, 80)];
    [self.contentView addSubview:_showImageView];
    
    _countLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 70, 110, 20)];
    _countLabel.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _countLabel.textColor=[UIColor whiteColor];
    _countLabel.textAlignment=NSTextAlignmentCenter;
    _countLabel.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:_countLabel];
    
    _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(120, 10, 100, 20)];
    _nameLabel.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:_nameLabel];
    
    for (UIView *subView in self.contentView.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView=(UIImageView *)subView;
            if (imageView!=_showImageView) {
                [imageView removeFromSuperview];
            }
        }
    }
    for (int i=0; i<5; i++) {
        UIImageView *emptyImageView=[[UIImageView alloc]initWithFrame:CGRectMake(120+i*12, 35, 10, 10)];
        emptyImageView.image=[UIImage imageNamed:@"StarEmpty"];
        [self.contentView addSubview:emptyImageView];
        UIImageView *fullImageView=[[UIImageView alloc]initWithFrame:emptyImageView.frame];
        fullImageView.image=[UIImage imageNamed:@"StarFull"];
        fullImageView.tag=100+i;
        [self.contentView addSubview:fullImageView];
        
    }
    
    _descLabel=[[UILabel alloc]initWithFrame:CGRectMake(120, 50, MyWidth-170, 40)];
    _descLabel.numberOfLines=0;
    _descLabel.font=[UIFont systemFontOfSize:13];
    [self.contentView addSubview:_descLabel];
    
}
-(void)setTouristModel:(TouristModel *)touristModel{
    _touristModel=touristModel;
    [_showImageView sd_setImageWithURL:[NSURL URLWithString:_touristModel.image_url]];
    _countLabel.text=[NSString stringWithFormat:@"%@ 篇游记",_touristModel.attraction_trips_count];
    _nameLabel.text=_touristModel.name;
    for (int i=0; i<5; i++) {
        UIImageView *imageView=(UIImageView *)[self.contentView viewWithTag:100+i];
        if ((int)(_touristModel.user_score.intValue+0.5)<i+1) {
            imageView.hidden=YES;
        }
        else{
            imageView.hidden=NO;
        }
    }
    _descLabel.text=_touristModel.description_summary;

}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
