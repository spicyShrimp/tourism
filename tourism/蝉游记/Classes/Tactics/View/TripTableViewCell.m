//
//  TripTableViewCell.m
//  蝉游记
//
//  Created by charles on 15/7/11.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "TripTableViewCell.h"
#import "TripModel.h"
@implementation TripTableViewCell
{
    UIImageView *_showImageView;
    UILabel *_nameLabel;
    UILabel *_timeAndCountLabel;
    UILabel *_descLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUI];
    }
    return self;
}
-(void)configUI{
    _showImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MyWidth-20, 150)];
    [self.contentView addSubview:_showImageView];
    
    _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 90, 150, 30)];
    _nameLabel.textColor=[UIColor whiteColor];
    _nameLabel.font=[UIFont boldSystemFontOfSize:18];
    [self.contentView addSubview:_nameLabel];
    
    _timeAndCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 120, 150, 20)];
    _timeAndCountLabel.textColor=[UIColor whiteColor];
    _timeAndCountLabel.font=[UIFont systemFontOfSize:15];
    [self.contentView addSubview:_timeAndCountLabel];
    
    _descLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 150, MyWidth-20, 45)];
    _descLabel.font=[UIFont systemFontOfSize:12];
    _descLabel.numberOfLines=0;
    [self.contentView addSubview:_descLabel];
}
-(void)setTripModel:(TripModel *)tripModel{
    _tripModel=tripModel;
    [_showImageView sd_setImageWithURL:[NSURL URLWithString:_tripModel.image_url]];
    _nameLabel.text=_tripModel.name;
    _timeAndCountLabel.text=[NSString stringWithFormat:@"%@ 天 / %@ 个旅游地",_tripModel.plan_days_count,_tripModel.plan_nodes_count];
    _descLabel.text=_tripModel.tripDesc;
}
- (void)awakeFromNib {
    // Initialization codeimage_url
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
