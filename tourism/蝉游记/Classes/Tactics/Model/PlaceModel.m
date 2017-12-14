//
//  PlaceModel.m
//  蝉游记
//
//  Created by Charles on 15/7/10.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "PlaceModel.h"

@implementation PlaceModel
- (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"placeId" : @"id"};
}


- (NSDictionary *)objectClassInArray
{
    return @{@"children" : [PlaceModel class]};
}
@end
