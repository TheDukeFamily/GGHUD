//
//  GGHUD.m
//  GGHUD_Demo
//
//  Created by Mac on 2018/6/21.
//  Copyright © 2018年 Mr.Gao. All rights reserved.
//

#import "GGHUD.h"
#import "GGHUDAnimationView.h"
#import "GGHUDMacros.h"
#import "UIView+GGHUD.h"
#import "UIImage+GGHUD.h"

@interface GGHUD ()

@property (nonatomic) GGHUDLoadingType hudType;

@property (nonatomic, strong) GGHUDAnimationView *loadingView;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation GGHUD

#pragma mark - lazy
- (GGHUDAnimationView *)loadingView
{
    if(!_loadingView)
    {
        _loadingView = [[GGHUDAnimationView alloc] init];
        
        _loadingView.translatesAutoresizingMaskIntoConstraints = NO;
        
        _loadingView.backgroundColor = [UIColor clearColor];
    }
    return _loadingView;
}

- (UIView *)indicatorView
{
    if(!_indicatorView)
    {
        _indicatorView = [[UIView alloc] init];
        
        _indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        
        _indicatorView.backgroundColor = [UIColor clearColor];
    }
    return _indicatorView;
}

- (UIImageView *)imageView
{
    if(!_imageView)
    {
        _imageView = [[UIImageView alloc] init];
        
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        
        _imageView.animationDuration = 1;
        
        _imageView.animationRepeatCount = 0;
    }
    return _imageView;
}

- (UILabel *)messageLabel
{
    if(!_messageLabel)
    {
        _messageLabel = [[UILabel alloc] init];
        
        _messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        
        _messageLabel.textColor = [UIColor lightGrayColor];
        
        _messageLabel.font = [UIFont systemFontOfSize:16];
        
        _messageLabel.backgroundColor = [UIColor clearColor];
        
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

- (UIButton *)refreshButton
{
    if(!_refreshButton)
    {
        _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _refreshButton.translatesAutoresizingMaskIntoConstraints = NO;
        
        [_refreshButton setTitleColor:[UIColor darkGrayColor]
                             forState:UIControlStateNormal];
        [_refreshButton setTitleColor:[UIColor blackColor]
                             forState:UIControlStateHighlighted];
        
        _refreshButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _refreshButton.titleLabel.font = [UIFont systemFontOfSize:18];
        
        [_refreshButton setTitle:GGHUD_DefaultRefreshButtonText forState:UIControlStateNormal];
        
        _refreshButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        _refreshButton.layer.borderWidth = 0.5;
        
        [_refreshButton addTarget:self action:@selector(refreshButtonClick)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshButton;
}

#pragma mark -set
- (void)setGifImageFile:(NSString *)gifImageFile
{
    _gifImageFile = gifImageFile;
    
    self.imageView.image = [UIImage GGHUDImageWithSmallGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:gifImageFile ofType:@"gif"]] scale:1];
}

- (void)setIndicatorViewSize:(CGSize)indicatorViewSize
{
    _indicatorViewSize = indicatorViewSize;
    
    [self setNeedsUpdateConstraints];
}

- (void)setGroupImageArray:(NSArray *)groupImageArray
{
    _groupImageArray = groupImageArray;
    
    if(groupImageArray.count>1)
    {
        self.imageView.animationImages = _groupImageArray;
        [self.imageView startAnimating];
    }
    
    [self setNeedsUpdateConstraints];
}

- (void)setFailureImage:(UIImage *)failureImage
{
    _failureImage = failureImage;
    
    [self.imageView stopAnimating];
    
    self.imageView.image = failureImage;
}

- (void)setIndicatorBackGroundColor:(UIColor *)indicatorBackGroundColor
{
    _indicatorBackGroundColor = indicatorBackGroundColor;
    
    self.loadingView.defaultBackGroundColor = indicatorBackGroundColor;
}

- (void)setIndicatorForegroundColor:(UIColor *)indicatorForegroundColor
{
    _indicatorForegroundColor = indicatorForegroundColor;
    
    self.loadingView.foregroundColor = indicatorForegroundColor;
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self configureInfo];
        
        [self configureSubViews];
    }
    return self;
}

- (void)configureInfo
{
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.indicatorViewSize = CGSizeMake(100, 100);
}

- (void)configureSubViews
{
    [self addSubview:self.indicatorView];
    
    [self addSubview:self.messageLabel];
    
    [self addSubview:self.refreshButton];
    
    [self.indicatorView addSubview:self.loadingView];
    
    [self.indicatorView addSubview:self.imageView];
}

#pragma mark - show method
- (void)showAtView:(UIView *)view hudType:(GGHUDLoadingType)hudType
{
    self.hudType = hudType;
    
    [self hidden];
    
    [self setupSubViewsWithHudType:hudType];
    
    [self dispatchMainQueue:^{
        view ? [view addSubview:self] : [[[UIApplication sharedApplication].windows lastObject] addSubview:self];
        //将试图推到最前面
        [self.superview bringSubviewToFront:self];
    }];
}

+ (void)showAtView:(UIView *)view message:(NSString *)message hudType:(GGHUDLoadingType)hudType
{
    GGHUD *hud = [[self alloc] initWithFrame:view.bounds];
    hud.messageLabel.text = message;
    [hud showAtView:view hudType:hudType];
}

+ (void)hideForView:(UIView *)view
{
    NSEnumerator *subViewEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subViewEnum)
    {
        if([subview isKindOfClass:self])
        {
            GGHUD *hud = (GGHUD *)subview;
            [hud hidden];
        }
    }
}

- (void)hidden
{
    [self dispatchMainQueue:^{
        if(self.superview)
        {
            [self removeFromSuperview];
            [self.loadingView removeSubLayer];
        }
    }];
}

- (void)hiddenAfterDelay:(NSTimeInterval)afterDelay
{
    [self performSelector:@selector(hidden) withObject:nil afterDelay:afterDelay];
}


//当用 Auto Layout 布局你的 view 的时候，确保在你父类中加入了下面的代码,否则当系统没有调用 -updateConstraints 的时候，你可能会遇到奇怪的 bug。
+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (void)setupSubViewsWithHudType:(GGHUDLoadingType)hudType
{
    hudType == GGHUDLoadingTypeFailure ? [self isShowRefreshButton:YES] : [self isShowRefreshButton:NO];
    
    if(hudType > 2)
    {//选择图片样式或错误样式
        self.imageView.hidden = NO;
        [self .loadingView removeFromSuperview];
    }else
    {
        self.imageView.hidden = YES;
        self.indicatorViewSize = CGSizeMake(100, 100);
        
        if(!self.loadingView.superview)
        {
            [self.indicatorView addSubview:self.loadingView];
        }
    }
    
    switch (hudType) {
            case GGHUDLoadingTypeCircle:
            [self.loadingView showAnimationAtView:self animationType:GGHUDAnimationTypeCircle];
            break;
            case GGHUDLoadingTypeCircleJoin:
            [self.loadingView showAnimationAtView:self animationType:GGHUDAnimationTypeCircleJoin];
            break;
            case GGHUDLoadingTypeDot:
            [self.loadingView showAnimationAtView:self animationType:GGHUDAnimationTypeDot];
            break;
            case GGHUDLoadingTypeGroupImage:
            break;
            case GGHUDLoadingTypeGifImage:
            break;
            case GGHUDLoadingTypeFailure:
            break;
        default:
            break;
    }
}


#pragma mark - other method
-(void)isShowRefreshButton:(BOOL)isShowRefreshButton
{
    if (isShowRefreshButton) {
        self.refreshButton.hidden = NO;
    }else{
        self.refreshButton.hidden = YES;
    }
}

-(void)refreshButtonClick
{
    [self.loadingView removeSubLayer];
    if(self.GGHUDReloadButtonClickBlock){
        self.GGHUDReloadButtonClickBlock();
    }
}


#pragma mark - updateConstraints
- (void)updateConstraints
{
    [self removeAllConstraints];
    
    [self.refreshButton removeAllConstraints];
    [self.messageLabel removeConstraintWithAttribte:NSLayoutAttributeWidth];
    [self.indicatorView removeAllConstraints];
    [self.loadingView removeAllConstraints];
    [self.imageView removeAllConstraints];
    
    // messageLabel.constraint
    [self addConstraintCenterXToView:self.messageLabel centerYToView:self.messageLabel];
    [self.messageLabel addConstraintWidth:250 height:0];
    
    // indicatorView.constraint
    [self addConstraintCenterXToView:self.indicatorView centerYToView:nil];
    [self addConstarintWithTopView:self.indicatorView toBottomView:self.messageLabel constarint:10];
    [self.indicatorView addConstraintWidth:self.indicatorViewSize.width height:self.indicatorViewSize.height];
    
    // imageView.constraint
    [self.indicatorView addConstraintCenterXToView:self.imageView centerYToView:self.imageView];
    [self.imageView addConstraintWidth:self.indicatorViewSize.width height:self.indicatorViewSize.height];
    
    // loadingView.constraint
    if (self.loadingView.superview) {
        [self.indicatorView addConstraintCenterXToView:self.loadingView centerYToView:self.loadingView];
        [self.loadingView addConstraintWidth:self.indicatorViewSize.width height:self.indicatorViewSize.height];
        
    }
    // refreshButton..constraint
    [self addConstraintCenterXToView:self.refreshButton centerYToView:nil];
    [self addConstarintWithTopView:self.messageLabel toBottomView:self.refreshButton constarint:10];
    [self.refreshButton addConstraintWidth:100 height:35];
    
    [super updateConstraints];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

@end

#pragma mark - UIView (MainQueue)

@implementation UIView (MainQueue)

-(void)dispatchMainQueue:(dispatch_block_t)block
{
    dispatch_async(dispatch_get_main_queue(), ^{
        block();
    });
}

@end
