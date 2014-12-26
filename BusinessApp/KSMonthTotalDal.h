//
//  KSMonthTotalDal.h
//  BusinessApp
//
//  Created by 喻雷 on 14/12/23.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSMonthTotalDal : NSObject{
    NSManagedObjectContext* _con;
}

//插入数据
- (void)insertCoreData:(NSMutableArray*)dataArray;

-(void)processCoreDate:(NSMutableArray*)dataArray;

- (void)updateData:(NSString*)unit  withIsLook:(NSString*)islook;

-(void)deleteData;

- (NSMutableArray*)selectData:(int)pageSize andOffset:(int)offset;
@end
