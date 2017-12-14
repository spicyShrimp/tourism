//
//  NoteDetailTableViewCell.h
//  蝉游记
//
//  Created by Charles on 15/7/14.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NoteModel;
@interface NoteDetailTableViewCell : UITableViewCell
@property(nonatomic,strong)NoteModel *noteModel;
//计算model显示后对应的cell的高度
+(CGFloat)heightWithModel:(NoteModel *)noteModel;
@end
