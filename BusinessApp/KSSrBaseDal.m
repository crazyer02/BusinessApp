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
    //把字符串传唤成如：12-01 00:00
    if(cdrq)
    {
        cdrq= [cdrq substringWithRange:NSMakeRange(5,5)];
        cdrq=[cdrq stringByAppendingString:@" 00:00"];
    }
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
    if (pageSize!=-1) {
        [fetchRequest setFetchLimit:pageSize];
        [fetchRequest setFetchOffset:offset];
    }
    [fetchRequest setSortDescriptors: sortDescriptors];
    NSEntityDescription *entity = [NSEntityDescription entityForName:SrBaseTableName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (SrBase *info in fetchedObjects) {
        NSLog(@"Id:%@ ; brxm:%@; cdrq:%@", info.ind,info.brxm,info.cdrq);
        [resultArray addObject:info];
    }
    return resultArray;
}

-(NSNumber*) getMaxId:(NSString*)cdrq
{
    NSManagedObjectContext *context = _con;
    //把字符串传唤成如：12-01 00:00
    if(cdrq)
    {
        cdrq= [cdrq substringWithRange:NSMakeRange(5,5)];
        cdrq=[cdrq stringByAppendingString:@" 00:00"];
    }
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"cdrq = %@",cdrq];
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"ind"];
    
    NSExpression *maxSalaryExpression = [NSExpression expressionForFunction:@"max:"                                                                  arguments:[NSArray arrayWithObject:keyPathExpression]];
    
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    [expressionDescription setName:@"maxInd"];
    [expressionDescription setExpression:maxSalaryExpression];
    [expressionDescription setExpressionResultType:NSInteger32AttributeType];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:SrBaseTableName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
    //这里不加则后面会报异常错误
    [fetchRequest setResultType:NSDictionaryResultType];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects && fetchedObjects.count > 0)
    {
        return [fetchedObjects[0] objectForKey:@"maxInd"];
    }
    return [NSNumber numberWithInt:0];
}
#pragma mark - private function

- (void)processModel:(NSManagedObjectContext *)context model:(SrBase *)model
{
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"ind = %d",model.ind];
    
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
    info.brxm = model.brxm;
    info.byh=model.byh;
    info.bz=model.bz;
    info.cdrq=model.cdrq;
    info.cpx=model.cpx;
    info.cpzy=model.cpzy;
    info.fuzenren=model.fuzenren;
    info.gname=model.gname;
    info.guishu=model.guishu;
    info.hezuozhuangtai=model.hezuozhuangtai;
    info.ind=model.ind;
    info.jiesuanfangshi=model.jiesuanfangshi;
    info.jsjg=model.jsjg;
    info.jspj=model.jspj;
    info.jszk=model.jszk;
    info.jymddm=model.jymddm;
    info.jymdmc=model.jymdmc;
    info.jymdsf=model.jymdsf;
    info.khks=model.khks;
    info.leibei=model.leibei;
    info.newjsjg=model.newjsjg;
    info.qrry=model.qrry;
    info.qrsj=model.qrsj;
    info.qrzt=model.qrzt;
    info.sheng=model.sheng;
    info.shi=model.shi;
    info.tsjg=model.tsjg;
    info.xian=model.xian;
    info.xjjg=model.xjjg;
    info.ybid=model.ybid;
    info.yiyuanjibie=model.yiyuanjibie;
    info.zhangqi=model.zhangqi;
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
