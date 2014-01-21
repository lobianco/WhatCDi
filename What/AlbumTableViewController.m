//
//  AlbumController.m
//  What
//
//  Created by What on 5/28/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "AlbumTableViewController.h"
#import "MarqueeLabel.h"
#import "API.h"
#import "AlbumTorrentTableViewCell.h"
#import "AlbumSectionHeaderView.h"
#import "HTTPRequestSingleton.h"
#import "AppDelegate.h"
#import "NSTask.h"
#import "GoogleDrive.h"
#import "Dropbox.h"
#import "AlbumTableHeaderView.h"
#import "Skydrive.h"
#import "UserSingleton.h"
#import "ImagePopupController.h"
#import "LoadingView.h"
#import "NSString+HTML.h"
#import "NSString+Tools.h"
#import "UIImage+ImageEffects.h"
#import "WCDAlbum.h"
#import "WCDTorrent.h"
#import "WCDReleaseGroup.h"
#import "CategorySectionHeaderView.h"
#import "UIBarButtonItem+Tools.h"
#import "AlbumTorrentStatsTableViewCell.h"
#import "NSDate+Tools.h"
#import "UIButton+Tools.h"
#import "GoogleDrive.h"

//#define AntiARCRetain(...) void *retainedThing = (__bridge_retained void *)__VA_ARGS__; retainedThing = retainedThing;
//#define AntiARCRelease(...) void *retainedThing = (__bridge void *)__VA_ARGS__; id unretainedThing = (__bridge_transfer id)retainedThing; unretainedThing = nil

@interface AlbumTableViewController ()

@property (nonatomic, weak) WCDAlbum *album; //TODO weak?
@property (nonatomic, strong) AlbumTableHeaderView *header;

//@property (nonatomic, readwrite) BOOL animationExpanded;
@property (nonatomic, strong) NSIndexPath *lastOpenedIndex;
@property (nonatomic, strong) NSMutableArray *indexPathArray;

//cloud services
//need to keep as property so delegate callback methods get called
//@property (nonatomic, strong) Skydrive *skydrive;

@property (nonatomic, strong) NSIndexPath *tappedIndexPath;
@property (nonatomic, strong) NSIndexPath *controlIndexPath;

@property (nonatomic, getter = isLoading) BOOL loading;

@end

@implementation AlbumTableViewController


//@synthesize animationExpanded = animationExpanded_;
@synthesize indexPathArray = indexPathArray_;

//@synthesize skydrive = skydrive_;

- (id)initWithAlbum:(WCDAlbum *)album {
    self = [super init];
    if (self) {
        _album = album;
        self.title = NSLocalizedString(album.name, album.name);
    }
    return self;
}

- (void)dealloc {
    NSLog(@"album table dealloc");
    //_album = nil;
}

- (void)viewDidLoad {
    self.loading = YES;
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable:) name:@"DownloadsEnabledNotification" object:nil];
    
    //tableheaderview must be set first, so that self.header is added on top of it and its gesture gets recognized
    //self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ALBUM_WIDTH + CELL_PADDING*2)];
    self.header = [[AlbumTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ALBUM_WIDTH + CELL_PADDING*2)];
    //[self.tableView addSubview:self.header];
    self.tableView.tableHeaderView = self.header;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(albumImageTapped:)];
    tapGesture.delegate = self.header;
    tapGesture.numberOfTouchesRequired = 1;
    [self.header addGestureRecognizer:tapGesture];
    
    self.lastOpenedIndex = nil;
}

-(void)reloadTable:(NSNotification *)note {
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //when closing popup image, restart marquee label
    [MarqueeLabel controllerViewAppearing:self];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.isLoading ? 0 : [[self.album.torrentsDictionary allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *releaseString = [[self.album.torrentsDictionary allKeys] objectAtIndex:section];
    WCDReleaseGroup *releaseGroup = [self.album.torrentsDictionary objectForKey:releaseString];
    
    if (self.controlIndexPath && (self.controlIndexPath.section == section))
        return [releaseGroup.objects count] + 1;
    
    return [releaseGroup.objects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if (self.controlIndexPath && ([indexPath compare:self.controlIndexPath] == NSOrderedSame))
    {
        NSString *releaseString = [[self.album.torrentsDictionary allKeys] objectAtIndex:indexPath.section];
        WCDReleaseGroup *releaseGroup = [self.album.torrentsDictionary objectForKey:releaseString];
        id torrent = [releaseGroup.objects objectAtIndex:(indexPath.row - 1)];
        
        static NSString *StatsIdentifier = @"StatsIdentifier";
        
        AlbumTorrentStatsTableViewCell *cell = (AlbumTorrentStatsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:StatsIdentifier];
        
        if (cell == nil)
        {
            cell = [[AlbumTorrentStatsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StatsIdentifier];
        }
        
        cell.torrent = torrent;
        
        return cell;
    }
    
    else 
    {
     
        NSString *releaseString = [[self.album.torrentsDictionary allKeys] objectAtIndex:indexPath.section];
        WCDReleaseGroup *releaseGroup = [self.album.torrentsDictionary objectForKey:releaseString];
        indexPath = [self adjustedIndexPathForIndexPath:indexPath];
        id torrent = [releaseGroup.objects objectAtIndex:indexPath.row];
        
        if ([torrent isKindOfClass:[WCDTorrent class]])
        {
        
            static NSString *TorrentIdentifier = @"TorrentIdentifier";
            
            AlbumTorrentTableViewCell *cell = (AlbumTorrentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:TorrentIdentifier];
            
            if (cell == nil)
            {
                cell = [[AlbumTorrentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TorrentIdentifier];
            }
            
            cell.torrent = torrent;
            [cell.downloadButton addTarget:self action:@selector(downloadTorrent:) forControlEvents:UIControlEventTouchUpInside];
            [cell.downloadButton expandHitTestEdgeInsets];
            
            if (![cell.contentView.subviews containsObject:cell.downloadButton] && [[UserSingleton sharedInstance] downloadsEnabled])
            {
                NSLog(@"add download button");
                [cell.contentView addSubview:cell.downloadButton];
            }
            
            else if ([cell.contentView.subviews containsObject:cell.downloadButton] && ![[UserSingleton sharedInstance] downloadsEnabled])
            {
                NSLog(@"remove download button");
                [cell.downloadButton removeFromSuperview];
            }
        
            return cell;
        }
    }
    
    return nil;
        
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath compare:self.controlIndexPath] == NSOrderedSame)
        return [AlbumTorrentStatsTableViewCell heightForRow];
    
    return [AlbumTorrentTableViewCell heightForRowWithLabel:@"Dummy text - doesn't matter" andSubtitle:@"more text - doesnt' matter"];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *releaseString = [[self.album.torrentsDictionary allKeys] objectAtIndex:section];
    WCDReleaseGroup *releaseGroup = [self.album.torrentsDictionary objectForKey:releaseString];
    if (releaseGroup.name == nil) {
        return nil;
    }
    
    CategorySectionHeaderView *headerView = [[CategorySectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kSectionHeaderHeight)];
    headerView.title.text = releaseGroup.name;
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kSectionHeaderHeight;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath compare:self.controlIndexPath] == NSOrderedSame) {
        [self.tableView selectRowAtIndexPath:self.tappedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        return;
    }
    
    if ([indexPath compare:self.tappedIndexPath] == NSOrderedSame)
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    indexPath = [self adjustedIndexPathForIndexPath:indexPath];
    NSIndexPath *indexPathToDelete = self.controlIndexPath;
    
    if ([indexPath compare:self.tappedIndexPath] == NSOrderedSame) {
        self.tappedIndexPath = nil;
        self.controlIndexPath = nil;
    } else {
        self.tappedIndexPath = indexPath;
        self.controlIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:indexPath.section];
    }
    
    UITableViewRowAnimation insertAnimation = (self.controlIndexPath.row == [self tableView:tableView numberOfRowsInSection:self.controlIndexPath.section] - 1) ? UITableViewRowAnimationTop : UITableViewRowAnimationNone;
    
    UITableViewRowAnimation deleteAnimation;
    if (self.controlIndexPath) {
        deleteAnimation = ((indexPathToDelete.row == [self tableView:tableView numberOfRowsInSection:indexPathToDelete.section] - 1) ? UITableViewRowAnimationTop : UITableViewRowAnimationNone);
    } else {
        deleteAnimation = (indexPathToDelete.row == [self tableView:tableView numberOfRowsInSection:indexPathToDelete.section] ? UITableViewRowAnimationTop : UITableViewRowAnimationNone);
    }
    
    [self.tableView beginUpdates];
    
    if (indexPathToDelete) {
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPathToDelete] withRowAnimation:deleteAnimation];
    }
    
    if (self.controlIndexPath) {
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:self.controlIndexPath] withRowAnimation:insertAnimation];
    }
    
    [self.tableView endUpdates];
        
}

-(NSIndexPath *)adjustedIndexPathForIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *controlPath = self.controlIndexPath;
    if(self.controlIndexPath != nil && indexPath.row > controlPath.row && indexPath.section == controlPath.section)
        return [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
    return indexPath;
}

/*
-(void)updateNavigationBarImage
{
    //CGRect visibleRect = [self.tableView bounds];
    
    //UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    //CGRect rect = CGRectMake(0, 0, keyWindow.bounds.size.width, self.navigationController.navigationBar.frame.size.height);
    UIGraphicsBeginImageContext(CGSizeMake(self.tableView.bounds.size.width, 44));
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *image = [UIGraphicsGetImageFromCurrentImageContext() applyLightEffect];
    UIGraphicsEndImageContext();
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}
 */
 
#pragma mark - Custom Methods

-(void)refresh
{
    //save this for reloading sections
    int oldKeys = self.album.torrentsDictionary.allKeys.count;
    
    NSURLRequest *request = [[API sharedInterface] getTorrentInfo:[NSString stringWithFormat:@"%i", self.album.idNum]];
    [API getRequest:request completionBlockWithJSON:^(id JSON) {
    
        NSDictionary *response = [JSON objectForKey:wRESPONSE];
        NSDictionary *group = [response objectForKey:@"group"];
        
        //album info here
        self.album.name = [[group objectForKey:@"name"] stringByDecodingHTMLEntities];
        self.album.year = [[group objectForKey:@"year"] integerValue];
        self.album.idNum = [[group objectForKey:@"id"] integerValue];
        self.album.releaseType = [[group objectForKey:@"releaseType"] integerValue];
        self.album.imageURL = [NSURL URLWithString:[group objectForKey:@"wikiImage"]];
        self.album.recordLabel = [[group objectForKey:@"recordLabel"] stringByDecodingHTMLEntities];
        self.album.catalogueNumber = [[group objectForKey:@"catalogueNumber"] stringByDecodingHTMLEntities];
        self.album.artist = [[[[group objectForKey:@"musicInfo"] objectForKey:@"artists"] objectAtIndex:0] objectForKey:@"name"]; //TODO: this is convoluted
        //self.album.tags = [group objectForKey:@"]
        
        NSMutableDictionary *dataSource = [NSMutableDictionary new];
        for (NSDictionary *tor in [[JSON objectForKey:@"response"] objectForKey:@"torrents"])
        {
            WCDTorrent *torrent = [[WCDTorrent alloc] init];
            torrent.parentAlbum = self.album;
            torrent.mediaType = [tor objectForKey:@"media"];
            torrent.idNum = [[tor objectForKey:@"id"] integerValue];
            torrent.format = [tor objectForKey:@"format"];
            torrent.encoding = [tor objectForKey:@"encoding"];
            torrent.scene = [[tor objectForKey:@"scene"] boolValue];
            torrent.hasLog = [[tor objectForKey:@"hasLog"] boolValue];
            torrent.logScore = [[tor objectForKey:@"logScore"] integerValue];
            torrent.hasCue = [[tor objectForKey:@"hasCue"] boolValue];
            torrent.hasLog = [[tor objectForKey:@"hasLog"] boolValue];
            torrent.fileCount = [[tor objectForKey:@"fileCount"] boolValue];
            torrent.size = [[tor objectForKey:@"size"] integerValue];
            torrent.seeders = [[tor objectForKey:@"seeders"] integerValue];
            torrent.leechers = [[tor objectForKey:@"leechers"] integerValue];
            torrent.snatches = [[tor objectForKey:@"snatched"] integerValue];
            torrent.freeTorrent = [[tor objectForKey:@"freeTorrent"] boolValue];
            torrent.remastered = [[tor objectForKey:@"remastered"] boolValue];
            torrent.remasterYear = [[tor objectForKey:@"remasterYear"] integerValue];
            torrent.remasterTitle = [[tor objectForKey:@"remasterTitle"] stringByDecodingHTMLEntities];
            torrent.remasterRecordLabel = [[tor objectForKey:@"remasterRecordLabel"] stringByDecodingHTMLEntities];
            torrent.remasterCatalogueNumber = [[tor objectForKey:@"remasterCatalogueNumber"] stringByDecodingHTMLEntities];
            torrent.username = [tor objectForKey:@"username"];
            torrent.time = [tor objectForKey:@"time"];
                        
            /*
            //break apart strings
            NSArray *separatedFiles = [[tor objectForKey:@"fileList"] componentsSeparatedByString:@"|||"];
            
            //reverse alphabetical sort (because when cells are added to table they will be added from bottom up)
            NSSortDescriptor *reverseSort = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
            NSArray *reverseSortedFiles = [separatedFiles sortedArrayUsingDescriptors:[NSArray arrayWithObject:reverseSort]];
            
            //strip empty strings
            NSArray *strippedEmptyStrings = [reverseSortedFiles filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
            
            //NSLog(@"array: %@", separatedFiles);
            for (NSString *string in strippedEmptyStrings)
            {
                NSString *stringWithoutSize = [string substringToIndex:[string rangeOfString:@"{{{"].location];
                
                ALFile *file = [[ALFile alloc] init];
                file.name = [stringWithoutSize stringByDecodingHTMLEntities];
                file.size = [[string stringBetweenString:@"{{{" andString:@"}}}"] integerValue];
                
                [torrent.files addObject:file];
            }
             */
                    
            NSMutableString *releaseString;
            if (torrent.remastered) {
                
                releaseString = [NSMutableString stringWithFormat:@"%i - ", torrent.remasterYear];
                if (torrent.remasterRecordLabel.length > 0)
                    [releaseString appendFormat:@"%@", torrent.remasterRecordLabel];
                if (torrent.remasterCatalogueNumber.length > 0)
                    [releaseString appendFormat:@" / %@", torrent.remasterCatalogueNumber];
                if (torrent.remasterTitle.length > 0)
                    [releaseString appendFormat:@" / %@", torrent.remasterTitle];
                [releaseString appendFormat:@" / %@", torrent.mediaType];
            }
            
            else {
                
                releaseString = [NSMutableString stringWithString:@"Original Release"];
                if (self.album.recordLabel.length > 0)
                    [releaseString appendFormat:@" / %@", self.album.recordLabel];
                if (self.album.catalogueNumber.length > 0)
                    [releaseString appendFormat:@" / %@", self.album.catalogueNumber];
                [releaseString appendFormat:@" / %@", torrent.mediaType];
            }
                        
            WCDReleaseGroup *releaseGroup = [dataSource objectForKey:releaseString];
            if (!releaseGroup)
            {
                releaseGroup = [[WCDReleaseGroup alloc] init];
                releaseGroup.name = releaseString;
            }
            
            [releaseGroup.objects addObject:torrent];
            [dataSource setObject:releaseGroup forKey:releaseString];
        }
        
        self.album.torrentsDictionary = dataSource;
        
        //close any open cells
        self.controlIndexPath = nil;
        
        //TODO figure out how to reload page when popping then re-pushing without using this BOOL. reason the page doesn't reload is because self.album is still in memory because it is retained by the previous view controller on teh stack (likely either the search results page or the latest torrents page)
        //BOOL wasLoading = self.isLoading;
        
        [self.tableView beginUpdates];
        if (self.isLoading) {
            self.loading = NO;
        } else {
            if (oldKeys > 0) {
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, oldKeys)] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
        [self.tableView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self.album.torrentsDictionary.allKeys count])] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
        //udpate header info
        self.header.album = self.album;
        
        //reset marqueelabel
        [MarqueeLabel controllerViewAppearing:self];
        
        //update controller title and artist name just in case we're loading this from a link in a forum thread
        self.title = NSLocalizedString(self.album.name, self.album.name);
        
        if (self.pullToRefreshView.state == SSPullToRefreshViewStateLoading)
            [self.pullToRefreshView finishLoading];
        if ([self loaderIsShowing]) {
            [self hideLoadingView];
        }
        
    } failureBlockWithError:^(NSError *error) {
        
        [self hideLoadingView];
        [self.pullToRefreshView finishLoading];
        NSLog(@"couldn't load album: %@", error);
        
    }];
}

- (void)albumImageTapped:(UITapGestureRecognizer *)gestureRecognizer {
    
    ImagePopupController *popup = [[ImagePopupController alloc] initWithImage:self.header.fullSizedAlbumImage];
    
    CATransition *transition = (CATransition *)[Constants imagePopoverAnimation];
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    [self presentViewController:popup animated:NO completion:nil];

}

/*
-(void)scrollAlbumHeader:(CGPoint)point
{
    CGFloat offset;
    if (self.tableView.pullToRefreshView.state == SVPullToRefreshStateLoading)
        offset = MAX((point.y + self.tableView.contentInset.top) * -1, (self.tableView.pullToRefreshView.frame.size.height - 100.f));
    else
        offset = MAX((point.y + self.tableView.contentInset.top) * -1, 0);
    
    self.header.transform = CGAffineTransformMakeTranslation(0, offset);
    
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(offset + MAX(ALBUM_WIDTH + CELL_PADDING*2, 0), 0, 0, 0);
    
}
 */

#pragma mark - Download/Upload Files

-(void)downloadTorrent:(id)sender {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([[GoogleDrive sharedDrive] isAuthorized]) {
        WCDTorrent *torrent = [(AlbumTorrentDownloadButton *)sender torrent];
        
        NSURLRequest *request = [[HTTPRequestSingleton sharedClient] requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/torrents.php?action=download&id=%i&authkey=%@", torrent.idNum, [UserSingleton sharedInstance].authkey] parameters:nil];        
        
        NSString *appDocPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *tmpPath = [appDocPath stringByAppendingPathComponent:@"tmp"];
        
        NSString *torrentName = torrent.parentAlbum.name;
        NSString *torrentArtist = torrent.parentAlbum.artist;
        NSInteger torrentYear = (torrent.remastered ? torrent.remasterYear : torrent.parentAlbum.year);
        NSString *torrentReleaseType = torrent.mediaType;
        NSString *torrentFormat = torrent.format;
        NSString *torrentBitrate = torrent.encoding;
        NSMutableString *fileName = [NSMutableString stringWithFormat:@"%@ - %@ - %i (%@ - %@ - %@).torrent", torrentArtist, torrentName, torrentYear, torrentReleaseType, torrentFormat, torrentBitrate];
        
        NSString *filePath = [tmpPath stringByAppendingPathComponent:fileName];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
        
        [appDelegate showAlertBannerWithTitle:@"Download In Progress" subtitle:[NSString stringWithFormat:@"Downloading %@ to your Google Drive storage.", fileName] style:ALAlertBannerStyleNotify];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self uploadFileToTheCloud:fileName fromPath:filePath];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [appDelegate showAlertBannerWithTitle:@"Download Failed" subtitle:[NSString stringWithFormat:@"%@ couldn't be downloaded. Please try again.", fileName] style:ALAlertBannerStyleFailure];
        }];
        
        [[[HTTPRequestSingleton sharedClient] operationQueue] addOperation:operation];
    }
    
    else {
        //prompt to link Dropbox
        [appDelegate showAlertBannerWithTitle:@"Google Drive Isn't Linked" subtitle:@"Not so fast pal. You haven't linked your Google Drive account yet. You can find the option in the Settings panel." style:ALAlertBannerStyleNotify];
    }
}

-(void)uploadFileToTheCloud:(NSString*)fileName fromPath:(NSString *)filePath {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [[GoogleDrive sharedDrive] uploadFile:fileName fromPath:filePath success:^{
        [appDelegate showAlertBannerWithTitle:@"File Added To Google Drive" subtitle:[NSString stringWithFormat:@"%@ was successfully added to your Google Drive storage.", fileName] style:ALAlertBannerStyleSuccess];
    } failure:^(NSError *error) {
        [appDelegate showAlertBannerWithTitle:error.localizedFailureReason subtitle:error.localizedDescription style:ALAlertBannerStyleFailure];
    }];
}

/*
-(void)uploadFile:(NSString *)fileName fromPath:(NSString *)fromPath
{    
    NSTask *task = [[NSTask alloc] init];
    
    [task setStandardInput:[NSFileHandle fileHandleWithNullDevice]];
    
    NSPipe *outputPipe = [NSPipe pipe];
    [task setStandardOutput:outputPipe];
    
    NSPipe *errorPipe = [NSPipe pipe];
    [task setStandardError:errorPipe];
    
    //NSString *askPassPath = [NSBundle pathForResource:@"ssh-askpass" ofType:@"" inDirectory:[[NSBundle mainBundle] bundlePath]];
    NSString *askPassPath = [NSBundle pathForResource:@"ios-ssh-askpass" ofType:@"" inDirectory:[[NSBundle mainBundle] bundlePath]];
    NSLog(@"askPathPass: %@", askPassPath);

    NSDictionary *environmentDict = [[NSProcessInfo processInfo] environment];
    NSMutableDictionary *env = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"NONE", @"DISPLAY", askPassPath, @"SSH_ASKPASS", nil];
    if ([environmentDict objectForKey:@"SSH_AUTH_SOCK"] != nil)
        [env setObject:[environmentDict objectForKey:@"SSH_AUTH_SOCK"] forKey:@"SSH_AUTH_SOCK"];
    
    //NSLog(@"Environment dict %@",env);
    
    //NSArray *arguments = [NSArray arrayWithObjects:@"", nil];
    NSArray *arguments = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@", fromPath], @"xxx@192.168.1.159:~/Desktop", nil];

    [task setLaunchPath:@"/usr/bin/scp"];
    [task setEnvironment:env];
    [task setArguments:arguments];
    //[task setLaunchPath:@"/bin/sh"];
    
    
    NSFileHandle *readHandle = [[task standardOutput] fileHandleForReading];
    
    [task launch];
    
    NSData *readData = [readHandle readDataToEndOfFile];
    
    NSString *output = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", output);
        
}
*/


@end
