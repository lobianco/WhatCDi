//
//  ReplyView.m
//  What
//
//  Created by What on 7/10/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "ReplyView.h"
#import "ReplyTableViewCell.h"
#import "ReplyNavBarView.h"

#define NAV_BAR_HEIGHT ([Constants iOSVersion] >= 7.0 ? 64.f : 44.f)

static CGFloat cIphone5TextHeight = 280.f;
static CGFloat cIphone4TextHeight = 190.f;

#define TEXT_FIELD_HEIGHT ([Constants deviceHasLargerScreen] ? cIphone5TextHeight : cIphone4TextHeight)

@interface ReplyView () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ReplyNavBarView *navBar;
@property (nonatomic, weak) UIButton *dismissKeyboardButton;

@end

@implementation ReplyView

/* 
 
 NOTE:
 
 Set scrollsToTop to NO for all subviews because otherwise it will disrupt the scroll to top functionality of the parent view
 
 */

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
                
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorFromHexString:cThreadCellEvenColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollsToTop = NO;
        [self addSubview:_tableView];
        
        _navBar = [[ReplyNavBarView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, NAV_BAR_HEIGHT)];
        [_navBar.titleLabel setText:@"Your Reply"];
        [_navBar.postButton addTarget:self action:@selector(post:) forControlEvents:UIControlEventTouchUpInside];
        [_navBar.cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_navBar];
    }
    
    return self;
}

-(void)post:(UIButton *)button
{    
    if (self.textView.text.length > 0) {
        [self.delegate postReply:self.textView.text];
        [self enableButtons:NO];
    }
}

- (void)postFailed {
    [self enableButtons:YES];
}

-(void)cancel:(UIButton *)button {    
    [self.delegate showReplyView:NO];
}

-(void)dismissKeyboard:(id)sender {
    [self partiallyHide:YES];
}

-(void)show:(BOOL)show
{
    //show for first time
    if (show)
    {
        [self enableButtons:YES];
        self.tableView.scrollEnabled = NO;
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [self setFrame:CGRectMake(0, 0.f, self.frame.size.width, self.frame.size.height)];
            
        } completion:^(BOOL finished) {
            
            [self setTextViewActive:YES];
            self.tableView.scrollEnabled = YES;
            
        }];
    }
    
    //dismiss completely
    else
    {
        [self enableButtons:NO];
        [self setTextViewActive:NO];
        self.tableView.scrollEnabled = NO;
        
        [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [self setFrame:CGRectMake(0, self.frame.size.height - NAV_BAR_HEIGHT + ([Constants iOSVersion] >= 7.0 ? 24.f : 4.f), self.frame.size.width, self.frame.size.height)];
            
        } completion:^(BOOL finished) {
            
            self.tableView.scrollEnabled = YES;
            [self.textView setText:@""];
            
        }];
    }
}

-(void)partiallyHide:(BOOL)hide
{
    if (hide)
    {
        [self enableButtons:NO];
        self.tableView.scrollEnabled = NO;
        [self setTextViewActive:NO];
        
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [self setFrame:CGRectMake(0, self.frame.size.height - NAV_BAR_HEIGHT - ([Constants iOSVersion] >= 7.0 ? 20.f : 40.f), self.frame.size.width, self.frame.size.height)];
            self.alpha = 1;
            self.textView.alpha = 0.7f; //keep it at 0.1f so it still recognizes touches
            
        } completion:nil];
    }
    
    else
    {
        [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [self setFrame:CGRectMake(0, 0.f, self.frame.size.width, self.frame.size.height)];
            self.alpha = 1;
            self.textView.alpha = 1;
            
        } completion:^(BOOL finished) {
            
            [self enableButtons:YES];
            [self setTextViewActive:YES];
            self.tableView.scrollEnabled = YES;
            
        }];
    }
}

- (void)enableButtons:(BOOL)enable {
    self.navBar.postButton.enabled = enable;
    self.navBar.cancelButton.enabled = enable;
    self.dismissKeyboardButton.enabled = enable;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.dismissKeyboardButton.alpha = enable ? 1.f : 0.f;
    } completion:nil];
}

-(void)setTextViewActive:(BOOL)active
{
    if (self.textView)
    {
        if (active)
            [self.textView becomeFirstResponder];
        
        else
            [self.textView resignFirstResponder];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return (sizeof(menuItems) / sizeof(menuItems[0]));
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ReplyCellIdentifier = @"ReplyCellIdentifier";
    ReplyTableViewCell *cell = (ReplyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ReplyCellIdentifier];
    
    if (cell == nil) {
        cell = [[ReplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReplyCellIdentifier];
    }
    
    self.textView = cell.inputTextView;
    self.textView.delegate = self;
    self.textView.scrollsToTop = NO;
    
    [cell.dismissKeyboard addTarget:self action:@selector(dismissKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    self.dismissKeyboardButton = cell.dismissKeyboard;
    
    return cell;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return NAV_BAR_HEIGHT;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TEXT_FIELD_HEIGHT;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"reply");
}

#pragma mark - Scroll View Delegate
/*
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{    
    if (self.tableView.contentOffset.y < (60 * -1))
    {        
        if (self.tableView.scrollEnabled)
            [self.delegate partiallyHideReplyView:YES];
    }
}
*/
#pragma mark - Text View

-(void)textViewDidBeginEditing:(UITextView *)textView
{    
    if (!self.tableView.scrollEnabled)
    {
        //[self.delegate partiallyHideReplyView:NO];
        [self partiallyHide:NO];
    }
}

@end
