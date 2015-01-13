//
//  KSSaleDayViewController.h
//  BusinessApp
//
//  Created by 喻雷 on 14/12/19.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCMultiSortTableView.h"
#import "MonthTotal.h"
#import "User.h"
#import "KSSrBaseDal.h"
#import "SrBase.h"

@interface KSSaleDayViewController : UIViewController<XCMultiTableViewDataSource>
{
   KSSrBaseDal *srBaseDal;
}

@property (strong, nonatomic) IBOutlet XCMultiTableView *tableView;

/**
 *  接受过来的user实体
 */
@property(nonatomic,weak)User *reciveUser;
@property(nonatomic,weak)MonthTotal *reciveDay;

@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic,strong) SrBase *srBasedata;
@end
