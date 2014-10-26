//
//  KSViewController.m
//  BusinessApp
//
//  Created by 喻雷 on 14-10-16.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

#import "KSViewController.h"
#import "GDataXMLNode.h"
#import "Reachability.h"

@interface KSViewController ()

@end

@implementation KSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    BOOL canConnectNetwork=[self isExiststenceNetwork];
    NSLog(@"Can connect network?----- %d",canConnectNetwork);
}

//检查是否存在网络
-(BOOL)isExiststenceNetwork
{
    BOOL isExistenceNetwork = FALSE;
    Reachability *r=[Reachability reachabilityWithHostName:@"http://192.168.8.4:8800/IApp"];
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

- (IBAction)doLoginBtn:(UIButton *)sender {
    
    if (![self isExiststenceNetwork]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"网络连接"
                                                            message:@"连接到康圣达服务器中断！"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        return;
    }
    NSString * loginMessage=[NSString  stringWithFormat:@"http://192.168.1.104:8800/IApp/GetUser_Login/%@/%@",self.logidLabel.text,self.pwdLabel.text];
    
    NSLog(@"%@",loginMessage);
    
    NSURL *url = [NSURL URLWithString: loginMessage];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    //[request setRequestMethod:@"POST"];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        GDataXMLDocument* doc=[[GDataXMLDocument alloc]initWithXMLString:response options:0 error:nil];
        
        NSArray* nodes=[doc.rootElement children];
        GDataXMLNode* nod=[nodes objectAtIndex:1];
        NSLog(@"%@", [nod stringValue]);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"测试"
                                                            message:[nod stringValue]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        
        
        [alertView show];
        [alertView release];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_logidLabel release];
    [_pwdLabel release];
    [super dealloc];
}
@end
