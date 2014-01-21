//
//  ThreadViewCell.m
//  What
//
//  Created by What on 5/2/13.
//  Copyright (c) 2013 What. All rights reserved.
//

#import "ThreadTableViewCell.h"
//#import "NIAttributedLabel+Height.h"
#import "NSAttributedString+Tools.h"
#import "UIColor+Tools.h"
#import "MyHTMLParser.h"
#import "NSString+HTML.h"
#import "UserSingleton.h"

NSString * const quoteColor[1] = {
    [0] = @"220,218,216",
};

@interface ThreadTableViewCell () <UIWebViewDelegate> {
    @private
    int webViewLoads;
}

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSString *bgColorHex;
@property (nonatomic) BOOL shouldDynamicallyReloadHeight;

@end

@implementation ThreadTableViewCell

+ (void)initialize {
	//'warm up' webkit
	UIWebView *dummy = [[UIWebView alloc] init];
    [dummy loadHTMLString:@"<html><body>TEST STRING</body></html>" baseURL:nil];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        webViewLoads = 0;
        
        if (!_webView) {
            _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, 1.f)];
            _webView.delegate = self;
            _webView.backgroundColor = [UIColor clearColor];
            _webView.opaque = NO;
            _webView.alpha = 0.f;
            _webView.scrollView.scrollsToTop = NO;
            _webView.scrollView.scrollEnabled = NO;
            [self.contentView addSubview:_webView];
        }
    }
    return self;
}

- (void)dealloc {
    NSLog(@"thread cell dealloc");
    
    _delegate = nil;
    _content = nil;
    _webView.delegate = nil;
    [_webView removeFromSuperview];
    _webView = nil;
    _bgColorHex = nil;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.webView.alpha = 0;
    self.webView.delegate = nil;
    self.content = nil;
    self.shouldDynamicallyReloadHeight = NO;
}

- (void)updateContent:(WCDPostContent *)content shouldDynamicallyReloadHeight:(BOOL)reload {
    self.webView.delegate = self;
    self.content = content;
    self.shouldDynamicallyReloadHeight = reload;
    
    NSString *contentCopy = [NSString stringWithString:content.htmlBody];
    contentCopy = [ThreadTableViewCell formatHTML:contentCopy forPreload:NO];
    
    NSString *extraCss = [NSString stringWithFormat:
@"body { background-color: #%@ } \
blockquote { background-color: rgba(%@,0.6); } \
a { color: #%@; }", self.bgColorHex, quoteColor[0], cCyanColor];
    
    contentCopy = [contentCopy stringByReplacingOccurrencesOfString:@"{%content_style2%}" withString:extraCss];
    //NSLog(@"unformatted: %@", contentCopy);
    
    [self.webView loadHTMLString:contentCopy baseURL:[UserSingleton sharedInstance].useSSL ? [NSURL URLWithString:cHostNameSSL] : [NSURL URLWithString:cHostName]];
}

+ (NSString *)formatHTML:(NSString *)html forPreload:(BOOL)preload {
    NSString *htmlCopy = [NSString stringWithString:html];
    
    //regex searches for 2 or more <br>'s (with or without slash and with or without whitespace) and replaces them with <br /><br />
    NSRegularExpression *compactLineBreaks = [NSRegularExpression regularExpressionWithPattern:@"(<br\\ ?\\/?>\\s*){2,}" options:NSRegularExpressionCaseInsensitive error:nil];
    htmlCopy = [compactLineBreaks stringByReplacingMatchesInString:htmlCopy options:0 range:NSMakeRange(0, htmlCopy.length) withTemplate:@"<br /><br />"]; //if using backslashes, we need 4 backslashes (instead of two) to equate to one in the regex template
    
    NSRegularExpression *removeJSLinks = [NSRegularExpression regularExpressionWithPattern:@"<a[^>]*onclick[^>]*>(.*?)<\\/a>" options:NSRegularExpressionCaseInsensitive error:nil];
    htmlCopy = [removeJSLinks stringByReplacingMatchesInString:htmlCopy options:0 range:NSMakeRange(0, htmlCopy.length) withTemplate:@"$1"];
    
    //delay image loading
    NSRegularExpression *delayImages = [NSRegularExpression regularExpressionWithPattern:@"<img[^>]*src=(\"https?:\\/\\/.*?[^>]\")[^>]*\\/>" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *retinaLoaderURL = [Constants deviceHasRetinaScreen] ? @"http://whatcdios.com/images/resources/loading@2x.gif" : @"http://whatcdios.com/images/resources/loading@2x.gif";
    htmlCopy = [delayImages stringByReplacingMatchesInString:htmlCopy options:0 range:NSMakeRange(0, htmlCopy.length) withTemplate:[NSString stringWithFormat:@"<img class=\"load-delay\" src=\"%@\" data-original=$1 width=\"auto\" height=\"128\" />", retinaLoaderURL]];
    
    //find smileys and make them a little smaller
    NSRegularExpression *smallifySmileys = [NSRegularExpression regularExpressionWithPattern:@"<img[^>]*src=(\"static\\/common\\/smileys\\/.*?[^>]\")[^>]*\\/>" options:NSRegularExpressionCaseInsensitive error:nil];
    htmlCopy = [smallifySmileys stringByReplacingMatchesInString:htmlCopy options:0 range:NSMakeRange(0, htmlCopy.length) withTemplate:@"<img class=\"what-smiley\" src=$1 />"];
    
    NSString *templateFile = preload ? @"../Files/template_preload" : @"../Files/template";
    NSString *htmlTemplate = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:templateFile ofType:@"html"] encoding:NSUTF8StringEncoding error:nil];
    htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:@"{%content_body%}" withString:htmlCopy];
    
    //add default css
    htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:@"{%content_style1%}" withString:[ThreadTableViewCell cssFile]];
    
    return htmlTemplate;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    webViewLoads++;
    webView.alpha = 0.f;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    webViewLoads--;
    
    if (webViewLoads > 0) {
        return;
    }
    
    webView.scrollView.scrollEnabled = NO;
    webView.scrollView.scrollsToTop = NO;
    
    if (webView.alpha < 1.f) {
        [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction animations:^{
            webView.alpha = 1.f;
        } completion:nil];
    }
    
    //a convoluted way to get the proper height for UIWebView - read more: http://stackoverflow.com/a/13096183/969967
    CGRect frame = webView.frame;
    frame.size = CGSizeMake(self.webView.frame.size.width, 1);
    webView.frame = frame;
    frame.size.height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    webView.frame = frame;
    
    CGRect selfFrame = self.frame;
    selfFrame.size.height = frame.size.height;
    self.frame = selfFrame;
    
    if (self.shouldDynamicallyReloadHeight) {
        if (selfFrame.size.height != self.content.cellHeight) {
            NSLog(@"old: %ld    new: %f", (long)self.content.cellHeight, selfFrame.size.height);
            self.content.cellHeight = selfFrame.size.height;
            [NSObject cancelPreviousPerformRequestsWithTarget:[self class]];
            [[self class] performSelector:@selector(refreshParentTable:) withObject:self afterDelay:0.2];
        }
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [self.delegate openLink:request.URL];
        return NO;
    }
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    webViewLoads--;
}

+ (void)refreshParentTable:(ThreadTableViewCell *)cell {
    UITableView *tableView = [Constants iOSVersion] >= 7.0 ? (UITableView*)cell.superview.superview : (UITableView*)cell.superview;

    dispatch_async(dispatch_get_main_queue(), ^{
        [tableView beginUpdates];
        [tableView endUpdates];
    });
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WebViewLoaded" object:cell];
}

+ (NSString *)cssFile {
    
    static NSString *cssFile;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cssFile = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"../Files/forumStyles" ofType:@"css"] encoding:NSUTF8StringEncoding error:NULL];
    });
    return cssFile;
}

-(void)setColorHex:(NSString *)colorHex {
    self.bgColorHex = colorHex;
    self.contentView.backgroundColor = [UIColor colorFromHexString:colorHex];    
}

@end
