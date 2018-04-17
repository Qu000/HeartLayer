//
//  ViewController.m
//  heartLayer
//
//  Created by qujiahong on 2018/4/17.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) dispatch_source_t timer;

//基点位置
/** 点赞     UIImageView*/
@property (weak, nonatomic) IBOutlet UIImageView *loveView;
/** 点赞次数  Label*/
@property (weak, nonatomic) IBOutlet UILabel *clickNumberLab;
/** 点赞次数*/
@property (nonatomic, assign) NSInteger clickNumber;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clickNumberLab.text = @"0次点赞";
    
    [self setupTimer];
    
    [self setupLoveView];
    
}

- (void)setupTimer{
    //初始化
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        
        [self showMoreLoveAnimateFromView:self.loveView addToView:self.view];
    });
    dispatch_resume(self.timer);
}

- (void)setupLoveView{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickLoveView)];
    //允许用户交互
    self.loveView.userInteractionEnabled = YES;
    [self.loveView addGestureRecognizer:tapGesture];
}
- (void)clickLoveView{
    self.clickNumber++;
    self.clickNumberLab.text = [NSString stringWithFormat:@"%ld次点赞",_clickNumber];
    [self showMoreLoveAnimateFromView:self.loveView addToView:self.view];
}


- (void)showMoreLoveAnimateFromView:(UIView *)fromView addToView:(UIView *)addToView {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 25)];
    CGRect loveFrame = [fromView convertRect:fromView.frame toView:addToView];
    CGPoint position = CGPointMake(fromView.layer.position.x, loveFrame.origin.y - 30);
    imageView.layer.position = position;
    NSArray *imgArr = @[@"heart_1",@"heart_2",@"heart_3",@"heart_4",@"heart_5",@"heart_1"];
    NSInteger img = arc4random()%6;
    imageView.image = [UIImage imageNamed:imgArr[img]];
    [addToView addSubview:imageView];
    
    imageView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        imageView.transform = CGAffineTransformIdentity;
    } completion:nil];
    
    CGFloat duration = 3 + arc4random()%5;
    CAKeyframeAnimation *positionAnimate = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimate.repeatCount = 1;
    positionAnimate.duration = duration;
    positionAnimate.fillMode = kCAFillModeForwards;
    positionAnimate.removedOnCompletion = NO;
    
    UIBezierPath *sPath = [UIBezierPath bezierPath];
    [sPath moveToPoint:position];
    CGFloat sign = arc4random()%2 == 1 ? 1 : -1;
    CGFloat controlPointValue = (arc4random()%50 + arc4random()%100) * sign;
    [sPath addCurveToPoint:CGPointMake(position.x, position.y - 300) controlPoint1:CGPointMake(position.x - controlPointValue, position.y - 150) controlPoint2:CGPointMake(position.x + controlPointValue, position.y - 150)];
    positionAnimate.path = sPath.CGPath;
    [imageView.layer addAnimation:positionAnimate forKey:@"heartAnimated"];
    
    
    [UIView animateWithDuration:duration animations:^{
        imageView.layer.opacity = 0;
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
    }];
}

@end
