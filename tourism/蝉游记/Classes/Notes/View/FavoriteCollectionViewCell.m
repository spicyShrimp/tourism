//
//  FavoriteCollectionViewCell.m
//  蝉游记
//
//  Created by Charles on 15/7/20.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "FavoriteCollectionViewCell.h"
#import "FavoriteModel.h"
@implementation FavoriteCollectionViewCell
{
    UIImageView *_imageView;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return  self;
}
-(void)configUI{
    _imageView=[[UIImageView alloc]init];
    [self.contentView addSubview:_imageView];
}
-(void)setModel:(FavoriteModel *)model{
    _model=model;
    CGFloat rightW=(MyWidth-25)/2;
    CGFloat rightH=rightW/model.width.floatValue*model.height.floatValue;
    _imageView.frame=CGRectMake(0, 0, rightW, rightH);
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.photo_url]placeholderImage:[UIImage imageNamed:@"TripShowCoverMask"]];
}

@end
