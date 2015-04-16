//
//  HomeViewController.m
//  TwoMatcheUp3
//
//  Created by delmarz on 2/11/15.
//  Copyright (c) 2015 delmarz. All rights reserved.
//

#import "HomeViewController.h"
#import "TestUser.h"
#import "ProfileViewController.h"
#import "MatchViewController.h"
#import "TransitionAnimator.h"


@interface HomeViewController () <ProfileViewControllerDelegate, MatchViewControllerDelegate, UIViewControllerTransitioningDelegate>




@property (strong, nonatomic) IBOutlet UIView *labelContainer;
@property (strong, nonatomic) IBOutlet UIView *buttonContainer;


@property (strong, nonatomic) IBOutlet UIBarButtonItem *chatBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *settingsBarButtonItem;


@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;



@property (strong, nonatomic) IBOutlet UILabel *firstnameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;

@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) IBOutlet UIButton *dislikeButton;


@property (strong, nonatomic) PFObject *photo;
@property (strong, nonatomic) NSArray *photos;
@property (strong, nonatomic) NSMutableArray *activities;


@property (nonatomic) BOOL currentPhotoIndex;
@property (nonatomic) BOOL  islikedByCurrentUser;
@property (nonatomic) BOOL  isDislikedByCurrentUser;




@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViews];
    
    
}


-(void)viewDidAppear:(BOOL)animated
{
    
    self.firstnameLabel.text = nil;
    self.ageLabel.text = nil;
    self.profileImageView.image = nil;

    self.likeButton.enabled = false;
    self.infoButton.enabled = false;
    self.dislikeButton.enabled = false;
    
    self.currentPhotoIndex = 0;
    
    PFQuery *query = [PFQuery queryWithClassName:kPhotoClassKey];
    [query whereKey:kPhotoUserKey notEqualTo:[PFUser currentUser]];
    [query includeKey:kPhotoUserKey];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            self.photos = objects;
            
            if ([self allowPhoto] == false) {
                [self setupNextPhoto];
            }
            else
            {
                  [self queryForCurrentPhotoIndex];
            }
            
          
            
        }
        else{
            NSLog(@"%@", error);
        }
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"homeToProfileSegue"]) {
        ProfileViewController *profileVC = segue.destinationViewController;
        profileVC.photo = self.photo;
        profileVC.delegate = self;
    }
//    else if ([segue.identifier isEqualToString:@"homeToMatchSegue"]) {
//        
//        MatchViewController *matchVC = segue.destinationViewController;
//        matchVC.matchedUserProfileImage = self.profileImageView.image;
//        matchVC.delegate = self;
//    }
    
    
}


-(void)setupViews
{
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
  
    [self addShadowForViews:self.labelContainer];
    [self addShadowForViews:self.buttonContainer];
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



- (IBAction)chatBarButtonItemPressed:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"homeToMatchesSegue" sender:self];
    
}

- (IBAction)settingsBarButtonItemPressed:(UIBarButtonItem *)sender
{
    
    
}


- (IBAction)likeButtonPressed:(UIButton *)sender
{
    [self checkLike];
    
}

- (IBAction)infoButtonPressed:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"homeToProfileSegue" sender:self];
    
}

- (IBAction)dislikeButtonPressed:(UIButton *)sender
{
    
    [self checkDislike];
}


#pragma mark - Helper Methods

-(void)queryForCurrentPhotoIndex
{
    
    if ([self.photos count] > 0) {
        
        self.photo = self.photos[self.currentPhotoIndex];
        PFFile *imageFile = self.photo[kPhotoImageKey];
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            
            if (!error) {
                
                UIImage *profileImage = [UIImage imageWithData:data];
                self.profileImageView.image = profileImage;
                [self updateView];
               
            }
            else
            {
                NSLog(@"%@", error);
            }
            
        }];
        
        
        PFQuery *queryForLike = [PFQuery queryWithClassName:kActivityClassKey];
        [queryForLike whereKey:kActivityTypeKey equalTo:kActivityTypeLikeyKey];
        [queryForLike whereKey:kActivityFromUserKey equalTo:[PFUser currentUser]];
        [queryForLike whereKey:kActivityPhotoKey equalTo:self.photo];
        
        PFQuery *queryForDislike = [PFQuery queryWithClassName:kActivityClassKey];
        [queryForDislike whereKey:kActivityTypeKey equalTo:kActivityTypeDislikeKey];
        [queryForDislike whereKey:kActivityFromUserKey equalTo:[PFUser currentUser]];
        [queryForDislike whereKey:kActivityPhotoKey equalTo:self.photo];
        
        PFQuery *combinedQuery = [PFQuery orQueryWithSubqueries:@[queryForLike, queryForDislike]];
        [combinedQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if (!error) {
                
                self.activities = [objects mutableCopy];
                
                
                if (self.activities == 0) {
                    self.islikedByCurrentUser = false;
                    self.isDislikedByCurrentUser = false;
                }
                else
                {
                    PFObject *activity = self.activities[0];
                    
                    if ([activity[kActivityTypeKey] isEqualToString:kActivityTypeLikeyKey]) {
                        
                        self.islikedByCurrentUser = true;
                        self.isDislikedByCurrentUser = false;
                    }
                    
                    else if ([activity[kActivityTypeKey] isEqualToString:kActivityTypeDislikeKey]){
                        
                        self.islikedByCurrentUser = false;
                        self.isDislikedByCurrentUser = true;
                    }
                    
                    else{
                        //other some activity
                    }
                }
                
                
                self.likeButton.enabled = true;
                self.infoButton.enabled = true;
                self.dislikeButton.enabled = true;
                
            }
            
        }];
        
    }
    
    
    
}


-(void)updateView
{
    
    self.firstnameLabel.text = self.photo[kPhotoUserKey][kUserProfileKey][kUserProfileFirstNameKey];
    self.ageLabel.text = [NSString stringWithFormat:@"%@", self.photo[kPhotoUserKey][kUserProfileKey][kUserProfileAgeKey]];
                          
    
    
}


-(void)setupNextPhoto
{
    
    if (self.currentPhotoIndex + 1 < [self.photos count]) {
        
        self.currentPhotoIndex ++;
        
        if ([self allowPhoto] == false) {
            [self setupNextPhoto];
        }
        else {
             [self queryForCurrentPhotoIndex];
        }
       
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"no more user to view" message:@"check back later for more people" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
    
    
}



-(BOOL)allowPhoto
{
    
    int ageMax = (int)[[NSUserDefaults standardUserDefaults] integerForKey:kageMaxKey];
    BOOL men = [[NSUserDefaults standardUserDefaults] boolForKey:kMenEnabledKey];
    BOOL women = [[NSUserDefaults standardUserDefaults] boolForKey:kWomenEnabledKey];
    BOOL single = [[NSUserDefaults standardUserDefaults] boolForKey:kSingleEnabledKey];
    
    PFObject *photo = self.photos[self.currentPhotoIndex];
    PFUser *user = photo[kPhotoUserKey];
    
    int userAge = [user[kUserProfileKey][kUserProfileAgeKey] intValue];
    NSString *gender = user[kUserProfileKey][kUserProfileGenderKey];
    NSString *relationshipStatus = user[kUserProfileKey][kUserProfileRelationshipStatusKey];
    
    if (userAge > ageMax) {
        return false;
    }
    else if (men == false && [gender isEqualToString:@"male"]){
        return false;
    }
    else if (women == false && [gender isEqualToString:@"female"]){
        return false;
    }
    else if (single == false && ([relationshipStatus isEqualToString:@"single"] || relationshipStatus == nil)){
        return false;
    }
    else
    {
        return true;
    }
    
    
    
}



-(void)saveLike
{
    
    
    PFObject *likeActivity = [PFObject objectWithClassName:kActivityClassKey];
    [likeActivity setObject:kActivityTypeLikeyKey forKey:kActivityTypeKey];
    [likeActivity setObject:[PFUser currentUser] forKey:kActivityFromUserKey];
    [likeActivity setObject:[self.photo objectForKey:kPhotoUserKey] forKey:kActivityToUserKey];
    [likeActivity setObject:self.photo forKey:kActivityPhotoKey];
    [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self checkForPhotoUserLike];
        [self.activities addObject:likeActivity];
        self.islikedByCurrentUser = true;
        self.isDislikedByCurrentUser = false;
        [self setupNextPhoto];
        
    }];
    
    
}





-(void)saveDislike
{
    
    PFObject *dislikeActivity = [PFObject objectWithClassName:kActivityClassKey];
    [dislikeActivity setObject:kActivityTypeDislikeKey forKey:kActivityTypeKey];
    [dislikeActivity setObject:[PFUser currentUser] forKey:kActivityFromUserKey];
    [dislikeActivity setObject:[self.photo objectForKey:kPhotoUserKey] forKey:kActivityToUserKey];
    [dislikeActivity setObject:self.photo forKey:kActivityPhotoKey];
    [dislikeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        [self.activities addObject:dislikeActivity];
        self.islikedByCurrentUser = false;
        self.isDislikedByCurrentUser = true;
        [self setupNextPhoto];
        
    }];
    
    
}


-(void)checkLike
{
    
    if (self.islikedByCurrentUser) {
        [self setupNextPhoto];
        return;
    }
    else if (self.isDislikedByCurrentUser){
        for (PFObject *activity in self.activities) {
            [activity deleteInBackground];
        }
        [self.activities removeLastObject];
        [self saveLike];
    }
    else{
        [self saveLike];
    }
    
}

-(void)checkDislike
{
    
    if (self.isDislikedByCurrentUser) {
        [self setupNextPhoto];
        return;
    }
    else if (self.islikedByCurrentUser){
        for (PFObject *activity in self.activities) {
            [activity deleteInBackground];
        }
        [self.activities removeLastObject];
        [self saveDislike];
    }
    else {
        [self saveDislike];
    }
    
    
}



-(void)checkForPhotoUserLike
{
    
    PFQuery *query = [PFQuery queryWithClassName:kActivityClassKey];
    [query whereKey:kActivityFromUserKey equalTo:self.photo[kPhotoUserKey]];
    [query whereKey:kActivityToUserKey equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if ([objects count] > 0) {
            
            //create chatroom
            [self createChatroom];
        }
        
    }];
    
    
}

-(void)createChatroom
{
    
    PFQuery *queryForChatroom = [PFQuery queryWithClassName:@"Chatroom"];
    [queryForChatroom whereKey:@"user1" equalTo:[PFUser currentUser]];;
    [queryForChatroom whereKey:@"user2" equalTo:self.photo[kPhotoUserKey]];
    
    PFQuery *queryForInverseChatroom = [PFQuery queryWithClassName:@"Chatroom"];
    [queryForInverseChatroom whereKey:@"user1" equalTo:self.photo[kPhotoUserKey]];
    [queryForInverseChatroom whereKey:@"user2" equalTo:[PFUser currentUser]];
    
    PFQuery *combinedQuery = [PFQuery orQueryWithSubqueries:@[queryForChatroom, queryForInverseChatroom]];
    [combinedQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (error) {
            NSLog(@"erro while creating chatroom %@", error);
        }
        else if ([objects count] == 0){
            
            PFObject *chatroom = [PFObject objectWithClassName:@"Chatroom"];
            [chatroom setObject:[PFUser currentUser] forKey:@"user1"];
            [chatroom setObject:self.photo[kPhotoUserKey] forKey:@"user2"];
            [chatroom saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
//                [self performSegueWithIdentifier:@"homeToMatchSegue" sender:self];
                
                UIStoryboard *myStoryboard = self.storyboard;
                MatchViewController *matchViewController = [myStoryboard instantiateViewControllerWithIdentifier:@"matchVC"];
                matchViewController.view.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.75];
                matchViewController.transitioningDelegate = self;
                matchViewController.matchedUserProfileImage = self.profileImageView.image;
                matchViewController.delegate = self;
                matchViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                [self presentViewController:matchViewController animated:true completion:nil];
                
                
            }];
            
            
        }
        
    }];
    
    
}

#pragma mark - MatchViewController Delegate

-(void)presentMatchesViewController
{
    
//    [self dismissViewControllerAnimated:false completion:^{
//        [self performSegueWithIdentifier:@"homeToMatchesSegue" sender:self];
//       
//    }];
    
    [self performSegueWithIdentifier:@"homeToMatchesSegue" sender:self];
    [self dismissViewControllerAnimated:true completion:nil];
    
    
    
}




#pragma mark - ProfileViewController Delegate

-(void)didPressLiked
{
    
    [self checkLike];
    [self.navigationController popViewControllerAnimated:false];
}

-(void)didPressCancel
{
    [self checkDislike];
    [self.navigationController popViewControllerAnimated:false];
    
}

#pragma mark - UIViewTransitioning Delegate

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    
    TransitionAnimator *animator = [[TransitionAnimator alloc] init];
    animator.presenting = true;
    return animator;
    
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    
    TransitionAnimator *animator = [[TransitionAnimator alloc] init];
    return animator;
    
}





@end
