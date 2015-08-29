//
//  KSReportViewController.m
//  BusinessApp
//
//  Created by Black on 15/8/28.
//  Copyright (c) 2015年 Kindstar. All rights reserved.
//

#import "KSReportViewController.h"
#import "KSWebAccess.h"

@interface KSReportViewController ()

@end

@implementation KSReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)ReloadReportPdfData
{
    // 判断网络是否连接上公司网络
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
    NSString *response=[webAccess GetReportPdf];
    if (response.length==0) {
        return NO;
        
    }
    return NO;
}

-(void)loadDocument:(NSString *)documentName inView:(UIWebView *)webView
{
    NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}
@end
