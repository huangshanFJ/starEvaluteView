//
//  FJStarView.h
//  FJStarEvaluteView
//
//  Created by mzl_Jfang on 16/2/29.
//  Copyright © 2016年 mzl_Jfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FJStarView;
@protocol FJStarViewDelegate <NSObject>

@optional
/**
 *  通知代理评分达到某个值
 */
- (void)starView:(FJStarView *)starView didChangedPercentage:(CGFloat)percentage;

@end

@interface FJStarView : UIView

@property (nonatomic, weak) id<FJStarViewDelegate> delegate;

/**
 *  是否使用动画，默认为NO
 */
@property (nonatomic, assign) BOOL shouldUseAnimation;

/**
 *  是否允许非整形评分,默认为NO
 */
@property (nonatomic, assign) BOOL allowIncompleteStar;

/**
 *  是否允许用户手指操作评分，默认为YES
 */
@property (nonatomic, assign) BOOL allowUserInteraction;

/**
 *  当前评分值，0--1，默认为1
 */
@property (nonatomic, assign) CGFloat percentage;

- (id)initWithFrame:(CGRect)frame starCount:(NSInteger)starCount;

- (void)setScore:(float)score withAnimation:(bool)isAnimate completion:(void (^)(BOOL finished))completion;

- (void)setScore:(float)score fullScore:(float)fullScore withAnimation:(bool)isAnimate;

@end
