//
//  ArtistController.m
//  What
//
//  Created by What on 6/13/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "ArtistTableViewController.h"
#import "API.h"
#import "ArtistWithAlbumTableViewCell.h"
#import "AlbumTableViewController.h"
#import "ImagePopupController.h"
#import "AppDelegate.h"
#import "NSString+Tools.h"
#import "NSString+HTML.h"
#import "WCDSectionInfo.h"
#import "ArtistSectionHeaderView.h"
#import "WCDArtist.h"
#import "ArtistImageView.h"

typedef enum {
    ReleaseTypeAlbum = 1,
    ReleaseTypeSoundtrack = 3,
    ReleaseTypeEP = 5,
    ReleaseTypeAnthology = 6,
    ReleaseTypeCompilation = 7,
    ReleaseTypeDJMix = 8,
    ReleaseTypeSingle = 9,
    ReleaseTypeLiveAlbum = 11,
    ReleaseTypeRemix = 13,
    ReleaseTypeBootleg = 14,
    ReleaseTypeInterview = 15,
    ReleaseTypeMixtape = 16,
    ReleaseTypeUnknown = 21,
    ReleaseTypeConcertRecordings = 22,
    ReleaseTypeDemo = 23,
    ReleaseTypes,
} ReleaseType;

NSString * const releaseType[] = {
    [ReleaseTypeAlbum] = @"Albums",
    [ReleaseTypeSoundtrack] = @"Soundtracks",
    [ReleaseTypeEP] = @"EPs",
    [ReleaseTypeAnthology] = @"Anthologies",
    [ReleaseTypeCompilation] = @"Compilations",
    [ReleaseTypeDJMix] = @"DJ Mixes",
    [ReleaseTypeSingle] = @"Singles",
    [ReleaseTypeLiveAlbum] = @"Live Albums",
    [ReleaseTypeRemix] = @"Remixes",
    [ReleaseTypeBootleg] = @"Bootlegs",
    [ReleaseTypeInterview] = @"Interviews",
    [ReleaseTypeMixtape] = @"Mixtapes",
    [ReleaseTypeUnknown] = @"Unknown",
    [ReleaseTypeConcertRecordings] = @"Concert Recordings",
    [ReleaseTypeDemo] = @"Demos",
};

@interface ArtistTableViewController () <SectionHeaderViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) WCDArtist *artist;

//collapsable sections
@property (nonatomic, strong) NSMutableArray *sectionInfoArray;
@property (nonatomic) NSInteger openSectionIndex;


@property (nonatomic, strong) ArtistImageView *artistImage;
@property (nonatomic, strong) UIImage *fullSizedArtistImage;
@property (nonatomic) CGFloat artistImageHeight;
@property (nonatomic, getter = isLoading) BOOL loading;

@end

#define HEADER_HEIGHT 40.f

@implementation ArtistTableViewController

@synthesize fullSizedArtistImage = fullSizedArtistImage_;
@synthesize artistImageHeight = artistImageHeight_;

- (id)initWithArtist:(WCDArtist *)artist {
    self = [super init];
    if (self) {
        // Custom initialization
        
        _artist = artist;
        self.title = NSLocalizedString(artist.name, artist.name);
    }
    return self;
}

- (void)viewDidLoad
{
    self.loading = YES;
    
    [super viewDidLoad];
    
    //remove pull to refresh for this view because of artist image
    [self.pullToRefreshView removeFromSuperview];
    self.pullToRefreshView.delegate = nil;
    self.pullToRefreshView = nil;
    
    self.openSectionIndex = 0;
        
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedTableView:)];
    tapGesture.delegate = self;
    [self.tableView addGestureRecognizer:tapGesture];
    
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    //[self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)dealloc {
    NSLog(@"table dealloc");
    _artist = nil;
    _sectionInfoArray = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.isLoading ? 0 : [self.artist.albumsDictionary.allKeys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    WCDSectionInfo *sectionInfo = (self.sectionInfoArray)[section];
    NSInteger numberOfAlbumsInSection = [sectionInfo.releaseGroup.objects count];
    
    return sectionInfo.open ? numberOfAlbumsInSection : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *AlbumCellIdentifier = @"AlbumCellIdentifier";
    
    ArtistWithAlbumTableViewCell *cell = (ArtistWithAlbumTableViewCell *)[tableView dequeueReusableCellWithIdentifier:AlbumCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[ArtistWithAlbumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AlbumCellIdentifier];
    }
    
    WCDReleaseGroup *releaseGroup = (WCDReleaseGroup *)[(self.sectionInfoArray)[indexPath.section] releaseGroup];
    cell.album = (releaseGroup.objects)[indexPath.row];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ArtistSectionHeaderView *sectionHeaderView = [[ArtistSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, HEADER_HEIGHT)];
    WCDSectionInfo *sectionInfo = (self.sectionInfoArray)[section];
    
    sectionHeaderView.title.text = sectionInfo.releaseGroup.name;
    sectionHeaderView.section = section;
    sectionHeaderView.delegate = self;
    
    return sectionHeaderView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADER_HEIGHT;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ArtistWithAlbumTableViewCell heightForAlbumCell];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    WCDReleaseGroup *releaseGroup = (WCDReleaseGroup *)[(self.sectionInfoArray)[indexPath.section] releaseGroup];
    WCDAlbum *album = (releaseGroup.objects)[indexPath.row];
    
    //AlbumController *albumController = [[AlbumController alloc] initWithAlbumId:album.idNum artistName:self.artist.name albumTitle:album.name];
    AlbumTableViewController *albumController = [[AlbumTableViewController alloc] initWithAlbum:album];
    [self.navigationController pushViewController:albumController animated:YES];
     
}

#pragma mark - Section header delegate

-(void)collapseOrExpandCellsInSection:(NSInteger)section
{
    WCDSectionInfo *sectionInfo = (self.sectionInfoArray)[section];
    sectionInfo.open ? [self closeSection:section] : [self openSection:section];
}

-(void)openSection:(NSInteger)sectionOpened
{
    WCDSectionInfo *sectionInfo = (self.sectionInfoArray)[sectionOpened];
	sectionInfo.open = YES;
    
    /*
     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
     */
    NSInteger countOfRowsToInsert = [sectionInfo.releaseGroup.objects count];
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }
    
    /*
     Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
     */
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) {
        
		WCDSectionInfo *previousOpenSection = (self.sectionInfoArray)[previousOpenSectionIndex];
        previousOpenSection.open = NO;
        
        NSInteger countOfRowsToDelete = [previousOpenSection.releaseGroup.objects count];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
    }
    
    // Style the animation so that there's a smooth flow in either direction.
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    // Apply the updates.
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.tableView endUpdates];
    
    //add a delay to the scroll to allow table animations to finish
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sectionOpened] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    });
    
    self.openSectionIndex = sectionOpened;
}

-(void)closeSection:(NSInteger)sectionClosed
{
    /*
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     */
	WCDSectionInfo *sectionInfo = (self.sectionInfoArray)[sectionClosed];
    
    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [self.tableView numberOfRowsInSection:sectionClosed];
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];

    }
    self.openSectionIndex = NSNotFound;
}

#pragma mark - Custom Methods

-(void)refresh
{
    NSURLRequest *request = [[API sharedInterface] getArtistInfo:[NSString stringWithFormat:@"%i", self.artist.idNum]];
    [API getRequest:request completionBlockWithJSON:^(id JSON) {
        
        NSDictionary *response = [JSON objectForKey:@"response"];
        NSArray *torrentGroup = [NSArray arrayWithArray:[response objectForKey:@"torrentgroup"]];
        
        
        //artist info here
        self.artist.name = [response objectForKey:@"name"];
        self.artist.imageURL = [NSURL URLWithString:[response objectForKey:@"image"]];
        self.artist.idNum = [[response objectForKey:@"id"] integerValue];
        
    
        //iterate through all albums of the artist
        NSMutableDictionary *dataSource = [NSMutableDictionary new];
        for (NSDictionary *groupInfo in torrentGroup)
        {
            NSString *name = [[groupInfo objectForKey:@"groupName"] stringByDecodingHTMLEntities];
            NSInteger release = [[groupInfo objectForKey:@"releaseType"] integerValue];
            //NSArray *torrents = [groupInfo objectForKey:@"torrent"];
            NSInteger year = [[groupInfo objectForKey:@"groupYear"] integerValue];
            NSURL *imageURL = [NSURL URLWithString:[groupInfo objectForKey:@"wikiImage"]];
            NSArray *tags = [groupInfo objectForKey:@"tags"];
            NSInteger idNum = [[groupInfo objectForKey:@"groupId"] integerValue];
            
            WCDAlbum *album = [[WCDAlbum alloc] init];
            album.name = name;
            album.releaseType = release;
            album.year = year;
            album.imageURL = imageURL;
            album.tags = tags;
            album.idNum = idNum;

            NSString *key = releaseType[release];
            if (key) {
                WCDReleaseGroup *releaseGroup = [dataSource objectForKey:key];
                
                if (releaseGroup == nil) {
                    releaseGroup = [[WCDReleaseGroup alloc] init];
                    releaseGroup.name = key;
                }
                
                [releaseGroup.objects addObject:album];
                [dataSource setObject:releaseGroup forKey:key];
            }
        }
        self.artist.albumsDictionary = dataSource;
        
        
        //collapsable sections stuff
        BOOL openSection = YES;
        if ((self.sectionInfoArray == nil) || ([self.sectionInfoArray count] != [self numberOfSectionsInTableView:self.tableView]))
        {
            NSMutableArray *infoArray = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < ReleaseTypes; i++)
            {
                WCDReleaseGroup *releaseGroup = [self.artist.albumsDictionary objectForKey:releaseType[i]];
                if (releaseGroup) {
                    WCDSectionInfo *sectionInfo = [[WCDSectionInfo alloc] init];
                    
                    sectionInfo.releaseGroup = releaseGroup;
                    sectionInfo.open = openSection;
                    
                    //open first section only
                    if (openSection)
                        openSection = NO;
                    
                    [infoArray addObject:sectionInfo];
                }
            }
            self.sectionInfoArray = infoArray;
        }
        
        [self.tableView beginUpdates];
        if (self.isLoading) {
            self.loading = NO;
        }
        [self.tableView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self.artist.albumsDictionary.allKeys count])] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
        if ([self.artist.imageURL.absoluteString length] > 0)
            [self performSelector:@selector(addArtistImage) withObject:nil afterDelay:1.0];
        
        if (self.pullToRefreshView.state == SSPullToRefreshViewStateLoading)
            [self.pullToRefreshView finishLoading];
        if ([self loaderIsShowing]) {
            [self hideLoadingView];
        }
        
    } failureBlockWithError:^(id error) {
        
        [self hideLoadingView];
        NSLog(@"error: %@", (NSError *)error);
        
    }];
}

-(void)addArtistImage
{
    self.artistImageHeight = 200.f; //([Constants deviceHasLargerScreen] ? 250.f : 200.f);
    self.artistImage = [[ArtistImageView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.artistImageHeight)];
    
    [UIView animateWithDuration:0.25f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:self.artistImage.frame]];
    } completion:^(BOOL finished) {
        [self.tableView addSubview:self.artistImage];
        [self.artistImage updateArtistImageWithURL:self.artist.imageURL];
    }];
    
}

-(void)tappedTableView:(UITapGestureRecognizer *)gesture
{
    CGPoint touchPoint = [gesture locationInView:self.tableView];
    if (CGRectContainsPoint(self.tableView.tableHeaderView.bounds, touchPoint))
    {
        ImagePopupController *popup = [[ImagePopupController alloc] initWithImage:self.artistImage.fullSizedImage];
        
        CATransition *transition = (CATransition *)[Constants imagePopoverAnimation];
        [self.view.window.layer addAnimation:transition forKey:nil];
        
        [self presentViewController:popup animated:NO completion:nil];
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //only allow touches on the artist image
    if (gestureRecognizer.view == self.tableView)
        return (CGRectContainsPoint(self.tableView.tableHeaderView.bounds, [touch locationInView:self.tableView.tableHeaderView]));
    
    return YES;
}

#pragma mark - ScrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    
    if (scrollView.contentOffset.y < 0)
    {
        CGRect artistImageFrame = self.artistImage.imageView.frame;
        artistImageFrame.origin.y = scrollView.contentOffset.y;
        artistImageFrame.size.height = (self.artistImageHeight + fabsf(scrollView.contentOffset.y));
        self.artistImage.imageView.frame = artistImageFrame;
    }
}


@end
