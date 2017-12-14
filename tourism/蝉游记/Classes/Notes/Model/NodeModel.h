//
//  NodeModel.h
//  test
//
//  Created by Charles on 15/7/14.
//  Copyright (c) 2015年 Charles. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NoteModel;
@interface NodeModel : NSObject
/**
 *  id
 */
@property(nonatomic,strong)NSString *nodeId;
/**
 *  星星数
 */
@property(nonatomic,strong)NSString *score;
/**
 *  描述
 */
@property(nonatomic,strong)NSString *comment;
/**
 *  始发地
 */
@property(nonatomic,strong)NSString *entry_name;
/**
 *  游记数组
 */
@property(nonatomic,strong)NSArray *notes;
@end
