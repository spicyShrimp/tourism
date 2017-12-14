//
//  AttractionContentModel.m
//  蝉游记
//
//  Created by Charles on 15/7/16.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "AttractionContentModel.h"
#import "NoteModel.h"
@implementation AttractionContentModel
-(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"attractionContentId":@"id",@"attractionContentDesc":@"description"};
}
-(NSDictionary *)objectClassInArray{
    return @{@"notes":[NoteModel class]};
}
@end
