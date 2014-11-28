//
//  KSWebAccess.h
//  BusinessApp
//
//  Created by 喻雷 on 14/11/26.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHttpHeaders.h"
#import "KSUser.h"
#import "KSUserDB.h"

@interface KSWebAccess : NSObject
/**
 *  判断网络是否正常
 *
 *  @return <#return value description#>
 */
-(BOOL)isExiststenceNetwork;

/**
 *  访问web的登陆
 *
 *  @param logid <#logid description#>
 *  @param pwd   <#pwd description#>
 *
 *  @return <#return value description#>
 */
-(NSString*)AccessLogin:(NSString *)logid pwd:(NSString *)pwd;

/**
 *  访问web根据用户返回月纪录
 *
 *  @param logid <#logid description#>
 *  @param type  <#type description#>
 *
 *  @return <#return value description#>
 */
-(NSString*)AccessSpecimenNum:(NSString *)logid type:(NSString *)type;
@end
