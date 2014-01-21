//
//  MenuTable.m
//  What
//
//  Created by What on 6/27/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "MenuTable.h"
#import "AppDelegate.h"

@interface MenuTable () {
    @private
    AppDelegate *appDelegate;
}

@end

@implementation MenuTable

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
        
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    
    return self;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if (CGRectContainsPoint(self.menuTableFooter.frame, [[touches anyObject] locationInView:self]))
        [self.parentController performSelector:@selector(pushSettings)];
    
    [self.nextResponder touchesEnded:touches withEvent:event];
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
    
    return appDelegate.navigationControllers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:[UIColor colorFromHexString:cMenuTableBackgroundSelectedColor]]];
        cell.textLabel.textColor = [UIColor colorFromHexString:cMenuTableFontColor];
    }
    
    //[cell.textLabel setText:menuItems[indexPath.row]];
    [cell.textLabel setText:[appDelegate.navigationControllerNames objectAtIndex:indexPath.row]];
    
    
    return cell;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainNavigationController *nav = [appDelegate.navigationControllers objectAtIndex:indexPath.row];
    appDelegate.visibleNavigationController = nav;
    [appDelegate.sidePanelController setCenterViewController:nav withFullCloseAnimation:YES completion:nil];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.parentController scrollViewWillBeginDragging:scrollView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.parentController scrollViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.parentController scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

@end
