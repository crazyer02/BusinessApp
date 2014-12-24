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
#import "KSWebAccess.h"
#import "GDataXMLNode.h"
#import "MonthTotal.h"
//#import "XCMultiSortTableViewDefault.h"

@interface KSMainViewController()<RKTabViewDelegate>

@property (retain, nonatomic) IBOutlet UIBarButtonItem *loginBarButtonItem;
@property (nonatomic,strong) IBOutlet RKTabView *titledTabsView;

@end

@implementation KSMainViewController{

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
    
    monthDal=[[KSMonthTotalDal alloc]init];
    //更新时间
    NSString *updateDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"updateDate"];
    
    if (!updateDate) {
        //如果无此对象，表示第一次，那么就读数据写到数据库中
        [self writeDate];
        
    }else{
        //有此对象说明只要从数据库中读数据
        NSTimeInterval update = updateDate.doubleValue;
        NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
        //8小时一更新
        if ((now - update)>10*60*60) {
            //如果超出8小时一更新就把数据库清空再重新写
            //[coreManager deleteData];
            [self writeDate];
        }else{
            //没有超过8小时一更新就从数据库中读
            NSMutableArray *array = [monthDal selectData:10 andOffset:0];
            _resultArray = [NSMutableArray arrayWithArray:array];
            [monthTableView reloadData];
        }
    }
}

-(void)writeDate
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",[NSDate timeIntervalSinceReferenceDate]] forKey:@"updateDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    KSWebAccess *webAccess=[[KSWebAccess alloc]init];
    NSString *response=[webAccess GetMonthTotal:_user.logid];
    if (nil!=response||response.length>0||![response isEqualToString:@""])
    {
        GDataXMLDocument* doc=[[GDataXMLDocument alloc]initWithXMLString:response options:0 error:nil];
        
        NSArray* nodes=[doc.rootElement elementsForName:@"QueryItem"];
        
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
    [monthDal insertCoreData:_resultArray];
    [monthTableView reloadData];
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

#pragma UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _resultArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MonthTotalCell";
    MonthTotalCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *cells = [[NSBundle mainBundle] loadNibNamed:@"MonthTotalCell" owner:self options:nil];
        cell = [cells lastObject];
    }
    MonthTotal *info = [_resultArray objectAtIndex:indexPath.row];
    [cell setContent:info];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //当你点击时说明要看此条新闻，那么就标注此新闻已被看过
    MonthTotal *info = [_resultArray objectAtIndex:indexPath.row];
    info.islook = @"1";
    //改变数据库查看状态
    [monthDal updateData:info.unit withIsLook:@"1"];
    //改变resultarry数据
    [_resultArray setObject:info atIndexedSubscript:indexPath.row];
    
}
@end
