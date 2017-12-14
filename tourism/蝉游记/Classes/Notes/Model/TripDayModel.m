//
//  TripDayModel.m
//  蝉游记
//
//  Created by Charles on 15/7/14.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "TripDayModel.h"
#import "NodeModel.h"
@implementation TripDayModel
-(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"tripDayId":@"id"};
}
-(NSDictionary *)objectClassInArray{
    return @{@"nodes":[NodeModel class]};
}
@end
