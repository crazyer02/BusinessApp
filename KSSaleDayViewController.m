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
#import "SrBase.h"

@interface KSSaleDayViewController()<UITableViewDelegate,XCMultiTableViewDataSource>
@end

@implementation KSSaleDayViewController{
    NSMutableArray *headData;
    NSMutableArray *leftTableData;
    NSMutableArray *rightTableData;
    NSNumber *maxId;
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
    
    
    [self writeDate];
    NSMutableArray *array = [srBaseDal selectData:-1 andOffset:0 andDate:_reciveDay.unit];
    _resultArray = [NSMutableArray arrayWithArray:array];
    
    [self initData];
    
    [self.tableView initWithFrame:CGRectInset(self.tableView.bounds,0,0)];
    //指定是否显示左边冻结的栏
    self.tableView.leftHeaderEnable = YES;
    //指定数据委托
    self.tableView.datasource = self;
}

-(void)writeDate
{
    maxId =[srBaseDal getMaxId:_reciveDay.unit];
    NSLog(@"maxId:%@", maxId);
    
    KSWebAccess *webAccess=[[KSWebAccess alloc]init];
    NSString *response=[webAccess QueryCheckAccount:_reciveUser.logid andDate:_reciveDay.unit andMaxBaseId:maxId];
    if (nil!=response||response.length>0||![response isEqualToString:@""])
    {
        GDataXMLDocument* doc=[[GDataXMLDocument alloc]initWithXMLString:response options:0 error:nil];
        
        NSArray* nodes=[doc.rootElement elementsForName:@"SrBase"];
        _resultArray = [NSMutableArray arrayWithCapacity:nodes.count];
        for (GDataXMLElement *ele in nodes) {
            SrBase *info=[[SrBase alloc]init];
            
            info.brxm= [[[ele elementsForName:@"Brxm"]objectAtIndex:0] stringValue];
            info.byh=[[[ele elementsForName:@"Byh"]objectAtIndex:0] stringValue];
            info.bz=[[[ele elementsForName:@"Bz"]objectAtIndex:0] stringValue];
            info.cdrq=[[[ele elementsForName:@"Cdrq"]objectAtIndex:0] stringValue];
            info.cpx=[[[ele elementsForName:@"Cpx"]objectAtIndex:0] stringValue];
            info.cpzy=[[[ele elementsForName:@"Cpzy"]objectAtIndex:0] stringValue];
            info.fuzenren=[[[ele elementsForName:@"Fuzenren"]objectAtIndex:0] stringValue];
            info.gname=[[[ele elementsForName:@"Gname"]objectAtIndex:0] stringValue];
            info.guishu=[[[ele elementsForName:@"Guishui"]objectAtIndex:0] stringValue];
            info.hezuozhuangtai=[[[ele elementsForName:@"Hezuozhuangtai"]objectAtIndex:0] stringValue];
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            info.ind=[f numberFromString:[[[ele elementsForName:@"Id"]objectAtIndex:0] stringValue]];
            info.jiesuanfangshi=[[[ele elementsForName:@"Jiesuanfangshi"]objectAtIndex:0] stringValue];
            info.jsjg=[[[ele elementsForName:@"Jsjg"]objectAtIndex:0] stringValue];
            info.jspj=[[[ele elementsForName:@"Jspj"]objectAtIndex:0] stringValue];
            info.jszk=[[[ele elementsForName:@"Jszk"]objectAtIndex:0] stringValue];
            info.jymddm=[[[ele elementsForName:@"Jymddm"]objectAtIndex:0] stringValue];
            info.jymdmc=[[[ele elementsForName:@"Jymdmc"]objectAtIndex:0] stringValue];
            info.jymdsf=[[[ele elementsForName:@"Jymdsf"]objectAtIndex:0] stringValue];
            info.khks=[[[ele elementsForName:@"Khks"]objectAtIndex:0] stringValue];
            info.leibei=[[[ele elementsForName:@"Leibei"]objectAtIndex:0] stringValue];
            info.newjsjg=[[[ele elementsForName:@"Newjsjg"]objectAtIndex:0] stringValue];
            info.qrry=[[[ele elementsForName:@"Qrry"]objectAtIndex:0] stringValue];
            info.qrsj=[[[ele elementsForName:@"Qrsj"]objectAtIndex:0] stringValue];
            info.qrzt=[[[ele elementsForName:@"Qrzt"]objectAtIndex:0] stringValue];
            info.sheng=[[[ele elementsForName:@"Sheng"]objectAtIndex:0] stringValue];
            info.shi=[[[ele elementsForName:@"Shi"]objectAtIndex:0] stringValue];
            info.tsjg=[[[ele elementsForName:@"Tsjg"]objectAtIndex:0] stringValue];
            info.xian=[[[ele elementsForName:@"Xian"]objectAtIndex:0] stringValue];
            info.xjjg=[[[ele elementsForName:@"Xjjg"]objectAtIndex:0] stringValue];
            info.ybid=[[[ele elementsForName:@"Ybid"]objectAtIndex:0] stringValue];
            info.yiyuanjibie=[[[ele elementsForName:@"Yiyuanjibie"]objectAtIndex:0] stringValue];
            info.zhangqi=[[[ele elementsForName:@"Zhangqi"]objectAtIndex:0] stringValue];
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
    headData = [NSMutableArray arrayWithCapacity:8];
    [headData addObject:@"最新"];
    [headData addObject:@"正常"];
    [headData addObject:@"折扣"];
    [headData addObject:@"牌价"];
    [headData addObject:@"医院"];
    [headData addObject:@"条码"];
    [headData addObject:@"项目名"];
    [headData addObject:@"状态"];
    leftTableData = [NSMutableArray arrayWithCapacity:_resultArray.count];
    NSMutableArray *one = [NSMutableArray arrayWithCapacity:_resultArray.count];
    for (SrBase *info in _resultArray) {
        [one addObject:[NSString stringWithFormat:@"%@", info.brxm]];
    }
    [leftTableData addObject:one];
    //    NSMutableArray *two = [NSMutableArray arrayWithCapacity:10];
    //    for (int i = 3; i < 10; i++) {
    //        [two addObject:[NSString stringWithFormat:@"ki-%d", i]];
    //    }
    //    [leftTableData addObject:two];
    
    
    rightTableData = [NSMutableArray arrayWithCapacity:_resultArray.count];
    
    NSMutableArray *oneR = [NSMutableArray arrayWithCapacity:_resultArray.count];
    for (SrBase *info in _resultArray) {
        NSMutableArray *ary = [NSMutableArray arrayWithCapacity:_resultArray.count];
        for ( int j = 0; j < headData.count; j++) {
            [ary addObject:[NSString stringWithFormat:@"¥%@",info.newjsjg]];
            [ary addObject:[NSString stringWithFormat:@"¥%@",info.jsjg]];
            [ary addObject:info.jszk];
            [ary addObject:[NSString stringWithFormat:@"¥%@",info.jspj]];
            [ary addObject:info.byh];
            [ary addObject:info.ybid];
            [ary addObject:info.jymdmc];
            [ary addObject:info.qrzt];
        }
        [oneR addObject:ary];
    }
    [rightTableData addObject:oneR];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"doShowDayDetail"])
    {
        id theSegue=segue.destinationViewController;
        [theSegue setValue:_srBasedata forKey:@"reciveDayDetail"];
    }
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
    CGFloat width=100.0f;
    switch (column) {
        case 0:
            width=80.0f;
            break;
        case 1:
            width=80.0f;
            break;
        case 2:
            width=50.0f;
            break;
        case 4:
            width=190.0f;
            break;
        case 5:
            width=140.0f;
            break;
        case 6:
            width=220.0f;
            break;
        case 7:
            width=80.0f;
            break;
    }
    return width;
}

- (CGFloat)tableView:(XCMultiTableView *)tableView cellHeightInRow:(NSUInteger)row InSection:(NSUInteger)section {
    if (section == 0) {
        return 40.0f;
    }else {
        return 40.0f;
    }
}
/**
 *  选中其中的某一行
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 */
- (void)tableView:(XCMultiTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _srBasedata= [_resultArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"doShowDayDetail" sender:self];
}
/**
 *  设置行的颜色
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *  @param row       <#row description#>
 *  @param column    <#column description#>
 *
 *  @return <#return value description#>
 */
//- (UIColor *)tableView:(XCMultiTableView *)tableView bgColorInSection:(NSUInteger)section InRow:(NSUInteger)row InColumn:(NSUInteger)column {
//    if (row == 1 && section == 0) {
//        return [UIColor colorWithRed:250 green:0 blue:0 alpha:0.8];//[UIColor colorWithWhite:223.0f/255.0f alpha:1.0];
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
