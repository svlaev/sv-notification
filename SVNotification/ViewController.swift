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

    @IBAction func actionShowMessageWithDuration(sender: AnyObject) {
        SVNotification.showTempNavBarNotification("I'm gone after 3 seconds", subtitle: nil, duration: 3.0, parent: self, tapClosure: nil)
    }

    @IBAction func actionShowTinyNotification(sender: AnyObject) {
        SVNotification.showTinyNotification("Tiny nitification", parent: self)
    }
}

