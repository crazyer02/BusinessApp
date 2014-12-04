//
//  KSMainViewController.h
//  BusinessApp
//
//  Created by 喻雷 on 14/10/24.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "KSUser.h"
//#import "KSUserDB.h"
#import "MYBlurIntroductionView.h"
#import "KSUserDal.h"
#import "User.h"
@interface KSMainViewController : UIViewController<MYIntroductionDelegate>

//@property (nonatomic, strong) KSUser * user;
//@property (nonatomic, strong) KSUserDB * userDB;
@property (nonatomic, strong) KSUserDal * userDal;
@property (nonatomic, strong) User * user;

@end
