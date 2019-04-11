import Foundation
import WebKit

class WKWebViewWrapper : NSObject, WKScriptMessageHandler{
    
    var wkWebView : WKWebView
    var eventFunctions : Dictionary<String, (String)->Void> = Dictionary<String, (String)->Void>()
    let events: Array<String> = ["finishCCreditCard", "documentReady", "callbackHandler"]
    
    init(forWebView webView : WKWebView){
        wkWebView = webView
        super.init()
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let contentBody = message.body as? String{
            if let eventFunction = eventFunctions[message.name]{
                eventFunction(contentBody)
            }
        }
        
        if(message.name == "callbackHandler") {
            print("Launch my Native Camera")
        }
    }
    
    func setUpPlayerAndEventDelegation(){
        
        let controller = WKUserContentController()
        wkWebView.configuration.userContentController = controller
        
        for eventname in events {
            controller.add(self, name: eventname)
        }
    }
}
