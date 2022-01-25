//
//  ViewController.swift
//  CC
//
//  Created by jingyaoTang on 2019/1/29.
//  Copyright © 2015年 yuhang. All rights reserved.
//

import UIKit
import WebKit

class Article: UIViewController, WKScriptMessageHandler, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    var theWebView:WKWebView?
    var htmlstring:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        //创建供js调用的接口
        let theConfiguration = WKWebViewConfiguration()
        theConfiguration.userContentController.add(self,name: "interOp")
        
        let theBackView = UIView(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-20))
        theBackView.backgroundColor = cTabbarButtonSel
        let swipeBack = UISwipeGestureRecognizer(target: self, action: #selector(self.naviBack))
        swipeBack.delegate = self
        theBackView.addGestureRecognizer(swipeBack)
        self.view.addSubview(theBackView)
        theWebView = WKWebView(frame: CGRect(x: 10, y: 20, width: UIScreen.main.bounds.width-20, height: UIScreen.main.bounds.height-20), configuration: theConfiguration)
        //theWebView!.load(request as URLRequest)
        self.theWebView?.loadHTMLString(htmlstring ?? "", baseURL: nil)
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

