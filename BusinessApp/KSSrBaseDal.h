//
//  KSSrBaseDal.h
//  BusinessApp
//
//  Created by 喻雷 on 14/12/26.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSSrBaseDal : NSObject{
    NSManagedObjectContext* _con;
}

-(void)processCoreDate:(NSMutableArray*)dataArray;

-(void)deleteData;

- (NSMutableArray*)selectData:(int)pageSize andOffset:(int)offset;

-(NSString*)getMaxId;
@end
