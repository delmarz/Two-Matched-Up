//
//  MatchesViewController.m
//  TwoMatcheUp3
//
//  Created by delmarz on 2/15/15.
//  Copyright (c) 2015 delmarz. All rights reserved.
//

#import "MatchesViewController.h"
#import "ChatViewController.h"

@interface MatchesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *availableChatroom;


@end

@implementation MatchesViewController


-(NSMutableArray *)availableChatroom
{
    if (!_availableChatroom) {
        _availableChatroom = [[NSMutableArray alloc] init];
    }
    return _availableChatroom;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

   
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
        [self updateAvailableChatroom];
    
    [self.tableView reloadData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"matchesToChatSegue"]) {
        ChatViewController *chatVC = segue.destinationViewController;
        NSIndexPath *indexPath = sender;
        PFObject *selectedChatroom = self.availableChatroom[indexPath.row];
        chatVC.chatroom = selectedChatroom;
    }
    
}


-(void)updateAvailableChatroom
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Chatroom"];
    [query whereKey:@"user1" equalTo:[PFUser currentUser]];
    PFQuery *queryInverse = [PFQuery queryWithClassName:@"Chatroom"];
    [queryInverse whereKey:@"user2" equalTo:[PFUser currentUser]];
    
    PFQuery *combinedQuery = [PFQuery orQueryWithSubqueries:@[query, queryInverse]];
    [combinedQuery includeKey:@"chat"];
    [combinedQuery includeKey:@"user1"];
    [combinedQuery includeKey:@"user2"];
    [combinedQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
          
            [self.availableChatroom removeAllObjects];
            self.availableChatroom = [objects mutableCopy];
            [self.tableView reloadData];
        }
        
        
    }];
   
}

#pragma mark - TableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.availableChatroom count];
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    PFObject *chatroom = self.availableChatroom[indexPath.row];
    
    PFUser *likedUser;
    PFUser *currentUser = [PFUser currentUser];
    PFUser *testFromUser = chatroom[@"user1"];
    
    if ([testFromUser.objectId isEqualToString:currentUser.objectId]) {
        likedUser = chatroom[@"user2"];
    }
    else if ([testFromUser.objectId isEqualToString:currentUser.objectId]){
        likedUser = chatroom[@"user1"];
    }
    
    cell.textLabel.text = likedUser[kUserProfileKey][kUserProfileFirstNameKey];
    cell.detailTextLabel.text = chatroom[@"createdAt"];
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    PFQuery *query = [[PFQuery alloc] initWithClassName:kPhotoClassKey];
    [query whereKey:kPhotoUserKey equalTo:likedUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0) {
            
            
            PFObject *photo = objects[0];
            PFFile *imageFile = photo[kPhotoImageKey];
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                
                cell.imageView.image = [UIImage imageWithData:data];
                cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
                
            }];
        }
    }];
    
    
    
    return cell;
}

#pragma mark - TableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self performSegueWithIdentifier:@"matchesToChatSegue" sender:indexPath];
    
}



@end
