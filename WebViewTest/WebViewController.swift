//
//  ViewController.swift
//  WebViewTest
//
//  Created by Dmitry Kuznetsov on 11/04/2019.
//  Copyright © 2019 Dmitry Kuznetsov. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    
    var webView: WKWebView!
    var eventFunctions : Dictionary<String, (String)->Void> = Dictionary<String, (String)->Void>()
    let events: Array<String> = ["finishCCreditCard", "documentReady", "callbackHandler"]
    
    private func setupWebView() {
        let contentController = WKUserContentController()
        let userScript = WKUserScript(
            source: "mobileHeader()",
            injectionTime: WKUserScriptInjectionTime.atDocumentEnd,
            forMainFrameOnly: true
        )
        contentController.addUserScript(userScript)
        contentController.add(self, name: "callbackHandler")
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        webView = WKWebView(frame: view.bounds, configuration: config)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("WebViewController load")
        
        self.setupWebView()
        view.addSubview(webView)
        
        let url = URL(string: "http://localhost:3080/")!
        webView.load(URLRequest(url: url))
        
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        toolbarItems = [refresh]
        navigationController?.isToolbarHidden = false
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }

    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("userContentController")
        if let contentBody = message.body as? String{
            if let eventFunction = eventFunctions[message.name]{
                eventFunction(contentBody)
            }
        }
        
        if(message.name == "callbackHandler") {
            print("Launch my Native Camera")
        }
    }
}

