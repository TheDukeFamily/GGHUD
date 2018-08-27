//
//  BaseViewController.m
//  GGHUD_Demo
//
//  Created by Mac on 2018/6/21.
//  Copyright © 2018年 Mr.Gao. All rights reserved.
//

#import "BaseViewController.h"
#import "GGHUD.h"

@interface BaseViewController ()
@property (nonatomic, strong) GGHUD *hudView;
@end

@implementation BaseViewController

- (GGHUD *)hudView{
    if(!_hudView){
        _hudView = [[GGHUD alloc] initWithFrame:self.view.bounds];
        self.hudView.messageLabel.text = @"";
        self.hudView.indicatorBackGroundColor = [[UIColor clearColor] colorWithAlphaComponent:0];
        self.hudView.indicatorForegroundColor = [UIColor redColor];
    }
    return _hudView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/** 显示HUD,在当前控制器view加载 **/
- (void)showGGHUD{
    [self.hudView showAtView:self.view hudType:GGHUDLoadingTypeCircle];
}

/** 隐藏HUD **/
- (void)hiddenGGHUD{
    [self.hudView hidden];
}

/** 显示加载失败 **/
- (void)showGGHUDFailure{
    self.hudView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.hudView.indicatorViewSize = CGSizeMake(127, 87);
    self.hudView.messageLabel.text = @"加载失败";
    [self.hudView.refreshButton setTitle:@"点击重试" forState:UIControlStateNormal];
    self.hudView.failureImage = [UIImage imageNamed:@"netwoking_loadfailed"];
    [self.hudView showAtView:self.view hudType:GGHUDLoadingTypeFailure];
}

/** 加载失败，点击重新加载block回调 **/
- (void)showGGHudExceptionsHandleBlock:(dispatch_block_t)exceptionsHandleBlock{
    [self.hudView setGGHUDReloadButtonClickBlock:^{
        exceptionsHandleBlock();
    }];
}

/** 空白数据显示层 **/
- (void)showEmptyDataGGHUDWithImage:(NSString *)image withTitle:(NSString *)title{
    
}

@end
