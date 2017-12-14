//
//  AccountModel.m
//  蝉游记
//
//  Created by Charles on 15/7/20.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "AccountModel.h"

@implementation AccountModel
-(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"accountId":@"id"};
}
@end
