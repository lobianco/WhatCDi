//
//  FirstViewController.m
//  What
//
//  Created by What on 4/24/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "API.h"
#import "ProfileJoinedDateView.h"
#import "ProfileAvatarCell.h"
#import "LoadingView.h"
#import "ProfileCarouselCell.h"
#import "ImagePopupController.h"
#import "NSDate+Tools.h"
#import "NSString+Tools.h"
#import "NSString+HTML.h"
#import "ProfileStatsFooter.h"
#import "AlbumTableViewController.h"
#import "MarqueeLabel.h"
#import "CategorySectionHeaderView.h"
#import "WCDUser.h"
#import "Sequencer.h"
#import "ProfileDescriptionCell.h"
#import "UIBarButtonItem+Tools.h"
#import "UserSingleton.h"
#import "ProfileDetailViewController.h"
#import "AppDelegate.h"
#import "ProfileStatsCell.h"

@interface ProfileTableViewController () <SwipeViewDelegate>

//@property (nonatomic, strong) NSString *userId;

//@property (nonatomic, strong) ProfileJoinedDateView *joinedDateView;
@property (nonatomic, strong) WCDUser *user;
@property (nonatomic, getter = isLoading) BOOL loading;

@end

@implementation ProfileTableViewController

- (id)initWithUser:(WCDUser *)user {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _user = user;
        self.title = NSLocalizedString(user.name, user.name);
    }
    return self;
}

- (void)dealloc {
    NSLog(@"profile table dealloc");
    
    _user = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    self.loading = YES;
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:UIApplicationWillEnterForegroundNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [MarqueeLabel controllerViewAppearing:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isLoading)
        return 0;
    
    if ([self.user.memberClass length] > 0)
        return [self numberOfSections];
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 3;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *AvatarCellIdentifier = @"AvatarCellIdentifier";
    static NSString *ProfileTextCellIdentifier = @"ProfileTextCellIdentifier";
    static NSString *CarouselCellIdentifier = @"CarouselCellIdentifier";
    static NSString *ProfileStatsCellIdentifier = @"ProfileStatsCell";
    
    if (indexPath.section == 0)
    {

        ProfileAvatarCell *cell = (ProfileAvatarCell *)[tableView dequeueReusableCellWithIdentifier:AvatarCellIdentifier];
        
        if (cell == nil) {
            cell = [[ProfileAvatarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AvatarCellIdentifier];
        }
        
        if ([self.user.name length] > 0)
        {
            cell.user = self.user;
        
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedUserImage:)];
            [cell.avatarView addGestureRecognizer:tapGesture];
            cell.avatarView.tag = indexPath.row;
        }
        
        return cell;
    }
    
    //stats
    else if (indexPath.section == 1) {
        
        ProfileStatsCell *cell = (ProfileStatsCell *)[tableView dequeueReusableCellWithIdentifier:ProfileStatsCellIdentifier];
        
        if (cell == nil) {
            cell = [[ProfileStatsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ProfileStatsCellIdentifier];
        }
        
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"Ratio / Required";
            NSString *ratioText = self.user.ratio ? [NSString stringWithFormat:@"%.2f", self.user.ratio] : @"Hidden";
            NSString *requiredRatioText = self.user.requiredRatio ? [NSString stringWithFormat:@"%.2f", self.user.requiredRatio] : @"Hidden";
            cell.valueLable.text = [NSString stringWithFormat:@"%@ / %@", ratioText, requiredRatioText];
        } else if (indexPath.row == 1) {
            cell.titleLabel.text = @"Uploaded";
            cell.valueLable.text = self.user.uploaded ? [NSString formatFileSize:self.user.uploaded forProfile:YES] : @"Hidden";
        } else if (indexPath.row == 2) {
            cell.titleLabel.text = @"Downloaded";
            cell.valueLable.text = self.user.downloaded ? [NSString formatFileSize:self.user.downloaded forProfile:YES] : @"Hidden";
        }
        
        return cell;
        
    }
    
    else if (indexPath.section == 2 && self.user.profileText.length > 0)
    {
        ProfileDescriptionCell *cell = (ProfileDescriptionCell *)[tableView dequeueReusableCellWithIdentifier:ProfileTextCellIdentifier];
        
        if (cell == nil) {
            cell = [[ProfileDescriptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ProfileTextCellIdentifier];
        }
        
        cell.profileText.text = [self.user.profileText stringByConvertingHTMLToPlainText];
        
        return cell;
    }
    
    
    else
    {
        ProfileCarouselCell *cell = (ProfileCarouselCell *)[tableView dequeueReusableCellWithIdentifier:CarouselCellIdentifier];
        
        if (cell == nil) {
            cell = [[ProfileCarouselCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CarouselCellIdentifier];
        }
        
        cell.swipeView.tag = indexPath.section;
        
        int sectionAdjustmentForProfileText = self.user.profileText.length > 0 ? 3 : 2;
                
        if (indexPath.section == sectionAdjustmentForProfileText)
        {
            if ([self.user.snatches count] > 0)
                cell.albums = self.user.snatches;
        }
        
        else if (indexPath.section == sectionAdjustmentForProfileText+1)
        {
            if ([self.user.uploads count] > 0)
                cell.albums = self.user.uploads;
        }
        
        cell.swipeView.delegate = self;
        
        return cell;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return [ProfileAvatarCell height];
    
    else if (indexPath.section == 1)
        return 40.f;
    
    else if (indexPath.section == 2 && self.user.profileText.length > 0)
        return 50.f;
    
    else
        return [ProfileCarouselCell height];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle;
    
    if (section == 1)
        sectionTitle = @"Stats";
    
    else if (section == 2 && self.user.profileText.length > 0)
        sectionTitle = @"Profile";
    
    else {
        int sectionAdjustmentForProfileText = self.user.profileText.length > 0 ? 3 : 2;
        if (section == sectionAdjustmentForProfileText)
            sectionTitle = @"Snatches";
        
        else if (section == sectionAdjustmentForProfileText+1)
            sectionTitle = @"Uploads";
    }

    CategorySectionHeaderView *headerView = [[CategorySectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kSectionHeaderHeight)];
    headerView.title.text = sectionTitle;
    return headerView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //int sectionAdjustmentForProfileText = self.user.profileText.length > 0 ? 3 : 2;
    //if (section < sectionAdjustmentForProfileText && section != 1)
    //    return 0.f;
    
    if (section == 0)
        return 0;
    
    return kSectionHeaderHeight;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2 && self.user.profileText.length > 0) {
        ProfileDetailViewController *profile = [[ProfileDetailViewController alloc] initWithUser:self.user];
        [self.navigationController pushViewController:profile animated:YES];
    }

}

-(void)refresh
{
    NSString *oldUserClass = self.user.memberClass;
    int oldNumberOfSections = [self numberOfSectionsInTableView:self.tableView];
    
    Sequencer *sequencer = [[Sequencer alloc] init];
    [sequencer enqueueStep:^(id result, SequencerCompletion completion) {
        
        NSURLRequest *request = [[API sharedInterface] getUserInfo:self.user.idNum];
        [API getRequest:request completionBlockWithJSON:^(id JSON) {
            
            NSDictionary *JSONdict = (NSDictionary *)JSON;
            NSDictionary *response = [JSONdict objectForKey:wRESPONSE];
            NSDictionary *stats = [response objectForKey:@"stats"];
            NSDictionary *personal = [response objectForKey:@"personal"];
            
            //self.user.name = [response objectForKey:@"username"];
            self.user.avatarURL = [NSURL URLWithString:[response objectForKey:@"avatar"]];
            self.user.joinDate = [stats objectForKey:@"joinedDate"];
            self.user.lastActiveDate = [stats objectForKey:@"lastAccess"];
            self.user.donor = [[personal objectForKey:@"donor"] boolValue];
            self.user.memberClass = [personal objectForKey:@"class"];
            self.user.profileText = [response objectForKey:@"profileText"];
            self.user.enabled = [[personal objectForKey:@"enabled"] boolValue];
            //self.joinedDateView.joinedLabel.text = self.user.joinDate;
            //self.joinedDateView.lastActiveLabel.text = self.user.lastActiveDate;
            
            //stats
            //need to use NSNull
            if ([stats objectForKey:@"ratio"] != [NSNull null])
                self.user.ratio = [[stats objectForKey:@"ratio"] doubleValue];
            if ([stats objectForKey:@"requiredRatio"] != [NSNull null])
                self.user.requiredRatio = [[stats objectForKey:@"requiredRatio"] doubleValue];
            if ([stats objectForKey:@"uploaded"] != [NSNull null])
                self.user.uploaded = [[stats objectForKey:@"uploaded"] longLongValue];
            if ([stats objectForKey:@"downloaded"] != [NSNull null])
                self.user.downloaded = [[stats objectForKey:@"downloaded"] longLongValue];
                        
            completion(nil);
            
        } failureBlockWithError:^(NSError *error) {
            
            NSLog(@"error on profile page: %@", error);
            [self hideLoadingView];
            [self.pullToRefreshView finishLoading];
            
            //AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            //[appDelegate showFailureAlertBannerWithError:error];
            
        }];
        
    }];
    
    [sequencer enqueueStep:^(id result, SequencerCompletion completion) {
        
        NSURLRequest *request = [[API sharedInterface] getUserRecents:[NSString stringWithFormat:@"%i", self.user.idNum]];
        [API getRequest:request completionBlockWithJSON:^(id JSON) {
            
            NSDictionary *JSONdict = (NSDictionary *)JSON;
            NSDictionary *response = [JSONdict objectForKey:wRESPONSE];
            NSArray *snatches = [response objectForKey:@"snatches"];
            NSArray *uploads = [response objectForKey:@"uploads"];
            
            NSMutableArray *snatchArray = [NSMutableArray new];
            for (NSDictionary *snatch in snatches)
            {
                WCDAlbum *album = [[WCDAlbum alloc] init];
                album.imageURL = [NSURL URLWithString:[snatch objectForKey:@"WikiImage"]];
                album.artist = [[[[[[snatch objectForKey:@"artists"] objectAtIndex:0] objectForKey:@"1"] objectAtIndex:0] objectForKey:@"name"] stringByDecodingHTMLEntities];
                album.name = [[snatch objectForKey:@"Name"] stringByDecodingHTMLEntities];
                album.idNum = [[snatch objectForKey:@"ID"] integerValue];
                
                [snatchArray addObject:album];
            }
            self.user.snatches = [NSArray arrayWithArray:snatchArray];
            
            NSMutableArray *uploadArray = [NSMutableArray new];
            for (NSDictionary *upload in uploads)
            {
                WCDAlbum *album = [[WCDAlbum alloc] init];
                album.imageURL = [NSURL URLWithString:[upload objectForKey:@"WikiImage"]];
                album.artist = [[[[[[upload objectForKey:@"artists"] objectAtIndex:0] objectForKey:@"1"] objectAtIndex:0] objectForKey:@"name"] stringByDecodingHTMLEntities];
                album.name = [[upload objectForKey:@"Name"] stringByDecodingHTMLEntities];
                album.idNum = [[upload objectForKey:@"ID"] integerValue];
                
                [uploadArray addObject:album];
            }
            self.user.uploads = [NSArray arrayWithArray:uploadArray];
            
            int numberOfSections = [self numberOfSections];
            [self.tableView beginUpdates];
            if (self.isLoading) {
                self.loading = NO;
            } else {
                if (oldUserClass.length > 0) {
                    [self.tableView deleteSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, oldNumberOfSections)] withRowAnimation:UITableViewRowAnimationFade];
                }
            }
            [self.tableView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, numberOfSections)] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            
            if (self.pullToRefreshView.state == SSPullToRefreshViewStateLoading)
                [self.pullToRefreshView finishLoading];
            if ([self loaderIsShowing]) {
                [self hideLoadingView];
            }
            
        } failureBlockWithError:^(id error) {
            
            NSLog(@"error: %@", (NSError *)error);
            [self hideLoadingView];
            [self.pullToRefreshView finishLoading];
            
            //AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            //[appDelegate showFailureAlertBannerWithError:error];
            
        }];
                
    }];
    
    [sequencer run];
    
}

-(int)numberOfSections
{
    int numberOfSections = 2; //+1 for avatar cell, +1 for stats
    if (self.user.snatches.count > 0)
        numberOfSections++;
    if (self.user.uploads.count > 0)
        numberOfSections++;
    if (self.user.profileText.length > 0)
        numberOfSections++;
    
    return numberOfSections;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Swipe View Delegate

-(void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
    ProfileCarouselCell *cell = (ProfileCarouselCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:swipeView.tag]];
    WCDAlbum *album = [cell.albums objectAtIndex:index];
    //AlbumController *albumController = [[AlbumController alloc] initWithAlbumId:album.idNum artistName:album.artist albumTitle:album.name];
    AlbumTableViewController *albumController = [[AlbumTableViewController alloc] initWithAlbum:album];
    [self.navigationController pushViewController:albumController animated:YES];
}

#pragma mark - Custom Methods

-(void)tappedUserImage:(UITapGestureRecognizer *)gesture
{
    UIImageView *imageView = (UIImageView *)[gesture view];
    ProfileAvatarCell *cell = (ProfileAvatarCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:imageView.tag inSection:0]];
    ImagePopupController *imagePopup = [[ImagePopupController alloc] initWithImage:[cell fullSizedAvatarImage]];
    CATransition *transition = (CATransition *)[Constants imagePopoverAnimation];
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    [self presentViewController:imagePopup animated:NO completion:nil];
    
}

@end
