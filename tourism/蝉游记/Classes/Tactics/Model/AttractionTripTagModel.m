//
//  AttractionTripTagModel.m
//  蝉游记
//
//  Created by Charles on 15/7/16.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "AttractionTripTagModel.h"
#import "AttractionContentModel.h"
@implementation AttractionTripTagModel
-(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"attractionTripTagId":@"id"};
}
-(NSDictionary *)objectClassInArray{
   return @{@"attraction_contents":[AttractionContentModel class]};
}
@end
