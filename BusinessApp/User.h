//
//  User.h
//  BusinessApp
//
//  Created by Black on 15/3/29.
//  Copyright (c) 2015年 Kindstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface User : NSObject

@property (nonatomic,copy) NSString * departmentName;
@property (nonatomic,copy) NSString * descrip;
@property (nonatomic,copy) NSString * logid;
@property (nonatomic,copy) NSString * username;
@end
