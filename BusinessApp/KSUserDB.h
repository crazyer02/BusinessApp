//
//  KSUserDB.h
//  BusinessApp
//
//  Created by 喻雷 on 14/10/27.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

#import "KSDBManager.h"
#import "KSUser.h"

@interface KSUserDB : NSObject{
    FMDatabase* _db;
}
/**
 *  创建数据库
 */
-(void) createDataBase;

/**
 *  保存一条用户
 *
 *  @param user 需要保持的用户数据
 */
-(void) saveUser:(KSUser*)user;

/**
 * @brief 删除一条用户数据
 *
 * @param uid 需要删除的用户的id
 */
-(void) deleteUserWithId:(NSString*) logid;

/**
 * @brief 修改用户的信息
 *
 * @param user 需要修改的用户信息
 */
-(void) mergeWithUser:(KSUser*)user;

/**
 * @brief 模拟分页查找数据。取uid大于某个值以后的limit个数据
 *
 * @param uid
 * @param limit 每页取多少个
 */
-(NSArray*) findWithUid:(NSString*)uid limit:(int) limit;
@end
