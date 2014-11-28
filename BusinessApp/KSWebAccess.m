//
//  KSWebAccess.m
//  BusinessApp
//
//  Created by 喻雷 on 14/11/26.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

#import "KSWebAccess.h"
#import "Reachability.h"
#import "GDataXMLNode.h"

#define kindstarUrl @"www.kindstar.com.cn"
#define kReachabilityUrl @"http://58.48.110.2:8900/IApp"

@implementation KSWebAccess

//检查是否存在网络
-(BOOL)isExiststenceNetwork
{
    BOOL isExistenceNetwork = FALSE;
    Reachability *r=[Reachability reachabilityWithHostName:kindstarUrl];
    switch ([r currentReachabilityStatus])
    {
        case NotReachable:
            isExistenceNetwork=FALSE;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork=TRUE;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork=TRUE;
            break;
    }
    return isExistenceNetwork;
}

#pragma mark -
-(NSString*)AccessLogin:(NSString *)logid pwd:(NSString *)pwd
{
    NSString * loginMessage=[kReachabilityUrl stringByAppendingString:[NSString stringWithFormat:@"/GetUser_Login/%@/%@",logid,pwd]];
    
    NSLog(@"%@",loginMessage);
    
    return [self WebAppAccess:loginMessage];
}



-(NSString*)AccessSpecimenNum:(NSString *)logid type:(NSString *)type
{
    NSString * resultMessage=[kReachabilityUrl stringByAppendingString:[NSString stringWithFormat:@"/GetSpecimenNum/%@/%@",logid,type]];
    
    NSLog(@"%@",resultMessage);
    
    return [self WebAppAccess:resultMessage];
}

#pragma mark - private function
- (NSString*)WebAppAccess:(NSString *)resultMessage
{
    NSURL *url = [NSURL URLWithString: resultMessage];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    //[request setRequestMethod:@"POST"];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    NSString *response=[[NSString alloc]init];
    if (!error) {
        response= [request responseString];
        NSLog(@"%@",response);
        return response;
    }
    return response;
}
@end
