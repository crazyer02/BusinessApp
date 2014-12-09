//
//  UIView+XCMultiTableView.m
//  XCMultiTableDemo
//
//  Created by Kingiol on 13-7-22.
//  Copyright (c) 2013年 Kingiol. All rights reserved.
//

#import "UIView+XCMultiSortTableView.h"

@implementation UIView (XCMultiTableView)

- (void)addBottomLineWithWidth:(CGFloat)width widthLine:(CGFloat)widthLine color:(UIColor *)color indentWidth:(CGFloat)indentWidth
{
    CGRect f = self.frame;
    f.size.height += width;
    self.frame = f;
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0-indentWidth, self.frame.size.height - width, widthLine, width)];
    bottomLine.backgroundColor = color;
    bottomLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:bottomLine];
}

- (void)addBottomLineWithWidth:(CGFloat)width bgColor:(UIColor *)color {
    CGFloat widthLine=self.frame.size.width;
    [self addBottomLineWithWidth:width widthLine:widthLine color:color indentWidth:0];
}

- (UIView *)addVerticalLineWithWidth:(CGFloat)width bgColor:(UIColor *)color atX:(CGFloat)x {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, 0.0f, width, self.bounds.size.height)];
    line.backgroundColor = color;
    line.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:line];
    return line;
}

@end
