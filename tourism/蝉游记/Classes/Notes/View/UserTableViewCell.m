//
//  UserTableViewCell.m
//  蝉游记
//
//  Created by Charles on 15/7/23.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "UserTableViewCell.h"
#import "UserModel.h"
@implementation UserTableViewCell
{
    UIImageView *_showImageView;
    UILabel *_nameLabel;
    UILabel *_lastTripLabel;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    _showImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
    _showImageView.layer.cornerRadius=20;
    _showImageView.clipsToBounds=YES;
    [self.contentView addSubview:_showImageView];
    
    _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 0, MyWidth-100, 30)];
    _nameLabel.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:_nameLabel];
    
    _lastTripLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 30, MyWidth-100, 30)];
    _lastTripLabel.font=[UIFont systemFontOfSize:12];
    [self.contentView addSubview:_lastTripLabel];
}
-(void)setUserModel:(UserModel *)userModel{
    _userModel=userModel;
    
    [_showImageView sd_setImageWithURL:[NSURL URLWithString:userModel.image]];
    
    _nameLabel.text=userModel.name;
    
    _lastTripLabel.text=userModel.latest_publish_trip_name;
}
@end
