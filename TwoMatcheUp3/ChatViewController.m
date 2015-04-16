//
//  ChatViewController.m
//  TwoMatcheUp3
//
//  Created by delmarz on 2/15/15.
//  Copyright (c) 2015 delmarz. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()

@property (strong, nonatomic) PFUser *likedUser;
@property (strong, nonatomic) PFUser *currentUser;

@property (strong, nonatomic) NSTimer *chatsTimer;

@property (nonatomic) BOOL initialLoadComplete;

@property (strong, nonatomic) NSMutableArray *chats;

@end

@implementation ChatViewController


-(NSMutableArray *)chats
{
    if (!_chats) {
        _chats = [[NSMutableArray alloc] init];
    }
    return _chats;
    
}

- (void)viewDidLoad {
    
    self.delegate = self;
    self.dataSource = self;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
  
    
    [[JSBubbleView appearance] setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0]];
    self.messageInputView.textView.placeHolder = @"New Message";
    [self setBackgroundColor:[UIColor whiteColor]];
     
    self.currentUser = [PFUser currentUser];
    PFUser *testFromUser = self.chatroom[@"user1"];
    
    if ([testFromUser.objectId isEqualToString:self.currentUser.objectId]) {
        self.likedUser = self.chatroom[@"user2"];
        
    }
    else if ([testFromUser.objectId isEqualToString:self.currentUser.objectId]) {
        self.likedUser = self.chatroom[@"user1"];
    }
    
    self.title = self.likedUser[kUserProfileKey][kUserProfileFirstNameKey];
    self.initialLoadComplete = false;
    
    [self checkForNewChats];
    
    self.chatsTimer = [NSTimer timerWithTimeInterval:15 target:self selector:@selector(checkForNewChats) userInfo:nil repeats:true];
    
    
}


-(void)viewDidDisappear:(BOOL)animated
{
    [self.chatsTimer invalidate];
    self.chatsTimer = nil;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - TableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.chats count];
    
}


#pragma mark - TableView Delegate REQUIRED

-(void)didSendText:(NSString *)text
{
    
    if (text.length != 0) {
        
        PFObject *chat = [PFObject objectWithClassName:@"Chat"];
        [chat setObject:self.chatroom forKey:@"chatroom"];
        [chat setObject:self.currentUser forKey:@"fromUser"];
        [chat setObject:self.likedUser forKey:@"toUser"];
        [chat setObject:text forKey:@"text"];
        [chat saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            [self.chats addObject:chat];
            [JSMessageSoundEffect playMessageSentAlert];
            [self.tableView reloadData];
            [self finishSend];
            [self scrollToBottomAnimated:true];
        }];
    }
    
}


-(JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PFObject *chat = self.chats[indexPath.row];
    PFUser *testFromUser = chat[@"fromUser"];
    
    if ([testFromUser.objectId isEqualToString:self.currentUser.objectId]) {
        
        return JSBubbleMessageTypeOutgoing;
    }
    else
    {
        return JSBubbleMessageTypeIncoming;
    }
}

-(UIImageView *)bubbleImageViewWithType:(JSBubbleMessageType)type forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PFObject *chat = self.chats[indexPath.row];
    PFUser *testFromUser = chat[@"fromUser"];
    
    if ([testFromUser.objectId isEqualToString:self.currentUser.objectId]) {
        
        return [JSBubbleImageViewFactory bubbleImageViewForType:type color:[UIColor js_bubbleGreenColor]];
    }
    else {
        return [JSBubbleImageViewFactory bubbleImageViewForType:type color:[UIColor js_bubbleLightGrayColor]];
    }
    
    
}


-(JSMessagesViewTimestampPolicy)timestampPolicy
{
    return JSMessagesViewTimestampPolicyAll;
}

-(JSMessagesViewAvatarPolicy)avatarPolicy
{
    
    return JSMessagesViewAvatarPolicyNone;
}

-(JSMessagesViewSubtitlePolicy)subtitlePolicy
{
    
    return JSMessagesViewSubtitlePolicyNone;
}

-(JSMessageInputViewStyle)inputViewStyle
{
    return JSMessageInputViewStyleFlat;
    
}


#pragma mark - Message View Delegate OPTIONAL

-(void)configureCell:(JSBubbleMessageCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if ([cell messageType] == JSBubbleMessageTypeOutgoing) {
        
        cell.bubbleView.textView.textColor = [UIColor whiteColor];
    }
    
    
}

-(BOOL)shouldPreventScrollToBottomWhileUserScrolling
{
    return true;
}


#pragma mark - Message View DataSource REQUIRED

-(NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *chat = self.chats[indexPath.row];
    NSString *message = chat[@"text"];
    return message;
    
    
}


-(NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(UIImageView *)avatarImageViewForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(NSString *)subtitleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


#pragma mark - Helper Methods

-(void)checkForNewChats
{
    
    int oldChatCount = (int)[self.chats count];
    
    PFQuery *queryForChats = [PFQuery queryWithClassName:@"Chat"];
    [queryForChats whereKey:@"chatroom" equalTo:self.chatroom];
    [queryForChats orderByAscending:@"createdAt"];
    [queryForChats findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            if (self.initialLoadComplete == false || oldChatCount != [objects count]) {
                
                self.chats = [objects mutableCopy];
                [self.tableView reloadData];
                
                if (self.initialLoadComplete == true) {
                    [JSMessageSoundEffect playMessageReceivedSound];
                }
                
                self.initialLoadComplete = true;
                [self scrollToBottomAnimated:true];
            }
            
        }
    }];
    
}




@end
