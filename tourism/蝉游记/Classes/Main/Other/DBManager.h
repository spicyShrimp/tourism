//
//  DBManager.h
//  蝉游记
//
//  Created by Charles on 15/7/23.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteModel.h"
#import "NotesModel.h"
@interface DBManager : NSObject
+(DBManager *)sharedInstance;

-(void)insertNotesList:(NotesModel *)notesModel;

-(void)insertNote:(NoteModel *)noteModel;

-(NSArray *)selectAllNotesList;

-(NSArray *)selectAllNote;

-(void)deleteNotesWithId:(NSString *)notesId;
@end
