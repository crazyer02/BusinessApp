//
//  MonthTotalHeader.h
//  BusinessApp
//
//  Created by 喻雷 on 15/1/13.
//  Copyright (c) 2015年 Kindstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonthTotalHeader : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelTotalPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelRefreshTime;

-(void)setContent:(NSString*)totalPrice refreshTime:(NSString *)time;
@end
