# WKCookieTest
WKWebView cookie test

测试wkwebview的cookie逻辑。
blog地址：http://t.csdnimg.cn/IhzjR

===============================

使用WKWebView框架开发h5的APP时，访问h5页面不携带Cookie。

经过定位，发现问题是在使用AFNetworking访问时禁用了cookie：

[[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyNever];
NSHTTPCookieStorage的cookie策略状态是持久化存储的，在不删除APP的情况下，他会始终保持原来的策略。所以即便删除上述代码，更新APP，NSHTTPCookieStorage的cookie策略依然不会改变。

如果需要在不删除当前APP的情况下更改策略，只能再次执行设置策略的代码以更新策略，更新为NSHTTPCookieAcceptPolicyOnlyFromMainDocumentDomain(这是NSHTTPCookieStorage的默认策略)，建议在APP启动时执行：

[[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyOnlyFromMainDocumentDomain];
更新后，NSHTTPCookieStorage的cookie策略成功改变，但是WKWebView依然不携带cookie。

查询文档，发现ios17之后，WKWebView有独立的cookie管理机制。在设置关闭NSHTTPCookieStorage的cookie策略后(NSHTTPCookieAcceptPolicyNever)，WKWebView的cookie策略也会被关闭。但是重新设置打开NSHTTPCookieStorage的策略(NSHTTPCookieAcceptPolicyOnlyFromMainDocumentDomain)，并不会同时打开WKWebView的cookie策略。

需要通过如下代码打开WKWebView的cookie策略：

if (@available(iOS 17.0, *)) {
    [[[WKWebsiteDataStore defaultDataStore] httpCookieStore] setCookiePolicy:WKCookiePolicyAllow completionHandler:^{
    }];
}
这样在iOS 17上，WKWebView就可以正常携带cookie了。

但是在iOS 17之前的版本，cookie策略仍然有问题，而且似乎不仅仅是cookie策略的问题。我没有找到有效的办法解决这个问题。这里是关于cookie测试的demo，包含了用于设置和获取cookie的web页面（注意，访问时需要通过浏览器的请求头查看是否携带cookie，web页面的get cookie按钮工作正常，也不能代表请求正确携带了cookie）：

https://github.com/zcsoft/WKCookieTest

欢迎有兴趣解决这个问题的同学继续提供解决方案。

# 最后，重点，如果页面需要嵌入wkwebview使用，那就尽量不要使用cookie。
