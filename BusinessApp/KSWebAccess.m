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

-(NSString*)GetMonthTotal:(NSString *)logid
{
    logid=@"01154";
    
    NSString * resultMessage=[kReachabilityUrl stringByAppendingString:[NSString stringWithFormat:@"/GetMonthTotal/%@",logid]];
    
    NSLog(@"%@",resultMessage);
    
    return [self WebAppAccess:resultMessage];
}

-(NSString*)QueryCheckAccount:(NSString *)logid andDate:(NSString *)date andMaxBaseId:(NSNumber*)maxId
{
    logid=@"01154";
    
    NSString * resultMessage=[kReachabilityUrl stringByAppendingString:[NSString stringWithFormat:@"/QueryCheckAccount/%@/%@/%@/0/0/0",logid,date,maxId]];
    
    NSLog(@"%@",resultMessage);
    
    return [self WebAppAccess:resultMessage];
}

/**
 *  获取报告的pdf二进制数据
 *
 *  @param date <#date description#>
 *  @param yqdh <#yqdh description#>
 *  @param ybbh <#ybbh description#>
 *
 *  @return <#return value description#>
 */
-(NSData*)GetReportPdf//:(NSString *)date andYqdh:(NSString *)yqdh andYbbh:(NSString*)ybbh
{
    NSString * date=@"2013-12-02 00:00:00.000";
    NSString * yqdh=@"ACL-TOP700";
    NSString * ybbh=@"2013";
    NSString * resultMessage=[kReachabilityUrl stringByAppendingString:[NSString stringWithFormat:@"/QueryCheckAccount/%@/%@/%@/1",date,yqdh,ybbh]];
    
    //NSLog(@"%@",resultMessage);
    
    return [self WebAppAccessData:resultMessage];
}

#pragma mark - private function
/**
 *  这个是接收字符串数据的
 *
 *  @param resultMessage <#resultMessage description#>
 *
 *  @return <#return value description#>
 */
- (NSString*)WebAppAccess:(NSString *)resultMessage
{
    //比如URL中包含汉字、空格等字符时，需要显示的转换一下
    resultMessage = [resultMessage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
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

/**
 *  这个是接收二进制数据的
 *
 *  @param resultMessage <#resultMessage description#>
 *
 *  @return <#return value description#>
 */
- (NSData*)WebAppAccessData:(NSString *)resultMessage
{
    //比如URL中包含汉字、空格等字符时，需要显示的转换一下
    resultMessage = [resultMessage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString: resultMessage];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    //[request setRequestMethod:@"POST"];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    NSData *response=[[NSData alloc]init];
    if (!error) {
        response= [request responseData ];
        //因为这里数据时asci格式的，需要转化成Utf8格式才能显示报告中的中文，否则报告消失
        if(response != nil)
        {
            NSString* newStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            
            NSString *newStr01 = [newStr substringFromIndex:1];
            
            NSString *truncatedString = [newStr01 substringToIndex:[newStr01 length]-1];
            
            NSArray* testArray = [[NSArray alloc] init];
            
            testArray = [truncatedString componentsSeparatedByString:@","];
            
            NSData *data = [NSPropertyListSerialization dataFromPropertyList:testArray format:NSPropertyListBinaryFormat_v1_0 errorDescription:&error];
            
            
            NSMutableData* mutableData = [data mutableCopy];
            
            for (NSNumber *byteVal in testArray)
            {
                Byte b = (Byte)(byteVal.intValue);
                [mutableData appendBytes:&b length:1];
            }

            return mutableData;
        }
        //NSLog(@"%@",response);
        
    }
    return response;
}
@end
