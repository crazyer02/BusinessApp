//
//  KSSaleDayViewController.h
//  BusinessApp
//
//  Created by 喻雷 on 14/12/19.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCMultiSortTableView.h"

@interface KSSaleDayViewController : UIViewController<XCMultiTableViewDataSource>

@property (strong, nonatomic) IBOutlet XCMultiTableView *tableView;

@end
