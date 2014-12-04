//
//  CheckOut.h
//  BusinessApp
//
//  Created by 喻雷 on 14/12/2.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CheckOut : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * price;
@property (nonatomic, retain) NSString * hospitalName;
@property (nonatomic, retain) NSString * itemId;
@property (nonatomic, retain) NSString * itemName;

@end
