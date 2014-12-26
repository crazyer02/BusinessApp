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
#import "KSMonthTotalDal.h"
#import "MonthTotalCell.h"


@interface KSMainViewController : UIViewController<MYIntroductionDelegate>{
    
    IBOutlet UITableView *monthTableView;
    KSMonthTotalDal *monthDal;
}

@property (nonatomic, strong) KSUserDal * userDal;
@property (nonatomic, strong) User * user;

@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic,strong) MonthTotal *daydata;
@end
