//
//  ViewController.swift
//  OLEContainerScrollViewDemo
//
//  Created by Chanon Purananunak on 21/10/2563 BE.
//  Copyright © 2563 Chanon Purananunak. All rights reserved.
//

import UIKit
import OLEContainerScrollView

class ViewController: UIViewController,UIScrollViewDelegate,UITableViewDelegate {
    
//    private var tableView: OLESimulatedTableView?
    
//    @IBOutlet var oleView: UIView!
//    @IBOutlet var oleScrollView: OLEContainerScrollView!
    @IBOutlet var oleScrollView: OLEContainerScrollView!
    @IBOutlet var uiscrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView = OLESimulatedTableView(frame: CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: CGSize(width: 24.0, height: 72.0)), numberOfRows: 14, rowHeight: 72, edgeInsets: UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16), cellSpacing: 4)
//        tableView?.backgroundColor = UIColor(hue: 0.562, saturation: 0.295, brightness: 0.943, alpha: 1)
//        tableView?.cellColor = UIColor(hue: 0.564, saturation: 0.709, brightness: 0.768, alpha: 1)
//        tableView?.contentSizeOutlineColor = UIColor(hue: 0.992, saturation: 0.654, brightness: 0.988, alpha: 1)
//        view.addSubview(tableView!)
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        let tableViewSize = CGSize(width: 320, height: 568)
//        let tableViewOrigin = CGPoint(x: view.bounds.midX - tableViewSize.width / 2, y: topLayoutGuide.length + 100)
//        tableView?.frame = CGRect(origin: tableViewOrigin, size: tableViewSize)
//    }

}
