//
//  GGHUD.h
//  GGHUD_Demo
//
//  Created by Mac on 2018/6/21.
//  Copyright © 2018年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GGHUDLoadingType) {
    /** 圆点 */
    GGHUDLoadingTypeCircle         = 0,
     /** 圆形 */
    GGHUDLoadingTypeCircleJoin     = 1,
    /** 一排点 */
    GGHUDLoadingTypeDot            = 2,
    /** 图片组 */
    GGHUDLoadingTypeGroupImage     = 3,
    /** Gif图 */
    GGHUDLoadingTypeGifImage       = 4,
    /** 加载失败样式 */
    GGHUDLoadingTypeFailure        = 5,
};

@interface GGHUD : UIView

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
/** 加载失败按钮点击 */
@property (nonatomic, copy) void (^GGHUDReloadButtonClickBlock)();
#pragma clang diagnostic pop

/** 指示器视图 */
@property (nonatomic, strong) UIView *indicatorView;

/** 消息指示器 */
@property (nonatomic,strong) UILabel  *messageLabel;

/** 刷新按钮 */
@property (nonatomic, strong) UIButton *refreshButton;

/** 指示器背景颜色,默认[[UIColor darkGrayColor] colorWithAlphaComponent:0.1] */
@property (nonatomic, strong) UIColor *indicatorBackGroundColor;

/** 指示器颜色,默认[UIColor lightGrayColor] */
@property (nonatomic, strong) UIColor  *indicatorForegroundColor;

/** 指示器大小 */
@property (nonatomic, assign) CGSize indicatorViewSize;

/** gif文件 */
@property (nonatomic, strong) NSString *gifImageFile;

/** 图片数组文件 */
@property (nonatomic, strong) NSArray *groupImageArray;

/** 加载失败图片 */
@property (nonatomic, strong) UIImage *failureImage;

- (void)showAtView:(UIView *)view hudType:(GGHUDLoadingType)hudType;

/** 显示HUD */
+(void)showAtView:(UIView *)view message:(NSString *)message hudType:(GGHUDLoadingType)hudType;

/** 隐藏HUD */
- (void)hidden;

/** 延迟消失 */
- (void)hiddenAfterDelay:(NSTimeInterval)afterDelay;

/**从View上隐藏 */
+(void)hideForView:(UIView *)view;

@end

@interface UIView (MainQueue)

-(void)dispatchMainQueue:(dispatch_block_t)block;

@end
