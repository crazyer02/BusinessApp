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
{
    BOOL hasPDF;
}
@end

@implementation KSReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pathToDownloadTo=[[NSString alloc]init];
    
    [self ReloadReportPdfData];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    hasPDF = [fileManager fileExistsAtPath:_pathToDownloadTo];
    if (hasPDF) {
        [self loadDocument:_pathToDownloadTo inView:_webview];
    }
    
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
    NSData *response=[webAccess GetReportPdf] ;
    if (response.length==0) {
        return NO;
    }
    
    NSString *filename = @"test.pdf";
    
    // Get the path to the App's Documents directory
    NSString *docPath = [self documentsDirectoryPath];
    // Combine the filename and the path to the documents dir into the full path
    _pathToDownloadTo = [NSString stringWithFormat:@"%@/%@", docPath, filename];
    NSLog(@"pathToDownloadTo: %@", _pathToDownloadTo);
    
    // Load the file from the remote server
    // NSData *tmp = [NSData dataWithContentsOfURL:theRessourcesURL];
    // Save the loaded data if loaded successfully
    if (response != nil) {
        
        NSError *error = nil;
        // Write the contents of our tmp object into a file
        [response writeToFile:_pathToDownloadTo options:NSDataWritingAtomic error:&error];
        if (error != nil) {
            NSLog(@"Failed to save the file: %@", [error description]);
        } else {
            // Display an UIAlertView that shows the users we saved the file :)
            UIAlertView *filenameAlert = [[UIAlertView alloc] initWithTitle:@"File saved" message:[NSString stringWithFormat:@"The file %@ has been saved.", filename] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [filenameAlert show];
        }
    }
    return NO;
}

-(void)loadDocument:(NSString *)path inView:(UIWebView *)webView
{
    //NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

/**
 Just a small helper function
 that returns the path to our
 Documents directory
 **/
- (NSString *)documentsDirectoryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    return documentsDirectoryPath;
}

//#pragma mark - UIWebViewDelegate
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    //if(navigationType == UIWebViewNavigationTypeLinkClicked) {
//    NSURL *requestedURL = [request URL];
//    // ...Check if the URL points to a file you're looking for...
//    // Then load the file
//    if (!hasPDF) {
//        NSData *fileData = [[NSData alloc] initWithContentsOfURL:requestedURL];
//        // Get the path to the App's Documents directory
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
//        [fileData writeToFile:[NSString stringWithFormat:@"%@/%@", documentsDirectory, [requestedURL lastPathComponent]] atomically:YES];
//    }
//    
//    //}
//    return YES;
//}
@end
