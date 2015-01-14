//
//  MonthTotalHeader.m
//  BusinessApp
//
//  Created by 喻雷 on 15/1/13.
//  Copyright (c) 2015年 Kindstar. All rights reserved.
//

#import "MonthTotalHeader.h"

@implementation MonthTotalHeader

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setContent:(NSString*)totalPrice refreshTime:(NSString *)time{

    _labelTotalPrice.text = [NSString stringWithFormat:@"¥%@",totalPrice];
    _labelRefreshTime.text = time;
}
@end
