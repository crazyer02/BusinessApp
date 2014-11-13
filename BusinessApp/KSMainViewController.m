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

@interface KSMainViewController()<RKTabViewDelegate>

@property (retain, nonatomic) IBOutlet UIBarButtonItem *loginBarButtonItem;
@property (nonatomic,strong) IBOutlet RKTabView *titledTabsView;

@end

@implementation KSMainViewController

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
    if(!_userDB)
    {
        _userDB=[[KSUserDB alloc]init];
        [_userDB createDataBase];
    }
    NSMutableArray * _userData=[NSMutableArray arrayWithArray:[_userDB findWithUid:nil limit:100]];
    if([_userData count]>0)
    {
        _user=[_userData objectAtIndex:0];
        self.loginBarButtonItem.title=_user.username;
        NSLog(@"%@",_user.username);
        //        self.logidLabel.text=_user.logid;
        //        self.userLabel.text=_user.username;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initMainWindowBackgroundImage];
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
    [self initMainPage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
 *  初始化页面的背景图片，同时设置导航的字体颜色
 */
- (void)initMainWindowBackgroundImage
{
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blurred_background.png"]];
    UIWindow *keyWindow=[UIApplication sharedApplication].windows[0];
    imageView.frame = keyWindow.bounds;
    [keyWindow insertSubview:imageView atIndex:0];
    
    //self.title.
    self.view.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
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
- (void)dealloc {
    [_loginBarButtonItem release];
    //_titledTabsView=nil;
    [self.titledTabsView release];

    [super dealloc];
}
@end
