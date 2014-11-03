//
//  KSDataBase.h
//  BusinessApp
//
//  Created by 喻雷 on 14/10/27.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface KSDataBase : NSObject

@property (assign,nonatomic) sqlite3* database;
-(void) openDB;
-(void) createTableList;
-(void) InsertTable;
-(void) queryTable;
@end
