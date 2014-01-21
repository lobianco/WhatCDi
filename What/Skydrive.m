//
//  Skydrive.m
//  What
//
//  Created by What on 6/6/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "Skydrive.h"
#import "AppDelegate.h"

static NSString *const kSkydriveClientID = @"xyz";
static NSString *const kSkydriveClientSecret = @"xyz";

@interface Skydrive ()

@property (nonatomic, strong) LiveConnectClient *liveClient;

@property (nonatomic, strong) NSString * folderId;
@property (nonatomic, strong) NSString * folderName;
@property (nonatomic, strong) NSString * folderUploadPath;
@property (nonatomic, strong) NSString * folderLink;
@property (nonatomic, strong) NSString * folderType;
@property (nonatomic, strong) NSString * status;

@end

@implementation Skydrive

@synthesize liveClient = liveClient_;

@synthesize folderId = folderId_;
@synthesize folderName = folderName_;
@synthesize folderUploadPath = folderUploadPath_;
@synthesize folderLink = folderLink_;
@synthesize folderType = folderType_;
@synthesize status = status_;


-(id)init
{
    if ( (self=[super init]) )
    {
        
        liveClient_ = [[LiveConnectClient alloc] initWithClientId:kSkydriveClientID delegate:self userState:@"auth"];
        if (liveClient_.session == nil)
        {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [liveClient_ login:appDelegate.window.rootViewController scopes:[NSArray arrayWithObjects:@"wl.signin wl.skydrive_update", nil] delegate:self userState:@"signin"];
        }
        
    }
    
    return self;
}

#pragma mark - Authentication


-(void)authCompleted:(LiveConnectSessionStatus)status session:(LiveConnectSession *)session userState:(id)userState
{
    NSLog(@"skydrive userstate: %@", userState);
    NSLog(@"session: %@", session);
    
    if (session != nil)
    {
        NSLog(@"session is not nil");
        
    }
    
    if ([userState isEqualToString:@"signin"])
    {
        NSLog(@"you are signed in");
    }
}

-(void)authFailed:(NSError *)error userState:(id)userState
{
    NSLog(@"%@",[NSString stringWithFormat:@"skydrive auth error: %@", [error localizedDescription]]);
}

#pragma mark - Folder Info

-(void)getFolderInfo
{
    NSString *folderId = @"Documents";
    [self.liveClient getWithPath:folderId delegate:self userState:@"get folder"];
}


#pragma mark - Upload File

-(void)uploadFile:(NSString *)filePath
{
    NSData *fileData = [[NSData alloc] initWithContentsOfFile:filePath];
    [self.liveClient uploadToPath:@"me/skydrive" fileName:@"filename.txt" data:fileData overwrite:LiveUploadRename delegate:self userState:@"upload"];
}

-(void)liveUploadOperationProgressed:(LiveOperationProgress *)progress operation:(LiveOperation *)operation
{
    
}


#pragma mark - Delegate Callbacks

-(void)liveOperationSucceeded:(LiveOperation *)operation
{
    if ([operation.userState isEqualToString:@"get folder"])
    {
        self.folderId = [operation.result objectForKey:@"id"];
        self.folderName = [operation.result objectForKey:@"name"];
        self.folderUploadPath = [operation.result objectForKey:@"upload_location"];
        self.folderLink = [operation.result objectForKey:@"link"];
        self.folderType = [operation.result objectForKey:@"type"];
    }
    
    else if ([operation.userState isEqualToString:@"upload"])
    {
        NSLog(@"%@", operation.result);
        NSString *fileId = [operation.result objectForKey:@"id"];
        NSString *fileName = [operation.result objectForKey:@"name"];
        NSString *fileDescription = [operation.result objectForKey:@"description"];
        NSString *fileSize = [operation.result objectForKey:@"size"];
        NSLog(@"id: %@ / filename: %@ / description: %@ / size: %@", fileId, fileName, fileDescription, fileSize);
    }
}

-(void)liveOperationFailed:(NSError *)error operation:(LiveOperation *)operation
{
    if ([operation.userState isEqual:@"get folder"]) {
        self.status = @"The request to read the SkyDrive folder information failed.";
    }
    
    else if ([operation.userState isEqualToString:@"upload"])
        NSLog(@"failed to upload: %@", error);
}


@end
