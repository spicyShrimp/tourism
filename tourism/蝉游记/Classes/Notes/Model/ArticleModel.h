//
//  ArticleModel.h
//  蝉游记
//
//  Created by Charles on 15/7/15.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleModel : NSObject
/**
 *  标题
 */
@property(nonatomic,strong)NSString *title;
/**
 *  图片
 */
@property(nonatomic,strong)NSString *image_url;
/**
 *  图片宽度
 */
@property(nonatomic,strong)NSString *image_width;
/**
 *  图片高度
 */
@property(nonatomic,strong)NSString *image_height;
/**
 *  用户信息
 */
@property(nonatomic,strong)NSDictionary *description_user_ids;
/**
 *  描述
 */
@property(nonatomic,strong)NSString *articleDesc;
/**
 *  地点
 */
@property(nonatomic,strong)NSDictionary *attraction;

@end
