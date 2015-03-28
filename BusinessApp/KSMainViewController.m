//
//  KSMainViewController.m
//  BusinessApp
//
//  Created by 喻雷 on 14/10/24.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

#import "KSMainViewController.h"
#import "KSUserDB.h"
//#import "RKTabView.h"
#import "KSAppDelegate.h"
#import "MYCustomPanel.h"
#import "KSWebAccess.h"
#import "GDataXMLNode.h"
#import "MonthTotal.h"
//#import "XCMultiSortTableViewDefault.h"
#import "MJRefresh.h"
#import "KSSaleDayViewController.h"

NSString *const MJTableViewCellIdentifier = @"MonthTotalCell";
NSString *const MJTableViewHeadIdentifier = @"MonthTotalHeader";
NSInteger pageNumber=0;
double totalPrice=0;
@interface KSMainViewController()//<RKTabViewDelegate>

@property (retain, nonatomic) IBOutlet UIBarButtonItem *loginBarButtonItem;
//@property (nonatomic,strong) IBOutlet RKTabView *titledTabsView;

@end

@implementation KSMainViewController{
    MonthTotalHeader *head;
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
    
    // 1.注册cell
    //[monthTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:MJTableViewCellIdentifier];
    
    //添加总和
//    CGRect r=[UIScreen mainScreen].applicationFrame;
//    UIView *headerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, r.size.width, 40)];
     head= [monthTableView dequeueReusableCellWithIdentifier:MJTableViewHeadIdentifier];
    if (head == nil) {
        NSArray *cells = [[NSBundle mainBundle] loadNibNamed:@"MonthTotalHeader" owner:self options:nil];
        head = [cells lastObject];
    }
    //[self  addBottomLineWithWidth:head viewWidth:1 bgColor:kSeparatorLineColor];
    [self addBottomLineWithWidth:head viewWidth:320 widthLine:1 color:[UIColor colorWithWhite:223.0f/255.0f alpha:1.0] indentWidth:0];
    monthTableView.tableHeaderView = head;
    
    //monthTableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    //monthTableView.scrollIndicatorInsets = UIEdgeInsetsMake(44, 0, 0, 0);
    // 2.集成刷新控件
    [self setupRefresh];
    
    //    RKTabItem *mastercardTabItem = [RKTabItem createUsualItemWithImageEnabled:nil imageDisabled:[UIImage imageNamed:@"mastercard"]];
    
//    RKTabItem *globeTabItem = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"globe_enabled"] imageDisabled:[UIImage imageNamed:@"globe_disabled"]];
//    globeTabItem.titleString=@"globe";
//    globeTabItem.tabState = TabStateEnabled;
//    RKTabItem *cameraTabItem = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"camera_enabled"] imageDisabled:[UIImage imageNamed:@"camera_disabled"]];
//    cameraTabItem.titleString=@"camera";
//    RKTabItem *cloudTabItem = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"cloud_enabled"] imageDisabled:[UIImage imageNamed:@"cloud_disabled"]];
//    cloudTabItem.titleString=@"cloud";
//    RKTabItem *userTabItem = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"user_enabled"] imageDisabled:[UIImage imageNamed:@"user_disabled"]];
//    userTabItem.titleString=@"user";
//    RKTabItem *watchTabItem = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"watch_enabled"] imageDisabled:[UIImage imageNamed:@"watch_disabled"]];
//    watchTabItem.titleString=@"watch";
//    
//    
//    self.titledTabsView.darkensBackgroundForEnabledTabs = YES;
//    self.titledTabsView.horizontalInsets = HorizontalEdgeInsetsMake(25, 25);
//    self.titledTabsView.titlesFontColor = [UIColor colorWithWhite:0.9f alpha:0.8f];
//    
//    self.titledTabsView.tabItems = [[NSArray alloc] initWithObjects:globeTabItem, cameraTabItem,cloudTabItem,userTabItem,watchTabItem,nil];
    
   
    
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
            //[monthDal deleteData];
            [self writeDate];
        }else{
            //[monthDal deleteData];
            //[self writeDate];
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
    [monthDal insertCoreData:_resultArray];
    [monthTableView reloadData];
}

//#pragma mark - RKTabViewDelegate
//
//- (void)tabView:(RKTabView *)tabView tabBecameEnabledAtIndex:(int)index tab:(RKTabItem *)tabItem {
//    NSLog(@"Tab  %d became enabled on tab view", index);
//}
//
//- (void)tabView:(RKTabView *)tabView tabBecameDisabledAtIndex:(int)index tab:(RKTabItem *)tabItem {
//    NSLog(@"Tab  %d became disabled on tab view", index);
//}

-(void) viewWillAppear:(BOOL)animated
{
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"is_first"]) {
        [self buildIntro];
    }
    
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
    if ([segue.identifier isEqualToString:@"doSaleDayPage"])
    {
        id theSegue=segue.destinationViewController;
        [theSegue setValue:_daydata forKey:@"reciveDay"];
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
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"MonthTotalCell";
//    [monthTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:MJTableViewCellIdentifier];
    MonthTotalCell *cell = [tableView dequeueReusableCellWithIdentifier:MJTableViewCellIdentifier];
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
    _daydata= [_resultArray objectAtIndex:indexPath.row];
    _daydata.islook = @"1";
    //改变数据库查看状态
    [monthDal updateData:_daydata.unit withIsLook:@"1"];
    //改变resultarry数据
    [_resultArray setObject:_daydata atIndexedSubscript:indexPath.row];
    
    [self performSegueWithIdentifier:@"doSaleDayPage" sender:self];
}


#pragma 上拉下拉刷新

/**
 为了保证内部不泄露，在dealloc中释放占用的内存
 */
- (void)dealloc
{
    NSLog(@"MJTableViewController--dealloc---");
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [monthTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //#warning 自动刷新(一进入程序就下拉刷新)
    [monthTableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [monthTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    monthTableView.headerPullToRefreshText = @"↓下拉刷新";
    monthTableView.headerReleaseToRefreshText = @"↑松开刷新";
    monthTableView.headerRefreshingText = @"刷新中……";
    
    monthTableView.footerPullToRefreshText = @"↑上拉加载更多数据";
    monthTableView.footerReleaseToRefreshText = @"↓松开马上加载更多数据了";
    monthTableView.footerRefreshingText = @"加载更多……";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加假数据

    [self writeDate];
    //没有超过8小时一更新就从数据库中读
    NSMutableArray *array = [monthDal selectData:10 andOffset:0];
    _resultArray = [NSMutableArray arrayWithArray:array];
    [self refreshHeader];
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [monthTableView reloadData];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [monthTableView headerEndRefreshing];
    });
}



- (void)footerRereshing
{
    pageNumber++;
    // 1.添加假数据
    NSMutableArray *array = [monthDal selectData:10 andOffset:pageNumber*10];
    //_resultArray = [NSMutableArray arrayWithArray:array];
    //建立一个NSIndexSet.
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:
                           NSMakeRange(_resultArray.count,[array count])];
    [_resultArray insertObjects:array atIndexes:indexes];
    
    [self refreshHeader];
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [monthTableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [monthTableView footerEndRefreshing];
    });
}

- (void)addBottomLineWithWidth:(UIView*) view viewWidth:(CGFloat)width widthLine:(CGFloat)widthLine color:(UIColor *)color indentWidth:(CGFloat)indentWidth
{
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0-indentWidth, view.frame.size.height - widthLine,width,widthLine )];
    bottomLine.backgroundColor = color;
    bottomLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [view addSubview:bottomLine];
}

- (void)refreshHeader
{
    totalPrice=0;
    for(MonthTotal *model in _resultArray)
    {
        totalPrice = totalPrice + [model.total doubleValue] ;
    }
    NSString *updateDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"updateDate"];
    if (!updateDate) {
        updateDate=@"暂无更新";
        
    }else{
        //有此对象说明只要从数据库中读数据
        NSTimeInterval update = updateDate.doubleValue;
        NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
        //8小时一更新
        if ((now - update)<1*60) {
updateDate=@"刚刚更新";
        }
        else if ((now - update)<60*60) {
            updateDate=[NSString stringWithFormat:@"更新于%.0f分钟前",((now-update)/60)];
        }
        else if ((now - update)<24*60*60) {
            updateDate=[NSString stringWithFormat:@"更新于%.0f小时前",((now-update)/60*60)];
        }
        else{
           updateDate=[NSString stringWithFormat:@"更新于%.0f天前",((now-update)/24*60*60)];
        }
    }

    [head setContent:[NSString stringWithFormat:@"%.2f",totalPrice]  refreshTime:updateDate];
}
@end
