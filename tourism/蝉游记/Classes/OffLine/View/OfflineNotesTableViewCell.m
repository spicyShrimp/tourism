//
//  OfflineNotesTableViewCell.m
//  蝉游记
//
//  Created by Charles on 15/7/24.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "OfflineNotesTableViewCell.h"
#import "NotesModel.h"
@implementation OfflineNotesTableViewCell
{
    UIImageView *_showImageView;
    UIImageView *_cover;
    UILabel *_nameLabel;
    UILabel *_timeandpicturesLabel;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=WhiteColor;
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
    
}

-(void)setNotesModel:(NotesModel *)notesModel{
    _notesModel=notesModel;
    _showImageView.image=notesModel.photoImage;
    _nameLabel.text=notesModel.name;
    _timeandpicturesLabel.text=[NSString stringWithFormat:@"%@ / %@天 / %@图",notesModel.start_date,notesModel.days,notesModel.photos_count];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
