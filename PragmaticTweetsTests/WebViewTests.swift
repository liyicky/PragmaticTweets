//
//  WebViewTests.swift
//  PragmaticTweets
//
//  Created by Jason Cheladyn on 8/23/16.
//  Copyright © 2016 Liyicky. All rights reserved.
//

import XCTest
@testable import PragmaticTweets

class WebViewTests: XCTestCase, UIWebViewDelegate {
    
    var loadedWebViewExpectation: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        XCTFail("Web View load failed")
        loadedWebViewExpectation?.fulfill()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        if let webViewContents = webView.stringByEvaluatingJavaScriptFromString("document.documentElement.textContent")
            where webViewContents != "" {
            loadedWebViewExpectation?.fulfill()
        }
        
    }
    
    func testWebviewLoaded() {
        guard let viewController = UIApplication.sharedApplication().windows[0].rootViewController as? ViewController
            else {
                XCTFail("Couldn't get root view controller")
                return
            }
        viewController.twitterWebView.delegate = self
        loadedWebViewExpectation = expectationWithDescription("Web View auto-load test")
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
}
