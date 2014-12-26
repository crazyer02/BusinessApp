//
//  SrBase.m
//  BusinessApp
//
//  Created by 喻雷 on 14/12/26.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

#import "SrBase.h"

@implementation SrBase

- (void)initWithModel:(SrBase*)model
{
    //self = [super init];
    if (self) {
        self.brxm = model.brxm;
        self.byh=model.byh;
        self.bz=model.bz;
        self.cdrq=model.cdrq;
        self.cpx=model.cpx;
        self.cpzy=model.cpzy;
        self.fuzenren=model.fuzenren;
        self.gname=model.gname;
        self.guishu=model.guishu;
        self.hezuozhuangtai=model.hezuozhuangtai;
        self.ind=model.ind;
        self.jiesuanfangshi=model.jiesuanfangshi;
        self.jsjg=model.jsjg;
        self.jspj=model.jspj;
        self.jszk=model.jszk;
        self.jymddm=model.jymddm;
        self.jymdmc=model.jymdmc;
        self.jymdsf=model.jymdsf;
        self.khks=model.khks;
        self.leibei=model.leibei;
        self.newjsjg=model.newjsjg;
        self.qrry=model.qrry;
        self.qrsj=model.qrsj;
        self.qrzt=model.qrzt;
        self.sheng=model.sheng;
        self.shi=model.shi;
        self.tsjg=model.tsjg;
        self.xian=model.xian;
        self.xjjg=model.xjjg;
        self.ybid=model.ybid;
        self.yiyuanjibie=model.yiyuanjibie;
        self.zhangqi=model.zhangqi;
    }
    //return self;
}

@end
