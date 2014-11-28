//
//  KSViewController.m
//  BusinessApp
//
//  Created by 喻雷 on 14-10-16.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

#import "KSViewController.h"
#import "GDataXMLNode.h"
//import "Reachability.h"
#import "KSUserDB.h"
#import "KSWebAccess.h"
#import "KSAppDelegate.h"

@interface KSViewController ()

@end

@implementation KSViewController

BOOL isSuccess;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    KSWebAccess *webAccess=[[KSWebAccess alloc]init];
    BOOL canConnectNetwork=[webAccess isExiststenceNetwork];
    NSLog(@"Can connect network?----- %d",canConnectNetwork);
    self.userDB=[[KSUserDB alloc] init];
    _user= [[KSUser alloc] init];
    
}


- (BOOL)Login {
    KSWebAccess *webAccess=[[KSWebAccess alloc]init];
    if (![webAccess isExiststenceNetwork]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"网络连接"
                                                            message:@"无法连接到网络！"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    NSString *response=[webAccess AccessLogin:self.logidLabel.text pwd:self.pwdLabel.text];
    
    if (response.length==0) {
        return NO;
        
    }
    GDataXMLDocument* doc=[[GDataXMLDocument alloc]initWithXMLString:response options:0 error:nil];
    
    NSArray* nodes=[doc.rootElement children];
    
    for (int i=0; i<[nodes count]; i++) {
        GDataXMLElement* ele=[nodes objectAtIndex:i];
        
        if([[ele name] isEqualToString:@"LogId"]){
            //根据<name value="wusj"/>
            //[[ele attributeForName:@"value"] stringValue]);
            _user.logid=[ele stringValue];
        }
        if([[ele name] isEqualToString:@"UserName"]){
            //根据<name value="wusj"/>
            //[[ele attributeForName:@"value"] stringValue]);
            _user.username=[ele stringValue];
        }
        if([[ele name] isEqualToString:@"DepartmentName"]){
            _user.departmentName=[ele stringValue];
        }
    }
    
    if (self.user) {
        [_userDB deleteUserWithId:nil];
        [_userDB saveUser:self.user];
        
        NSLog(@"qingkong user");
        return YES;
        //[self performSegueWithIdentifier:@"doLoginReturnMain" sender:self];
        //self.user=[_userDB findWithUid:nil limit:10];
        //[self.navigationController pushViewController:KSM animated:<#(BOOL)#>]
    }
    return NO;
    
}

//登录事件
- (IBAction)doLoginBtn:(UIButton *)sender {
    //    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    hud.mode = MBProgressHUDModeIndeterminate;
    //    hud.labelText = @"登录中...";
    //
    //    hud.removeFromSuperViewOnHide = YES;
    //    [hud hide:YES afterDelay:10];
    
    
    MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"登录中...";
    HUD.dimBackground = YES;
    [HUD showAnimated:YES whileExecutingBlock:^{
        isSuccess=[self Login];
        NSLog(@"%@",@"登录中.......");
    } completionBlock:^{
        [HUD removeFromSuperview];
        //        [HUD release];
        if (isSuccess) {
            // 设置全局登陆变量
            KSAppDelegate *delegate=(KSAppDelegate*)[[UIApplication sharedApplication]delegate];
            delegate.loginId=_user.logid;
            [self performSegueWithIdentifier:@"doLoginReturnMain" sender:self];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录信息"
                                                                message:@"登录的用户名或者密码不正确！"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
            
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)dealloc {
//    [_logidLabel release];
//    [_pwdLabel release];
//    [super dealloc];
//}
@end
