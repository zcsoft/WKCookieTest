//
//  WebViewController.m
//  wkcookie
//
//  Created by bo cui on 2024/1/8.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController () <WKNavigationDelegate>

@property (nonatomic, strong)  WKWebView *webView;
@property (strong, nonatomic) NSString *url;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webView.navigationDelegate = self;
    if (@available(iOS 16.4, *)) {
        self.webView.inspectable = YES;
    }
    [self.view addSubview:self.webView];

    // 关闭
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"close" style:UIBarButtonItemStyleDone target:self action:@selector(itemCloseAction)];
    [closeButton setTintColor:[UIColor blackColor]];
    UIBarButtonItem *loadButton = [[UIBarButtonItem alloc] initWithTitle:@"load" style:UIBarButtonItemStyleDone target:self action:@selector(itemLoadAction)];
    [closeButton setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItems = @[closeButton, loadButton];
}

- (void)itemCloseAction {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)itemLoadAction {
    [self updateWebView];
}

#pragma mark - Web View Methods

- (void) updateWebView {
    // The content of this url is the same as tcookie.html
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://szy.haohaikj.cn/tcookie"]];
    //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    [self.webView loadRequest:request];
}

- (void)webView:(WKWebView *)webView
decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
    decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView
didFailNavigation:(WKNavigation *)navigation
        withError:(NSError *)error {
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
}

@end
