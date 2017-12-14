//
//  NotesModel.h
//  蝉游记
//
//  Created by Charles on 15/7/9.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserModel,TripDayModel;

@interface NotesModel : NSObject
/**
 *  游记id
 */
@property(nonatomic,strong)NSString *notesId;
/**
 *  游记名
 */
@property(nonatomic,strong)NSString *name;
/**
 *  开始时间
 */
@property(nonatomic,strong)NSString *start_date;
/**
 *  持续时间
 */
@property(nonatomic,strong)NSString *days;
/**
 *  照片数量
 */
@property(nonatomic,strong)NSString *photos_count;
/**
 *  展示照片
 */
@property(nonatomic,strong)NSString *front_cover_photo_url;
/**
 *  图片 (用作数据库查询出的图片)
 */
@property(nonatomic,strong)UIImage *photoImage;
/**
 *  bestflag
 */
@property(nonatomic,strong)NSString *featured;
/**
 *  用户
 */
@property(nonatomic,strong)UserModel *user;

/**
 *  整本游记
 */
@property(nonatomic,strong)NSArray *trip_days;
/**
 *  提示
 */
@property(nonatomic,strong)NSString *tip;
@end
