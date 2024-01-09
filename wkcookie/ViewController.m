//
//  ViewController.m
//  wkcookie
//
//  Created by bo cui on 2024/1/8.
//

#import "ViewController.h"
#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController ()

@property(weak, nonatomic) IBOutlet UILabel *policyLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refresh];
}

- (IBAction)openWebView:(id)sender {
    WebViewController *webvc = [[WebViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webvc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:^{
        ;
    }];
}

// set cookieAcceptPolicy = NSHTTPCookieAcceptPolicyNever, WKCookiePolicyDisallow
- (IBAction)setNever:(id)sender {
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyNever];
    if (@available(iOS 17.0, *)) {
        __weak typeof(self) weakself = self;
        [[[WKWebsiteDataStore defaultDataStore] httpCookieStore] setCookiePolicy:WKCookiePolicyDisallow completionHandler:^{
            [weakself refresh];
        }];
    } else {
        [self refresh];
    }
}

// set cookieAcceptPolicy = NSHTTPCookieAcceptPolicyOnlyFromMainDocumentDomain, WKCookiePolicyAllow
- (IBAction)setDomain:(id)sender {
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyOnlyFromMainDocumentDomain];
    if (@available(iOS 17.0, *)) {
        __weak typeof(self) weakself = self;
        [[[WKWebsiteDataStore defaultDataStore] httpCookieStore] setCookiePolicy:WKCookiePolicyAllow completionHandler:^{
            [weakself refresh];
        }];
    } else {
        [self refresh];
    }
}

- (IBAction)clearCookie:(id)sender {
// only clear cookie
//    WKHTTPCookieStore *cookieStore = [[WKWebsiteDataStore defaultDataStore] httpCookieStore];
//    [cookieStore getAllCookies:^(NSArray* cookies) {
//        for (NSHTTPCookie *cookie in cookies) {
//            [cookieStore deleteCookie:cookie completionHandler:nil];
//        }
//    }];
    
    // clear all data
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:date completionHandler:^{
    }];
}

- (void)refresh {
    NSHTTPCookieAcceptPolicy nsPolicy = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookieAcceptPolicy;
    if (@available(iOS 17.0, *)) {
        __weak typeof(self) weakself = self;
        [[[WKWebsiteDataStore defaultDataStore] httpCookieStore] getCookiePolicy:^(WKCookiePolicy policy) {
            weakself.policyLabel.text = [NSString stringWithFormat:@"NS:%ld  WK:%ld", nsPolicy, policy];
        }];
    } else {
        self.policyLabel.text = [NSString stringWithFormat:@"NS:%ld  WK:-", nsPolicy];
    }
}

@end
