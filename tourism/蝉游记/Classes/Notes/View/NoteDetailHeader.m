//
//  NoteDetailHeader.m
//  蝉游记
//
//  Created by Charles on 15/7/15.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "NoteDetailHeader.h"
#import "NodeModel.h"
@implementation NoteDetailHeader
{
    UIImageView *_nodeImageView;
    UILabel *_label;
}
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUI];
    }
    return self;
}
-(void)configUI{
    
    _nodeImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
    _nodeImageView.image=[UIImage imageNamed:@"A_sight"];
    [self.contentView addSubview:_nodeImageView];
    
    _label=[[UILabel alloc]initWithFrame:CGRectMake(60, 10, MyWidth-80, 40)];
    _label.font=[UIFont systemFontOfSize:20];
    [self.contentView addSubview:_label];
}

-(void)setNodeModel:(NodeModel *)nodeModel{
    _nodeModel=nodeModel;
    _label.text=nodeModel.entry_name;
}
@end
