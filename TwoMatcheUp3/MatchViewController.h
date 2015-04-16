//
//  MatchViewController.h
//  TwoMatcheUp3
//
//  Created by delmarz on 2/15/15.
//  Copyright (c) 2015 delmarz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"


@protocol  MatchViewControllerDelegate <NSObject>

@required
-(void)presentMatchesViewController;

@end

@interface MatchViewController : UIViewController
@property (weak, nonatomic) id <MatchViewControllerDelegate> delegate;
@property (strong, nonatomic) UIImage *matchedUserProfileImage;

@end
