//
//  UserModel.h
//  蝉游记
//
//  Created by Charles on 15/7/9.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NotesModel;
@interface UserModel : NSObject
/**
 *  用户ID
 */
@property(nonatomic,strong)NSString *userId;
/**
 *  用户名
 */
@property(nonatomic,strong)NSString *name;
/**
 *  用户头像
 */
@property(nonatomic,strong)NSString *image;
/**
 *  游记数
 */
@property(nonatomic,strong)NSString *trips_count;
/**
 *  游记
 */
@property(nonatomic,strong)NSArray *trips;

@property(nonatomic,strong)NSString *latest_publish_trip_name;
@end
