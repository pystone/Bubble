//
//  BBAppIntroMgr.swift
//  Bubble
//
//  Created by Amy on 9/27/14.
//  Copyright (c) 2014 Bubble. All rights reserved.
//

import Foundation
import UIKit


class BBAppIntroMgr: NSObject{
    
    func shouldShowAppIntro() -> Bool {
          return true
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
    }
    
    func showAppIntro(){
        
    }

}