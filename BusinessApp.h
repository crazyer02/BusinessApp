//
//  BusinessApp.h
//  BusinessApp
//
//  Created by 喻雷 on 14/12/2.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BusinessApp : NSManagedObject

@property (nonatomic, retain) NSString * departmentName;
@property (nonatomic, retain) NSString * descrip;
@property (nonatomic, retain) NSString * logid;
@property (nonatomic, retain) NSString * username;

@end
