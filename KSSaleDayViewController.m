//
//  KSSaleDayViewController.m
//  BusinessApp
//
//  Created by 喻雷 on 14/12/19.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

#import "KSSaleDayViewController.h"
#import "KSMainViewController.h"
#import "KSSrBaseDal.h"
#import "KSWebAccess.h"
#import "GDataXMLNode.h"

@interface KSSaleDayViewController()<XCMultiTableViewDataSource>

@end

@implementation KSSaleDayViewController{
    NSMutableArray *headData;
    NSMutableArray *leftTableData;
    NSMutableArray *rightTableData;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];

    srBaseDal=[[KSSrBaseDal alloc]init];
    NSString *maxId =[srBaseDal getMaxId];
    if ([maxId isEqual:@"0"]) {
        //如果无此对象，表示第一次，那么就读数据写到数据库中
        [self writeDate];
        
    }
    else{
    }
    [self initData];
    
    [self.tableView initWithFrame:CGRectInset(self.tableView.bounds,0,0)];
    //指定是否显示左边冻结的栏
    self.tableView.leftHeaderEnable = YES;
    //指定数据委托
    self.tableView.datasource = self;
}

-(void)writeDate
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",[NSDate timeIntervalSinceReferenceDate]] forKey:@"updateDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    KSWebAccess *webAccess=[[KSWebAccess alloc]init];
    NSString *response=[webAccess GetMonthTotal:_reciveUser.logid];
    if (nil!=response||response.length>0||![response isEqualToString:@""])
    {
        GDataXMLDocument* doc=[[GDataXMLDocument alloc]initWithXMLString:response options:0 error:nil];
        
        NSArray* nodes=[doc.rootElement elementsForName:@"QueryItem"];
        _resultArray = [NSMutableArray arrayWithCapacity:nodes.count];
        for (GDataXMLElement *ele in nodes) {
            MonthTotal *info=[[MonthTotal alloc]init];
            GDataXMLElement *totalElement=[[ele elementsForName:@"Total"]objectAtIndex:0];
            info.total= [totalElement stringValue];
            
            GDataXMLElement *unitElement=[[ele elementsForName:@"Unit"]objectAtIndex:0];
            info.unit= [unitElement stringValue];
            
            GDataXMLElement *numElement=[[ele elementsForName:@"YbidNum"]objectAtIndex:0];
            info.ybidnum= [numElement stringValue];
            
            [_resultArray addObject:info];
        }
    }
    
    //把数据写到数据库
    [srBaseDal processCoreDate:_resultArray];

}

/**
 *  初始化数据
 */
- (void)initData {
    headData = [NSMutableArray arrayWithCapacity:10];
    [headData addObject:@"姓名"];
    [headData addObject:@"年龄"];
    [headData addObject:@"性别"];
    [headData addObject:@"身份"];
    [headData addObject:@"电话"];
    leftTableData = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *one = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < 10; i++) {
        [one addObject:[NSString stringWithFormat:@"ki-%d", i]];
    }
    [leftTableData addObject:one];
    //    NSMutableArray *two = [NSMutableArray arrayWithCapacity:10];
    //    for (int i = 3; i < 10; i++) {
    //        [two addObject:[NSString stringWithFormat:@"ki-%d", i]];
    //    }
    //    [leftTableData addObject:two];

    
    rightTableData = [NSMutableArray arrayWithCapacity:10];
    
    NSMutableArray *oneR = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < 10; i++) {
        NSMutableArray *ary = [NSMutableArray arrayWithCapacity:10];
        for (int j = 0; j < 5; j++) {
            if (j == 1) {
                [ary addObject:[NSNumber numberWithInt:random() % 5]];
            }else if (j == 2) {
                [ary addObject:[NSNumber numberWithInt:random() % 10]];
            }
            else {
                [ary addObject:[NSString stringWithFormat:@"column %@ %@", _reciveDay.unit, _reciveUser.username]];
            }
        }
        [oneR addObject:ary];
    }
    [rightTableData addObject:oneR];
    
    //    NSMutableArray *twoR = [NSMutableArray arrayWithCapacity:10];
    //    for (int i = 3; i < 10; i++) {
    //        NSMutableArray *ary = [NSMutableArray arrayWithCapacity:10];
    //        for (int j = 0; j < 5; j++) {
    //            if (j == 1) {
    //                [ary addObject:[NSNumber numberWithInt:random() % 5]];
    //            }else if (j == 2) {
    //                [ary addObject:[NSNumber numberWithInt:random() % 5]];
    //            }else {
    //                [ary addObject:[NSString stringWithFormat:@"column %d %d", i, j]];
    //            }
    //        }
    //        [twoR addObject:ary];
    //    }
    //    [rightTableData addObject:twoR];
}

#pragma mark - XCMultiTableViewDataSource


- (NSArray *)arrayDataForTopHeaderInTableView:(XCMultiTableView *)tableView {
    return [headData copy];
}
- (NSArray *)arrayDataForLeftHeaderInTableView:(XCMultiTableView *)tableView InSection:(NSUInteger)section {
    return [leftTableData objectAtIndex:section];
}

- (NSArray *)arrayDataForContentInTableView:(XCMultiTableView *)tableView InSection:(NSUInteger)section {
    return [rightTableData objectAtIndex:section];
}


- (NSUInteger)numberOfSectionsInTableView:(XCMultiTableView *)tableView {
    return [leftTableData count];
}

- (CGFloat)tableView:(XCMultiTableView *)tableView contentTableCellWidth:(NSUInteger)column {
    if (column == 0) {
        //return 100.0f+XCMultiTableView_DefaultLeftHeaderWidth;
        return 100.0f;
    }
    return 100.0f;
}

- (CGFloat)tableView:(XCMultiTableView *)tableView cellHeightInRow:(NSUInteger)row InSection:(NSUInteger)section {
    if (section == 0) {
        return 40.0f;
    }else {
        return 40.0f;
    }
}

//- (UIColor *)tableView:(XCMultiTableView *)tableView bgColorInSection:(NSUInteger)section InRow:(NSUInteger)row InColumn:(NSUInteger)column {
//    if (row == 1 && section == 0) {
//        return [UIColor whiteColor];//[UIColor colorWithWhite:223.0f/255.0f alpha:1.0];
//    }
//    return [UIColor clearColor];
//}

- (UIColor *)tableView:(XCMultiTableView *)tableView headerBgColorInColumn:(NSUInteger)column {
    //这个是表头第一个的颜色
    if (column == -1) {
        return [UIColor colorWithWhite:243.0f/255.0f alpha:1.0];
    }else{ //if (column == 1) {
        return [UIColor colorWithWhite:243.0f/255.0f alpha:1.0];
    }
    //return [UIColor clearColor];
}

@end
