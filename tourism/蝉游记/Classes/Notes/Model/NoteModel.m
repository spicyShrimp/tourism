//
//  NoteModel.m
//  蝉游记
//
//  Created by Charles on 15/7/14.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "NoteModel.h"

@implementation NoteModel
-(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"noteId":@"id",@"noteDescription":@"description"};
}
@end
