//
//  PlanDayModel.m
//  蝉游记
//
//  Created by Charles on 15/7/16.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "PlanDayModel.h"
#import "PlanNodeModel.h"
@implementation PlanDayModel
-(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"planDayId":@"id"};
}
-(NSDictionary *)objectClassInArray{
    return @{@"plan_nodes":[PlanNodeModel class]};
}
@end
