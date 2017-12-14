//
//  TripModel.m
//  蝉游记
//
//  Created by charles on 15/7/11.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "TripModel.h"

@implementation TripModel
-(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"tripId":@"id",@"tripDesc":@"description"};
}
@end
