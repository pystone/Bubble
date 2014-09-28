//
//  BBAppIntroMgr.swift
//  Bubble
//
//  Created by Amy on 9/27/14.
//  Copyright (c) 2014 Bubble. All rights reserved.
//

import Foundation
import UIKit


class BBAppIntroMgr: NSObject, UIWebViewDelegate{
    
    var firstLoad: Bool = true
    var _introWnd: UIWindow?
    
    var googleBtn: UIButton?
    var iCloudBtn: UIButton?
    var introView: UIImageView?
    var webView: UIWebView?
    var loginInMgr: BBGoogleLoginManager?
    var textLabel: UILabel?
    var cancelBtn: UIButton?
    var activityJuhua : UIActivityIndicatorView?
    
    class func shouldShowAppIntro() -> Bool {
        
        var first = NSUserDefaults.standardUserDefaults().boolForKey("AppIntroVersionNumKey")
        if first == true{
            return false
        }
        
        return  true
    }
    
    struct Static {
        static var token : dispatch_once_t = 0
        static var instance :BBAppIntroMgr?
    }
    
    class func getInstance() ->BBAppIntroMgr{
        dispatch_once(&Static.token) {  Static.instance = BBAppIntroMgr() }
        return Static.instance!
    }
    
    override init(){
        assert(Static.instance == nil, "Singleton already initialized!")
        _introWnd = UIWindow(frame: UIScreen.mainScreen().bounds);
        _introWnd?.backgroundColor = UIColor.clearColor();
    }
    
    func createViews(){
        if introView?.superview != nil{
            return
        }
        
        let bounds: CGRect = UIScreen.mainScreen().bounds
        introView = UIImageView(frame: CGRectMake(0, 0, bounds.width, bounds.height))
        var image = UIImage(named: "login_bg.png");
        introView?.image = image
        introView?.userInteractionEnabled = true
        introView?.backgroundColor = UIColor.whiteColor()
        
        googleBtn = UIButton(frame: CGRectMake(bounds.width/2 - 110,  bounds.height/2 - 70, 100, 100))
        googleBtn?.setBackgroundImage(UIImage(named: "Google.png"), forState: .Normal)
        googleBtn?.addTarget(self, action: Selector("SignInPressed:"), forControlEvents: .TouchUpInside)
        
        iCloudBtn = UIButton(frame: CGRectMake(bounds.width/2 + 10,  bounds.height/2 - 70,100 , 100))
        iCloudBtn?.setBackgroundImage(UIImage(named: "icloud.png"), forState: .Normal)
        iCloudBtn?.addTarget(self, action: Selector("nextTime:"), forControlEvents: .TouchUpInside)
        
        textLabel = UILabel(frame: CGRectMake(70, 120, 180, 80))
        textLabel?.backgroundColor = UIColor.clearColor()
        textLabel?.text = "Sync Your Calendar With:"
        textLabel?.textAlignment = NSTextAlignment.Center
        textLabel?.numberOfLines = 2;
        textLabel?.textColor = UIColor(red: (97/255), green: (215/255), blue: (236/255), alpha: 1.0)
        textLabel?.font = UIFont.systemFontOfSize(24.0)
        
        cancelBtn = UIButton(frame: CGRectMake(70, bounds.height/2 + 50, 180, 40))
        cancelBtn?.setTitle("Or Maybe Later", forState: .Normal)
        cancelBtn?.setTitleColor(UIColor(red: (97/255), green: (215/255), blue: (236/255), alpha: 1.0), forState: .Normal)
        cancelBtn?.titleLabel?.font = UIFont.systemFontOfSize(24.0)
        cancelBtn?.titleLabel?.textAlignment = NSTextAlignment.Center
        cancelBtn?.addTarget(self, action: Selector("nextTime:"), forControlEvents: .TouchUpInside)
        
        activityJuhua = UIActivityIndicatorView(activityIndicatorStyle:.Gray)
        activityJuhua?.frame = CGRectMake(140, 300, 40, 40)
        activityJuhua?.hidesWhenStopped = true
        activityJuhua?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        introView?.addSubview(googleBtn!)
        introView?.addSubview(iCloudBtn!)
        introView?.addSubview(textLabel!)
        introView?.addSubview(cancelBtn!)
    }
    
    func showAppIntro(){
        createViews()
        
        var firstLoad = true
        
        _introWnd?.hidden = false;
        _introWnd?.addSubview(introView!)
        _introWnd?.makeKeyAndVisible()
        _introWnd?.windowLevel = UIWindowLevelStatusBar
        
        if firstLoad == true{
            NSUserDefaults.standardUserDefaults().setBool(firstLoad, forKey: "AppIntroVersionNumKey")
        }
    }
    
    func SignInPressed(sender: UIButton!) {
        
        let bounds: CGRect = UIScreen.mainScreen().bounds
        introView?.removeFromSuperview()
        webView = UIWebView(frame: bounds)
        webView?.delegate = self
        _introWnd?.addSubview(webView!)
        webView!.addSubview(activityJuhua!)
        activityJuhua?.startAnimating()
        
        loginInMgr = BBGoogleLoginManager()
        var str : String?
        str = loginInMgr?.getAuthorationRequestURLString()
        
        var urlstr = NSURL(string: str!)
        var request1: NSURLRequest = NSURLRequest(URL: urlstr)
        
        webView?.loadRequest(request1)
    }
    
    func nextTime(sender: UIButton!) {
        dismissIntroView()
     }
    
    func getMainWindow() -> UIWindow{
        var delegate = UIApplication.sharedApplication().delegate as AppDelegate
        return delegate.window!
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if request.URL.host == "localhost" {
            var verifier: String?
            let urlQuery: NSString = request.URL.query!
            var params = urlQuery.componentsSeparatedByString("&") as [String]
            for param in params{
                var keyValue = param.componentsSeparatedByString("=") as [String]
                var key = keyValue[0]
                if key == "code"{
                    verifier = keyValue[1]
                    println(verifier)
                    break;
                }
            }
            
            if verifier != nil{
                loginInMgr?.authorizationCode = verifier
                let dataStr : NSString? = loginInMgr?.getAccessTokenRequestData(verifier!)
                let data = dataStr?.dataUsingEncoding(
                    NSUTF8StringEncoding)
                let url : String? = loginInMgr?.getAccessTokenURL()
                println(url)
                loginInMgr?.requestAccessToken(url!, data: data!)
            }
            
            webView.removeFromSuperview()
            dismissIntroView()
            return false
            
        }
        return true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        activityJuhua?.stopAnimating()
    }
    
    func dismissIntroView(){
        introView?.removeFromSuperview()
        _introWnd?.windowLevel = UIWindowLevelNormal
        _introWnd?.hidden = true
        getMainWindow().makeKeyAndVisible()
    }
}




