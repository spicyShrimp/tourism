//
//  PlaceModel.h
//  蝉游记
//
//  Created by Charles on 15/7/10.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceModel : NSObject
/**
 *  英文名
 */
@property(nonatomic,strong)NSString *name_en;
/**
 *  景点ID
 */
@property(nonatomic,strong)NSString *placeId;
/**
 *  景点图片
 */
@property(nonatomic,strong)NSString *image_url;
/**
 *  中文名
 */
@property(nonatomic,strong)NSString *name_zh_cn;
/**
 *  景点数
 */
@property(nonatomic,strong)NSString *poi_count;

@property(nonatomic,strong)NSArray *children;


@end
