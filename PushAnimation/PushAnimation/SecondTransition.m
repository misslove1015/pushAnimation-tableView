//
//  SecondTransition.m
//  TransitionDemo
//
//  Created by JackXu on 16/7/10.
//  Copyright © 2016年 BFMobile. All rights reserved.
//

#import "SecondTransition.h"
#import "ViewController.h"
#import "NextViewController.h"
#import "TableViewCell.h"

@implementation SecondTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    NextViewController *fromViewController = (NextViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    ViewController *toViewController = (ViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    //获得要移动的图片的快照
    UIView *imageSnapshot = [fromViewController.imageView snapshotViewAfterScreenUpdates:NO];
    imageSnapshot.frame = [containerView convertRect:fromViewController.imageView.frame fromView:fromViewController.imageView.superview];
    fromViewController.imageView.hidden = YES;
    
    //获得图片对应的cell
    TableViewCell *cell = [toViewController.tableView cellForRowAtIndexPath:[toViewController.tableView indexPathForSelectedRow]];
    cell.productImageView.hidden = YES;
    
    //设置初始view的状态
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    [containerView addSubview:imageSnapshot];
    
    [UIView animateWithDuration:duration animations:^{
        fromViewController.view.alpha = 0.0;
        imageSnapshot.frame = [containerView convertRect:cell.productImageView.frame fromView:cell.productImageView.superview];
    } completion:^(BOOL finished) {
        [imageSnapshot removeFromSuperview];
        fromViewController.imageView.hidden = NO;
        cell.productImageView.hidden = NO;
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
    
}




@end
