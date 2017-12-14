//
//  CustomLayout.m
//  WaterFlowDemo
//
//  Created by Charles on 15/7/3.
//  Copyright (c) 2015年 Charles. All rights reserved.
//

#import "CustomLayout.h"

@implementation CustomLayout
{
    //上下左右间距
    UIEdgeInsets _sectionInsets;
    //横向间距
    CGFloat _itemSpace;
    //纵向间距
    CGFloat _lineSpace;
    //列数
    NSInteger _column;
    //存储每一列的高度
    NSMutableArray *_heightArray;
    //存储frame属性对象的数组
    NSMutableArray *_attrArray;
}
-(instancetype)initWithSectionInsets:(UIEdgeInsets)sectionInsets itemSpace:(CGFloat)itemSpace lineSpace:(CGFloat)lineSpace{
    self=[super init];
    if (self) {
        _sectionInsets=sectionInsets;
        _itemSpace=itemSpace;
        _lineSpace=lineSpace;
        
        //默认两列
        _column=2;
        //高度的数组
        _heightArray=[NSMutableArray array];
        _attrArray=[NSMutableArray array];
    }
    return self;
}
//每次刷新网格视图时调用
-(void)prepareLayout{
    [super prepareLayout];
    //获取多少列
    if (self.delegate) {
        _column=[self.delegate numberOfColumns];
    }
    //删除之前的数据
    [_attrArray removeAllObjects];
    
    //初始化高度的数组
    [_heightArray removeAllObjects];
    for (int i=0; i<_column; i++) {
        NSNumber *n=[NSNumber numberWithFloat:_sectionInsets.top];
        [_heightArray addObject:n];
    }
    //计算位置
    //每一个cell的位置
    NSInteger cellCnt=[self.collectionView numberOfItemsInSection:0];
    //宽度
    CGFloat width=(self.collectionView.bounds.size.width-_sectionInsets.left-_sectionInsets.right-_itemSpace*(_column-1))/_column;
    for (int i=0; i<cellCnt; i++) {
        //高度
        NSIndexPath *indexPath=[NSIndexPath indexPathForItem:i inSection:0];
        CGFloat heigth=[self.delegate heightAtIndexPath:indexPath];
        //x
        //确定cell在第几列
        NSInteger index=[self lowestColumnIndex];
        CGFloat x=_sectionInsets.left+(width+_itemSpace)*index;
        //y
        CGFloat y=[_heightArray[index] floatValue];
        //设置frame
        CGRect frame=CGRectMake(x, y, width, heigth);
        
        UICollectionViewLayoutAttributes *attr=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attr.frame=frame;
        
        [_attrArray addObject:attr];
        
        //更新y值
        _heightArray[index]=[NSNumber numberWithFloat:(y+heigth+_lineSpace)];
    }
}
/**
 *  找到当前位置最低列的序号
 */
-(NSInteger)lowestColumnIndex{
    NSInteger index=-1;
    CGFloat height=CGFLOAT_MAX;
    for (int i=0; i<_heightArray.count; i++) {
        NSNumber *n=_heightArray[i];
        if (n.floatValue<height) {
            height=n.floatValue;
            index=i;
        }
    }
    return index;
}
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    return _attrArray;
}
/**
 *  设置网格视图的大小
 */
-(CGSize)collectionViewContentSize{
    NSInteger index=[self highestCloumnIndex];
    CGFloat height=[_heightArray[index] floatValue];
    return CGSizeMake(self.collectionView.bounds.size.width, height);
}
/**
 *  计算所有列中最高列的序号
 */
-(NSInteger)highestCloumnIndex{
    CGFloat height=CGFLOAT_MIN;
    NSInteger index=-1;
    for (int i=0; i<_heightArray.count; i++) {
        NSNumber *n=_heightArray[i];
        if (n.floatValue>height) {
            height=n.floatValue;
            index=i;
        }
    }
    return index;
}
@end
