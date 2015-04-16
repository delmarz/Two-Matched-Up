//
//  TransitionAnimator.m
//  TwoMatcheUp3
//
//  Created by delmarz on 2/15/15.
//  Copyright (c) 2015 delmarz. All rights reserved.
//

#import "TransitionAnimator.h"

@implementation TransitionAnimator

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    return 0.25f;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect endFrame = fromViewController.view.bounds;
    
    if (self.presenting) {
        
        fromViewController.view.userInteractionEnabled = false;
        
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
        
        CGRect startFrame = endFrame;
        
        toViewController.view.alpha = 0.0;
        toViewController.view.frame = startFrame;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            
            fromViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
            toViewController.view.alpha = 1.0;
            toViewController.view.frame = endFrame;
            
        } completion:^(BOOL finished) {
            [transitionContext completeTransition: true];
            
        }];
    }
    else {
        toViewController.view.userInteractionEnabled = true;
        
     
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
        
        [UIView animateWithDuration:[self  transitionDuration:transitionContext] animations:^{
            
            toViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
            fromViewController.view.alpha = 0.0;
            fromViewController.view.frame = endFrame;
            
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:true];
            
        }];
    }
    
   
}




@end
