//
//  GGHUDAnimationView.h
//  GGHUD_Demo
//
//  Created by Mac on 2018/6/21.
//  Copyright © 2018年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GGHUDAnimationType) {
    /** 圆点 */
    GGHUDAnimationTypeCircle = 0,
    /** 圆形 */
    GGHUDAnimationTypeCircleJoin,
    /** 一排点 */
    GGHUDAnimationTypeDot,
};

@interface GGHUDAnimationView : UIView
@property (nonatomic,assign) NSInteger  count;

@property (nonatomic) UIColor  *defaultBackGroundColor;//

@property (nonatomic) UIColor  *foregroundColor;

- (void)showAnimationAtView:(UIView *)view animationType:(GGHUDAnimationType)animationType;

-(void)removeSubLayer;

@end
