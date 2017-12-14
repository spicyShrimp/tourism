//
//  AccountModel.h
//  蝉游记
//
//  Created by Charles on 15/7/20.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountModel : NSObject
/**
 *  用户ID
 */
@property(nonatomic,strong)NSString *accountId;
/**
 *  用户头像
 */
@property(nonatomic,strong)NSString *image;
/**
 *  用户昵称
 */
@property(nonatomic,strong)NSString *name;
/**
 *  用户性别
 */
@property(nonatomic,strong)NSString *gender;
@end
