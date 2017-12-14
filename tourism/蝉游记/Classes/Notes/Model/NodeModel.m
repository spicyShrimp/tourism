//
//  NodeModel.m
//  test
//
//  Created by Charles on 15/7/14.
//  Copyright (c) 2015年 Charles. All rights reserved.
//

#import "NodeModel.h"
#import "NoteModel.h"
@implementation NodeModel
-(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"nodeId":@"id"};
}
-(NSDictionary *)objectClassInArray{
    return @{@"notes":[NoteModel class]};
}
@end
