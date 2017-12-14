//
//  CustomLayout.h
//  WaterFlowDemo
//
//  Created by Charles on 15/7/3.
//  Copyright (c) 2015年 Charles. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CustomLayoutDelegate <NSObject>

/**
 返回多少列
 */
-(NSInteger)numberOfColumns;
//cell的高度
-(CGFloat)heightAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface CustomLayout : UICollectionViewLayout
/**
 *  代理属性
 */
@property(nonatomic,assign)id<CustomLayoutDelegate> delegate;
/**
 *  初始化
 *
 *  @param sectionInsets 上下左右的间距
 *  @param itemSpace     横向间距
 *  @param lineSpace     纵向间距
 */
-(instancetype)initWithSectionInsets:(UIEdgeInsets)sectionInsets itemSpace:(CGFloat)itemSpace lineSpace:(CGFloat)lineSpace;
@end
