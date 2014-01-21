//
//  ALSectionHeaderView.h
//  What
//
//  Created by What on 7/15/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategorySectionHeaderView.h"
#import "ArtistTableViewController.h"

@protocol SectionHeaderViewDelegate;

@interface ArtistSectionHeaderView : CategorySectionHeaderView

@property (nonatomic, weak) id <SectionHeaderViewDelegate> delegate;

@property (nonatomic) NSInteger section;

-(void)toggleOpenWithUserAction:(BOOL)userAction;

@end


/*
 Protocol to be adopted by the section header's delegate; the section header tells its delegate when the section should be opened and closed.
 */
@protocol SectionHeaderViewDelegate <NSObject, UIGestureRecognizerDelegate>

@optional
-(void)collapseOrExpandCellsInSection:(NSInteger)section;
//-(void)sectionHeaderView:(ALSectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)sectionOpened;
//-(void)sectionHeaderView:(ALSectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)sectionClosed;

@end