//
//  TripDetailTableViewCell.m
//  蝉游记
//
//  Created by Charles on 15/7/16.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "TripDetailTableViewCell.h"
#import "PlanNodeModel.h"
@implementation TripDetailTableViewCell
{
    UILabel *_nodeLabel;
    UIImageView *_showImageView;
    UILabel *_tipsLabel;
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
    _nodeLabel=[[UILabel alloc]init];
    [self.contentView addSubview:_nodeLabel];
    
    _showImageView=[[UIImageView alloc]init];
    [self.contentView addSubview:_showImageView];
    
    _tipsLabel=[[UILabel alloc]init];
    _tipsLabel.font=[UIFont systemFontOfSize:15];
    [self.contentView addSubview:_tipsLabel];
}
-(void)setPlanNodeModel:(PlanNodeModel *)planNodeModel{
    _planNodeModel=planNodeModel;
    _nodeLabel.frame=CGRectMake(10, 10, MyWidth-20, 20);
    _nodeLabel.text=planNodeModel.entry_name;
    
    CGFloat imageY=40;
    if (planNodeModel.image_url.length>0) {
        _showImageView.hidden=NO;
        _showImageView.frame=CGRectMake(10, imageY, MyWidth-20, 200);
        [_showImageView sd_setImageWithURL:[NSURL URLWithString:planNodeModel.image_url]];
        imageY=imageY+210;
    }
    else{
        _showImageView.hidden=YES;
    }
    //求文字高度
    CGSize size=[planNodeModel.tips boundingRectWithSize:CGSizeMake(MyWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    _tipsLabel.frame=CGRectMake(10, imageY, MyWidth-20, size.height);
    _tipsLabel.numberOfLines=0;
    _tipsLabel.text=planNodeModel.tips;
}
+(CGFloat)heightWithModel:(PlanNodeModel *)model{
    CGFloat height=10;
    height=height+20+10;
    if (model.image_url.length>0) {
        height=height+200+10;
    }
    CGSize size=[model.tips boundingRectWithSize:CGSizeMake(MyWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    height=height+size.height+10;
    return height;
}
@end
