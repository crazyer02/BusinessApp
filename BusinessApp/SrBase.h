//
//  SrBase.h
//  BusinessApp
//
//  Created by 喻雷 on 14/12/26.
//  Copyright (c) 2014年 Kindstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SrBase : NSObject
@property (nonatomic, copy) NSString *brxm;
@property (nonatomic, copy) NSString *byh;
@property (nonatomic, copy) NSString *bz;
@property (nonatomic, copy) NSString *cdrq;
@property (nonatomic, copy) NSString *cpx;
@property (nonatomic, copy) NSString *cpzy;
@property (nonatomic, copy) NSString *fuzenren;
@property (nonatomic, copy) NSString *gname;
@property (nonatomic, copy) NSString *guishu;
@property (nonatomic, copy) NSString *hezuozhuangtai;
@property (nonatomic, copy) NSString *ind;
@property (nonatomic, copy) NSString *jiesuanfangshi;
@property (nonatomic, copy) NSString *jsjg;
@property (nonatomic, copy) NSString *jspj;
@property (nonatomic, copy) NSString *jszk;
@property (nonatomic, copy) NSString *jymddm;
@property (nonatomic, copy) NSString *jymdmc;
@property (nonatomic, copy) NSString *jymdsf;
@property (nonatomic, copy) NSString *khks;
@property (nonatomic, copy) NSString *leibei;
@property (nonatomic, copy) NSString *newjsjg;
@property (nonatomic, copy) NSString *qrry;
@property (nonatomic, copy) NSString *qrsj;
@property (nonatomic, copy) NSString *qrzt;
@property (nonatomic, copy) NSString *sheng;
@property (nonatomic, copy) NSString *shi;
@property (nonatomic, copy) NSString *tsjg;
@property (nonatomic, copy) NSString *xian;
@property (nonatomic, copy) NSString *xjjg;
@property (nonatomic, copy) NSString *ybid;
@property (nonatomic, copy) NSString *yiyuanjibie;
@property (nonatomic, copy) NSString *zhangqi;

- (void)initWithModel:(SrBase*)model;
@end
