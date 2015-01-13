//
//  KSSaleDayDetailViewController.m
//  BusinessApp
//
//  Created by 喻雷 on 15/1/5.
//  Copyright (c) 2015年 Kindstar. All rights reserved.
//

#import "KSSaleDayDetailViewController.h"
//@property (nonatomic, copy) NSString *brxm;
//@property (nonatomic, copy) NSString *byh;
//@property (nonatomic, copy) NSString *bz;
//@property (nonatomic, copy) NSString *cdrq;
//@property (nonatomic, copy) NSString *cpx;
//@property (nonatomic, copy) NSString *cpzy;
//@property (nonatomic, copy) NSString *fuzenren;
//@property (nonatomic, copy) NSString *gname;
//@property (nonatomic, copy) NSString *guishu;
//@property (nonatomic, copy) NSString *hezuozhuangtai;
//@property (nonatomic, assign) NSNumber *ind;
//@property (nonatomic, copy) NSString *jiesuanfangshi;
//@property (nonatomic, copy) NSString *jsjg;
//@property (nonatomic, copy) NSString *jspj;
//@property (nonatomic, copy) NSString *jszk;
//@property (nonatomic, copy) NSString *jymddm;
//@property (nonatomic, copy) NSString *jymdmc;
//@property (nonatomic, copy) NSString *jymdsf;
//@property (nonatomic, copy) NSString *khks;
//@property (nonatomic, copy) NSString *leibei;
//@property (nonatomic, copy) NSString *newjsjg;
//@property (nonatomic, copy) NSString *qrry;
//@property (nonatomic, copy) NSString *qrsj;
//@property (nonatomic, copy) NSString *qrzt;
//@property (nonatomic, copy) NSString *sheng;
//@property (nonatomic, copy) NSString *shi;
//@property (nonatomic, copy) NSString *tsjg;
//@property (nonatomic, copy) NSString *xian;
//@property (nonatomic, copy) NSString *xjjg;
//@property (nonatomic, copy) NSString *ybid;
//@property (nonatomic, copy) NSString *yiyuanjibie;
//@property (nonatomic, copy) NSString *zhangqi;
@implementation KSSaleDayDetailViewController

- (void)initPage
{
    _labelbrxm.text=self.reciveDayDetail.brxm;
    _labelbyh.text=self.reciveDayDetail.byh;
    _labelbz.text=self.reciveDayDetail.bz;
    _labelcpx.text=self.reciveDayDetail.cpx;
    _labelcpzy.text=self.reciveDayDetail.cpzy;
    _labelcdrq.text=self.reciveDayDetail.cdrq;
    _labelfuzeren.text=self.reciveDayDetail.fuzenren;
    _labelgname.text=self.reciveDayDetail.gname;
    _labelguishu.text=self.reciveDayDetail.guishu;
    _labelhezuozhuangtai.text=self.reciveDayDetail.hezuozhuangtai;
    _labeljiesuanfangsi.text=self.reciveDayDetail.jiesuanfangshi;
    _labeljsjg.text=[NSString stringWithFormat:@"¥%@",self.reciveDayDetail.jsjg];
    _labeljspj.text=[NSString stringWithFormat:@"¥%@",self.reciveDayDetail.jspj];
    _labeljymddm.text=self.reciveDayDetail.jymddm;
    _labeljymdmc.text=self.reciveDayDetail.jymdmc;
    _labeljymdsf.text=[NSString stringWithFormat:@"¥%@",self.reciveDayDetail.jymdsf];
    _labelkhks.text=self.reciveDayDetail.khks;
    _labelleibei.text=self.reciveDayDetail.leibei;
    _labelnewjsjg.text=[NSString stringWithFormat:@"¥%@",self.reciveDayDetail.newjsjg];
    //_labelqrbz.text=self.reciveDayDetail.q;
    _labelqrry.text=self.reciveDayDetail.qrry;
    _labelqrsj.text=self.reciveDayDetail.qrsj;
    _labelqrzt.text=self.reciveDayDetail.qrzt;
    _labelsheng.text=self.reciveDayDetail.sheng;
    _labelshi.text=self.reciveDayDetail.shi;
    //_labelwsd.text=self.reciveDayDetail.cdrq;
    _labelXian.text=self.reciveDayDetail.xian;
    _labelybid.text=self.reciveDayDetail.ybid;
    _labelzhangqi.text=self.reciveDayDetail.zhangqi;
    _labelzk.text=self.reciveDayDetail.jszk;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect r=[UIScreen mainScreen].applicationFrame;
    //能滚动的范围
    self.scrollView.contentSize=CGSizeMake(r.size.width, 490);
    //周边增加滚动区域
    self.scrollView.contentInset=UIEdgeInsetsMake(-64, 0, 0, 0);
    //控件的移动位置
    self.scrollView.contentOffset=CGPointMake(0, 64);
    
    [self initPage];
 
}
@end
