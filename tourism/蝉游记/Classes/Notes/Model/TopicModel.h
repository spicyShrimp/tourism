//
//  TopicModel.h
//  蝉游记
//
//  Created by Charles on 15/7/9.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicModel : NSObject
/**
 *  专题ID
 */
@property(nonatomic,strong)NSString *topicId;
/**
 *  专题小标题
 */
@property(nonatomic,strong)NSString *title;
/**
 *  专题展示图片
 */
@property(nonatomic,strong)NSString *image_url;
/**
 *  专题名
 */
@property(nonatomic,strong)NSString *name;
/**
 *  目的地ID
 */
@property(nonatomic,strong)NSString *destination_id;
/**
 *  更新ID
 */
@property(nonatomic,strong)NSString *updated_at;

@property(nonatomic,strong)NSArray *article_sections;
@end
