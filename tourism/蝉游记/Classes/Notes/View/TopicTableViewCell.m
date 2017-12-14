//
//  TopicTableViewCell.m
//  蝉游记
//
//  Created by Charles on 15/7/9.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "TopicTableViewCell.h"
#import "TopicModel.h"
@implementation TopicTableViewCell
{
    UIImageView *_showImageView;
    UIImageView *_cover;
    UILabel *_nameLabel;
    UILabel *_titleLabel;
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
    /**
     展示图片
     */
    _showImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MyWidth-20, 195)];
    _showImageView.contentMode=UIViewContentModeScaleAspectFill;
    _showImageView.clipsToBounds=YES;
    [self.contentView addSubview:_showImageView];
    /**
     蒙版
     */
    _cover=[[UIImageView alloc]initWithFrame:_showImageView.frame];
    _cover.image=[UIImage imageNamed:@"PlanCoverMask"];
    _cover.userInteractionEnabled=YES;
    [self.contentView addSubview:_cover];
    /**
     专题名
     */
    _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 130, MyWidth-40, 30)];
    _nameLabel.numberOfLines=0;
    _nameLabel.font=[UIFont boldSystemFontOfSize:20.0f];
    _nameLabel.textColor=[UIColor whiteColor];
    [self.contentView addSubview:_nameLabel];
    
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 160, MyWidth-40, 20)];
    _titleLabel.textColor=[UIColor whiteColor];
    _titleLabel.font=[UIFont systemFontOfSize:15.0f];
    [self.contentView addSubview:_titleLabel];
    
}

-(void)setTopicModel:(TopicModel *)topicModel{
    _topicModel=topicModel;
    [_showImageView sd_setImageWithURL:[NSURL URLWithString:_topicModel.image_url]];
    _nameLabel.text=_topicModel.name;
    _titleLabel.text=_topicModel.title;
}
@end
