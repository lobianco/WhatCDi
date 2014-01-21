//
//  SecondViewController.m
//  What
//
//  Created by What on 4/24/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "LoginTableViewController.h"
//#import "LoginView.h"
#import "HTTPRequestSingleton.h"
#import "JSONRequestSingleton.h"
#import "UIApplication+AppDimensions.h"
#import "AppDelegate.h"
#import "API.h"
#import "UserSingleton.h"

@interface LoginTableViewController () <UIGestureRecognizerDelegate>
{
    @private
    UITextField *emailText;
    UITextField *passText;
    UIImageView *sloganView;
}

@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UIImageView *rippyView;
@property (nonatomic, strong) UITableView *loginTable;

@property (nonatomic, strong) UILabel *sslLabel;
@property (nonatomic, strong) UIImageView *sslCheckbox;
@property (nonatomic, strong) UIButton *sslButton;

@property (nonatomic) BOOL loggingIn;

@end

@implementation LoginTableViewController


- (id)init
{
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Login", @"Login");
    }
    return self;
}

/*
-(void)loadView
{
    LoginView *v = [[LoginView alloc] initWithFrame:CGRectMake(0, 0, [UIApplication currentSize].width, [UIApplication currentSize].height)];
    self.view = v;
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.view setBackgroundColor:[UIColor colorFromHexString:cMenuTableBackgroundColor]];
    self.loggingIn = NO;
    
    UIImage *logo = [UIImage imageNamed:@"../Images/logo.png"];
    self.logoView = [[UIImageView alloc] initWithImage:logo];
    [self.logoView setFrame:CGRectMake((self.view.frame.size.width / 2) - (logo.size.width / 2),(self.view.frame.size.height/2) - (logo.size.height/2),logo.size.width,logo.size.height)];
    [self.view addSubview:self.logoView];
    
    UIImage *rippyUpsideDown = [UIImage imageNamed:@"../Images/rippy_upside-down.png"];
    self.rippyView = [[UIImageView alloc] initWithImage:rippyUpsideDown];
    [self.rippyView setFrame:CGRectMake((self.view.frame.size.width/2) - (rippyUpsideDown.size.width/2), (rippyUpsideDown.size.height * -2), rippyUpsideDown.size.width, rippyUpsideDown.size.height)];
    self.rippyView.alpha = 0;
    [self.view addSubview:self.rippyView];
        
    CGFloat tableViewWidth = 260;
    CGFloat tableViewHeight = 80;
    self.loginTable = [[UITableView alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 2) - (tableViewWidth / 2), (self.view.frame.size.height / 2) - (tableViewHeight / 2), tableViewWidth, tableViewHeight) style:UITableViewStylePlain];
    self.loginTable.backgroundView = nil;
    [self.loginTable setBackgroundColor:[UIColor colorFromHexString:cMenuTableBackgroundSelectedColor]];
    self.loginTable.dataSource = self;
    self.loginTable.delegate = self;
    self.loginTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.loginTable setSeparatorColor:[UIColor colorFromHexString:@"4f4e4c"]];
    self.loginTable.scrollEnabled = NO;
    self.loginTable.alpha = 0.f;
    [self.view addSubview:self.loginTable];
    
    if ([self.loginTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.loginTable setSeparatorInset:UIEdgeInsetsZero];
    }
    
    CGFloat buttonPadding = 5.f;
    UIImage *checkbox = [UserSingleton sharedInstance].useSSL ? [UIImage imageNamed:@"../Images/sslBoxChecked.png"] : [UIImage imageNamed:@"../Images/sslBox.png"];
    self.sslCheckbox = [[UIImageView alloc] initWithImage:checkbox];
    self.sslCheckbox.frame = CGRectMake(self.loginTable.frame.origin.x + buttonPadding, self.loginTable.frame.origin.y + self.loginTable.frame.size.height + CELL_PADDING, checkbox.size.width, checkbox.size.height);
    self.sslCheckbox.alpha = 0.f;
    [self.view addSubview:self.sslCheckbox];
    
    self.sslLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.sslCheckbox.frame.origin.x + self.sslCheckbox.frame.size.width + buttonPadding, self.sslCheckbox.frame.origin.y, 94.f, self.sslCheckbox.frame.size.height)];
    self.sslLabel.textAlignment = NSTextAlignmentLeft;
    self.sslLabel.textColor = [UIColor colorFromHexString:cMenuTableFontColor];
    self.sslLabel.backgroundColor = [UIColor clearColor];
    self.sslLabel.font = [Constants appFontWithSize:12.f bolded:YES];
    self.sslLabel.alpha = 0.f;
    self.sslLabel.text = @"SSL Connection";
    [self.view addSubview:self.sslLabel];

    self.sslButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sslButton.adjustsImageWhenHighlighted = YES;
    self.sslButton.layer.cornerRadius = 4.f;
    self.sslButton.layer.masksToBounds = YES;
    self.sslButton.clipsToBounds = YES;
    [self.sslButton addTarget:self action:@selector(sslButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.sslButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25f]] forState:UIControlStateHighlighted];
    self.sslButton.frame = CGRectMake(self.sslCheckbox.frame.origin.x - buttonPadding, self.sslCheckbox.frame.origin.y - buttonPadding, self.sslCheckbox.frame.size.width + self.sslLabel.frame.size.width + buttonPadding*3, self.sslCheckbox.frame.size.height + buttonPadding*2);
    self.sslButton.alpha = 0.f;
    [self.view addSubview:self.sslButton];
    
    
    UIImage *slogan = [UIImage imageNamed:@"../Images/slogan.png"];
    sloganView = [[UIImageView alloc] initWithImage:slogan];
    sloganView.alpha = 0.f;
    [sloganView setFrame:CGRectMake((self.view.frame.size.width / 2) - (slogan.size.width / 2), self.view.frame.size.height - slogan.size.height, slogan.size.width, slogan.size.height)];
    [self.view addSubview:sloganView];
    
    /*
    [UIView animateWithDuration:1.5f delay:0 options:(UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction) animations:^{
        [sloganView setAlpha:0.2];
    } completion:nil];
     */
    
    UITapGestureRecognizer *tapSlogan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedSlogan:)];
    tapSlogan.delegate = self;
    [self.view addGestureRecognizer:tapSlogan];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    swipe.delegate = self;
    [self.view addGestureRecognizer:swipe];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return !([touch.view isKindOfClass:[UIControl class]]);
}

-(void)sslButtonTapped:(id)sender
{
    if (!self.loggingIn) {
        [UserSingleton sharedInstance].useSSL = ![UserSingleton sharedInstance].useSSL;
        [[UserSingleton sharedInstance] saveData];
        
        UIImage *sslImage = [UserSingleton sharedInstance].useSSL ? [UIImage imageNamed:@"../Images/sslBoxChecked.png"] : [UIImage imageNamed:@"../Images/sslBox.png"];
        CGFloat alpha = [UserSingleton sharedInstance].useSSL ? 0.75f : 0.25f;
        
        [UIView transitionWithView:self.sslCheckbox
                          duration:0.2f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.sslCheckbox.image = sslImage;
                            self.sslCheckbox.alpha = alpha;
                            self.sslLabel.alpha = alpha;
                        } completion:NULL];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissSelf) name:kLoggedInNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self initialAnimation];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)initialAnimation
{
    CGFloat sslAlpha = [UserSingleton sharedInstance].useSSL ? 0.75f : 0.25f;
    
    CGFloat logoY = [Constants deviceHasLargerScreen] ? 110.f : 90.f;
    if ([Constants iOSVersion] >= 7.0)
        logoY += 20.f;
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.logoView.frame = CGRectMake(self.logoView.frame.origin.x, logoY, self.logoView.frame.size.width, self.logoView.frame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.loginTable.alpha = 1.f;
            self.sslButton.alpha = 1.f;
            sloganView.alpha = 0.2f;
            
            self.sslCheckbox.alpha = sslAlpha;
            self.sslLabel.alpha = sslAlpha;
        } completion:nil];
    }];
    
    if ([Constants iOSVersion] < 7.0) {
        self.rippyView.alpha = 1;
        [UIView animateWithDuration:0.3 delay:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.rippyView.frame = CGRectMake(self.rippyView.frame.origin.x, 0, self.rippyView.frame.size.width, self.rippyView.frame.size.height);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 delay:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.rippyView.frame = CGRectMake(self.rippyView.frame.origin.x, (self.rippyView.image.size.height * -2), self.rippyView.frame.size.width, self.rippyView.frame.size.height);
            } completion:^(BOOL finished) {
                self.rippyView.alpha = 0;
            }];
        }];
    }
}

-(void)swiped:(UISwipeGestureRecognizer *)gesture
{
    if (gesture.direction != UISwipeGestureRecognizerDirectionDown)
        return;
    
    [self.view endEditing:YES];
}

-(void)tappedSlogan:(UITapGestureRecognizer *)gesture
{
    
    CGPoint touch = [gesture locationInView:self.view];
    CGRect sloganFrame = sloganView.frame;
    
    if (CGRectContainsPoint(sloganFrame, touch))
    {
        NSLog(@"slogan touched");
    }
}

#pragma mark - Table View Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"]; //autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        cell.textLabel.textColor = [UIColor colorFromHexString:@"f8f6f4"];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        
        [cell.contentView addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"../Images/loginCellShadow.png"]]];
        
        if ([indexPath section] == 0)
        {
            UITextField *inputText = [[UITextField alloc] initWithFrame:CGRectMake(100, 5, 190, 30)];
            inputText.adjustsFontSizeToFitWidth = YES;
            inputText.delegate = self;
            inputText.backgroundColor = [UIColor clearColor];
            inputText.autocorrectionType = UITextAutocorrectionTypeNo;
            inputText.clearButtonMode = UITextFieldViewModeWhileEditing;
            inputText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            inputText.autocapitalizationType = UITextAutocapitalizationTypeNone;
            inputText.textAlignment = UITextAlignmentLeft;
            inputText.textColor = [UIColor colorFromHexString:@"dcdad6"];
            inputText.font = [Constants appFontWithSize:14.f];
            
            switch ([indexPath row]) {
                case 0:
                    cell.textLabel.text = @"Username";
                    
                    inputText.keyboardType = UIKeyboardTypeEmailAddress;
                    
                    if ([[UserSingleton sharedInstance] saveCredentials])
                        [inputText setText:[[UserSingleton sharedInstance] usernameCredential]];
                    
                    if (inputText.text.length <= 0) {
                        if ([inputText respondsToSelector:@selector(setAttributedPlaceholder:)]) {
                            inputText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: [UIColor colorFromHexString:@"dcdad6" alpha:0.5]}];
                        }
                    }
                    
                    emailText = inputText;
                    break;
                    
                case 1:
                    cell.textLabel.text = @"Password";
                    
                    inputText.keyboardType = UIKeyboardTypeDefault;
                    inputText.returnKeyType = UIReturnKeyGo;
                    inputText.secureTextEntry = YES;
                    
                    if ([[UserSingleton sharedInstance] saveCredentials])
                        [inputText setText:[[UserSingleton sharedInstance] passwordCredential]];
                    
                    if (inputText.text.length <= 0) {
                        if (inputText.text.length <= 0) {
                            if ([inputText respondsToSelector:@selector(setAttributedPlaceholder:)]) {
                                inputText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Required" attributes:@{NSForegroundColorAttributeName: [UIColor colorFromHexString:@"dcdad6" alpha:0.5]}];
                            }
                        }
                    }
                    
                    passText = inputText;
                    break;
                    
                default:
                    break;
            }
            
            [cell.contentView addSubview:inputText];
            
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:tableView.backgroundColor];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self performLogin];
    
    return YES;
}

-(void)performLogin
{
    if (!self.loggingIn) {
        
        self.loggingIn = YES;
        
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:emailText.text, @"username", passText.text, @"password", [NSNumber numberWithInt:1], @"keeplogged", nil];
        
        NSURLRequest *request = [[HTTPRequestSingleton sharedClient] requestWithMethod:@"POST" path:@"/login.php" parameters:params];
        
        AFHTTPRequestOperation *loginOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [loginOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            //if index.php, login was successful
            //if login.php, login failed
            
            if ([[operation.response.URL.pathComponents objectAtIndex:1] isEqualToString:@"index.php"])
            {
                
                if ([[UserSingleton sharedInstance] saveCredentials])
                {
                    NSLog(@"saved credentials");
                    
                    [[UserSingleton sharedInstance] setUsernameCredential:emailText.text];
                    [[UserSingleton sharedInstance] setPasswordCredential:passText.text];
                    [[UserSingleton sharedInstance] saveData];
                }
                
                //save cookie
                [self saveCookie];
                [self loadIndexAndUserData];
                
            }
            
            //too many login attempts, or site could be down
            else
            {
                NSLog(@"login failure after success");
                self.loggingIn = NO;
                [appDelegate showAlertBannerWithTitle:@"Login Attempt Unsuccessful" subtitle:@"The website could be down or you might have made too many login attempts recently. Try again later." style:ALAlertBannerStyleFailure];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [appDelegate showFailureAlertBannerWithError:error];
            
            self.loggingIn = NO;
            
            NSLog(@"login failure here: %@", error);
            NSLog(@"headers: %@", [operation.response allHeaderFields]);
        }];
        
        [[[HTTPRequestSingleton sharedClient] operationQueue] addOperation:loginOperation];
    }
}

-(void)saveCookie
{
    NSMutableDictionary *cookieDictionary = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:COOKIE_KEY]];
    if (!cookieDictionary)
        cookieDictionary = [NSMutableDictionary new];
    
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[UserSingleton sharedInstance].useSSL ? [NSURL URLWithString:cHostNameSSL] : [NSURL URLWithString:cHostName]];
    
    for (NSHTTPCookie *cookie in cookies)
    {
        [cookieDictionary setValue:[NSDictionary dictionaryWithDictionary:cookie.properties] forKey:[UserSingleton sharedInstance].useSSL ? cHostNameSSL : cHostName];
        [[NSUserDefaults standardUserDefaults] setObject:cookieDictionary forKey:COOKIE_KEY];
        
        NSLog(@"%@", cookieDictionary);
    }
}

-(void)loadIndexAndUserData
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate loadIndexAndUserData];
}

- (void)dismissSelf {
    NSLog(@"sequence completed, closing login screen");
    [self dismissViewControllerAnimated:YES completion:^{
        self.loggingIn = NO;
    }];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)keyboardWillAppear:(NSNotification *)note
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, -80); //216 == keyboard height
    } completion:^(BOOL finished) {
        
    }];
}

-(void)keyboardWillHide:(NSNotification *)note
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, 0); //216 == keyboard height
    } completion:^(BOOL finished) {
        
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
