//
//  Tips.swift
//  FWWB
//
//  Created by ZQ on 2019/3/20.
//  Copyright © 2019年 fwwb. All rights reserved.
//

import UIKit
import WebKit

class Tips: UIViewController, WKScriptMessageHandler, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    var theWebView:WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "jw", ofType: "html", inDirectory: "HTML5")
        let url = NSURL(fileURLWithPath: path!)
        let request = NSURLRequest(url: url as URL)
        
        //创建供js调用的接口
        let theConfiguration = WKWebViewConfiguration()
        theConfiguration.userContentController.add(self,
                                                   name: "interOp")
        
        let theBackView = UIView(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-20))
        theBackView.backgroundColor = cTabbarButtonSel
        let swipeBack = UISwipeGestureRecognizer(target: self, action: #selector(self.naviBack))
        swipeBack.delegate = self
        theBackView.addGestureRecognizer(swipeBack)
        self.view.addSubview(theBackView)
        
        theWebView = WKWebView(frame: CGRect(x: 10, y: 20, width: UIScreen.main.bounds.width-20, height: UIScreen.main.bounds.height-20), configuration: theConfiguration)
        theWebView!.load(request as URLRequest)
        theWebView?.allowsBackForwardNavigationGestures = true
        self.view.addSubview(theWebView!)
        
    }
    
    @objc func naviBack(_sender: UISwipeGestureRecognizer){
        print("tapped")
        
        if (theWebView?.canGoBack)! {
            print("1")
            theWebView?.goBack()
        }else{
            print("2")
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    //响应处理js那边的调用
    func userContentController(_ userContentController:WKUserContentController,
                               didReceive message: WKScriptMessage) {
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


