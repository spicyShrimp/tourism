//
//  PlanNodeModel.m
//  蝉游记
//
//  Created by Charles on 15/7/16.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "PlanNodeModel.h"

@implementation PlanNodeModel
-(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"planNodeId":@"id"};
}
@end
