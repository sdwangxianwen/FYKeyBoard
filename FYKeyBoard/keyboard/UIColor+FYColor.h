//
//  UIColor+FYColor.h
//  quhuimai
//
//  Created by wang on 2019/4/1.
//  Copyright © 2019 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FYGradientColorDirectionType) {
    FYGradientColorDirectionHorizontal = 0,   // 横向
    FYGradientColorDirectionVertical,         // 竖向
    FYGradientColorDirectionUpwardDiagonal,   // 斜向下
    FYGradientColorDirectionDownDiagonal      // 斜向上
};
NS_ASSUME_NONNULL_BEGIN

@interface UIColor (FYColor)
+ (UIColor *) colorWithHexString:(NSString *)color;
+ (UIColor *) colorWithHexString:(NSString *)color aplha:(CGFloat)alpha;
+ (instancetype)colorRandom;

/**
 渐变色:指定开始颜色+结束颜色+方向枚举+尺寸大小
 */
+ (UIColor *)fy_gradientColorWithSize:(CGSize)size direction:(FYGradientColorDirectionType)direction startColor:(UIColor *)startcolor endColor:(UIColor *)endColor;

/**
 渐变色:指定颜色数组+位置数组+方向枚举+尺寸大小
 注意:颜色数组count 必须 等于 位置数组;colors 元素必须是CGColor
 例如: @[(__bridge id)[UIColor greenColor].CGColor, (__bridge id)[UIColor whiteColor].CGColor]
 */
+ (UIColor *)fy_gradientColorWithSize:(CGSize)size direction:(FYGradientColorDirectionType)direction colors:(NSArray *)colors locations:(NSArray <NSNumber *>*)locations;
@end

NS_ASSUME_NONNULL_END
