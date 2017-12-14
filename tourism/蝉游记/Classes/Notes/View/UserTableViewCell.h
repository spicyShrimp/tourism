//
//  UserTableViewCell.h
//  蝉游记
//
//  Created by Charles on 15/7/23.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;
@interface UserTableViewCell : UITableViewCell
@property(nonatomic,strong)UserModel *userModel;
@end
