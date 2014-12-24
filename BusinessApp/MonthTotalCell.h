//
//  MonthTotalCell.h
//  BusinessApp
//
//  Created by 喻雷 on 14/12/24.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MonthTotal.h"

@interface MonthTotalCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *TitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *numberLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

-(void)setContent:(MonthTotal*)info;
@end
