//
//  ToursitDetailModel.h
//  蝉游记
//
//  Created by Charles on 15/7/16.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToursitDetailModel : NSObject
/**
 *  id
 */
@property(nonatomic,strong)NSString *touristDetailId;
/**
 *  中文名
 */
@property(nonatomic,strong)NSString *name_zh_cn;
/**
 *  英文名
 */
@property(nonatomic,strong)NSString *name_en;
/**
 *  描述
 */
@property(nonatomic,strong)NSString *touristDetailDesc;
/**
 *  链接文本
 */
@property(nonatomic,strong)NSString *tips_html;
/**
 *  星星数
 */
@property(nonatomic,strong)NSString *user_score;
/**
 *  照片数
 */
@property(nonatomic,strong)NSString *photos_count;
/**
 *  游记数
 */
@property(nonatomic,strong)NSString *attraction_trips_count;
/**
 *  经度
 */
@property(nonatomic,strong)NSString *lat;
/**
 *  纬度
 */
@property(nonatomic,strong)NSString *lng;
/**
 *  地址
 */
@property(nonatomic,strong)NSString *address;

@property(nonatomic,strong)NSArray *attraction_trip_tags;
@end
