//
//  NextViewController.m
//  PushAnimation
//
//  Created by miss on 16/11/28.
//  Copyright © 2016年 mukr. All rights reserved.
//
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#import "NextViewController.h"
#import "SecondTransition.h"
#import "ViewController.h"
#import "ThirdViewController.h"
@interface NextViewController ()<UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactivePopTransition;
@property (nonatomic, strong) UIButton *playButton;
@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    _imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 235*SCREEN_WIDTH/375);
    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 235*SCREEN_WIDTH/375);
    _tableView.frame = CGRectMake(0, CGRectGetMaxY(_imageView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-64-235*SCREEN_WIDTH/375);
    _imageView.image = _image;
    _tableView.tableHeaderView = _headerView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(back:)];
    [self.view addGestureRecognizer:swipe];
    
}

- (UIButton *)playButton{
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _playButton.center = _headerView.center;
        _playButton.bounds = CGRectMake(0, 0, 60, 60);
        [_playButton setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        _playButton.alpha = 0;
    }
    return _playButton;
}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    cell.contentView.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:0.5];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.2, 0.2, 1)];
    
    scaleAnimation.toValue  = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [cell.layer addAnimation:scaleAnimation forKey:@"transform"];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ThirdViewController *third = [[ThirdViewController alloc]init];
    [self.navigationController pushViewController:third animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
    [_headerView addSubview:[self playButton]];
    [UIView animateWithDuration:0.5 animations:^{
        _playButton.alpha = 1;
    }];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
    [_playButton removeFromSuperview];
}

-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    if ([animationController isKindOfClass:[SecondTransition class]]) {
        return self.interactivePopTransition;
    }
    return nil;
}


-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (fromVC == self && [toVC isKindOfClass:[ViewController class]]) {
        return [[SecondTransition alloc] init];
    }
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
