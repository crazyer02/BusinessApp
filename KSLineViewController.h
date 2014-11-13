//
//  KSLineViewController.h
//  BusinessApp
//
//  Created by 喻雷 on 14/11/13.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "BEMSimpleLineGraphView.h"

@interface KSLineViewController : UIViewController<BEMSimpleLineGraphDelegate>

@property (strong, nonatomic) IBOutlet BEMSimpleLineGraphView *myGraph;

@property (strong, nonatomic) NSMutableArray *ArrayOfValues;
@property (strong, nonatomic) NSMutableArray *ArrayOfDates;

//@property (strong, nonatomic) IBOutlet UILabel *labelValues;
//@property (strong, nonatomic) IBOutlet UILabel *labelDates;

@end
