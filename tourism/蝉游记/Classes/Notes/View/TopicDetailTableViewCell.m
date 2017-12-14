//
//  TopicDetailTableViewCell.m
//  蝉游记
//
//  Created by Charles on 15/7/15.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "TopicDetailTableViewCell.h"
#import "ArticleModel.h"
@implementation TopicDetailTableViewCell
{
    UIView *_titleTipView;
    UILabel *_titleLabel;
    UIImageView *_showImageView;
    UILabel *_descLabel;
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
    _titleTipView=[[UIView alloc]init];
    _titleTipView.backgroundColor=[UIColor colorWithRed:18.0/255 green:135.0/255 blue:217.0/255 alpha:1.0];
    [self.contentView addSubview:_titleTipView];
    _titleLabel=[[UILabel alloc]init];
    _titleLabel.font=[UIFont boldSystemFontOfSize:20];
    [self.contentView addSubview:_titleLabel];
    
    _showImageView=[[UIImageView alloc]init];
    [self.contentView addSubview:_showImageView];
    
    _descLabel=[[UILabel alloc]init];
    _descLabel.numberOfLines=0;
    _descLabel.font=[UIFont systemFontOfSize:15];
    [self.contentView addSubview:_descLabel];
}


-(void)setArticleModel:(ArticleModel *)articleModel{
    _articleModel=articleModel;
    CGFloat contentOffsetY=10;
    if (articleModel.title.length>0) {
        _titleTipView.hidden=NO;
        _titleLabel.hidden=NO;
        //求文本大小
        _titleTipView.frame=CGRectMake(10, contentOffsetY, 5, 20);
        _titleLabel.frame=CGRectMake(20, contentOffsetY, MyWidth-20, 20);
        _titleLabel.text=articleModel.title;
        contentOffsetY=contentOffsetY+20+10;
    }
    else{
        _titleTipView.hidden=YES;
        _titleLabel.hidden=YES;
    }
    
    if (articleModel.image_url.length>0) {
        _showImageView.hidden=NO;
        CGFloat rightH=(MyWidth-20)/articleModel.image_width.floatValue*articleModel.image_height.floatValue;
        _showImageView.frame=CGRectMake(10, contentOffsetY, MyWidth-20, rightH);
        [_showImageView sd_setImageWithURL:[NSURL URLWithString:articleModel.image_url] placeholderImage:[UIImage imageNamed:@"MyTripCellPhotoPlaceholder"]];
        contentOffsetY=contentOffsetY+rightH+10;
    }
    else{
        _showImageView.hidden=YES;
    }
    if (articleModel.articleDesc.length>0) {
        _descLabel.hidden=NO;
        //求文本大小
        CGSize size=[articleModel.articleDesc boundingRectWithSize:CGSizeMake(MyWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        _descLabel.frame=CGRectMake(10, contentOffsetY, MyWidth-20, size.height);
        _descLabel.text=articleModel.articleDesc;
    }
    else{
        _descLabel.hidden=YES;
    }
}

+(CGFloat)heightWithModel:(ArticleModel *)articleModel{
    CGFloat height=10;
    if (articleModel.title.length>0) {
        height=height+20+10;
    }
    if (articleModel.image_url.length>0) {
        CGFloat rightH=(MyWidth-20)/articleModel.image_width.floatValue*articleModel.image_height.floatValue;
        height=height+rightH+10;
    }
    if (articleModel.articleDesc.length>0) {
        CGSize size=[articleModel.articleDesc boundingRectWithSize:CGSizeMake(MyWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        height=height+size.height+10;
    }
    return height;
}

@end
