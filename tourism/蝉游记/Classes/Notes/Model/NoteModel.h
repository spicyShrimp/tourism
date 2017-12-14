//
//  NoteModel.h
//  蝉游记
//
//  Created by Charles on 15/7/14.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteModel : NSObject
/**
 *  id
 */
@property(nonatomic,strong)NSString *noteId;
/**
 *  描述
 */
@property(nonatomic,strong)NSString *noteDescription;
/**
 *  图片(字典: 宽image_width 高image_height 地址url)
 */
@property(nonatomic,strong)NSDictionary *photo;
/**
 *  图片 (用作数据库查询出的图片)
 */
@property(nonatomic,strong)UIImage *photoImage;
@property(nonatomic,strong)NSString *photo_width;
@property(nonatomic,strong)NSString *photo_height;

@property(nonatomic,strong)NSString *width;
@property(nonatomic,strong)NSString *height;
@property(nonatomic,strong)NSString *photo_url;
@property(nonatomic,strong)NSString *video_url;

@end
