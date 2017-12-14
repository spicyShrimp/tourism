//
//  NotesTableViewCell.m
//  蝉游记
//
//  Created by Charles on 15/7/9.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "NotesTableViewCell.h"
#import "NotesModel.h"
#import "UserModel.h"
@implementation NotesTableViewCell
{
    UIImageView *_showImageView;
    UIImageView *_bestImageView;
    UILabel *_nameLabel;
    UILabel *_timeandpicturesLabel;
    UIImageView *_cover;
    UIButton *_userIconButton;
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
    /**
     展示图片
     */
    _showImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MyWidth-20, 195)];
    _showImageView.contentMode=UIViewContentModeScaleAspectFill;
    _showImageView.clipsToBounds=YES;
    [self.contentView addSubview:_showImageView];
    /**
     蒙版
     */
    _cover=[[UIImageView alloc]initWithFrame:_showImageView.frame];
    _cover.image=[UIImage imageNamed:@"TripCellCoverMask"];
    _cover.userInteractionEnabled=YES;
    [self.contentView addSubview:_cover];
    
    _bestImageView=[[UIImageView alloc]initWithFrame:CGRectMake(MyWidth-82, 10, 66, 26)];
    _bestImageView.image=[UIImage imageNamed:@"FlagBest"];
    [self.contentView addSubview:_bestImageView];
    
    /**
     游记名
     */
    _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, MyWidth-40, 50)];
    _nameLabel.numberOfLines=0;
    _nameLabel.font=[UIFont boldSystemFontOfSize:20.0f];
    _nameLabel.textColor=[UIColor whiteColor];
    [self.contentView addSubview:_nameLabel];
    
    _timeandpicturesLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 60, MyWidth-80, 20)];
    _timeandpicturesLabel.font=[UIFont systemFontOfSize:14.0f];
    _timeandpicturesLabel.textColor=[UIColor whiteColor];
    [self.contentView addSubview:_timeandpicturesLabel];
    
    _userIconButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _userIconButton.frame=CGRectMake(10, 130, 50, 50);
    _userIconButton.layer.cornerRadius=25;
    _userIconButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _userIconButton.layer.borderWidth=2;
    _userIconButton.clipsToBounds=YES;
    [_userIconButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_userIconButton];
}
-(void)setNotesModel:(NotesModel *)notesModel{
    _notesModel=notesModel;
    
    [_showImageView sd_setImageWithURL:[NSURL URLWithString:_notesModel.front_cover_photo_url]];
    
    if ([notesModel.featured isEqualToString:@"1"]) {
        _bestImageView.hidden=NO;
        _nameLabel.width=MyWidth-110;
    }
    else{
        _bestImageView.hidden=YES;
        _nameLabel.width=MyWidth-40;
    }
    _nameLabel.text=_notesModel.name;
    
    _timeandpicturesLabel.text=[NSString stringWithFormat:@"%@ / %@天 / %@图",_notesModel.start_date,_notesModel.days,_notesModel.photos_count];
    
    _userModel=_notesModel.user;
    if (_userModel) {
        _userIconButton.hidden=NO;
        [_userIconButton sd_setBackgroundImageWithURL:[NSURL URLWithString:_userModel.image] forState:UIControlStateNormal];
        _userIconButton.tag=_userModel.userId.integerValue;
    }
    else{
        _userIconButton.hidden=YES;
    }
}
-(void)btnClicked:(UIButton *)button{
    
    if (self.userIconBlock) {
        self.userIconBlock(_userModel);
    }
}
@end
