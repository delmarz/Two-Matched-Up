//
//  MatchViewController.m
//  TwoMatcheUp3
//
//  Created by delmarz on 2/15/15.
//  Copyright (c) 2015 delmarz. All rights reserved.
//

#import "MatchViewController.h"

@interface MatchViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *matchedUserProfileImageView;
@property (strong, nonatomic) IBOutlet UIImageView *matchedCurrentUserProfileImageView;
@property (strong, nonatomic) IBOutlet UIButton *keepSearchingButton;
@property (strong, nonatomic) IBOutlet UIButton *viewChatButton;



@end

@implementation MatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
    
    PFQuery *query = [PFQuery queryWithClassName:kPhotoClassKey];
    [query whereKey:kPhotoUserKey equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if ([objects count] > 0) {
            
            PFObject *photo = objects[0];
            PFFile *imageFile = photo[kPhotoImageKey];
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                
                self.matchedCurrentUserProfileImageView.image = [UIImage imageWithData:data];
                self.matchedUserProfileImageView.image = self.matchedUserProfileImage;
                
            }];
        }
        
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (IBAction)keepSearchingButtonPressed:(UIButton *)sender
{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)viewChatButtonPressed:(UIButton *)sender
{
    [self.delegate presentMatchesViewController];
    
}


@end
