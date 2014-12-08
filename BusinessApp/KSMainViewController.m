//
//  KSMainViewController.m
//  BusinessApp
//
//  Created by 喻雷 on 14/10/24.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

#import "KSMainViewController.h"
#import "KSUserDB.h"
#import "RKTabView.h"
#import "KSAppDelegate.h"
#import "MYCustomPanel.h"

@interface KSMainViewController()<RKTabViewDelegate,XCMultiTableViewDataSource>

@property (retain, nonatomic) IBOutlet UIBarButtonItem *loginBarButtonItem;
@property (nonatomic,strong) IBOutlet RKTabView *titledTabsView;

@end

@implementation KSMainViewController{
    NSMutableArray *headData;
    NSMutableArray *leftTableData;
    NSMutableArray *rightTableData;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/**
 *   初始化页面
 */
- (void)initMainPage
{
//if(!_userDB)
    if(!_userDal)
    {
//        _userDB=[[KSUserDB alloc]init];
//        [_userDB createDataBase];
        self.userDal=[[KSUserDal alloc]init];
        
    }
    NSMutableArray *_userData =[self.userDal selectData:1 andOffset:0];
    //NSMutableArray * _userData=[NSMutableArray arrayWithArray:[_userDB findWithUid:nil limit:100]];
    if([_userData count]>0)
    {
        _user=[_userData objectAtIndex:0];
        if (_user.logid.length>0) {
            self.loginBarButtonItem.title=_user.username;
        }
        else
        {
            self.loginBarButtonItem.title=@"登录";
            return;
        }
        
        
        // 设置全局登陆变量
        KSAppDelegate *delegate=(KSAppDelegate*)[[UIApplication sharedApplication]delegate];
        delegate.loginId=_user.logid;
        
        NSLog(@"%@",_user.username);
        //        self.logidLabel.text=_user.logid;
        //        self.userLabel.text=_user.username;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    //    RKTabItem *mastercardTabItem = [RKTabItem createUsualItemWithImageEnabled:nil imageDisabled:[UIImage imageNamed:@"mastercard"]];
    
    RKTabItem *globeTabItem = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"globe_enabled"] imageDisabled:[UIImage imageNamed:@"globe_disabled"]];
    globeTabItem.titleString=@"globe";
    globeTabItem.tabState = TabStateEnabled;
    RKTabItem *cameraTabItem = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"camera_enabled"] imageDisabled:[UIImage imageNamed:@"camera_disabled"]];
    cameraTabItem.titleString=@"camera";
    RKTabItem *cloudTabItem = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"cloud_enabled"] imageDisabled:[UIImage imageNamed:@"cloud_disabled"]];
    cloudTabItem.titleString=@"cloud";
    RKTabItem *userTabItem = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"user_enabled"] imageDisabled:[UIImage imageNamed:@"user_disabled"]];
    userTabItem.titleString=@"user";
    RKTabItem *watchTabItem = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"watch_enabled"] imageDisabled:[UIImage imageNamed:@"watch_disabled"]];
    watchTabItem.titleString=@"watch";
    
    
    
    self.titledTabsView.darkensBackgroundForEnabledTabs = YES;
    self.titledTabsView.horizontalInsets = HorizontalEdgeInsetsMake(25, 25);
    self.titledTabsView.titlesFontColor = [UIColor colorWithWhite:0.9f alpha:0.8f];
    
    self.titledTabsView.tabItems = [[NSArray alloc] initWithObjects:globeTabItem, cameraTabItem,cloudTabItem,userTabItem,watchTabItem,nil];
    
    
    [self initData];
    
    [self.tableView initWithFrame:CGRectInset(self.tableView.bounds,0,0)];
    //指定是否显示左边冻结的栏
    self.tableView.leftHeaderEnable = YES;
    //指定数据委托
    self.tableView.datasource = self;
    //[self.view addSubview:tableView];
    
//    XCMultiTableView *tableView1 = [[XCMultiTableView alloc] initWithFrame:CGRectInset(self.view.bounds, 0, 44)];
//    tableView1.leftHeaderEnable = YES;
//    tableView1.datasource = self;
//    [self.view addSubview:tableView1];
    
}

#pragma mark - RKTabViewDelegate

- (void)tabView:(RKTabView *)tabView tabBecameEnabledAtIndex:(int)index tab:(RKTabItem *)tabItem {
    NSLog(@"Tab  %d became enabled on tab view", index);
}

- (void)tabView:(RKTabView *)tabView tabBecameDisabledAtIndex:(int)index tab:(RKTabItem *)tabItem {
    NSLog(@"Tab  %d became disabled on tab view", index);
}

-(void) viewWillAppear:(BOOL)animated
{
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"is_first"]) {
        
    }
    [self buildIntro];
    [self initMainPage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
/**
 *  <#Description#>
 *
 *  @param segue  <#segue description#>
 *  @param sender <#sender description#>
 */
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"doLogidPage"])
    {
        NSLog(@"进入登陆页面");
        KSUserDB* db=[[KSUserDB alloc]init];
        [db createDataBase];
    }
    if ([segue.identifier isEqualToString:@"doLogedPage"])
    {
        id theSegue=segue.destinationViewController;
        [theSegue setValue:_user forKey:@"reciveUser"];
    }
}

/**
 *  点击登录按钮
 *
 *  @param sender <#sender description#>
 */
- (IBAction)LoginBarItem:(id)sender
{
    if (_user.logid==NULL||_user.logid==nil) {
        [self performSegueWithIdentifier:@"doLogidPage" sender:self];
    } else {
        [self performSegueWithIdentifier:@"doLogedPage" sender:self];
    }
}
#pragma mark - Build MYBlurIntroductionView

-(void)buildIntro{
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
    
    //Create Stock Panel with header
    UIView *headerView = [[NSBundle mainBundle] loadNibNamed:@"TestHeader" owner:nil options:nil][0];
    MYIntroductionPanel *panel1 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) title:@"欢迎使用康圣达IOS APP" description:@"客户利益至上，医师需求第一。" image:[UIImage imageNamed:@"HeaderImage.png"] header:headerView];
    
    //Create Stock Panel With Image
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) title:@"Automated Stock Panels" description:@"质量是企业的生命，科技是企业的动力。" image:[UIImage imageNamed:@"ForkImage.png"]];
    
    //Create custom panel with events
    MYCustomPanel *panel4 = [[MYCustomPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) nibNamed:@"MYCustomPanel"];
    
    //Add panels to an array
    NSArray *panels = @[panel1, panel2, panel4];
    
    //Create the introduction view and set its delegate
    MYBlurIntroductionView *introductionView = [[MYBlurIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    introductionView.delegate = self;
    introductionView.BackgroundImageView.image = [UIImage imageNamed:@"Toronto, ON.jpg"];
    //introductionView.LanguageDirection = MYLanguageDirectionRightToLeft;
    
    //Build the introduction with desired panels
    [introductionView buildIntroductionWithPanels:panels];
    
    //Add the introduction to your view
    [self.view addSubview:introductionView];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"is_first"];
   
}

#pragma mark - MYIntroduction Delegate

-(void)introduction:(MYBlurIntroductionView *)introductionView didChangeToPanel:(MYIntroductionPanel *)panel withIndex:(NSInteger)panelIndex{
    NSLog(@"Introduction did change to panel %d", panelIndex);
    
    //You can edit introduction view properties right from the delegate method!
    //If it is the first panel, change the color to green!
    if (panelIndex == 0) {
        [introductionView setBackgroundColor:[UIColor colorWithRed:90.0f/255.0f green:175.0f/255.0f blue:113.0f/255.0f alpha:1]];
    }
    //If it is the second panel, change the color to blue!
    else if (panelIndex == 1){
        [introductionView setBackgroundColor:[UIColor colorWithRed:50.0f/255.0f green:79.0f/255.0f blue:133.0f/255.0f alpha:1]];
    }
    
}

-(void)introduction:(MYBlurIntroductionView *)introductionView didFinishWithType:(MYFinishType)finishType {
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    NSLog(@"Introduction did finish");
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
                [ary addObject:[NSString stringWithFormat:@"column %d %d", i, j]];
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
        return [UIColor colorWithWhite:233.0f/255.0f alpha:1.0];
    }else{ //if (column == 1) {
        return [UIColor colorWithWhite:233.0f/255.0f alpha:1.0];
    }
    //return [UIColor clearColor];
}

@end
