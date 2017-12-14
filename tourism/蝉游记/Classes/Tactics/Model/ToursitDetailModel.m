//
//  ToursitDetailModel.m
//  蝉游记
//
//  Created by Charles on 15/7/16.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "ToursitDetailModel.h"
#import "AttractionTripTagModel.h"
@implementation ToursitDetailModel
-(NSDictionary *)replacedKeyFromPropertyName{
  return @{@"touristDetailId":@"id",@"touristDetailDesc":@"description"};
}
-(NSDictionary *)objectClassInArray{
    return @{@"attraction_trip_tags":[AttractionTripTagModel class]};
}
@end
