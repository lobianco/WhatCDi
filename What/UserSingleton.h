//
//  UserSingleton.h
//  What
//
//  Created by What on 6/4/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    ForumOpenToFirstPage,
    ForumOpenToLastPage,
    
} ForumOpenTo;

@interface UserSingleton : NSObject

+ (UserSingleton *)sharedInstance;

@property (nonatomic, readwrite) BOOL loggedIn;

//user info
@property (nonatomic, strong) NSString *username;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString *authkey;
@property (nonatomic, readwrite) double uploaded;
@property (nonatomic, readwrite) double downloaded;
@property (nonatomic, readwrite) double ratio;
@property (nonatomic, strong) NSString *memberClass;
@property (nonatomic, strong) NSString *joinDate;
@property (nonatomic, strong) NSString *lastActiveDate;
@property (nonatomic, strong) NSString *avatarString;
@property (nonatomic) NSInteger newMessages;

//settings
@property (nonatomic, readwrite) BOOL useSSL;
@property (nonatomic, readwrite) BOOL saveCredentials;
@property (nonatomic, strong) NSString *usernameCredential;
@property (nonatomic, strong) NSString *passwordCredential;

@property (nonatomic, readwrite) BOOL useSignature;
@property (nonatomic, strong) NSString *signature;

@property (nonatomic, readwrite) BOOL showRecentSearches;
@property (nonatomic, strong) NSArray *recentSearches;

@property (nonatomic, readwrite) ForumOpenTo forumOpenTo;
@property (nonatomic, strong, readonly) NSArray *forumOpenToOptions;

@property (nonatomic, readwrite) BOOL downloadsEnabled;

//methods
-(void)saveData;
-(void)loadData;
-(void)clearData;

@end
