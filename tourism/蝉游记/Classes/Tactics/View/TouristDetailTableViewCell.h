//
//  TouristDetailTableViewCell.h
//  蝉游记
//
//  Created by Charles on 15/7/16.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AttractionContentModel;
@interface TouristDetailTableViewCell : UITableViewCell
@property(nonatomic,strong)AttractionContentModel *model;
//计算model显示后对应的cell的高度
+(CGFloat)heightWithModel:(AttractionContentModel *)model;
@end
