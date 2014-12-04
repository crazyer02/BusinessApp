//
//  KSViewController.h
//  BusinessApp
//
//  Created by 喻雷 on 14-10-16.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ASIHttpHeaders.h"
//#import "KSUser.h"
//#import "KSUserDB.h"
#import "MBProgressHUD.h"
//#import <sqlite3.h>
#import "KSUserDal.h"
#import "User.h"

@interface KSViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITextField *logidLabel;
@property (retain, nonatomic) IBOutlet UITextField *pwdLabel;

//@property (nonatomic, strong) KSUser * user;
//
//@property (nonatomic, strong) KSUserDB * userDB;
@property (nonatomic, strong) User * user;
@property(nonatomic,strong) KSUserDal *userDal;
@end
