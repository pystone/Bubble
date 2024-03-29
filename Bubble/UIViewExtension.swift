//
//  UIViewExtension.swift
//  Bubble
//
//  Created by PY on 9/28/14.
//  Copyright (c) 2014 Bubble. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: .ExtraLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.frame
        blurView.alpha = 0.0
        blurView.tag = BlurViewTag
        self.addSubview(blurView)
        
        UIView.animateWithDuration(BlurTransitionTime, animations: {() -> Void in
            blurView.alpha = BlurAlpha
        })
    }
    
    func removeBlurEffect() {
        if let blurView: UIView = self.viewWithTag(BlurViewTag) {
            UIView.animateWithDuration(BlurTransitionTime,
                animations: { () -> Void in
                    blurView.alpha = 0.0
                },
                completion: { (finished: Bool) -> Void in
                    blurView.removeFromSuperview()
            })
            
        }
    }
}