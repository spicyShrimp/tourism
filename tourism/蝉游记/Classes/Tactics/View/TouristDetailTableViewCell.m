//
//  TouristDetailTableViewCell.m
//  蝉游记
//
//  Created by Charles on 15/7/16.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "TouristDetailTableViewCell.h"
#import "AttractionContentModel.h"
#import "NoteModel.h"
@implementation TouristDetailTableViewCell
{
    UILabel *_descLabel;
    UIScrollView *_scrollView;
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
    _descLabel=[[UILabel alloc]init];
    _descLabel.numberOfLines=0;
    _descLabel.font=[UIFont systemFontOfSize:15];
    [self.contentView addSubview:_descLabel];
    
    _scrollView=[[UIScrollView alloc]init];
    [self.contentView addSubview:_scrollView];
    
}
-(void)setModel:(AttractionContentModel *)model{
    _model=model;
    NSArray *notes=model.notes;
    //求文本高度
    CGSize size=[model.attractionContentDesc boundingRectWithSize:CGSizeMake(MyWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    _descLabel.frame=CGRectMake(10, 10, MyWidth-20, size.height);
    _descLabel.text=model.attractionContentDesc;
    
    _scrollView.frame=CGRectMake(0, size.height+20, MyWidth, 100);
    CGFloat tempX=0;
    
    /**
     *  复用scrollView时先清除其所有子视图
     */
    NSArray *tempArray=_scrollView.subviews;
    for (UIImageView *temp in tempArray) {
        [temp removeFromSuperview];
    }
    for (int i=0; i<notes.count; i++) {
        NoteModel *subModel=notes[i];
        CGFloat rightW=100/subModel.height.floatValue*subModel.width.floatValue;
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(tempX+10, 0, rightW, 100)];
        tempX=tempX+rightW+10;
        [imageView sd_setImageWithURL:[NSURL URLWithString:subModel.photo_url]];
        [_scrollView addSubview:imageView];
    }
    _scrollView.contentSize=CGSizeMake(tempX+10, 0);

}
+(CGFloat)heightWithModel:(AttractionContentModel *)model{
    CGFloat height=10;
    //求文本高度
    CGSize size=[model.attractionContentDesc boundingRectWithSize:CGSizeMake(MyWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    height=height+size.height+10;
    //加上滚动视图高度
    return height+100+10;

}
@end
