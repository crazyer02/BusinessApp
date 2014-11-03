//
//  KSDataBase.m
//  BusinessApp
//
//  Created by 喻雷 on 14/10/27.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

#import "KSDataBase.h"

@implementation KSDataBase

//存放数据库文件
-(NSString*) dataFilePath
{
    NSArray* dataPaths=NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString* docPath=[dataPaths objectAtIndex:0];
    NSString* fileName=[docPath stringByAppendingPathComponent:@"kindstarData.db"];
    NSLog(@"%@",fileName);
    return fileName;
}

//打开数据库
-(void)openDB
{
    NSString* path=[self dataFilePath];
    sqlite3_open([path UTF8String], &_database);
}


-(void) createTableList
{
    const char* createSql="create table user(ID INTEGER PRIMARY KEY AUTOINCREMENT,logid text,username text)";
    char* errmsg;
    sqlite3_exec(_database, createSql, NULL, NULL, &errmsg);
    NSLog(@"%s",errmsg);
    sqlite3_free(errmsg);
    
}

-(void) InsertTable
{
    const char* insertSql="INSERT INTO user(logid,username) VALUES('yulei','yulei')";
    char* errmsg;
    sqlite3_exec(_database, insertSql, NULL, NULL, &errmsg);
    NSLog(@"%s",errmsg);
    sqlite3_free(errmsg);
}

-(void) queryTable
{
    [self openDB];
    const char* selectSql="select logid,username from user";
    sqlite3_stmt* statement;
    if(sqlite3_prepare_v2(_database, selectSql, -1, &statement, nil)==SQLITE_OK)
    {
        while (sqlite3_step(statement)==SQLITE_ROW) {
            int _id=sqlite3_column_int(statement, 0);
            NSString* username=[[NSString alloc] initWithString:(char*)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            NSLog(@">>>>>>>>>>>>Id: %i,>>>>>>>>>>>>>>>Username: %@",_id,username);
        }
    }
}

@end
