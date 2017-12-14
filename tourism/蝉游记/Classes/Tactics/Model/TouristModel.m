//
//  TouristModel.m
//  蝉游记
//
//  Created by charles on 15/7/11.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "TouristModel.h"

@implementation TouristModel
-(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"touristId":@"id",@"touristDescription":@"description"};
}
@end
