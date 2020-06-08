//
//  UIColor+FYColor.m
//  quhuimai
//
//  Created by wang on 2019/4/1.
//  Copyright © 2019 wang. All rights reserved.
//

#import "UIColor+FYColor.h"

@implementation UIColor (FYColor)
+ (UIColor *) colorWithHexString: (NSString *)hexString aplha:(CGFloat)alpha {
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    //hexString应该6到8个字符
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    //如果hexString 有@"0X"前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    
    //如果hexString 有@"#""前缀
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    //RGB转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //R
    NSString *rString = [cString substringWithRange:range];
    
    //G
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //B
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    //
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}
+ (UIColor *) colorWithHexString: (NSString *)hexString {
   return [self colorWithHexString:hexString aplha:1.0];
}
+ (instancetype)colorRandom {
    return [UIColor colorWithR:arc4random_uniform(256) G:arc4random_uniform(256) B:arc4random_uniform(256) alpha:1];
}
+ (instancetype)colorWithR:(int)red G:(int)green B:(int)blue alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}

+ (UIColor *)fy_gradientColorWithSize:(CGSize)size direction:(FYGradientColorDirectionType)direction startColor:(UIColor *)startcolor endColor:(UIColor *)endColor {
    if (CGSizeEqualToSize(size, CGSizeZero) || !startcolor || !endColor) {
        return [UIColor clearColor];
    }
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    switch (direction) {
        case FYGradientColorDirectionHorizontal:
            startPoint = CGPointMake(0.0, 0.0);
            endPoint = CGPointMake(1.0, 0.0);
            break;
        case FYGradientColorDirectionVertical:
            startPoint = CGPointMake(0.0, 0.0);
            endPoint = CGPointMake(0.0, 1.0);
            break;
        case FYGradientColorDirectionUpwardDiagonal:
            startPoint = CGPointMake(0.0, 0.0);
            endPoint = CGPointMake(1.0, 1.0);
            break;
        case FYGradientColorDirectionDownDiagonal:
            startPoint = CGPointMake(0.0, 1.0);
            endPoint = CGPointMake(1.0, 0.0);
            break;
        default:
            break;
    }
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    gradientLayer.locations = @[@0.0, @1.0];
    
    gradientLayer.colors = @[(__bridge id)startcolor.CGColor, (__bridge id)endColor.CGColor];
    UIGraphicsBeginImageContext(size);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [UIColor colorWithPatternImage:image];
}

+ (UIColor *)fy_gradientColorWithSize:(CGSize)size direction:(FYGradientColorDirectionType)direction colors:(NSArray *)colors locations:(NSArray<NSNumber *> *)locations {
    
    if (CGSizeEqualToSize(size, CGSizeZero) || colors.count <= 0 || locations.count <= 0 || colors.count != locations.count) {
        return [UIColor clearColor];
    }
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    switch (direction) {
        case FYGradientColorDirectionHorizontal:
            startPoint = CGPointMake(0.0, 0.0);
            endPoint = CGPointMake(1.0, 0.0);
            break;
        case FYGradientColorDirectionVertical:
            startPoint = CGPointMake(0.0, 0.0);
            endPoint = CGPointMake(0.0, 1.0);
            break;
        case FYGradientColorDirectionUpwardDiagonal:
            startPoint = CGPointMake(0.0, 0.0);
            endPoint = CGPointMake(1.0, 1.0);
            break;
        case FYGradientColorDirectionDownDiagonal:
            startPoint = CGPointMake(0.0, 1.0);
            endPoint = CGPointMake(1.0, 0.0);
            break;
        default:
            break;
    }
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    gradientLayer.locations = locations;
    
    gradientLayer.colors = colors;
    UIGraphicsBeginImageContext(size);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [UIColor colorWithPatternImage:image];
}

@end
