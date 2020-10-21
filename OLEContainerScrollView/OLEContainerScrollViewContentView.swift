//
//  OLEContainerScrollViewContentView.swift
//  OLEContainerScrollView
//
//  Created by Chanon Purananunak on 20/10/2563 BE.
//  Copyright © 2563 Chanon Purananunak. All rights reserved.
//
//  Copyright (c) 2014 Ole Begemann.
//  https://github.com/ole/OLEContainerScrollView

import UIKit
import OLEContainerScrollView

class OLEContainerScrollViewContentView: UIView {
    override func didAddSubview(_ subview: UIView) {
        if superview is OLEContainerScrollView {
            (superview as? OLEContainerScrollView)?.didAddSubview(toContainer: subview)
        }
    }
    
    override func willRemoveSubview(_ subview: UIView) {
        if superview is OLEContainerScrollView {
            (superview as? OLEContainerScrollView)?.willRemoveSubview(fromContainer: subview)
        }
        super.willRemoveSubview(subview)
    }
}
