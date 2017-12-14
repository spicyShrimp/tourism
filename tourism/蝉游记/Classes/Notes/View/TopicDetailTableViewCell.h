//
//  TopicDetailTableViewCell.h
//  蝉游记
//
//  Created by Charles on 15/7/15.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ArticleModel;
@interface TopicDetailTableViewCell : UITableViewCell
@property(nonatomic,strong)ArticleModel *articleModel;
+(CGFloat)heightWithModel:(ArticleModel *)articleModel;
@end
