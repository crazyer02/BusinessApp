//
//  KSUserDal.h
//  BusinessApp
//
//  Created by 喻雷 on 14/12/3.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSUserDal : NSObject{
    NSManagedObjectContext* _con;
}


//插入数据
- (void)insertCoreData:(NSMutableArray*)dataArray;
//查询
- (NSMutableArray*)selectData:(int)pageSize andOffset:(int)currentPage;
//删除
- (void)deleteData;
//更新
- (void)updateData:(NSString*)newsId withIsLook:(NSString*)islook;
@end
