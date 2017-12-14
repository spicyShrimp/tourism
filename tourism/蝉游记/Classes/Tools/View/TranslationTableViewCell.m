//
//  TranslationTableViewCell.m
//  蝉游记
//
//  Created by Charles on 15/7/16.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "TranslationTableViewCell.h"
#import "TranslationModel.h"
@implementation TranslationTableViewCell
{
    UILabel *_srcLabel;
    UILabel *_dstLabel;
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
    _srcLabel=[[UILabel alloc]init];
    _srcLabel.numberOfLines=0;
    [self.contentView addSubview:_srcLabel];
    
    _dstLabel=[[UILabel alloc]init];
    _dstLabel.numberOfLines=0;
    [self.contentView addSubview:_dstLabel];
}
-(void)setModel:(TranslationModel *)model{
    _model=model;
    CGFloat contentOffsetY=10;
    //求文字大小
    if (model.src.length>0) {
        CGSize srcSize=[model.src boundingRectWithSize:CGSizeMake(MyWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
        _srcLabel.frame=CGRectMake(10, contentOffsetY, MyWidth-20, srcSize.height);
        _srcLabel.text=model.src;
        contentOffsetY=contentOffsetY+srcSize.height+10;
    }
    if (model.dst.length>0) {
        CGSize dstSize=[model.dst boundingRectWithSize:CGSizeMake(MyWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
        _dstLabel.frame=CGRectMake(10, contentOffsetY, MyWidth-20, dstSize.height);
        _dstLabel.text=model.dst;
    }
}
+(CGFloat)heightWithModel:(TranslationModel *)model{
    CGFloat height=10;
    if (model.src.length>0) {
        CGSize srcSize=[model.src boundingRectWithSize:CGSizeMake(MyWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
        height=height+srcSize.height+10;
    }
    if (model.dst.length>0) {
        CGSize dstSize=[model.dst boundingRectWithSize:CGSizeMake(MyWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
        height=height+dstSize.height+10;
    }
    return height;
}
@end
