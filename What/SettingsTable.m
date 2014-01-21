//
//  SettingsTable.m
//  What
//
//  Created by What on 6/27/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "SettingsTable.h"
#import "ToggleCell.h"
#import "TextViewCell.h"
#import "UserSingleton.h"
#import "ToggleObject.h"
#import "TextViewObject.h"
#import "TextFieldObject.h"
#import "SettingsGroup.h"
#import "PickerObject.h"
#import "PickerCell.h"
#import "AppDelegate.h"
#import "DefaultCell.h"
#import "TextFieldCell.h"
//#import "Dropbox.h"
#import "GoogleDrive.h"
#import <MessageUI/MFMailComposeViewController.h>

//Settings Groups
#define kSettingsGroupGeneral       @"Personal Settings"
#define kSettingsGroupForum         @"Community Settings"
#define kSettingsGroupDownloads     @"Torrent Settings"

//Individual settings
#define kSettingSaveCredentials     @"Save Login Credentials"

#define kSettingOpenThreadsTo       @"Open Forum Threads to..."
#define kSettingSignature           @"Signature"
#define kSettingSignatureField      @"SignatureField"

#define kSettingDownloads           @"Downloads"
//#define kSettingsDropboxKey         @"Dropbox Key"
//#define kSettingsDropboxSecret      @"Dropbox Secret"
#define kSettingLinkGoogleDrive     @"Link iPhone to Google Drive"
#define kSettingUnlinkGoogleDrive   @"Unlink iPhone from Google Drive"

static const CGFloat textFieldMaximumCharacters = 140.f;
static const CGFloat cKeyboardHeight = 216.f;

@interface SettingsTable ()  <UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *tableData;

@end

@implementation SettingsTable

@synthesize tableData = tableData_;


-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.dataSource = self;
        self.delegate = self;
        self.backgroundView = nil;
        self.backgroundColor = [UIColor colorFromHexString:cMenuTableBackgroundColor];
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.separatorColor = [UIColor colorFromHexString:cMenuTableSeparatorColor];
        //NEED THIS!!
        self.scrollsToTop = NO;
        
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        
        //GENERAL
        ToggleObject *saveCredentialsToggle = [[ToggleObject alloc] init];
        saveCredentialsToggle.title = kSettingSaveCredentials;
        saveCredentialsToggle.on = [UserSingleton sharedInstance].saveCredentials;
        
        SettingsGroup *generalGroup = [[SettingsGroup alloc] initWithSettings:[NSArray arrayWithObjects:saveCredentialsToggle, nil]];
        generalGroup.title = kSettingsGroupGeneral;
        
        
        //FORUM
        PickerObject *forumPagePicker = [[PickerObject alloc] init];
        forumPagePicker.title = kSettingOpenThreadsTo;
        forumPagePicker.selectedOption = ([[UserSingleton sharedInstance] forumOpenToOptions])[[UserSingleton sharedInstance].forumOpenTo];
        
        ToggleObject *signatureToggle = [[ToggleObject alloc] init];
        signatureToggle.title = kSettingSignature;
        signatureToggle.on = [[UserSingleton sharedInstance] useSignature];
        
        TextViewObject *signatureField = [[TextViewObject alloc] init];
        signatureField.title = kSettingSignatureField;
        signatureField.text = [[UserSingleton sharedInstance] signature];
        
        SettingsGroup *forumGroup = [[SettingsGroup alloc] initWithSettings:[NSArray arrayWithObjects:forumPagePicker, signatureToggle, nil]];
        forumGroup.title = kSettingsGroupForum;
        
        if (signatureToggle.on)
            [forumGroup.settingsObjects addObject:signatureField];

        
        //DOWNLOADING
        ToggleObject *downloadToggle = [[ToggleObject alloc] init];
        downloadToggle.on = [UserSingleton sharedInstance].downloadsEnabled;
        downloadToggle.title = kSettingDownloads;
        
        //TextFieldObject *dropboxKeyObject = [[TextFieldObject alloc] init];
        //dropboxKeyObject.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"DropboxAppKey"];
        //dropboxKeyObject.title = kSettingsDropboxKey;
        
        //TextFieldObject *dropboxSecretObject = [[TextFieldObject alloc] init];
        //dropboxSecretObject.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"DropboxSecret"];
        //dropboxSecretObject.title = kSettingsDropboxSecret;
        
        SettingsObject *googleDriveObject = [[SettingsObject alloc] init];
        googleDriveObject.title = ([[GoogleDrive sharedDrive] isAuthorized] ? kSettingUnlinkGoogleDrive : kSettingLinkGoogleDrive);
        
        SettingsGroup *downloadsGroup = [[SettingsGroup alloc] initWithSettings:[NSArray arrayWithObjects:downloadToggle, googleDriveObject, nil]];
        downloadsGroup.title = kSettingsGroupDownloads;
        
        //ABOUT
        SettingsObject *versionObject = [[SettingsObject alloc] init];
        versionObject.title = [NSString stringWithFormat:@"What.CD for iPhone v%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
        
        SettingsObject *feedbackAndReviewsObject = [[SettingsObject alloc] init];
        feedbackAndReviewsObject.title = @"General Information and Reviews";
        
        SettingsObject *bugsAndRequestsObject = [[SettingsObject alloc] init];
        bugsAndRequestsObject.title = @"Bug Reports and Feature Requests";
        
        SettingsObject *feedbackObject = [[SettingsObject alloc] init];
        feedbackObject.title = @"Email the Developer";
        
        SettingsGroup *aboutGroup = [[SettingsGroup alloc] initWithSettings:[NSArray arrayWithObjects:versionObject, feedbackAndReviewsObject, bugsAndRequestsObject, feedbackObject, nil]];
        aboutGroup.title = @"About";

        
        //TABLE DATA SOURCE
        tableData_ = [[NSMutableArray alloc] initWithObjects:generalGroup, forumGroup, downloadsGroup, aboutGroup, nil];
    }
    
    return self;
}

-(void)addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGoogleDriveCellText:) name:@"GoogleDriveLinkageChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

-(void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)keyboardWillShow
{
    UIEdgeInsets insetsForKeyboard = UIEdgeInsetsMake(0, 0, cKeyboardHeight, 0); //keyboard height
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentInset = insetsForKeyboard;
        self.scrollIndicatorInsets = insetsForKeyboard;
    } completion:^(BOOL finished) {
        [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }];
}

-(void)keyboardWillHide
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentInset = UIEdgeInsetsZero;
        self.scrollIndicatorInsets = UIEdgeInsetsZero;
    } completion:nil];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if (CGRectContainsPoint(self.settingsTableHeader.frame, [[touches anyObject] locationInView:self]))
        [self.parentController performSelector:@selector(popSettings)];
    
    [self.nextResponder touchesEnded:touches withEvent:event];
}

-(void)updateGoogleDriveCellText:(NSNotification *)note
{
    SettingsGroup *settingsGroup = [self.tableData objectAtIndex:2];
    SettingsObject *googleDriveObject = [settingsGroup.settingsObjects objectAtIndex:1];
    googleDriveObject.title = ([[GoogleDrive sharedDrive] isAuthorized] ? kSettingUnlinkGoogleDrive : kSettingLinkGoogleDrive);
    
    [self beginUpdates];
    [self reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:2]] withRowAnimation:UITableViewRowAnimationFade];
    [self endUpdates];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.tableData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SettingsGroup *settingsGroup = [self.tableData objectAtIndex:section];
    return settingsGroup.settingsObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingsGroup *settingsGroup = [self.tableData objectAtIndex:indexPath.section];
    SettingsObject *settingsObject = [settingsGroup.settingsObjects objectAtIndex:indexPath.row];
    settingsObject.tag = indexPath.section;
    
    if ([settingsObject isKindOfClass:[ToggleObject class]])
    {
        ToggleObject *toggleObject = (ToggleObject*)settingsObject;
        
        static NSString *ToggleIdentifier = @"ToggleIdentifier";
        ToggleCell *cell = (ToggleCell *)[tableView dequeueReusableCellWithIdentifier:ToggleIdentifier];
        
        if (cell == nil) {
            cell = [[ToggleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ToggleIdentifier];
        }
        
        [cell setChecked:toggleObject.on animated:NO];
        cell.toggleObject = toggleObject;
        
        return cell;
    }
    
    else if ([settingsObject isKindOfClass:[TextViewObject class]])
    {
        TextViewObject *textFieldObject = (TextViewObject*)settingsObject;
        
        static NSString *FieldIdentifier = @"TextViewIdentifier";
        TextViewCell *cell = (TextViewCell *)[tableView dequeueReusableCellWithIdentifier:FieldIdentifier];
        
        if (cell == nil) {
            cell = [[TextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FieldIdentifier];
        }
        
        cell.textView.text = textFieldObject.text;
        cell.textView.delegate = self;
        
        return cell;
    }
    
    else if ([settingsObject isKindOfClass:[TextFieldObject class]]) {
        
        TextFieldObject *textFieldObject = (TextFieldObject*)settingsObject;
        
        static NSString *FieldIdentifier = @"FieldIdentifier";
        TextFieldCell *cell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:FieldIdentifier];
        
        if (cell == nil) {
            cell = [[TextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FieldIdentifier];
        }
        
        cell.textField.text = textFieldObject.text;
        cell.textField.delegate = self;
        cell.textField.tag = indexPath.row;
        cell.label.text = textFieldObject.title;
        //cell.textView.delegate = self;
        
        return cell;
    }
    
    else if ([settingsObject isKindOfClass:[PickerObject class]])
    {
        PickerObject *pickerObject = (PickerObject*)settingsObject;
        
        static NSString *PickerIdentifier = @"PickerIdentifier";
        PickerCell *cell = (PickerCell *)[tableView dequeueReusableCellWithIdentifier:PickerIdentifier];
        
        if (cell == nil) {
            cell = [[PickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PickerIdentifier];
        }
        
        cell.pickerObject = pickerObject;
        return cell;
    }
    
    else
    {
        static NSString *DefaultIdentifier = @"DefaultIdentifier";
        DefaultCell *cell = (DefaultCell *)[tableView dequeueReusableCellWithIdentifier:DefaultIdentifier];
        
        if (cell == nil) {
            cell = [[DefaultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DefaultIdentifier];
        }
        
        cell.settingsObject = settingsObject;
        return cell;
    }
        
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:tableView.backgroundColor];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingsGroup *settingsGroup = [self.tableData objectAtIndex:indexPath.section];
    SettingsObject *settingsObject = [settingsGroup.settingsObjects objectAtIndex:indexPath.row];
    
    if ([settingsObject isKindOfClass:[TextViewObject class]])
        return 70.f;
    
    return [ToggleCell heightForCell];;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    [headerView setBackgroundColor:[UIColor colorFromHexString:cMenuTableBackgroundSelectedColor]]; //cMenuTableBackgroundSelectedColor
    
    SettingsGroup *settingsGroup = [self.tableData objectAtIndex:section];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CELL_PADDING, 0, CELL_WIDTH - CELL_PADDING*2, kSectionHeaderHeight)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor colorFromHexString:cMenuTableFontColor alpha:0.5]];
    [titleLabel setFont:[Constants appFontWithSize:10.f bolded:YES]];
    [titleLabel setText:settingsGroup.title];
    [headerView addSubview:titleLabel];
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kSectionHeaderHeight;
}

# pragma mark - Mail Delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (result == MFMailComposeResultSent) {
        NSLog(@"sent");
    }
    
    [self.parentController dismissModalViewControllerAnimated:YES];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SettingsGroup *settingsGroup = [self.tableData objectAtIndex:indexPath.section];
    SettingsObject *settingsObject = [settingsGroup.settingsObjects objectAtIndex:indexPath.row];
    
    if ([settingsGroup.title isEqualToString:@"About"]) {
        if ([settingsObject.title isEqualToString:@"General Information and Reviews"]) {
            double delayInSeconds = 0.2;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.parentController gotoFeedbackForum];
            });
        }
        
        else if ([settingsObject.title isEqualToString:@"Bug Reports and Feature Requests"]) {
            double delayInSeconds = 0.2;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.parentController gotoBugsForum];
            });
        }
        
        else if ([settingsObject.title isEqualToString:@"Email the Developer"]) {
            if ([MFMailComposeViewController canSendMail])
            {
                MFMailComposeViewController *feedbackController = [[MFMailComposeViewController alloc] init];
                [feedbackController setSubject:[NSString stringWithFormat:@"Feedback for WhatCDi %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
                [feedbackController setToRecipients:[NSArray arrayWithObjects:@"feedback@whatcdios.com", nil]];
                [feedbackController setMessageBody:[NSString stringWithFormat:@"Leave your feedback here!\n\n\
/* -------------------------------- \n\
Debug information\n\n\
Device: %@\n\
iOS Version: %@\n\
App Version: %@\n\
-------------------------------- */", [Constants platformString], [[UIDevice currentDevice] systemVersion], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]] isHTML:NO];
                feedbackController.modalPresentationStyle = UIModalPresentationFormSheet;
                feedbackController.mailComposeDelegate = self;
                [self.parentController presentModalViewController:feedbackController animated:YES];
            }
            
            else {
                
                AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                [appDelegate showAlertBannerWithTitle:@"No Email Accounts" subtitle:@"You haven't set up any email accounts on your device yet. Feel free to do that now. I'll wait right here." style:ALAlertBannerStyleFailure];
            }
        }
        return;
    }
    
    else if ([settingsGroup.title isEqualToString:kSettingsGroupGeneral])
    {
        if ([settingsObject.title isEqualToString:kSettingSaveCredentials])
        {
            ToggleObject *sslToggle = (ToggleObject *)settingsObject;
            sslToggle.on = !sslToggle.on;
            
            [[UserSingleton sharedInstance] setSaveCredentials:sslToggle.on];
            
            //TODO clear credentials when this is set to no?
        }
        
        [self beginUpdates];
        [self reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self endUpdates];
    }
    
    else if ([settingsGroup.title isEqualToString:kSettingsGroupForum])
    {
        if ([settingsObject.title isEqualToString:kSettingOpenThreadsTo])
        {
            PickerObject *forumPagePicker = (PickerObject*)settingsObject;
            
            UIActionSheet *forumPicker = [[UIActionSheet alloc] initWithTitle:forumPagePicker.title delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:([[UserSingleton sharedInstance] forumOpenToOptions])[0], ([[UserSingleton sharedInstance] forumOpenToOptions])[1], nil];
            forumPicker.tag = indexPath.section;
            [forumPicker showInView:self];
            
        }
        
        else if ([settingsObject.title isEqualToString:kSettingSignature])
        {
            ToggleObject *signatureToggle = (ToggleObject *)settingsObject;
            signatureToggle.on = !signatureToggle.on;
            
            //ToggleCell *cell = (ToggleCell*)[tableView cellForRowAtIndexPath:indexPath];
            //cell.toggleObject = signatureToggle;
            
            //[cell setChecked:signatureToggle.on animated:YES];
            
            if (signatureToggle.on)
            {
                TextViewObject *signatureField = [[TextViewObject alloc] init];
                signatureField.title = kSettingSignatureField;
                signatureField.text = (![[UserSingleton sharedInstance] signature] ? @"" : [[UserSingleton sharedInstance] signature]);
                
                [settingsGroup.settingsObjects addObject:signatureField];
                
                [self beginUpdates];
                [self insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:signatureToggle.tag]] withRowAnimation:UITableViewRowAnimationTop];
                [self reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self endUpdates];
            }
            
            else
            {
                [settingsGroup.settingsObjects removeLastObject];
                
                [self beginUpdates];
                [self deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:signatureToggle.tag]] withRowAnimation:UITableViewRowAnimationTop];
                [self reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self endUpdates];
            }
            
            [[UserSingleton sharedInstance] setUseSignature:signatureToggle.on];
        }
    }
    
    else if ([settingsGroup.title isEqualToString:kSettingsGroupDownloads])
    {
        if ([settingsObject.title isEqualToString:kSettingDownloads])
        {
            
            ToggleObject *downloadToggle = (ToggleObject *)settingsObject;
            downloadToggle.on = !downloadToggle.on;
            
            //ToggleCell *cell = (ToggleCell*)[tableView cellForRowAtIndexPath:indexPath];
            //cell.toggleObject = downloadToggle;
            
            //[cell setChecked:downloadToggle.on animated:YES];
            
            [[UserSingleton sharedInstance] setDownloadsEnabled:downloadToggle.on];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadsEnabledNotification" object:nil];
            
            //NOTE this caused the nav bar button to become unresponsive
            [tableView beginUpdates];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView endUpdates];
            
        }
        
        //LINK CLOUD STORAGE
        else
        {
            /*
            NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:@"DropboxAppKey"];
            NSString *secret = [[NSUserDefaults standardUserDefaults] objectForKey:@"DropboxSecret"];
            if ([key length] <= 0 || [secret length] <= 0) {
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate showAlertBannerWithTitle:@"Dropbox App Key and Secret Needed" subtitle:@"Go to dropbox.com/developers and create a new app. See What.CD forums for instructions." style:ALAlertBannerStyleNotify];
                return;
            }
             */
            
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            if ([[GoogleDrive sharedDrive] isAuthorized])
            {
                if ([[GoogleDrive sharedDrive] unauthorize])
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"GoogleDriveLinkageChanged" object:nil];
                else
                    [appDelegate showAlertBannerWithTitle:@"Couldn't Deauthorize Google Drive" subtitle:@"Please try again in a few minutes." style:ALAlertBannerStyleFailure];
            }
            
            else {
                
                [(UINavigationController *)appDelegate.window.rootViewController pushViewController:[[GoogleDrive sharedDrive] createAuthController] animated:YES];
                //[[Dropbox sharedBox] linkFromController:self.parentController];
            }
        }
        
    }
    
    [[UserSingleton sharedInstance] saveData];

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.parentController scrollViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.parentController scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

#pragma mark - UIActionSheet Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        NSLog(@"%i", buttonIndex);
        [[UserSingleton sharedInstance] setForumOpenTo:buttonIndex];
        [[UserSingleton sharedInstance] saveData];
        
        SettingsGroup *forumGroup = [self.tableData objectAtIndex:1];
        PickerObject *forumPagePicker = [forumGroup.settingsObjects objectAtIndex:0];
        forumPagePicker.selectedOption = ([[UserSingleton sharedInstance] forumOpenToOptions])[[UserSingleton sharedInstance].forumOpenTo];
        
        [self beginUpdates];
        [self reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:actionSheet.tag]] withRowAnimation:UITableViewRowAnimationFade];
        [self endUpdates];
    }
}


#pragma mark - Text View

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return textView.text.length + (text.length - range.length) <= textFieldMaximumCharacters;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [[UserSingleton sharedInstance] setSignature:textView.text];
    [[UserSingleton sharedInstance] saveData];
}

/*
# pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 1) {
        [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"DropboxAppKey"];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        //NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
        NSDictionary *infoPlist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        NSMutableArray *urlSchemes = [NSMutableArray arrayWithArray:[[[infoPlist objectForKey:@"CFBundleURLTypes"] objectAtIndex:0] objectForKey:@"CFBundleURLSchemes"]];
        if ([urlSchemes count] > 1) {
            [urlSchemes removeObjectAtIndex:1];
        }
        [urlSchemes addObject:textField.text];
        [infoPlist writeToFile:plistPath atomically:YES];
        NSLog(@"test");
    }
    else if (textField.tag == 2) {
        [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"DropboxSecret"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
 */

@end
