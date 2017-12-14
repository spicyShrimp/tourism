//
//  UserModel.m
//  蝉游记
//
//  Created by Charles on 15/7/9.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "UserModel.h"
#import "NotesModel.h"
@implementation UserModel
- (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"userId" : @"id"};
}
-(NSDictionary *)objectClassInArray{
    return @{@"trips":[NotesModel class]};
}
@end
