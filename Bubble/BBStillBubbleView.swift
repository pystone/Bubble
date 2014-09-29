//
//  BBStillBubbleView.swift
//  Bubble
//
//  Created by ChuangXie on 9/28/14.
//  Copyright (c) 2014 Bubble. All rights reserved.
//

import Foundation
import UIKit

class BBStillBubbleView: BBTaskBubbleView {
    
    override func bubbleViewDidPan(sender: UIPanGestureRecognizer) {
        self.delegate?.bubbleViewDidPan(sender)
    }
}
