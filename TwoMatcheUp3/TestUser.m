//
//  TestUser.m
//  TwoMatcheUp3
//
//  Created by delmarz on 2/11/15.
//  Copyright (c) 2015 delmarz. All rights reserved.
//

#import "TestUser.h"

@implementation TestUser


+(void)saveTestUserToParse
{
    
    PFUser *newUser = [PFUser user];
    newUser.username = @"user1";
    newUser.password = @"password1";
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (!error) {
            
            NSDictionary *profile = @{@"name": @"Sheelyn Degracia Bague",
                                      @"first_name": @"Sheelyn",
                                      @"age": @"22",
                                      @"gender": @"female",
                                      @"location": @"Punta Princesa Cebu City",
                                      @"birthday": @"12/13/1992"
                                      
                                      };
            
            [newUser setObject:profile forKey:@"profile"];
            [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                UIImage *image = [UIImage imageNamed:@"fian2.jpg"];
                NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
                
                PFFile *imageFile = [PFFile fileWithData:imageData];
                [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    
                    if (succeeded) {
                        
                        PFObject *photo = [PFObject objectWithClassName:kPhotoClassKey];
                        [photo setObject:newUser forKey:kPhotoUserKey];
                        [photo setObject:imageFile forKey:kPhotoImageKey];
                        [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            
                            NSLog(@"successfully image save");
                        }];
                    }
                    
                }];
                
            }];
        }
        
    }];
    
    
    
    
}

@end
