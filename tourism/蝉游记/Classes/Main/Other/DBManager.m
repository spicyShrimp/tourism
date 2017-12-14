//
//  DBManager.m
//  蝉游记
//
//  Created by Charles on 15/7/23.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabase.h"
@implementation DBManager
{
    //数据库对象
    FMDatabase *_myDatabase;
}

+ (DBManager *)sharedInstance
{
    static DBManager *manager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[DBManager alloc] init];
    });
    
    return manager;
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        
//        初始化数据库对象
        [self createDataBase];
    }
    return self;
}

//初始化数据库对象
- (void)createDataBase
{
    //数据库文件的路径
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/notes.sqlite"];
    
    //1.初始化数据库对象
    _myDatabase = [[FMDatabase alloc] initWithPath:path];
    
    //2.打开数据库
    BOOL ret = [_myDatabase open];
    if (!ret) {
        NSLog(@"数据库打开失败:%@",_myDatabase.lastErrorMessage);
    }else{
        //打开数据库成功
        
        NSString *createNotesList = @"create table if not exists notesList (notesId varchar(255) ,  name varchar(255) , start_date varchar(255), days varchar(255) , photos_count varchar(255) ,photoImage blob)";
        
        NSString *createNotes = @"create table if not exists notes (noteId varchar(255) , noteDescription varchar(255) , photoImage blob ,photo_width varchar(255) ,photo_height varchar(255))";
        BOOL flag1=[_myDatabase executeUpdate:createNotesList];
        if (!flag1) {
            NSLog(@"创建notesList表格失败:%@",_myDatabase.lastErrorMessage);
        }
        BOOL flag2 =[_myDatabase executeUpdate:createNotes];
        if (!flag2) {
            NSLog(@"创建notes表格失败:%@",_myDatabase.lastErrorMessage);
        }
    }
}
//头部
-(void)insertNotesList:(NotesModel *)notesModel{
    NSString *insertNotesList = @"insert into notesList (notesId,name,start_date,days,photos_count,photoImage) values (?,?,?,?,?,?)";
    
    NSData *data =[NSData dataWithContentsOfURL:[NSURL URLWithString:notesModel.front_cover_photo_url]];
    BOOL ret = [_myDatabase executeUpdate:insertNotesList,notesModel.notesId,notesModel.name,notesModel.start_date,notesModel.days,notesModel.photos_count,data];
    if (!ret) {
        NSLog(@"添加数据失败:%@",_myDatabase.lastErrorMessage);
    }
}

//游记
-(void)insertNote:(NoteModel *)noteModel{
    NSString *insertNotes = @"insert into notes (noteId,noteDescription,photoImage,photo_width,photo_height) values (?,?,?,?,?)";
    
    NSData *data =[NSData dataWithContentsOfURL:[NSURL URLWithString:noteModel.photo[@"url"]]];
    BOOL ret = [_myDatabase executeUpdate:insertNotes,noteModel.noteId,noteModel.noteDescription,data,noteModel.photo[@"image_width"],noteModel.photo[@"image_height"]];
    if (!ret) {
        NSLog(@"添加数据失败:%@",_myDatabase.lastErrorMessage);
    }
}


//查询user表里面所有的数据
-(NSArray *)selectAllNote
{

    NSString *selectNotes = @"select * from notes";
    
    FMResultSet *rs = [_myDatabase executeQuery:selectNotes];
    //用游标的方式来管理数据
    
    NSMutableArray *array = [NSMutableArray array];
    while ([rs next]) {
        //创建对象
        NoteModel *model = [[NoteModel alloc] init];
        model.noteId = [rs stringForColumn:@"noteId"];
        model.noteDescription=[rs stringForColumn:@"noteDescription"];
        NSData *data = [rs dataForColumn:@"photoImage"];
        model.photoImage=[UIImage imageWithData:data];
        model.photo_width=[rs stringForColumn:@"photo_width"];
        model.photo_height=[rs stringForColumn:@"photo_height"];
        [array addObject:model];
    }
    return array;
}


//查询user表里面所有的数据
-(NSArray *)selectAllNotesList
{
    NSString *selectNotes = @"select * from notesList";
    
    FMResultSet *rs = [_myDatabase executeQuery:selectNotes];
    //用游标的方式来管理数据
    
    NSMutableArray *array = [NSMutableArray array];
    while ([rs next]) {
        //创建对象
        NotesModel *model = [[NotesModel alloc] init];
        model.notesId = [rs stringForColumn:@"notesId"];
        model.name=[rs stringForColumn:@"name"];
        model.start_date=[rs stringForColumn:@"start_date"];
        model.days=[rs stringForColumn:@"days"];
        model.photos_count=[rs stringForColumn:@"photos_count"];
        NSData *data = [rs dataForColumn:@"photoImage"];
        model.photoImage=[UIImage imageWithData:data];
        [array addObject:model];
    }
    return array;
}

//删除
-(void)deleteNotesWithId:(NSString *)notesId
{
    NSString *deleteSql = @"delete from notesList where notesId=?";
    BOOL ret = [_myDatabase executeUpdate:deleteSql,notesId];
    if (!ret) {
        NSLog(@"删除失败:%@",_myDatabase.lastErrorMessage);
    }
    
}


@end
