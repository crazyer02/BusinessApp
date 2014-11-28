//
//  KSLineViewController.m
//  BusinessApp
//
//  Created by 喻雷 on 14/11/13.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

#import "KSLineViewController.h"
#import "KSWebAccess.h"
#import "GDataXMLNode.h"

NSInteger totalNumber;

@interface KSLineViewController ()

@end

@implementation KSLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.ArrayOfValues=[[NSMutableArray alloc]init];
    self.ArrayOfDates=[[NSMutableArray alloc]init];
    
    NSString *logid=[[NSString alloc]init];
    logid=@"0384";
    [self ReloadSpecimenNumData:logid];
    
    /* This is commented out because the graph is created in the interface with this sample app. However, the code remains as an example for creating the graph using code.
     BEMSimpleLineGraphView *myGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 60, 320, 250)];
     myGraph.delegate = self;
     [self.view addSubview:myGraph]; */
    
    // Customization of the graph
    //self.myGraph.enableTouchReport = YES;
    self.myGraph.colorTop = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];
    self.myGraph.colorBottom = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];
    // Leaving this not-set on iOS 7 will default to your window's tintColor
    self.myGraph.colorLine = [UIColor whiteColor];
    self.myGraph.colorXaxisLabel = [UIColor whiteColor];
    self.myGraph.widthLine = 3.0;
    self.myGraph.enableTouchReport = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - SimpleLineGraph Data Source

- (int)numberOfPointsInGraph {
    return (int)[self.ArrayOfValues count];
}

- (float)valueForIndex:(NSInteger)index {
    return [[self.ArrayOfValues objectAtIndex:index] floatValue];
}

#pragma mark - SimpleLineGraph Delegate

- (int)numberOfGapsBetweenLabels {
    return 1;
}

- (NSString *)labelOnXAxisForIndex:(NSInteger)index {
    return [self.ArrayOfDates objectAtIndex:index];
}

- (void)didTouchGraphWithClosestIndex:(int)index {
    self.labelValues.text = [NSString stringWithFormat:@"标本个数：%@", [self.ArrayOfValues objectAtIndex:index]];
    
    self.labelDates.text = [NSString stringWithFormat:@"时间：%@", [self.ArrayOfDates objectAtIndex:index]];
}

- (void)didReleaseGraphWithClosestIndex:(float)index {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.labelValues.alpha = 0.0;
        self.labelDates.alpha = 0.0;
    } completion:^(BOOL finished){
        
        self.labelValues.text = [NSString stringWithFormat:@"总标本数：%d", totalNumber];
        switch (self.graphTimeCycleChoice.selectedSegmentIndex) {
            case 0:
                self.labelDates.text = @"近12个月";
                break;
            case 1:
                self.labelDates.text = @"近2周";
                break;
            default:
               self.labelDates.text = @"近12个月";
                break;
        }
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.labelValues.alpha = 1.0;
            self.labelDates.alpha = 1.0;
        } completion:nil];
    }];
    
}

#pragma mark - TimeCycleChanged
- (void)ReloadSpecimenNumData:(NSString *)logid
{
    totalNumber = 0;
    NSString *type=[[NSString alloc]init];
    switch (self.graphTimeCycleChoice.selectedSegmentIndex) {
        case 0:
            type=@"1";
            self.labelDates.text = @"近12个月";
            break;
        case 1:
            type=@"2";
            self.labelDates.text = @"近2周";
            break;
        default:
            type=@"1";
            self.labelDates.text = @"近12个月";
            break;
    }
    
    KSWebAccess *webAccess=[[KSWebAccess alloc]init];
    NSString *response=[webAccess AccessSpecimenNum:logid type:type];
    if (nil!=response||response.length>0||![response isEqualToString:@""])
    {
        GDataXMLDocument* doc=[[GDataXMLDocument alloc]initWithXMLString:response options:0 error:nil];
        
        NSArray* nodes=[doc.rootElement elementsForName:@"QueryItem"];
        
        for (GDataXMLElement *ele in nodes) {
            GDataXMLElement *numElement=[[ele elementsForName:@"YbidNum"]objectAtIndex:0];
            [self.ArrayOfValues addObject:[numElement stringValue]];
            
            GDataXMLElement *unitElement=[[ele elementsForName:@"Unit"]objectAtIndex:0];
            [self.ArrayOfDates addObject:[unitElement stringValue]];
            totalNumber = totalNumber + [[numElement stringValue] integerValue] ;
        }
    }
    self.labelValues.text = [NSString stringWithFormat:@"总标本数：%d", totalNumber];
}

- (IBAction)TimeCycleChanged:(id)sender
{
    [self.ArrayOfValues removeAllObjects];
    [self.ArrayOfDates removeAllObjects];
    NSString *logid=[[NSString alloc]init];
    
    logid=@"0384";
   
    [self ReloadSpecimenNumData:logid];
    [self.myGraph reloadGraph];
    
}

@end
