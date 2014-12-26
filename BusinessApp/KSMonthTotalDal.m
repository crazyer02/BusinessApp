//
//  KSMonthTotalDal.m
//  BusinessApp
//
//  Created by 喻雷 on 14/12/23.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

#import "KSMonthTotalDal.h"
#import "CoreDateManager.h"
#import "MonthTotal.h"

@implementation KSMonthTotalDal

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
    
    //找出数据库中所有的数据
    NSMutableArray *array = [self selectData:32 andOffset:0];
    for(MonthTotal *model in dataArray)
    {
        BOOL isNotExists=false;
        for (MonthTotal *info in array)
        {
            //NSLog(@"unit:%@; %@",model.unit, info.unit);
            if ([model.unit isEqualToString: info.unit] && ![model.total isEqualToString: info.total])
            {
                [self updateModel:context model:model];
                isNotExists=true;
                break;
            } else if([model.unit isEqualToString: info.unit] && [model.total isEqualToString: info.total]){
                isNotExists=true;
                break;
            }
            isNotExists=false;
        }
        
        if (!isNotExists)  {
            [self insertModel:context model:model];
        }
    }
    
//    for (MonthTotal *model in dataArray) {
//        [self insertModel:context model:model];
//    }
}

-(void)processCoreDate:(NSMutableArray*)dataArray
{
    
}

//更新
- (void)updateData:(NSString*)unit  withIsLook:(NSString*)islook
{
    NSManagedObjectContext *context =_con;
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"unit = %@",unit];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:MonthTableName inManagedObjectContext:context]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
    for (MonthTotal *info in result) {
        info.islook = islook;
    }
    
    //保存
    if ([context save:&error]) {
        //更新成功
        NSLog(@"更新成功");
    }
}

//查询
- (NSMutableArray*)selectData:(int)pageSize andOffset:(int)offset
{
    NSManagedObjectContext *context = _con;
    
    // 限定查询结果的数量
    //setFetchLimit
    // 查询的偏移量
    //setFetchOffset
    NSSortDescriptor * sort = [NSSortDescriptor sortDescriptorWithKey:@"unit" ascending:NO];
    NSArray * sortDescriptors = [NSArray arrayWithObject: sort];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setFetchLimit:pageSize];
    [fetchRequest setFetchOffset:offset];
    [fetchRequest setSortDescriptors: sortDescriptors];
    NSEntityDescription *entity = [NSEntityDescription entityForName:MonthTableName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (MonthTotal *info in fetchedObjects) {
        NSLog(@"unit:%@", info.unit);
        NSLog(@"total:%@", info.total);
        [resultArray addObject:info];
    }
    return resultArray;
}

//删除
-(void)deleteData
{
    NSManagedObjectContext *context = _con;
    NSEntityDescription *entity = [NSEntityDescription entityForName:MonthTableName inManagedObjectContext:context];
    
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

#pragma mark - private function

- (void)insertModel:(NSManagedObjectContext *)context model:(MonthTotal *)model
{
    MonthTotal *tatolInfo = [NSEntityDescription insertNewObjectForEntityForName:MonthTableName inManagedObjectContext:context];
    tatolInfo.unit = model.unit;
    tatolInfo.ybidnum = model.ybidnum;
    tatolInfo.total = model.total;
    tatolInfo.islook=@"0";
    NSError *error;
    if(![context save:&error])
    {
        NSLog(@"不能保存：%@",[error localizedDescription]);
    }
}

- (void)updateModel:(NSManagedObjectContext *)context model:(MonthTotal *)model
{
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"unit = %@",model.unit];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:MonthTableName inManagedObjectContext:context]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    
    NSError *error = nil;
    //这里获取到的是一个数组，你需要取出你要更新的那个obj
    NSArray *result = [context executeFetchRequest:request error:&error];
    for (MonthTotal *info in result) {
        info.islook = model.islook;
        info.unit=model.unit;
    }
    
    //保存
    if ([context save:&error]) {
        //更新成功
        NSLog(@"更新成功");
    }}

@end
