//
//  OLEContainerScrollView+Swizzling.swift
//  OLEContainerScrollView
//
//  Created by Chanon Purananunak on 20/10/2563 BE.
//  Copyright © 2563 Chanon Purananunak. All rights reserved.
//

import UIKit
//import OLEContainerScrollViewContentView
//import OLESwizzling
//import OLEContainerScrollView

class OLEContainerScrollViewSwizzling: UICollectionViewLayout {
    
    var oleswizzling: OLESwizzling?
    override init() {
        super.init()
        self.oleswizzling = OLESwizzling.init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.oleswizzling = OLESwizzling.init()
//        fatalError("init(coder:) has not been implemented")
    }
    
    func swizzleUICollectionViewLayoutFinalizeCollectionViewUpdates() {
        var classToSwizzle = UICollectionViewLayout.self
        var selectorToSwizzle = #selector(UICollectionViewLayout.finalizeCollectionViewUpdates)
        var originalIMP: IMP? = nil
        
        originalIMP = oleswizzling?.OLEReplaceMethodWithBlock(classToSwizzle, selectorToSwizzle, { //(_self) in
            // Call original implementation
//            ((void ( *)(id, SEL)),originalIMP)(_self, selectorToSwizzle)
            
            // Manually set the collection view's contentSize to its new size (after the updates have been performed) to cause
            // a relayout of all views in the container scroll view.
            // We do this to animate the resizing of the collection view and its adjacent views in the container scroll view
            // in sync with the cell update animations (finalizeCollectionViewUpdates is called inside the animation block).
            // If we don't do this, the collection view will set its new content size only after the cell update animations
            // have finished, which is too late for us.
            let collectionView = self.collectionView//_self.collectionView
            let collectionViewIsInsideOLEContainerScrollView = collectionView?.superview is OLEContainerScrollViewContentView
            if collectionViewIsInsideOLEContainerScrollView {
                collectionView?.contentSize = self.collectionViewContentSize//_self.collectionViewContentSize
            }
        })
        
    }

    func swizzleUITableView() {
        let classToSwizzle = UITableView.self
        let obfuscatedSelector = "_\("endCe")llAnimat\("ionsWit")hContext:"
        let selectorToSwizzle = NSSelectorFromString(obfuscatedSelector)

        var originalIMP: IMP? = nil
        originalIMP = oleswizzling?.OLEReplaceMethodWithBlock(classToSwizzle, selectorToSwizzle, { //(_self, context) in
            // Call original implementation
//            ((void ( *)(id, SEL, id)),originalIMP)(_self, selectorToSwizzle, context)
            
            let collectionView = self.collectionView
            var collectionViewContentSize = self.collectionViewContentSize
            UIView.animate(withDuration: 0.25, animations: {
                // Manually set the table view's contentSize to its new size (after the updates have been performed) to cause
                // a relayout of all views in the container scroll view.
                // We do this to animate the resizing of the table view and its adjacent views in the container scroll view
                // in sync with the cell update animations. If we don't do this, the table view will set its new content size
                // only after the cell update animations have finished, which is too late for us.
                let tableViewIsInsideOLEContainerScrollView = collectionView?.superview is OLEContainerScrollViewContentView //_self.superview is OLEContainerScrollViewContentView
                if tableViewIsInsideOLEContainerScrollView {
                    let obfuscatedPropertyKey = "_\("cont")entSize"
                    
                    //_self.contentSize = value(forKey: obfuscatedPropertyKey)?.cgSizeValue ?? CGSize.zero
                    guard let contentSize = self.value(forKey: obfuscatedPropertyKey) else { return }
                    collectionViewContentSize = contentSize as! CGSize
                }
            })
        })
        
    }
}
