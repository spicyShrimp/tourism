//
//  PlanNodeModel.h
//  蝉游记
//
//  Created by Charles on 15/7/16.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlanNodeModel : NSObject
/**
 *  id
 */
@property(nonatomic,strong)NSString *planNodeId;
/**
 *  提示
 */
@property(nonatomic,strong)NSString *tips;
/**
 *  经度
 */
@property(nonatomic,strong)NSString *lat;
/**
 *  纬度
 */
@property(nonatomic,strong)NSString *lng;
/**
 *  图片
 */
@property(nonatomic,strong)NSString *image_url;
/**
 *  站点名
 */
@property(nonatomic,strong)NSString *entry_name;
/**
 *  地名字典(id 和 name_zh_cn)
 */
@property(nonatomic,strong)NSDictionary *destination;
@end
