//
//  PlanDayModel.h
//  蝉游记
//
//  Created by Charles on 15/7/16.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlanDayModel : NSObject
/**
 *  id
 */
@property(nonatomic,strong)NSString *planDayId;
/**
 *  描述
 */
@property(nonatomic,strong)NSString *memo;
/**
 *  旅游点
 */
@property(nonatomic,strong)NSArray *plan_nodes;
@end
