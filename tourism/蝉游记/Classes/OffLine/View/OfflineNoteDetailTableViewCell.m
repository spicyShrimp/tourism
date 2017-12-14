//
//  OfflineNoteDetailTableViewCell.m
//  蝉游记
//
//  Created by Charles on 15/7/24.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "OfflineNoteDetailTableViewCell.h"
#import "NoteModel.h"
@implementation OfflineNoteDetailTableViewCell
{
    UIImageView *_showImageView;
    UILabel *_descLabel;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUI];
    }
    return self;
}
-(void)configUI{
    
    _showImageView=[[UIImageView alloc]init];
    [self.contentView addSubview:_showImageView];
    
    _descLabel=[[UILabel alloc]init];
    _descLabel.numberOfLines=0;
    _descLabel.font=[UIFont systemFontOfSize:15];
    [self.contentView addSubview:_descLabel];
}
-(void)setNoteModel:(NoteModel *)noteModel{
    _noteModel=noteModel;
    CGFloat contentOffsetY=10;
    
    if(noteModel.photoImage){
        _showImageView.hidden=NO;
        NSString *photoW=noteModel.photo_width;
        NSString *photoH=noteModel.photo_height;
        CGFloat rightH=((MyWidth-20)/photoW.floatValue)*photoH.floatValue;
        _showImageView.frame=CGRectMake(10, contentOffsetY, MyWidth-20, rightH);
        _showImageView.image=noteModel.photoImage;
        contentOffsetY=contentOffsetY+rightH+10;
    }
    else{
        _showImageView.hidden=YES;
    }
    
    if (noteModel.noteDescription.length>0) {
        _descLabel.hidden=NO;
        _descLabel.text=noteModel.noteDescription;
        //求文本大小
        CGSize size=[noteModel.noteDescription boundingRectWithSize:CGSizeMake(MyWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        _descLabel.frame=CGRectMake(10, contentOffsetY, MyWidth-20, size.height);
    }
    else{
        _descLabel.hidden=YES;
    }
    
    
}

+(CGFloat)heightWithModel:(NoteModel *)noteModel{
    CGFloat height=10;
    
    //图片
    NSString *imageUrl=noteModel.photo[@"url"];
    if(imageUrl.length>0){
        NSString *photoW=noteModel.photo[@"image_width"];
        NSString *photoH=noteModel.photo[@"image_height"];
        CGFloat rightH=((MyWidth-20)/photoW.floatValue)*photoH.floatValue;
        height=height+rightH+10;
    }
    
    //文字
    if (noteModel.noteDescription.length>0) {
        CGSize size=[noteModel.noteDescription boundingRectWithSize:CGSizeMake(MyWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        height=height+size.height+10;
    }
    return height;
}

@end
