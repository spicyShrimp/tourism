//
//  RegionModel.m
//  蝉游记
//
//  Created by Charles on 15/7/10.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "RegionModel.h"

@implementation RegionModel
- (NSDictionary *)objectClassInArray
{
    return @{@"destinations" : [PlaceModel class]};
}
@end
