//
//  TopicModel.m
//  蝉游记
//
//  Created by Charles on 15/7/9.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "TopicModel.h"
#import "ArticleModel.h"
@implementation TopicModel
- (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"topicId" : @"id"};
}
-(NSDictionary *)objectClassInArray{
    return @{@"article_sections":[ArticleModel class]};
}
@end
