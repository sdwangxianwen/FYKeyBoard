//
//  UIView+FYExtension.h
//  FYAlertView
//
//  Created by wang on 2018/8/2.
//  Copyright © 2018年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYBaseViewController;
typedef NS_ENUM(NSInteger,borderDirectionType) {
    borderDirectionTypeTop,
    borderDirectionTypeLeft,
    borderDirectionTypeBottom,
    borderDirectionTypeRight
};

/**
 渐变方式
 
 - IHGradientChangeDirectionLevel:              水平渐变
 - IHGradientChangeDirectionVertical:           竖直渐变
 - IHGradientChangeDirectionUpwardDiagonalLine: 向下对角线渐变
 - IHGradientChangeDirectionDownDiagonalLine:   向上对角线渐变
 */
typedef NS_ENUM(NSInteger, IHGradientChangeDirection) {
    IHGradientChangeDirectionLevel,
    IHGradientChangeDirectionVertical,
    IHGradientChangeDirectionUpwardDiagonalLine,
    IHGradientChangeDirectionDownDiagonalLine,
};


@interface UIView (FYExtension)
@property (nonatomic, assign) CGFloat fy_x;
@property (nonatomic, assign) CGFloat fy_y;
@property (nonatomic, assign) CGFloat fy_width;
@property (nonatomic, assign) CGFloat fy_height;
@property (nonatomic, assign) CGFloat fy_centerX;
@property (nonatomic, assign) CGFloat fy_centerY;
@property (nonatomic, assign) CGSize  fy_size;
@property (nonatomic, assign) CGPoint fy_origin;
@property (nonatomic, assign, readonly) CGFloat fy_maxX;
@property (nonatomic, assign, readonly) CGFloat fy_minX;
@property (nonatomic, assign, readonly) CGFloat fy_maxY;
@property (nonatomic, assign, readonly) CGFloat fy_minY;

/**
 获取当前的控制器
 */
- (FYBaseViewController *)getCurrentViewController;

- (void)addBorder:(borderDirectionType)direction color:(UIColor*)color width:(CGFloat)width;
/**
 设置一个view的radius
 @param corners corner
 @param radius 角度
 */
- (void)setCustomRectCorner:(UIRectCorner)corners radius:(CGFloat)radius;

-(void)setCustomRectCorner:(UIRectCorner)corners rect:(CGRect)rect radius:(CGFloat)radius;

/*
 * 将会把一个view变成圆形，并将它描边, 因为没有使用view 的layer
 * 不要设置该view的layer 属性。
 */
- (void)sn_ClipToCircle:(CGRect)frame borderColor:(UIColor *)borderColor borderWidth:(CGFloat)width;

/**
 缩放进场动画

 @param duration 动画时长
 @param scaleRatio 缩放比例
 @param finishBlock 回调
 */
- (void)animation_scaleShowWithDuration:(CGFloat)duration
                                  ratio:(CGFloat)scaleRatio
                            finishBlock:(void(^)(void))finishBlock;

/**
 缩放出厂动画

 @param duration 动画时长
 @param scaleRatio 缩放比例
 @param finishBlock 回调
 */
- (void)animation_scaleDismissWithDuration:(CGFloat)duration
                                     ratio:(CGFloat)scaleRatio
                               finishBlock:(void(^)(void))finishBlock;

/**
 添加四边阴影

 @param theColor 阴影颜色
 */
- (void)addShadowWithColor:(UIColor *)theColor ;

-(void)addGradientWith:(NSArray *)colors;

/**
 创建渐变颜色
 
 @param size       渐变的size
 @param direction  渐变方式
 @param startcolor 开始颜色
 @param endColor   结束颜色

 */
-(void)bm_colorGradientChangeWithSize:(CGSize)size
                                     direction:(IHGradientChangeDirection)direction
                                    startColor:(UIColor *)startcolor
                                      endColor:(UIColor *)endColor;

@end
