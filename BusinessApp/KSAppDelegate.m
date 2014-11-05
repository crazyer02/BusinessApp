//
//  KSAppDelegate.m
//  BusinessApp
//
//  Created by 喻雷 on 14-10-16.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

#import "KSAppDelegate.h"

@interface KSAppDelegate ()

@property (nonatomic, strong) UIWindow * statusWindow;
@property (nonatomic, strong) UILabel * statusLabel;

@end

@implementation KSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
  
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

///**
// * @brief 在状态栏显示 一些Log
// *
// * @param string 需要显示的内容
// * @param duration  需要显示多长时间
// */
//+ (void) showStatusWithText:(NSString *) string duration:(NSTimeInterval) duration {
//    
//    KSAppDelegate * delegate = (KSAppDelegate *) [UIApplication sharedApplication].delegate;
//    
//    delegate.statusLabel.text = string;
//    [delegate.statusLabel sizeToFit];
//    CGRect rect = [UIApplication sharedApplication].statusBarFrame;
//    CGFloat width = delegate.statusLabel.frame.size.width;
//    CGFloat height = rect.size.height;
//    rect.origin.x = rect.size.width - width - 5;
//    rect.size.width = width;
//    delegate.statusWindow.frame = rect;
//    delegate.statusLabel.frame = CGRectMake(0, 0, width, height);
//    
//    if (duration < 1.0) {
//        duration = 1.0;
//    }
//    if (duration > 4.0) {
//        duration = 4.0;
//    }
//    [delegate performSelector:@selector(dismissStatus) withObject:nil afterDelay:duration];
//}
//
///**
// * @brief 干掉状态栏文字
// */
//- (void) dismissStatus {
//    CGRect rect = self.statusWindow.frame;
//    rect.origin.y -= rect.size.height;
//    [UIView animateWithDuration:0.5 animations:^{
//        self.statusWindow.frame = rect;
//    }];
//}
@end
