//
//  OLESimulatedTableView.swift
//  OLEContainerScrollViewDemo
//
//  Created by Chanon Purananunak on 21/10/2563 BE.
//  Copyright © 2563 Chanon Purananunak. All rights reserved.
//

import UIKit

class OLESimulatedTableView: UIScrollView {

    var showBoundsOutline = false
    var cellColor: UIColor?
    var contentSizeOutlineColor: UIColor?
    private(set) var numberOfRows = 0
    private(set) var rowHeight: CGFloat = 0.0
    private(set) var cellSpacing: CGFloat = 0.0
    private(set) var edgeInsets: UIEdgeInsets?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, numberOfRows: Int, rowHeight: CGFloat, edgeInsets: UIEdgeInsets, cellSpacing: CGFloat) {
        self.init(frame: frame)
        self.numberOfRows = numberOfRows
        self.rowHeight = rowHeight
        self.edgeInsets = edgeInsets
        self.cellSpacing = cellSpacing
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
