//
//  TripDayModel.h
//  蝉游记
//
//  Created by Charles on 15/7/14.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NodeModel;
@interface TripDayModel : NSObject
/**
 *  id
 */
@property(nonatomic,strong)NSString *tripDayId;
/**
 *  游记日期
 */
@property(nonatomic,strong)NSString *trip_date;
/**
 *  第几天
 */
@property(nonatomic,strong)NSString *day;
/**
 *  目的地(字典:有id和name_zh_cn)
 */
@property(nonatomic,strong)NSDictionary *destination;
/**
 *  结
 */
@property(nonatomic,strong)NSArray *nodes;

@end
