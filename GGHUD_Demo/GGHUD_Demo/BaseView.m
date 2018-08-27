//
//  BaseView.m
//  GGHUD_Demo
//
//  Created by Mac on 2018/6/21.
//  Copyright © 2018年 Mr.Gao. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

@end
