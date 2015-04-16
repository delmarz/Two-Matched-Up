//
//  ProfileViewController.m
//  TwoMatcheUp3
//
//  Created by delmarz on 2/15/15.
//  Copyright (c) 2015 delmarz. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()


@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *singleLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *taglineLabel;

@property (strong, nonatomic) IBOutlet UIView *lowerContainer;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViews];
    
    PFFile *imageFile = self.photo[kPhotoImageKey];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        
        if (!error) {
            
            self.profileImageView.image = [UIImage imageWithData:data];
        }
        
    }];
    
    PFUser *user = self.photo[kPhotoUserKey];
    
    if (user[kUserProfileKey][kUserProfileRelationshipStatusKey] == nil) {
        self.singleLabel.text = @"Single";
    }
    else{
        self.singleLabel.text = user[kUserProfileKey][kUserProfileRelationshipStatusKey];
    }
    
    
    self.ageLabel.text = [NSString stringWithFormat:@"%@", user[kUserProfileKey][kUserProfileAgeKey]];
    self.locationLabel.text = user[kUserProfileKey][kUserProfileLocationKey];
    self.taglineLabel.text = user[kUserTaglineKey];
                          
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupViews
{
    
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    [self addShadowForViews:self.lowerContainer];
    self.profileImageView.layer.masksToBounds = true;
    
    
}

-(void)addShadowForViews:(UIView *)view
{
    
    view.layer.masksToBounds = false;
    view.layer.cornerRadius = 4;
    view.layer.shadowRadius = 1;
    view.layer.shadowOffset = CGSizeMake(0, 1);
    view.layer.shadowOpacity = 0.25;
    
    
}




- (IBAction)likeButtonPressed:(UIButton *)sender
{
    
    [self.delegate didPressLiked];
  
}

- (IBAction)dislikeButtonPressed:(UIButton *)sender
{
    
    [self.delegate didPressCancel];
    
}

@end
