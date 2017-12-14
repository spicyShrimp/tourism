//
//  ArticleModel.m
//  蝉游记
//
//  Created by Charles on 15/7/15.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "ArticleModel.h"

@implementation ArticleModel
-(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"articleDesc":@"description"};
}
@end
