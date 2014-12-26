//
//  KSSrBaseDal.m
//  BusinessApp
//
//  Created by 喻雷 on 14/12/26.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

#import "KSSrBaseDal.h"
#import "CoreDateManager.h"
#import "SrBase.h"
@implementation KSSrBaseDal

-(void)processCoreDate:(NSMutableArray*)dataArray
{
    NSManagedObjectContext *context =_con; //[self managedObjectContext];
    
    for(SrBase *model in dataArray)
    {
        [self processModel:context model:model];
    }
    
}

//查询
- (NSMutableArray*)selectData:(int)pageSize andOffset:(int)offset andDate:(NSString*)cdrq
{
    NSManagedObjectContext *context = _con;
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"cdrq = %@",cdrq];
    // 限定查询结果的数量
    //setFetchLimit
    // 查询的偏移量
    //setFetchOffset
    NSSortDescriptor * sort = [NSSortDescriptor sortDescriptorWithKey:@"ind" ascending:NO];
    NSArray * sortDescriptors = [NSArray arrayWithObject: sort];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:pageSize];
    [fetchRequest setFetchOffset:offset];
    [fetchRequest setSortDescriptors: sortDescriptors];
    NSEntityDescription *entity = [NSEntityDescription entityForName:SrBaseTableName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (SrBase *info in fetchedObjects) {
        NSLog(@"Id:%@", info.ind);
        //NSLog(@"total:%@", info.total);
        [resultArray addObject:info];
    }
    return resultArray;
}

-(NSString*) getMaxId
{
    NSManagedObjectContext *context = _con;
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"ind"];
    
    NSExpression *maxSalaryExpression = [NSExpression expressionForFunction:@"max:"                                                                  arguments:[NSArray arrayWithObject:keyPathExpression]];
    
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    
    [expressionDescription setName:@"maxSalary"];
    
    [expressionDescription setExpression:maxSalaryExpression];
    
    [expressionDescription setExpressionResultType:NSDecimalAttributeType];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
    NSEntityDescription *entity = [NSEntityDescription entityForName:SrBaseTableName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    for (SrBase *info in fetchedObjects) {
        return info.ind;
    }
    return @"0";
}
#pragma mark - private function

- (void)processModel:(NSManagedObjectContext *)context model:(SrBase *)model
{
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"ind = %@",model.ind];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:SrBaseTableName inManagedObjectContext:context]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    
    NSError *error = nil;
    //这里获取到的是一个数组，你需要取出你要更新的那个obj
    NSArray *result = [context executeFetchRequest:request error:&error];
    if([result count]==0)
    {
        [self insertModel:context model:model];
    }
    else if([result count]==1)
    {
        [self updateModel:context model:model];
    }
}


- (void)insertModel:(NSManagedObjectContext *)context model:(SrBase *)model
{
    SrBase *info = [NSEntityDescription insertNewObjectForEntityForName:SrBaseTableName inManagedObjectContext:context];
    [info initWithModel:model];
    NSError *error;
    if(![context save:&error])
    {
        NSLog(@"不能保存：%@",[error localizedDescription]);
    }
}

- (void)updateModel:(NSManagedObjectContext *)context model:(SrBase *)model
{
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"ind = %@",model.ind];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:SrBaseTableName inManagedObjectContext:context]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    
    NSError *error = nil;
    //这里获取到的是一个数组，你需要取出你要更新的那个obj
    NSArray *result = [context executeFetchRequest:request error:&error];
    for (SrBase *info in result) {
        info.jsjg = model.jsjg;
        info.newjsjg=model.newjsjg;
        info.jszk=model.jszk;
        info.jymdsf=model.jymdsf;
    }
    
    //保存
    if ([context save:&error]) {
        //更新成功
        NSLog(@"更新成功");
    }
}
@end
