//
//  KSLogedViewController.m
//  BusinessApp
//
//  Created by 喻雷 on 14/10/28.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

#import "KSLogedViewController.h"

@interface KSLogedViewController ()

@end

@implementation KSLogedViewController

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
    // Do any additional setup after loading the view.
    if (_reciveUser) {
        self.logidLabel.text=[NSString stringWithFormat:@"%@",_reciveUser.logid];
        self.usernameLabel.text=[NSString stringWithFormat:@"%@",_reciveUser.username];
        self.departmentNameLabel.text=[NSString stringWithFormat:@"%@",_reciveUser.departmentName];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  切换账号按钮事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)exchangeAccount:(id)sender
{
    [self performSegueWithIdentifier:@"doExchangeToLogin" sender:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //doExchangeToLogin
}
*/

- (void)dealloc {
    //[_departmentNameLabel release];
//    [_logidLabel release];
//    [_usernameLabel release];
//    [super dealloc];
}
@end
