//
//  KSSaleDayDetailViewController.h
//  BusinessApp
//
//  Created by 喻雷 on 15/1/5.
//  Copyright (c) 2015年 Kindstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SrBase.h"
@interface KSSaleDayDetailViewController : UIViewController

@property (nonatomic,strong) SrBase *reciveDayDetail;
@property (weak, nonatomic) IBOutlet UILabel *labelsheng;
@property (weak, nonatomic) IBOutlet UILabel *labelshi;

@property (weak, nonatomic) IBOutlet UILabel *labelXian;

@property (weak, nonatomic) IBOutlet UILabel *labelwsd;

@property (weak, nonatomic) IBOutlet UILabel *labelybid;
@property (weak, nonatomic) IBOutlet UILabel *labelbyh;
@property (weak, nonatomic) IBOutlet UILabel *labelbrxm;
@property (weak, nonatomic) IBOutlet UILabel *labelbz;
@property (weak, nonatomic) IBOutlet UILabel *labeljymddm;
@property (weak, nonatomic) IBOutlet UILabel *labeljymdmc;
@property (weak, nonatomic) IBOutlet UILabel *labeljymdsf;
@property (weak, nonatomic) IBOutlet UILabel *labeljspj;
@property (weak, nonatomic) IBOutlet UILabel *labelzk;
@property (weak, nonatomic) IBOutlet UILabel *labeljsjg;
@property (weak, nonatomic) IBOutlet UILabel *labelnewjsjg;
@property (weak, nonatomic) IBOutlet UILabel *labelhezuozhuangtai;
@property (weak, nonatomic) IBOutlet UILabel *labelguishu;
@property (weak, nonatomic) IBOutlet UILabel *labelzhangqi;
@property (weak, nonatomic) IBOutlet UILabel *labeljiesuanfangsi;
@property (weak, nonatomic) IBOutlet UILabel *labelfuzeren;
@property (weak, nonatomic) IBOutlet UILabel *labelcpx;
@property (weak, nonatomic) IBOutlet UILabel *labelcpzy;
@property (weak, nonatomic) IBOutlet UILabel *labelleibei;
@property (weak, nonatomic) IBOutlet UILabel *labelgname;
@property (weak, nonatomic) IBOutlet UILabel *labelqrry;

@property (weak, nonatomic) IBOutlet UILabel *labelqrzt;
@property (weak, nonatomic) IBOutlet UILabel *labelqrsj;
@property (weak, nonatomic) IBOutlet UILabel *labelqrbz;
@property (weak, nonatomic) IBOutlet UILabel *labelkhks;
@property (weak, nonatomic) IBOutlet UILabel *labelbrlb;
@property (weak, nonatomic) IBOutlet UILabel *labelcdrq;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
