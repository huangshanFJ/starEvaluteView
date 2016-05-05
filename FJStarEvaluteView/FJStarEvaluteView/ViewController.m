//
//  ViewController.m
//  FJStarEvaluteView
//
//  Created by mzl_Jfang on 16/2/29.
//  Copyright © 2016年 mzl_Jfang. All rights reserved.
//

#import "ViewController.h"
#import "FJStarView.h"

@interface ViewController ()<FJStarViewDelegate>

@property (nonatomic, strong) FJStarView *starView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _starView = [[FJStarView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 80) starCount:5];
    _starView.backgroundColor = [UIColor greenColor];
    _starView.delegate = self;
    [self.view addSubview:_starView];
    //刚开始为0（默认为5）
    dispatch_async(dispatch_get_main_queue(), ^{
        [_starView setScore:2.0f fullScore:10.0f withAnimation:YES];
    });
    
}

#pragma mark - StarViewdelegate

- (void)starView:(FJStarView *)starView didChangedPercentage:(CGFloat)percentage {
    NSLog(@"%f",percentage);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
