//
//  KSLogedViewController.h
//  BusinessApp
//
//  Created by 喻雷 on 14/10/28.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSUser.h"

@interface KSLogedViewController : UIViewController
@property (retain, nonatomic) IBOutlet UILabel *logidLabel;
@property (retain, nonatomic) IBOutlet UILabel *usernameLabel;
@property (retain, nonatomic) IBOutlet UILabel *departmentNameLabel;

/**
 *  接受过来的user实体
 */
@property(nonatomic,weak)KSUser *reciveUser;

@end
