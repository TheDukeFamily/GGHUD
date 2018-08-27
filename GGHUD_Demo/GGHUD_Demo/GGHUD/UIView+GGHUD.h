//
//  UIView+GGHUD.h
//  GGHUD_Demo
//
//  Created by Mac on 2018/6/21.
//  Copyright © 2018年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GGHUD)
- (void)addConstraintWidth:(CGFloat)width
                    height:(CGFloat)height;

- (void)addConstraintCenterXToView:(UIView *)xView
                     centerYToView:(UIView *)yView;

- (NSLayoutConstraint *)addConstraintCenterYToView:(UIView *)yView
                                          constant:(CGFloat)constant;

- (NSLayoutConstraint *)addConstarintWithTopView:(UIView *)topView
                                    toBottomView:(UIView *)bottomView
                                      constarint:(CGFloat)constarint;

- (void)removeConstraintWithAttribte:(NSLayoutAttribute)attribute;

- (void)removeAllConstraints;
@end
