//
//  GGHUDAnimationView.m
//  GGHUD_Demo
//
//  Created by Mac on 2018/6/21.
//  Copyright © 2018年 Mr.Gao. All rights reserved.
//

#import "GGHUDAnimationView.h"
#import "GGHUD.h"
#import "GGHUDMacros.h"

@interface GGHUDAnimationView()
@property (nonatomic,strong) CAReplicatorLayer *replicatorLayer ;

@property (nonatomic,strong) CALayer *mylayer;

@property (nonatomic,strong) CABasicAnimation  *basicAnimation;

@property (nonatomic) GGHUDAnimationType type;
@end

@implementation GGHUDAnimationView

#pragma mark - lazy
- (CAReplicatorLayer *)replicatorLayer
{
    if(!_replicatorLayer)
    {
        _replicatorLayer = [CAReplicatorLayer layer];
        _replicatorLayer.cornerRadius = 10.0f;
    }
    return _replicatorLayer;
}

- (CALayer *)mylayer
{
    if(!_mylayer)
    {
        _mylayer = [CALayer layer];
        _mylayer.masksToBounds = YES;
    }
    return _mylayer;
}

-(CABasicAnimation *)basicAnimation
{
    if (!_basicAnimation)
    {
        _basicAnimation = [CABasicAnimation animation];
        _basicAnimation.repeatCount = MAXFLOAT;
        _basicAnimation.removedOnCompletion = NO;
        _basicAnimation.fillMode = kCAFillModeForwards;
    }
    return _basicAnimation;
}

#pragma mark - set
- (void)setDefaultBackGroundColor:(UIColor *)defaultBackGroundColor{
    _defaultBackGroundColor = defaultBackGroundColor;
    self.replicatorLayer.backgroundColor = defaultBackGroundColor.CGColor;
}

- (void)setForegroundColor:(UIColor *)foregroundColor{
    _foregroundColor = foregroundColor;
    self.mylayer.backgroundColor = foregroundColor.CGColor;
}


#pragma mark - init
- (instancetype)init
{
    if(self = [super init])
    {
        self.defaultBackGroundColor = GGHUD_DefaultBackGroundColor;
        self.foregroundColor        = GGHUD_DefaultForegroundColor;
        self.count = 10;
    }
    return self;
}


#pragma mark - ShowAnimation method

- (void)showAnimationAtView:(UIView *)view animationType:(GGHUDAnimationType)animationType{
    [self dispatchMainQueue:^{
        [self removeSubLayer];
    }];
    
    self.type = animationType;
    
    switch (animationType) {
            case GGHUDAnimationTypeCircle:
            self.count = 10;
            [self configCircle];
            break;
            case GGHUDAnimationTypeCircleJoin:
            self.count = 100;
            [self configCircle];
            break;
            case GGHUDAnimationTypeDot:
            self.count = 3;
            [self configDot];
            break;
        default:
            break;
    }
    
    [self dispatchMainQueue:^{
        [self addSubLayer];
    }];
}

-(void)configCircle
{
    CGFloat width = 10;
    
    self.mylayer.frame = CGRectMake(0, 0, width, width);
    self.mylayer.cornerRadius = width / 2;
    self.mylayer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
    
    self.replicatorLayer.instanceCount = self.count;
    
    CGFloat angle = 2 * M_PI / self.count;
    self.replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1);
    self.replicatorLayer.instanceDelay = 1.0 / self.count;
    
    self.basicAnimation.keyPath = @"transform.scale";
    self.basicAnimation.duration = 1;
    self.basicAnimation.fromValue = @1;
    self.basicAnimation.toValue = @0.1;
    
}


-(void)configDot
{
    CGFloat width = 15 ;
    
    self.mylayer.frame = CGRectMake(0, 0, width, width);
    self.mylayer.transform = CATransform3DMakeScale(0, 0, 0);
    self.mylayer.cornerRadius = width / 2;
    self.replicatorLayer.instanceCount = self.count;
    
    self.replicatorLayer.instanceTransform = CATransform3DMakeTranslation(100/3, 0, 0);
    self.replicatorLayer.instanceDelay = 0.8 / self.count;
    
    self.basicAnimation.keyPath = @"transform.scale";
    self.basicAnimation.duration = 0.8;
    self.basicAnimation.fromValue = @1;
    self.basicAnimation.toValue = @0;
    
}

-(void)removeSubLayer
{
    [self.replicatorLayer removeFromSuperlayer];
    [self.mylayer removeFromSuperlayer];
    [self.mylayer removeAnimationForKey:@"GGHUD"];
    
}

-(void)addSubLayer
{
    [self.layer addSublayer:self.replicatorLayer];
    [self.replicatorLayer addSublayer:self.mylayer];
    [self.mylayer addAnimation:self.basicAnimation forKey:@"GGHUD"];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.replicatorLayer.frame = self.bounds;
    self.replicatorLayer.position = self.center;
    
    switch (self.type) {
            case GGHUDAnimationTypeCircle:
            case GGHUDAnimationTypeCircleJoin:
            self.mylayer.position = CGPointMake(50,20);
            
            break;
            
            case GGHUDAnimationTypeDot:
            self.mylayer.position = CGPointMake(15, 50);
            
            break;
            
        default:
            break;
    }
}

@end
