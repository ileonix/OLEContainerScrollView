//
//  OLEContainerScrollView.swift
//  OLEContainerScrollView
//
//  Created by Chanon Purananunak on 20/10/2563 BE.
//  Copyright © 2563 Chanon Purananunak. All rights reserved.
//
// Convert from Copyright (c) 2014 Ole Begemann.
// https://github.com/ole/OLEContainerScrollView

import UIKit
import QuartzCore
import CoreGraphics

//protocol OLEContainerScrollViewScrollable: AnyObject {
//    var scrollView: UIScrollView? { get }
//}

//class UIScrollView: OLEContainerScrollViewScrollable {
//    var scrollView: UIScrollView?
//}

class OLEContainerScrollView: UIScrollView {
    var contentView: UIView?
    var spacing: CGFloat = 0.0
    var ignoreHiddenSubviews = false
    
    var subviewsInLayoutOrder: [AnyHashable]?
    var oleContainerScrollViewSwizzling: OLEContainerScrollViewSwizzling?
    
//    override init() {
//        super.init()
//        if self is OLEContainerScrollView {
//            oleContainerScrollViewSwizzling?.swizzleUICollectionViewLayoutFinalizeCollectionViewUpdates()
//            oleContainerScrollViewSwizzling?.swizzleUITableView()
//        }
//        commonInitForOLEContainerScrollView()
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView?.frame = frame
        // +initialize can be called multiple times if subclasses don't implement it.
        // Protect against multiple calls
        if self is OLEContainerScrollView {
            oleContainerScrollViewSwizzling?.swizzleUICollectionViewLayoutFinalizeCollectionViewUpdates()
            oleContainerScrollViewSwizzling?.swizzleUITableView()
        }
        commonInitForOLEContainerScrollView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInitForOLEContainerScrollView()
    }
    
    deinit {
        // Removing the subviews will unregister KVO observers
        for subview in (self.contentView?.subviews)! {
            subview.removeFromSuperview()
        }
    }
    
    func commonInitForOLEContainerScrollView() {
        contentView = OLEContainerScrollViewContentView(frame: CGRect.zero)
        addSubview(contentView!)
        subviewsInLayoutOrder = [AnyHashable](repeating: 0, count: 4)
        spacing = 0.0
        ignoreHiddenSubviews = true
    }

    func setSpacing(_ spacing: CGFloat) {
        self.spacing = spacing
        setNeedsLayout()
    }

    func setIgnoreHiddenSubviews(_ newValue: Bool) {
        ignoreHiddenSubviews = newValue
        setNeedsLayout()
    }
    
    func didAddSubview(toContainer subview: UIView?) {
        assert(subview != nil, "Invalid parameter not satisfying: subview != nil")

        var ix: Int? = nil
        if let subview = subview {
            ix = NSArray(object: subviewsInLayoutOrder).indexOfObjectIdentical(to: subview) //subviewsInLayoutOrder.indexOfObjectIdentical(to: subview)
        }
        if ix != NSNotFound {
            subviewsInLayoutOrder?.remove(at: ix ?? 0)
            if let subview = subview {
                subviewsInLayoutOrder?.append(subview)
            }
            setNeedsLayout()
            return
        }

//        subview?.autoresizingMask = UIViewAutoresizingNone //not have this enum (UIViewAutoresizingNone) option in swift

        if let subview = subview {
            subviewsInLayoutOrder?.append(subview)
        }

        if subview is UIScrollView {
            let scrollView = subview as? UIScrollView
            scrollView?.isScrollEnabled = false
            if #available(iOS 13.0, *) {
                scrollView?.addObserver(self, forKeyPath: NSStringFromSelector(#selector(getter: NSCollectionLayoutContainer.contentSize)), options: .old, context: &KVOContext)
            } else {
                // Fallback on earlier versions
                
            }
        } else if (subview?.responds(to: #selector(getter: UIWebView.scrollView)))! {
            let scrollView = subview?.perform(#selector(getter: UIWebView.scrollView)) as? UIScrollView
            scrollView?.isScrollEnabled = false
            if #available(iOS 13.0, *) {
                scrollView?.addObserver(self, forKeyPath: NSStringFromSelector(#selector(getter: NSCollectionLayoutContainer.contentSize)), options: .old, context: &KVOContext)
            } else {
                // Fallback on earlier versions
                
            }
        } else {
            subview?.addObserver(self, forKeyPath: NSStringFromSelector(#selector(getter: frame)), options: .old, context: KVOContext)
            subview?.addObserver(self, forKeyPath: NSStringFromSelector(#selector(getter: bounds)), options: .old, context: KVOContext)
        }

        self.setNeedsLayout()
    }

    func willRemoveSubview(fromContainer subview: UIView?) {
        assert(subview != nil, "Invalid parameter not satisfying: subview != nil")

        if subview is UIScrollView {
            if #available(iOS 13.0, *) {
                subview?.removeObserver(self, forKeyPath: NSStringFromSelector(#selector(getter: NSCollectionLayoutContainer.contentSize)), context: &KVOContext)
            } else {
                // Fallback on earlier versions
            }
        } else if subview?.responds(to: #selector(getter: UIWebView.scrollView)) ?? false {
            let scrollView = subview?.perform(#selector(getter: UIWebView.scrollView)) as? UIScrollView
            if #available(iOS 13.0, *) {
                scrollView?.removeObserver(self, forKeyPath: NSStringFromSelector(#selector(getter: NSCollectionLayoutContainer.contentSize)), context: &KVOContext)
            } else {
                // Fallback on earlier versions
            }
        } else {
            subview?.removeObserver(self, forKeyPath: NSStringFromSelector(#selector(getter: frame)), context: &KVOContext)
            subview?.removeObserver(self, forKeyPath: NSStringFromSelector(#selector(getter: bounds)), context: &KVOContext)
        }
        subviewsInLayoutOrder?.removeAll { $0 as AnyObject === subview as AnyObject }
        setNeedsLayout()
    }
    
    //MARK: - KVO
    private var KVOContext = UnsafeMutableRawPointer(bitPattern: 0)//&KVOContext
    func observeValue(forKeyPath keyPath: String, of object: Any, change: [NSKeyValueChangeKey : Any], context: UnsafeMutableRawPointer) {
        if context == KVOContext {
            if #available(iOS 13.0, *) {
                if keyPath == NSStringFromSelector(#selector(getter: NSCollectionLayoutContainer.contentSize)) {
                    let scrollView = object as! UIScrollView
                    
                    guard let oldContentSize = (change[NSKeyValueChangeKey.oldKey] as? CGSize) else { return }
                    //                let oldContentSize = change[NSKeyValueChangeKey.oldKey].cgSizeValue
                    
                    let newContentSize = scrollView.contentSize
                    if !(newContentSize.equalTo(oldContentSize)) {
                        setNeedsLayout()
                        layoutIfNeeded()
                    }
                } else if (keyPath == NSStringFromSelector(#selector(getter: frame))) || (keyPath == NSStringFromSelector(#selector(getter: bounds))) {
                    let subview = object as! UIView
                    guard let oldFrame = (change[NSKeyValueChangeKey.oldKey] as? CGRect) else { return }
                    //                let oldFrame = change[NSKeyValueChangeKey.oldKey].cgRectValue
                    let newFrame = subview.frame
                    if !(newFrame.equalTo(oldFrame)) {
                        setNeedsLayout()
                        layoutIfNeeded()
                    }
                }
            } else {
                // Fallback on earlier versions
                
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    //MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Translate the container view's content offset to contentView bounds.
        // This keeps the contentView always centered on the visible portion of the container view's
        // full content size, and avoids the need to make the contentView large enough to fit the
        // container view's full content size.
        contentView?.frame = bounds
        contentView?.bounds = CGRect(origin: contentOffset, size: (contentView?.bounds.size)!)
        
        // The logical vertical offset where the current subview (while iterating over all subviews)
        // must be positioned. Subviews are positioned below each other, in the order they were added
        // to the container. For scroll views, we reserve their entire contentSize.height as vertical
        // space. For non-scroll views, we reserve their current frame.size.height as vertical space.
        var yOffsetOfCurrentSubview: CGFloat = 0.0
        
        for index in 0..<subviewsInLayoutOrder!.count {
            let subview = subviewsInLayoutOrder![index] as? UIView
            
            // Make the height hidden subviews zero in order to behave like UIStackView.
            if ignoreHiddenSubviews && ((subview?.isHidden) != nil) {
                var frame = subview?.frame
                frame?.origin.y = yOffsetOfCurrentSubview
                frame?.origin.x = 0
                frame?.size.width = contentView?.bounds.size.width as! CGFloat
                subview?.frame = frame!

                // Do not set the height to zero. Just don't add the original height to yOffsetOfCurrentSubview.
                // This is to keep the original height when the view is unhidden.
                continue
            }
            
            if (subview?.responds(to: #selector(getter: UIWebView.scrollView)))! {
                let scrollView = subview?.perform(#selector(getter: UIWebView.scrollView)) as? UIScrollView
                var frame = subview?.frame
                var contentOffset = scrollView?.contentOffset
                
                // Translate the logical offset into the sub-scrollview's real content offset and frame size.
                // Methodology:
                
                // (1) As long as the sub-scrollview has not yet reached the top of the screen, set its scroll position
                // to 0.0 and position it just like a normal view. Its content scrolls naturally as the container
                // scroll view scrolls.
                // else
                // (2) If the user has scrolled far enough down so that the sub-scrollview reaches the top of the
                // screen, position its frame at 0.0 and start adjusting the sub-scrollview's content offset to
                // scroll its content.
                if (self.contentOffset.y ) < yOffsetOfCurrentSubview {
                    contentOffset?.y = 0.0
                    frame?.origin.y = yOffsetOfCurrentSubview
                } else {
                    contentOffset?.y = (self.contentOffset.y ) - yOffsetOfCurrentSubview
                    frame?.origin.y = self.contentOffset.y
                }
                
                // (3) The sub-scrollview's frame should never extend beyond the bottom of the screen, even if its
                // content height is potentially much greater. When the user has scrolled so far that the remaining
                // content height is smaller than the height of the screen, adjust the frame height accordingly.
                let remainingBoundsHeight = CGFloat(fmax(Float(bounds.maxY - frame!.minY), 0.0))
                let remainingContentHeight = CGFloat(fmax(Float((scrollView?.contentSize.height)! - contentOffset!.y), 0.0))
                frame?.size.height = CGFloat(fmin(Float(remainingBoundsHeight), Float(remainingContentHeight)))
                frame?.size.width = contentView?.bounds.size.width as! CGFloat

                subview?.frame = frame!
                scrollView?.contentOffset = contentOffset!

                yOffsetOfCurrentSubview += (scrollView?.contentSize.height)! + (scrollView?.contentInset.top)! + (scrollView?.contentInset.bottom)!
            } else {
                // Normal views are simply positioned at the current offset
                var frame = subview?.frame
                frame?.origin.y = yOffsetOfCurrentSubview
                frame?.origin.x = 0
                frame?.size.width = contentView?.bounds.size.width as! CGFloat
                subview?.frame = frame!

                yOffsetOfCurrentSubview += (frame?.size.height)!
            }
            
            if index < (subviewsInLayoutOrder!.count - 1) {
                yOffsetOfCurrentSubview += spacing
            }
        }
        
        // If our content is shorter than our bounds height, take the contentInset into account to avoid
        // scrolling when it is not needed.
        let minimumContentHeight = bounds.size.height - (contentInset.top + contentInset.bottom)

        let initialContentOffset = contentOffset
//        contentSize = CGSize(width: bounds.size.width, height: CGFloat(fmax(yOffsetOfCurrentSubview, Float(minimumContentHeight))))
        contentSize = CGSize(width: bounds.size.width, height: CGFloat(fmax(yOffsetOfCurrentSubview, minimumContentHeight)))

        // If contentOffset changes after contentSize change, we need to trigger layout update one more time.
        if !initialContentOffset.equalTo(contentOffset) {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
}

extension UIScrollView {
    func scrollView() -> UIScrollView? {
        return self
    }
}
