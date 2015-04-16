//
//  Constant.h
//  TwoMatcheUp3
//
//  Created by delmarz on 2/11/15.
//  Copyright (c) 2015 delmarz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrefixHeader.pch"

@interface Constant : NSObject

#pragma mark - User Class

extern NSString *const kUserTaglineKey;

extern NSString *const kUserProfileKey;
extern NSString *const kUserProfileNameKey;
extern NSString *const kUserProfileFirstNameKey;
extern NSString *const kUserProfileBirthdayKey;
extern NSString *const kUserProfileGenderKey;
extern NSString *const kUserProfileLocationKey;
extern NSString *const kUserProfileInterestedInKey;
extern NSString *const kUserProfilePictureURL;
extern NSString *const kUserProfileAgeKey;
extern NSString *const kUserProfileRelationshipStatusKey;

#pragma mark - Photo clas

extern NSString *const kPhotoClassKey;
extern NSString *const kPhotoImageKey;
extern NSString *const kPhotoUserKey;

#pragma mark - Activity Class

extern NSString *const kActivityClassKey;
extern NSString *const kActivityTypeKey;
extern NSString *const kActivityTypeLikeyKey;
extern NSString *const kActivityTypeDislikeKey;
extern NSString *const kActivityFromUserKey;
extern NSString *const kActivityToUserKey;
extern NSString *const kActivityPhotoKey;

#pragma mark - Settings

extern NSString *const kageMaxKey;
extern NSString *const kMenEnabledKey;
extern NSString *const kWomenEnabledKey;
extern NSString *const kSingleEnabledKey;


@end
