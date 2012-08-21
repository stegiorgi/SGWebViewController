//
//  SGWebViewController.m
//  iUniversity
//
//  Created by Michele Amati on 6/14/12.
//  Copyright (c) 2012 Apex-net srl. All rights reserved.
//

#import "SGWebViewController.h"

@interface SGWebViewController ()

@property (nonatomic, retain) UIWebView *webview;
// Loading hud
@property (nonatomic, retain) MBProgressHUD *HUD;

@end


@implementation SGWebViewController


@synthesize webview = _webview;
@synthesize HUD = _HUD;

- (id)init
{
    return [self initWithNibName:nil bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.webview = [[UIWebView alloc] init];
    }
    return self;
}

- (void)test
{
    NSLog(@"test",nil);
}

- (void)loadView
{
    if (!self.webview) {
        self.webview = [[UIWebView alloc] init];
    }
    self.webview.dataDetectorTypes = UIDataDetectorTypeNone;
    self.webview.scrollView.backgroundColor = [UIColor grayColor];
    self.webview.delegate = self;
    self.view = self.webview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.webview stopLoading];
    self.webview.delegate = nil;
    [self.HUD hide:NO];
    self.HUD.delegate = nil;
    [super viewWillDisappear:animated];
}

#pragma mark - Public

- (void)loadChartWithHTML:(NSString *)html senchaBundleURL:(NSString *)bundle
{
    [self.webview loadHTMLString:html baseURL:[NSURL URLWithString:bundle]];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // The "signal" indicating the chart has being loaded, a call to the url "callback:..."
    if ([request.URL.scheme isEqualToString:@"callback"]) {
        [self.HUD hide:YES];
        return NO;
    }
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error 
{
    NSLog(@"%@",[error description]);
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // Showing a wait HUD
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.HUD.labelText = NSLocalizedString(@"Please wait", nil);
    self.HUD.removeFromSuperViewOnHide = YES;
    self.HUD.opacity = 0.7;
    [self.view addSubview:self.HUD];
    [self.HUD show:YES];
}

@end
