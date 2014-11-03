//
//  KSUserDB.m
//  BusinessApp
//
//  Created by 喻雷 on 14/10/27.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

#import "KSUserDB.h"

#define kUserTableName @"KSUser"

@implementation KSUserDB

- (id)init
{
    self = [super init];
    if (self) {
        //========== 首先查看有没有建立message的数据库，如果未建立，则建立数据库=========
        _db=[KSDBManager defaultDBManager].dataBase;
    }
    return self;
}

-(void) createDataBase{
    FMResultSet* set=[_db executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type ='table' and name = '%@'",kUserTableName]];
    [set next];
    NSInteger count=[set intForColumnIndex:0];
    BOOL existTable=!!count;
    if (existTable) {
        // TODO:是否更新数据库
        NSLog(@"数据库已经存在");
        //@"数据库已经存在" duration:2];
    } else {
        // TODO: 插入新的数据库 
        NSString * sql = @"CREATE TABLE KSUser (uid INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL,logid VARCHAR(50),  username VARCHAR(50), description VARCHAR(100))";
        BOOL res = [_db executeUpdate:sql];
        if (!res) {
            NSLog(@"数据库创建失败");
            //[KSAppDelegate showStatusWithText:@"数据库创建失败" duration:2];
        } else {
            NSLog(@"数据库创建成功");
            //[KSAppDelegate showStatusWithText:@"数据库创建成功" duration:2];
        }
    }

}

/**
 * @brief 保存一条用户记录
 *
 * @param user 需要保存的用户数据
 */
- (void) saveUser:(KSUser *) user {
    NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT INTO KSUser"];
    NSMutableString * keys = [NSMutableString stringWithFormat:@" ("];
    NSMutableString * values = [NSMutableString stringWithFormat:@" ( "];
    NSMutableArray * arguments = [NSMutableArray arrayWithCapacity:5];
    if (user.logid) {
        [keys appendString:@"logid,"];
        [values appendString:@"?,"];
        [arguments addObject:user.logid];
    }
    if (user.username) {
        [keys appendString:@"username,"];
        [values appendString:@"?,"];
        [arguments addObject:user.username];
    }
    if (user.description) {
        [keys appendString:@"description,"];
        [values appendString:@"?,"];
        [arguments addObject:user.description];
    }
    [keys appendString:@")"];
    [values appendString:@")"];
    [query appendFormat:@" %@ VALUES%@",
     [keys stringByReplacingOccurrencesOfString:@",)" withString:@")"],
     [values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];
    NSLog(@"%@",query);
    NSLog(@"插入一条数据");
    //[AppDelegate showStatusWithText:@"插入一条数据" duration:2.0];
    [_db executeUpdate:query withArgumentsInArray:arguments];
}

/**
 * @brief 删除一条用户数据
 *
 * @param uid 需要删除的用户的id,如果为空则全部删除。
 */
- (void) deleteUserWithId:(NSString *) uid {
    NSString * query = [NSString stringWithFormat:@"DELETE FROM KSUser "];
    if (uid) {
        query = [query stringByAppendingFormat:@"WHERE uid = '%@'",uid];
    }
    
    NSLog(@"删除一条数据");
    //[AppDelegate showStatusWithText:@"删除一条数据" duration:2.0];
    [_db executeUpdate:query];
}

/**
 * @brief 修改用户的信息
 *
 * @param user 需要修改的用户信息
 */
- (void) mergeWithUser:(KSUser *) user {
    if (!user.uid) {
        return;
    }
    NSString * query = @"UPDATE KSUser SET";
    NSMutableString * temp = [NSMutableString stringWithCapacity:20];
    // xxx = xxx;
    if (user.logid) {
        [temp appendFormat:@" logid = '%@',",user.logid];
    }
    if (user.username) {
        [temp appendFormat:@" username = '%@',",user.username];
    }
    if (user.description) {
        [temp appendFormat:@" description = '%@',",user.description];
    }
    [temp appendString:@")"];
    query = [query stringByAppendingFormat:@"%@ WHERE uid = '%@'",[temp stringByReplacingOccurrencesOfString:@",)" withString:@""],user.uid];
    NSLog(@"%@",query);
    
    NSLog(@"修改一条数据");
    //[AppDelegate showStatusWithText:@"修改一条数据" duration:2.0];
    [_db executeUpdate:query];
}

/**
 * @brief 模拟分页查找数据。取uid大于某个值以后的limit个数据
 *
 * @param uid
 * @param limit 每页取多少个
 */
- (NSArray *) findWithUid:(NSString *) uid limit:(int) limit {
    NSString * query = @"SELECT uid,logid,username,description FROM KSUser";
    if (!uid) {
        query = [query stringByAppendingFormat:@" ORDER BY uid DESC limit %d",limit];
    } else {
        query = [query stringByAppendingFormat:@" WHERE uid > %@ ORDER BY uid DESC limit %d",uid,limit];
    }
    
    FMResultSet * rs = [_db executeQuery:query];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
    NSLog(@"查询user的条数位： %i" ,[array count]);
	while ([rs next]) {
        KSUser * user = [KSUser new];
        user.uid = [rs stringForColumn:@"uid"];
        user.logid = [rs stringForColumn:@"logid"];
        user.username = [rs stringForColumn:@"username"];
        user.description = [rs stringForColumn:@"description"];
        [array addObject:user];
	}
	[rs close];
    return array;
}

@end
