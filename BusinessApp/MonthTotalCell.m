//
//  MonthTotalCell.m
//  BusinessApp
//
//  Created by 喻雷 on 14/12/24.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

#import "MonthTotalCell.h"

@implementation MonthTotalCell

- (void)awakeFromNib {
    // Initialization code
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        _TitleLabel.textColor = [UIColor darkGrayColor];
    }
}

-(void)setContent:(MonthTotal*)info
{
    _numberLabel.text=info.ybidnum;
    _TitleLabel.text = info.unit;
    _priceLabel.text = info.total;
    if ([info.islook isEqualToString:@"1"]) {
        _TitleLabel.textColor = [UIColor darkGrayColor];
    }
}

@end
