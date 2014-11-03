//
//  KSMainViewController.h
//  BusinessApp
//
//  Created by 喻雷 on 14/10/24.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSUser.h"
#import "KSUserDB.h"

@interface KSMainViewController : UIViewController

@property (nonatomic, strong) KSUser * user;
@property (nonatomic, strong) KSUserDB * userDB;

@end
