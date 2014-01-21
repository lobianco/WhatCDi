//
//  SearchResultsController.m
//  What
//
//  Created by What on 7/26/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "PaginatorTableViewController.h"
#import "UIBarButtonItem+Tools.h"
#import "PaginatorFooterView.h"

@interface PaginatorTableViewController ()

@property (nonatomic, strong) PaginatorFooterView *footerView;

@property (nonatomic, strong) UILabel *footerLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) int previousNumberOfRows;

@end

@implementation PaginatorTableViewController

- (id)init
{
    if ( (self=[super init]) )
    {
        self.title = NSLocalizedString(@"Search", @"Search");
    }
    
    return self;
}

- (void)dealloc {
    NSLog(@"paginator dealloc");
    _paginator = nil;
    _footerView = nil;
    _activityIndicator = nil;
    _footerLabel = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
        
    [self setupTableViewFooter];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}

- (void)setupTableViewFooter
{
    self.footerView = [[PaginatorFooterView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, 40.f)];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, self.footerView.frame.size.height)];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [UIColor colorFromHexString:cMenuTableFontColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.shadowColor = [UIColor colorFromHexString:@"82817f"];
    label.shadowOffset = CGSizeMake(0, 1);
    
    self.footerLabel = label;
    [self.footerView addSubview:label];
    
    // set up activity indicator
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicatorView.center = CGPointMake(40, (self.footerView.frame.size.height/2));
    activityIndicatorView.hidesWhenStopped = YES;
    
    self.activityIndicator = activityIndicatorView;
    [self.footerView addSubview:activityIndicatorView];
    
    self.tableView.tableFooterView = nil;
    self.previousNumberOfRows = 0;
}

- (void)updateTableViewFooter
{
    if ([self.paginator.results count] != 0)
    {
        self.footerLabel.text = [NSString stringWithFormat:@"Page %d out of %d", self.paginator.page, self.paginator.pageTotal];
    } else
    {
        self.footerLabel.text = @"";
    }
    
    [self.footerLabel setNeedsDisplay];
}

#pragma mark - Table View Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.paginator.results count];
}

#pragma mark - Custom Methods

- (void)fetchNextPage
{
    [self.paginator fetchNextPage];
    [self.activityIndicator startAnimating];
}

-(void)paginator:(id)paginator didReceiveResults:(NSArray *)results
{
    [self updateTableViewFooter];
    [self.activityIndicator stopAnimating];
    
    NSMutableArray *userIndexPaths = [[NSMutableArray alloc] init];
    NSInteger i = [self.paginator.results count] - [results count];
    
    for (NSDictionary *result in results)
    {
        [userIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        i++;
    }
    
    NSMutableArray *rowsToDelete = [NSMutableArray new];
    for (int i = 0; i < self.previousNumberOfRows; i++) {
        [rowsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [self.tableView beginUpdates];
    if (!self.tableView.tableFooterView)
        self.tableView.tableFooterView = self.footerView;
    if (rowsToDelete.count > 0) {
        self.previousNumberOfRows = 0;
        [self.tableView deleteRowsAtIndexPaths:rowsToDelete withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.tableView insertRowsAtIndexPaths:userIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
    if (self.loaderIsShowing)
        [self hideLoadingView];
}

- (void)paginatorDidFailToRespond:(id)paginator {
    [self.activityIndicator stopAnimating];
    if (self.loaderIsShowing)
        [self hideLoadingView];
}

-(void)paginatorDidReset:(id)paginator {
    if ([self.tableView numberOfRowsInSection:0] > 0) {
        self.previousNumberOfRows = [self.tableView numberOfRowsInSection:0];
    }
    [self updateTableViewFooter];
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [super scrollViewDidScroll:scrollView];
    
    // when reaching bottom, load a new page
    if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.bounds.size.height)
    {
        // ask next page only if we haven't reached last page
        if(![self.paginator reachedLastPage])
        {
            // fetch next page of results
            [self fetchNextPage];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
