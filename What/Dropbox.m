//
//  Dropbox.m
//  What
//
//  Created by What on 6/5/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "Dropbox.h"
#import "AppDelegate.h"

@interface Dropbox ()

@end

@implementation Dropbox

+ (Dropbox *)sharedBox
{
    static Dropbox *sharedBox = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedBox = [[Dropbox alloc] init];
    });
    
    return sharedBox;
}

-(id)init
{
    if ( (self = [super init]) )
    {
        if ([DBAccountManager sharedManager] == nil)
        {
            NSString *appKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"DropboxAppKey"];
            NSString *secret = [[NSUserDefaults standardUserDefaults] objectForKey:@"DropboxSecret"];
            
            if (!appKey || !secret)
                return nil;
            
            DBAccountManager* accountMgr = [[DBAccountManager alloc] initWithAppKey:appKey secret:secret];
            [DBAccountManager setSharedManager:accountMgr];
        }
    }
    
    return self;
}

/*
-(BOOL)createDropboxDirectory
{
    NSString *appDocPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dropboxPath = [appDocPath stringByAppendingPathComponent:@"Dropbox"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dropboxPath])
        return [[NSFileManager defaultManager] createDirectoryAtPath:dropboxPath withIntermediateDirectories:NO attributes:nil error:nil];
    
    NSLog(@"%@", dropboxPath);
    return NO;
}
*/

-(BOOL)isLinked
{
    if (![DBAccountManager sharedManager].linkedAccount)
        return NO;
    
    return YES;
}

-(void)linkFromController:(UIViewController *)controller
{
    if (![self isLinked])
    {
        NSLog(@"linking");
        //AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [[DBAccountManager sharedManager] linkFromController:controller];
    }
    
    else
        NSLog(@"already linked");
}

-(void)unlink
{
    if ([self isLinked])
    {
        NSLog(@"unlinking");
        DBAccount *currentAccount = [[DBAccountManager sharedManager] linkedAccount];
        [currentAccount unlink];
    }
    
    else
        NSLog(@"already unlinked");
}

-(void)uploadWithFileName:(NSString *)filename fromPath:(NSString *)filepath
{
    DBAccount *account = [DBAccountManager sharedManager].linkedAccount;
    
    if (account) {
        DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:account];
        [DBFilesystem setSharedFilesystem:filesystem];
    }
    
    else
    {
        NSLog(@"needs to link");
        return;
    }
    
    DBPath *newPath = [[DBPath root] childPath:filename];
    DBFile *file = [[DBFilesystem sharedFilesystem] createFile:newPath error:nil];
    
    NSData *fileData = [[NSFileManager defaultManager] contentsAtPath:filepath];
    DBError *dbError;
    if ([file writeData:fileData error:&dbError])
    {
        NSLog(@"successfully uploaded to dropbox");
        
        //delete local file
        NSError *error;
        if ([[NSFileManager defaultManager] removeItemAtPath:filepath error:&error])
            NSLog(@"removed %@ from local", filename);
    }
    
}

/*
-(void)uploadWithCompletionBlock:(CompletionBlock)block
{
    self.cb = block;
    
    if ([self linkDropbox])
        [self.dbRestClient uploadFile:self.fileName toPath:@"/" withParentRev:nil fromPath:self.filePath];
}


-(BOOL)linkDropbox {
    if (![[DBSession sharedSession] isLinked])
    {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [[DBSession sharedSession] linkFromController:appDelegate.window.rootViewController];
        return NO;
    }
    
    else
    {
        NSLog(@"dropbox already linked");
        return YES;
    }
}

-(DBRestClient *)dbRestClient
{
    if (!dbRestClient_)
    {
        dbRestClient_ = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        dbRestClient_.delegate = self;
    }
    
    return dbRestClient_;
    
}

-(void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata
{
    if (metadata.isDirectory) {
        NSLog(@"Folder '%@' contains:", metadata.path);
        for (DBMetadata *file in metadata.contents) {
            NSLog(@"\t%@", file.filename);
        }
    }
}

-(void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error
{
    NSLog(@"metadata error: %@", error);
}

-(void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath from:(NSString *)srcPath metadata:(DBMetadata *)metadata
{
    NSLog(@"file uploaded to path: %@", metadata.path);
    self.cb();
}

-(void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error
{
    NSLog(@"file upload failed with error: %@", error);
}
 */

@end
