//
//  ViewController.swift
//  SVNotification
//
//  Created by Stanislav Vlaev on 6/27/16.
//  Copyright © 2016 Test. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func actionShowDefaultNotification(sender: AnyObject) {
        SVNotification.showPermanentNavBarNotification("Default", subtitle: nil, parent: self) { notification in
            notification.hide()
        }
    }

    @IBAction func actionShowDefaultNotificationWithSubtitle(sender: AnyObject) {
        SVNotification.showPermanentNavBarNotification("Default title", subtitle: "Default subtitle", parent: self) { notification in
            notification.hide()
        }
    }

    @IBAction func actionShowTinyNotification(sender: AnyObject) {
        SVNotification.showTinyNotification("Tiny nitification", parent: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        SVNotification.withTitle("test", parent: self, andLayout: .Default).show()
//        SVNotification.show("test", parent: self, type: .Default) { notification in
//            notification.hide()
//        }
    }


}

