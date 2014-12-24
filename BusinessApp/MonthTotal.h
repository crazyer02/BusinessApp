//
//  MonthTotal.h
//  BusinessApp
//
//  Created by 喻雷 on 14/12/23.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MonthTotal : NSObject
@property (nonatomic, copy) NSString *total;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *ybidnum;
@property (nonatomic, strong) NSString *islook;//0未查看1已查看
@end
