//
//  ProfileViewController.h
//  TwoMatcheUp3
//
//  Created by delmarz on 2/15/15.
//  Copyright (c) 2015 delmarz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"


@protocol ProfileViewControllerDelegate <NSObject>

@required
-(void)didPressLiked;
-(void)didPressCancel;

@end

@interface ProfileViewController : UIViewController

@property (weak, nonatomic) id <ProfileViewControllerDelegate> delegate;
@property (strong, nonatomic) PFObject *photo;

@end
