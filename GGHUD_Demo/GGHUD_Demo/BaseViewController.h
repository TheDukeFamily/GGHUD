//
//  BaseViewController.h
//  GGHUD_Demo
//
//  Created by Mac on 2018/6/21.
//  Copyright © 2018年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
/** 显示HUD,在当前控制器view加载 白色背景 **/
- (void)showGGHUD;

/** 隐藏HUD **/
- (void)hiddenGGHUD;

/** 显示加载失败 **/
- (void)showGGHUDFailure;

/** 加载失败，点击重新加载block回调 **/
- (void)showGGHudExceptionsHandleBlock:(dispatch_block_t)exceptionsHandleBlock;

/** 空白数据显示层 **/
- (void)showEmptyDataGGHUDWithImage:(NSString *)image withTitle:(NSString *)title;
@end
