//
//  KSUserDal.m
//  BusinessApp
//
//  Created by 喻雷 on 14/12/3.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

#import "KSUserDal.h"
#import "CoreDateManager.h"

@implementation KSUserDal

/**
 *  初始化重写
 *
 *  @return <#return value description#>
 */
- (id)init
{
    self = [super init];
    if (self) {
        //========== 首先查看有没有建立message的数据库，如果未建立，则建立数据库=========
        _con=[[CoreDateManager defaultCoreDateManager] managedObjectContext];
    }
    return self;
}

//插入数据
- (void)insertCoreData:(NSMutableArray*)dataArray
{
    NSManagedObjectContext *context =_con; //[self managedObjectContext];
    for (User *user in dataArray) {
        User *userInfo = [NSEntityDescription insertNewObjectForEntityForName:TableName inManagedObjectContext:context];
        userInfo.logid = user.logid;
        userInfo.username = user.username;
        userInfo.departmentName = user.departmentName;
        
        NSError *error;
        if(![context save:&error])
        {
            NSLog(@"不能保存：%@",[error localizedDescription]);
        }
    }
}

//查询
- (NSMutableArray*)selectData:(int)pageSize andOffset:(int)currentPage
{
    NSManagedObjectContext *context = _con;
    
    // 限定查询结果的数量
    //setFetchLimit
    // 查询的偏移量
    //setFetchOffset
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setFetchLimit:pageSize];
    [fetchRequest setFetchOffset:currentPage];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:TableName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (User *info in fetchedObjects) {
        NSLog(@"logid:%@", info.logid);
        NSLog(@"username:%@", info.username);
        [resultArray addObject:info];
    }
    return resultArray;
}

//删除
-(void)deleteData
{
    NSManagedObjectContext *context = _con;
    NSEntityDescription *entity = [NSEntityDescription entityForName:TableName inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    if (!error && datas && [datas count])
    {
        for (NSManagedObject *obj in datas)
        {
            [context deleteObject:obj];
        }
        if (![context save:&error])
        {
            NSLog(@"error:%@",error);
        }
    }
}
//更新
- (void)updateData:(NSString*)newsId  withIsLook:(NSString*)islook
{
    NSManagedObjectContext *context = _con;
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"newsid like[cd] %@",newsId];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:TableName inManagedObjectContext:context]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    
    //https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/Predicates/Articles/pCreating.html
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
//    for (User *info in result) {
//        info.islook = islook;
//    }
//    
//    //保存
//    if ([context save:&error]) {
//        //更新成功
//        NSLog(@"更新成功");
//    }
}

@end
