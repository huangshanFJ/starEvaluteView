//
//  FJStarView.m
//  FJStarEvaluteView
//
//  Created by mzl_Jfang on 16/2/29.
//  Copyright © 2016年 mzl_Jfang. All rights reserved.
//

#import "FJStarView.h"

@interface FJStarView ()

//{
//    __weak UIView *_lightStarView;
//    __weak UIView *_grayStarView;
//    __weak UIPanGestureRecognizer *_panGes;
//}

@property (nonatomic, strong) UIView *lightStarView;
@property (nonatomic, strong) UIView *grayStarView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGes;
@property (nonatomic, assign, readonly) NSInteger starCount;
@property (nonatomic, assign) CGFloat starWidth;

@end

#define DEFAULT_DURATION 0.3f

@implementation FJStarView

- (id)initWithFrame:(CGRect)frame starCount:(NSInteger)starCount {
    self = [super initWithFrame:frame];
    if (self) {
        _starCount = starCount;
        self.starWidth = (CGFloat)self.frame.size.width / self.starCount;
        
        [self internalInit];
    }
    return self;
}

//从xib中创建的
- (void)awakeFromNib {
    [self internalInit];
}

- (void)internalInit {
    //默认值
    self.percentage = 1.0f;
    self.shouldUseAnimation = NO;
    self.allowIncompleteStar = NO;
    self.allowUserInteraction = YES;
    
    //星星视图
    _grayStarView = [self starViewWithImageName:@"backgroundStar@2x.png"];
    _lightStarView = [self starViewWithImageName:@"foregroundStar@2x.png"];
    
    [self addSubview:_grayStarView];
    [self addSubview:_lightStarView];
}

- (UIView *)starViewWithImageName:(NSString *)imageName {
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
    
    //添加星星
    for (int i = 0; i<self.starCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i *self.starWidth, 0, self.starWidth, self.bounds.size.height)];
        imageView.image = [UIImage imageNamed:imageName];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
    }
    return view;
}

#pragma mark - Set Score

/**
 *  设置控件分数
 *
 *  @param score     分数，必须在 0 － 1 之间
 *  @param isAnimate 是否启用动画
 */
- (void)setScore:(float)score fullScore:(float)fullScore withAnimation:(bool)isAnimate
{
    score = score / fullScore;
    [self setScore:score withAnimation:isAnimate completion:^(BOOL finished){}];
}

/**
 *  设置控件分数
 *
 *  @param score      分数，必须在 0 － 1 之间
 *  @param isAnimate  是否启用动画
 *  @param completion 动画完成block
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate completion:(void (^)(BOOL finished))completion
{
    NSAssert((score >= 0.0)&&(score <= 1.0), @"score must be between 0 and 1");
    
    if (score < 0)
    {
        score = 0;
    }
    
    if (score > 1)
    {
        score = 1;
    }
    
    CGPoint point = CGPointMake(score * self.frame.size.width, 0);
    
    if(isAnimate)
    {
        __weak __typeof(self)weakSelf = self;
        
        [UIView animateWithDuration:0.2 animations:^
         {
             [weakSelf changeStarForegroundViewWithPoint:point];
             
         } completion:^(BOOL finished)
         {
             if (completion)
             {
                 completion(finished);
             }
         }];
    }
    else
    {
        [self changeStarForegroundViewWithPoint:point];
    }
}

#pragma mark -
#pragma mark - Touche Event
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if(CGRectContainsPoint(rect,point))
    {
        [self changeStarForegroundViewWithPoint:point];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    __weak __typeof(self)weakSelf = self;
    
    [UIView animateWithDuration:0.2 animations:^
     {
         [weakSelf changeStarForegroundViewWithPoint:point];
     }];
}

#pragma mark - Change Star Foreground With Point
/**
 *  通过坐标改变前景视图
 *
 *  @param point 坐标
 */
- (void)changeStarForegroundViewWithPoint:(CGPoint)point
{
    CGPoint p = point;
    
    if (p.x < 0)
    {
        p.x = 0;
    }
    
    if (p.x > self.frame.size.width)
    {
        p.x = self.frame.size.width;
    }
    
    NSString * str = [NSString stringWithFormat:@"%0.2f",p.x / self.frame.size.width];
    float score = [str floatValue];
    p.x = score * self.frame.size.width;
    self.lightStarView.frame = CGRectMake(0, 0, p.x, self.frame.size.height);
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(starView:didChangedPercentage:)])
    {
        [self.delegate starView:self didChangedPercentage:score];
    }
}

@end














