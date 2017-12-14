//
//  AttractionContentModel.h
//  蝉游记
//
//  Created by Charles on 15/7/16.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NotesModel,UserModel;
@interface AttractionContentModel : NSObject
@property(nonatomic,strong)NSString *attractionContentId;
@property(nonatomic,strong)NSString *attractionContentDesc;
@property(nonatomic,strong)NotesModel *trip;
@property(nonatomic,strong)UserModel *user;
@property(nonatomic,strong)NSArray *notes;
@end
