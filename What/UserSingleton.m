//
//  UserSingleton.m
//  What
//
//  Created by What on 6/4/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "UserSingleton.h"
#import "AppDelegate.h"

#define kLoggedInKey        @"loggedInKey"

//user info
#define kUsernameKey        @"usernameKey"
#define kUserIdKey          @"userIdKey"
#define kAuthkeyKey         @"authkeyKey"
#define kUploadedKey        @"uploadedKey"
#define kDownloadedKey      @"downloadedKey"
#define kRatioKey           @"ratioKey"
#define kMemberClassKey     @"memberClassKey"
#define kJoinDateKey        @"joinDateKey"
#define kLastActiveKey      @"lastActiveKey"
#define kAvatarStringKey    @"avatarStringKey"
#define kNewMessagesKey     @"newMessagesKey"
//#define kIsFriendKey        @"isFriendKey"

//settings
#define kUseSSLSettingKey   @"useSSLsettingKey"
#define kSaveCredentialsKey @"saveCredentialsKey"
#define kUsernameCredential @"usernameCredential"
#define kPasswordCredential @"passwordCredential"

#define kUseSignatureKey    @"useSignatureKey"
#define kSignatureKey       @"signatureKey"

#define kShowRecentSearches @"showRecentSearches"
#define kRecentSearches     @"recentSearches"

#define kForumOpenTo        @"forumOpenTo"

#define kDownloadsEnabled   @"downloadsEnabledKey"

@interface UserSingleton () {
    @private
    NSUserDefaults *prefs;
    AppDelegate *appDelegate;
}

@end

@implementation UserSingleton

+ (UserSingleton *)sharedInstance
{
    static UserSingleton *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[UserSingleton alloc] init];
    });
    
    return sharedInstance;
}

-(id)init
{
    if ( (self=[super init]) ) {
        [self resetData];
        
        prefs = [NSUserDefaults standardUserDefaults];
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

-(BOOL)createTemporaryDirectories
{
    NSString *appDocPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *tempPath = [appDocPath stringByAppendingPathComponent:@"tmp"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:tempPath])
        return [[NSFileManager defaultManager] createDirectoryAtPath:tempPath withIntermediateDirectories:NO attributes:nil error:nil];
    
    NSLog(@"%@", tempPath);
    return NO;
}

-(void)saveData
{    
    [prefs setBool:self.loggedIn forKey:kLoggedInKey];
    
    //user info
    [prefs setObject:self.username forKey:kUsernameKey];
    [prefs setInteger:self.userId forKey:kUserIdKey];
    [prefs setObject:self.authkey forKey:kAuthkeyKey];
    [prefs setDouble:self.uploaded forKey:kUploadedKey];
    [prefs setDouble:self.downloaded forKey:kDownloadedKey];
    [prefs setDouble:self.ratio forKey:kRatioKey];
    [prefs setObject:self.memberClass forKey:kMemberClassKey];
    [prefs setObject:self.joinDate forKey:kJoinDateKey];
    [prefs setObject:self.lastActiveDate forKey:kLastActiveKey];
    [prefs setObject:self.avatarString forKey:kAvatarStringKey];
    [prefs setInteger:self.newMessages forKey:kNewMessagesKey];
    
    [self saveSettings];
    
    [prefs synchronize];
    NSLog(@"data saved");
}

-(void)saveSettings
{    
    //settings
    [prefs setBool:self.useSSL forKey:kUseSSLSettingKey];
    [prefs setBool:self.saveCredentials forKey:kSaveCredentialsKey];
    [prefs setObject:self.usernameCredential forKey:kUsernameCredential];
    [prefs setObject:self.passwordCredential forKey:kPasswordCredential];
    
    [prefs setBool:self.useSignature forKey:kUseSignatureKey];
    [prefs setObject:self.signature forKey:kSignatureKey];
    
    [prefs setBool:self.showRecentSearches forKey:kShowRecentSearches];
    [prefs setObject:self.recentSearches forKey:kRecentSearches];
    
    [prefs setInteger:self.forumOpenTo forKey:kForumOpenTo];
    
    [prefs setBool:self.downloadsEnabled forKey:kDownloadsEnabled];
}

-(void)loadData
{    
    _loggedIn = [prefs boolForKey:kLoggedInKey];
    
    //user info
    _username = [prefs objectForKey:kUsernameKey];
    _userId = [prefs integerForKey:kUserIdKey];
    _authkey = [prefs objectForKey:kAuthkeyKey];
    _uploaded = [prefs doubleForKey:kUploadedKey];
    _downloaded = [prefs doubleForKey:kDownloadedKey];
    _ratio = [prefs doubleForKey:kRatioKey];
    _memberClass = [prefs objectForKey:kMemberClassKey];
    _joinDate = [prefs objectForKey:kJoinDateKey];
    _lastActiveDate = [prefs objectForKey:kLastActiveKey];
    _avatarString = [prefs objectForKey:kAvatarStringKey];
    _newMessages = [prefs integerForKey:kNewMessagesKey];
    
    [self loadSettings];
    
    NSLog(@"data loaded");
}

-(void)loadSettings
{    
    //settings
    if ([prefs objectForKey:kUseSSLSettingKey])
        _useSSL = [prefs boolForKey:kUseSSLSettingKey];
    if ([prefs objectForKey:kSaveCredentialsKey])
        _saveCredentials = [prefs boolForKey:kSaveCredentialsKey];
    if ([prefs objectForKey:kUsernameCredential])
        _usernameCredential = [prefs objectForKey:kUsernameCredential];
    if ([prefs objectForKey:kPasswordCredential])
        _passwordCredential = [prefs objectForKey:kPasswordCredential];
    
    if ([prefs objectForKey:kUseSignatureKey])
        _useSignature = [prefs boolForKey:kUseSignatureKey];
    if ([prefs objectForKey:kSignatureKey])
        _signature = [prefs objectForKey:kSignatureKey];
    
    if ([prefs objectForKey:kShowRecentSearches])
        _showRecentSearches = [prefs boolForKey:kShowRecentSearches];
    if ([prefs objectForKey:kRecentSearches])
        _recentSearches = [prefs objectForKey:kRecentSearches];
    
    if ([prefs objectForKey:kForumOpenTo])
        _forumOpenTo = [prefs integerForKey:kForumOpenTo];
    
    if ([prefs objectForKey:kDownloadsEnabled])
        _downloadsEnabled = [prefs boolForKey:kDownloadsEnabled];
}

-(void)clearData
{    
    [prefs removeObjectForKey:kLoggedInKey];
    
    [prefs removeObjectForKey:kUsernameKey];
    [prefs removeObjectForKey:kUserIdKey];
    [prefs removeObjectForKey:kAuthkeyKey];
    [prefs removeObjectForKey:kUploadedKey];
    [prefs removeObjectForKey:kDownloadedKey];
    [prefs removeObjectForKey:kRatioKey];
    [prefs removeObjectForKey:kMemberClassKey];
    [prefs removeObjectForKey:kJoinDateKey];
    [prefs removeObjectForKey:kLastActiveKey];
    [prefs removeObjectForKey:kAvatarStringKey];
    [prefs removeObjectForKey:kNewMessagesKey];
    
    //settings
    //[prefs removeObjectForKey:kUseSSLSettingKey];
    [prefs removeObjectForKey:kSaveCredentialsKey];
    [prefs removeObjectForKey:kUsernameCredential];
    [prefs removeObjectForKey:kPasswordCredential];
    [prefs removeObjectForKey:kUseSignatureKey];
    [prefs removeObjectForKey:kSignatureKey];
    [prefs removeObjectForKey:kShowRecentSearches];
    [prefs removeObjectForKey:kRecentSearches];
    [prefs removeObjectForKey:kForumOpenTo];
    [prefs removeObjectForKey:kDownloadsEnabled];
    
    [self resetData];
        
    NSLog(@"data cleared");
}

-(void)resetData
{
    if ([self createTemporaryDirectories])
        NSLog(@"temprary directory created");
    
    _loggedIn = NO;
    
    //user info
    _username = [NSString new];
    _userId = 0;
    _authkey = [NSString new];
    _uploaded = 0;
    _downloaded = 0;
    _ratio = 0;
    _memberClass = [NSString new];
    _joinDate = [NSString new];
    _lastActiveDate = [NSString new];
    _avatarString = [NSString new];
    _newMessages = 0;
    
    //settings
    _useSSL = NO;
    _saveCredentials = YES;
    _usernameCredential = [NSString new];
    _passwordCredential = [NSString new];
    
    _useSignature = NO;
    _signature = [NSString new];
    
    _showRecentSearches = NO;
    _recentSearches = [NSArray new];
    
    _forumOpenTo = ForumOpenToLastPage;
    _forumOpenToOptions = [NSArray arrayWithObjects:@"First Page", @"Last Page", nil];
    
    _downloadsEnabled = YES;
}

- (void)setNewMessages:(NSInteger)newMessages {
    if (_newMessages != newMessages) {
        NSLog(@"set");
        _newMessages = newMessages;
    }
    [appDelegate updateInboxCount:newMessages];
}

-(NSString *)signature
{
    if ([_signature length] > 0)
        return _signature;
    
    return @"Sent from my iPhone using WhatCDi";
}

@end
