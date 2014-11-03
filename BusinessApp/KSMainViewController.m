//
//  KSMainViewController.m
//  BusinessApp
//
//  Created by 喻雷 on 14/10/24.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

#import "KSMainViewController.h"
#import "KSUserDB.h"

@interface KSMainViewController ()
@property (retain, nonatomic) IBOutlet UILabel *logidLabel;
@property (retain, nonatomic) IBOutlet UILabel *userLabel;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *loginBarButtonItem;

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



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initMainWindowBackgroundImage];
    
    self.view.tintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    _userDB=[[KSUserDB alloc]init];
    [_userDB createDataBase];
    NSMutableArray * _userData=[NSMutableArray arrayWithArray:[_userDB findWithUid:nil limit:100]];
    if([_userData count]>0)
    {
        _user=[_userData objectAtIndex:0];
        self.loginBarButtonItem.title=_user.username;
//        self.logidLabel.text=_user.logid;
//        self.userLabel.text=_user.username;
    }
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
    [_logidLabel release];
    [_userLabel release];
    [_loginBarButtonItem release];
    [super dealloc];
}
@end
