//
//  NotesModel.m
//  蝉游记
//
//  Created by Charles on 15/7/9.
//  Copyright (c) 2015年 charles. All rights reserved.
//

#import "NotesModel.h"
#import "TripDayModel.h"
@implementation NotesModel
- (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"notesId" : @"id"};
}
-(NSDictionary *)objectClassInArray{
    return @{@"trip_days":[TripDayModel class]};
}
@end
