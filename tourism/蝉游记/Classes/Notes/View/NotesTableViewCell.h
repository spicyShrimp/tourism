//
//  NotesTableViewCell.h
//  蝉游记
//
//  Created by Charles on 15/7/9.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NotesModel;
@class UserModel;
@interface NotesTableViewCell : UITableViewCell
@property(nonatomic,strong)NotesModel *notesModel;
@property(nonatomic,strong)UserModel *userModel;
@property(nonatomic,copy)void(^userIconBlock)(UserModel *userModel);
@end
