//
//  Constant.m
//  TwoMatcheUp3
//
//  Created by delmarz on 2/11/15.
//  Copyright (c) 2015 delmarz. All rights reserved.
//

#import "Constant.h"

@implementation Constant


#pragma mark - User Class

NSString *const kUserTaglineKey                         = @"tagline";

NSString *const kUserProfileKey                         = @"profile";
NSString *const kUserProfileNameKey                     = @"name";
NSString *const kUserProfileFirstNameKey                = @"first_name";
NSString *const kUserProfileBirthdayKey                 = @"birthday";
NSString *const kUserProfileGenderKey                   = @"gender";
NSString *const kUserProfileLocationKey                 = @"location";
NSString *const kUserProfileInterestedInKey             = @"interested_in";
NSString *const kUserProfilePictureURL                  = @"pictureURL";
NSString *const kUserProfileAgeKey                      = @"age";
NSString *const kUserProfileRelationshipStatusKey       = @"relationship_status";

#pragma mark - Photo clas

NSString *const kPhotoClassKey                          = @"Photo";
NSString *const kPhotoImageKey                          = @"image";
NSString *const kPhotoUserKey                           = @"user";

#pragma mark - Activity Class

NSString *const kActivityClassKey                       = @"Activity";
NSString *const kActivityTypeKey                        = @"type";
NSString *const kActivityTypeLikeyKey                   = @"like";
NSString *const kActivityTypeDislikeKey                 = @"dislike";
NSString *const kActivityFromUserKey                    = @"fromUser";
NSString *const kActivityToUserKey                      = @"toUser";
NSString *const kActivityPhotoKey                       = @"photo";

#pragma mark - Settings

#pragma mark - Settings

NSString *const kageMaxKey                              = @"ageMax";
NSString *const kMenEnabledKey                          = @"men";
NSString *const kWomenEnabledKey                        = @"women";
NSString *const kSingleEnabledKey                       = @"single";

@end
