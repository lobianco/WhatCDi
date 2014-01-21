//
//  GoogleDrive.m
//  What
//
//  Created by What on 6/5/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "GoogleDrive.h"
#import "GTLDrive.h"
#import "AppDelegate.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

static NSString *const kGoogleAppFolderName = @"What.CD for iPhone";
static NSString *const kGoogleKeychainItemName = @"WhatCDi Google Drive Keychain";
static NSString *const kGoogleClientID = @"xyz";
static NSString *const kGoogleClientSecret = @"xyz";

#define ERROR_DOMAIN @"GoogleDriveErrorDomain"

@interface GoogleDrive ()

@property (nonatomic, retain) GTLServiceDrive *driveService;

@end

@implementation GoogleDrive

+ (GoogleDrive *)sharedDrive {
    static GoogleDrive *sharedDrive = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDrive = [[GoogleDrive alloc] init];
    });
    return sharedDrive;
}

-(id)init {
    if ( (self = [super init]) ) {
        // Initialize the drive service & load existing credentials from the keychain if available
        self.driveService = [[GTLServiceDrive alloc] init];
        self.driveService.authorizer = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kGoogleKeychainItemName
                                                                                             clientID:kGoogleClientID
                                                                                         clientSecret:kGoogleClientSecret];
    }
    return self;
}

// Helper to check if user is authorized
- (BOOL)isAuthorized {
    return [((GTMOAuth2Authentication *)self.driveService.authorizer) canAuthorize];
}

- (BOOL)unauthorize {
    BOOL didUnauthorize = [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:kGoogleKeychainItemName];
    if (didUnauthorize)
        [self.driveService setAuthorizer:nil];
    return didUnauthorize;
}

// Creates the auth controller for authorizing access to Google Drive.
- (GTMOAuth2ViewControllerTouch *)createAuthController {
    GTMOAuth2ViewControllerTouch *authController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:kGTLAuthScopeDriveFile
                                                                                              clientID:kGoogleClientID
                                                                                          clientSecret:kGoogleClientSecret
                                                                                      keychainItemName:kGoogleKeychainItemName
                                                                                              delegate:self
                                                                                      finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    
    return authController;
}

// Handle completion of the authorization process, and updates the Drive service with the new credentials.
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController finishedWithAuth:(GTMOAuth2Authentication *)authResult error:(NSError *)error {
    if (error != nil) {
        self.driveService.authorizer = nil;
    }
    else {
        self.driveService.authorizer = authResult;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GoogleDriveLinkageChanged" object:nil];
}

- (void)checkForDocumentsFolder:(void (^)(NSString *folderRef))success failure:(void (^)(NSError *error))failure {
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    GTLQueryDrive *findFolderQuery = [GTLQueryDrive queryForFilesList];
    findFolderQuery.q = [NSString stringWithFormat:@"mimeType='application/vnd.google-apps.folder' and trashed=false and title='%@'", kGoogleAppFolderName];
    [self.driveService executeQuery:findFolderQuery completionHandler:^(GTLServiceTicket *ticket, GTLDriveFileList *files, NSError *error) {
        if (files.items.count <= 0 && !error) {
            GTLDriveFile *folderObject = [GTLDriveFile object];
            folderObject.title = kGoogleAppFolderName;
            folderObject.mimeType = @"application/vnd.google-apps.folder";
            
            GTLQueryDrive *query = [GTLQueryDrive queryForFilesInsertWithObject:folderObject uploadParameters:nil];
            [self.driveService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLDriveFile *insertedFile, NSError *error) {
                if (error == nil) {
                    success(insertedFile.identifier);
                }
                else {
                    NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey : @"Failed To Create App Folder in Google Drive", NSLocalizedDescriptionKey : @"For some reason, I couldn't create an app folder in your Google Drive storage. Try re-linking your phone in the Settings panel."};
                    failure([NSError errorWithDomain:ERROR_DOMAIN code:-1 userInfo:userInfo]);
                }
            }];
        }
        else if (error) {
            NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey : @"Google Drive Experienced An Error", NSLocalizedDescriptionKey : @"And that's all the information I know. Please try again."};
            failure([NSError errorWithDomain:ERROR_DOMAIN code:-1 userInfo:userInfo]);
        }
        else {
            success([(GTLDriveChildReference *)files[0] identifier]);
        }
    }];
}

-(void)uploadFile:(NSString *)file fromPath:(NSString *)path success:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    [self checkForDocumentsFolder:^(NSString *folderRef){
        GTLDriveParentReference *parent = [GTLDriveParentReference object];
        parent.identifier = folderRef;
        
        GTLDriveFile *fileObject = [GTLDriveFile object];
        fileObject.parents = @[parent];
        fileObject.title = file;
        fileObject.originalFilename = file;
        
        fileObject.descriptionProperty = @"Uploaded from WhatCDi";
        fileObject.mimeType = @"application/x-bittorrent";
        
        GTLUploadParameters *uploadParameters = [GTLUploadParameters uploadParametersWithData:[NSData dataWithContentsOfFile:path] MIMEType:fileObject.mimeType];
        GTLQueryDrive *query = [GTLQueryDrive queryForFilesInsertWithObject:fileObject uploadParameters:uploadParameters];
        
        [self.driveService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLDriveFile *insertedFile, NSError *error) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            //remove local file
            if ([[NSFileManager defaultManager] removeItemAtPath:path error:nil])
                NSLog(@"removed %@ from local", file);
            if (error == nil) {
                success();
            }
            else {
                NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey : @"Failed To Upload File To Google Drive", NSLocalizedDescriptionKey : @"I wasn't able to upload this file to Google Drive. Why don't you try again?"};
                failure([NSError errorWithDomain:ERROR_DOMAIN code:-1 userInfo:userInfo]);
            }
        }];
    } failure:^(NSError *error) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        //remove local file
        if ([[NSFileManager defaultManager] removeItemAtPath:path error:nil])
            NSLog(@"removed %@ from local", file);
        failure(error);
    }];
}

@end
