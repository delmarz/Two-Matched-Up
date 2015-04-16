//
//  EditProfileViewController.m
//  TwoMatcheUp3
//
//  Created by delmarz on 2/15/15.
//  Copyright (c) 2015 delmarz. All rights reserved.
//

#import "EditProfileViewController.h"

@interface EditProfileViewController ()


@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneBarButtonItem;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UITextView *taglineTextView;
@property (strong, nonatomic) IBOutlet UIView *profileContainer;


@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViews];
    
    PFQuery *query = [PFQuery queryWithClassName:kPhotoClassKey];
    [query whereKey:kPhotoUserKey equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       
        
        if ([objects count] > 0) {
            
            PFObject *photo = objects[0];
            PFFile *imageFile =  photo[kPhotoImageKey];
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error) {
                    
                    self.profileImageView.image = [UIImage imageWithData:data];
                   
                }
            }];
        }
        
    }];
    
    
    self.taglineTextView.text = [PFUser currentUser][kUserTaglineKey];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupViews
{
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    
    [self addShadowForViews:self.profileContainer];
}

-(void)addShadowForViews:(UIView *)view
{
    view.layer.masksToBounds = false;
    view.layer.cornerRadius = 4;
    view.layer.shadowRadius = 1;
    view.layer.shadowOffset = CGSizeMake(0, 1);
    view.layer.shadowOpacity = 0.25;
    
}

- (IBAction)doneBarButtonItemPressed:(UIBarButtonItem *)sender
{
    [[PFUser currentUser] setObject:self.taglineTextView.text forKey:kUserTaglineKey];
    [[PFUser currentUser] saveInBackground];
    [self.navigationController popViewControllerAnimated:true];
    
}


@end
