//
//  FirstTransition.m
//  TransitionDemo
//
//  Created by JackXu on 16/7/10.
//  Copyright © 2016年 BFMobile. All rights reserved.
//

#import "FirstTransition.h"
#import "ViewController.h"
#import "NextViewController.h"
#import "TableViewCell.h"

@implementation FirstTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    ViewController *fromViewController = (ViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    NextViewController *toViewController = (NextViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];

    //获得cell中的图片的快照
    TableViewCell *cell = (TableViewCell*)[fromViewController.tableView cellForRowAtIndexPath:[fromViewController.tableView indexPathForSelectedRow]];
    UIView *cellImageSnapshot = [cell.productImageView snapshotViewAfterScreenUpdates:NO];
    cellImageSnapshot.frame = [containerView convertRect:cell.productImageView.frame fromView:cell.productImageView.superview];
    cell.imageView.hidden = YES;
    
    //设置初始view的状态
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    toViewController.view.alpha = 0;
    toViewController.imageView.hidden = YES;
    
    [containerView addSubview:toViewController.view];
    [containerView addSubview:cellImageSnapshot];
    
    [UIView animateWithDuration:duration animations:^{
        toViewController.view.alpha = 1.0;
        CGRect frame = [containerView convertRect:toViewController.imageView.frame fromView:toViewController.view];
        cellImageSnapshot.frame = frame;
    }completion:^(BOOL finished) {
        toViewController.imageView.hidden = NO;
        cell.productImageView.hidden = NO;
        [cellImageSnapshot removeFromSuperview];
        
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}




@end
