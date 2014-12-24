//
//  CoreDateManager.h
//  SQLiteTest
//
//  Created by 喻雷 on 14/12/3.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#define TableName @"User"
#define MonthTableName @"MonthTotal"

@interface CoreDateManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

/// 单例模式
+(CoreDateManager*) defaultCoreDateManager;

@end
