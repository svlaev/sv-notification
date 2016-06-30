//
//  ViewController.swift
//  SVNotification
//
//  Created by Stanislav Vlaev on 6/27/16.
//  Copyright © 2016 Test. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var btnNavBarDefault: UIButton!
    @IBOutlet weak var btnNavBarSubtitle: UIButton!
    @IBOutlet weak var btnNavBarDuration: UIButton!
    @IBOutlet weak var btnNavBarSuccess: UIButton!
    @IBOutlet weak var btnNavBarWarning: UIButton!
    @IBOutlet weak var btnNavBarError: UIButton!
    @IBOutlet weak var btmTinyNotification: UIButton!

    // MARK: - Actions

    @IBAction func actionShowNotification(sender: UIButton) {
        switch sender {
            case btnNavBarDefault:
                SVNotification.showNavBarInfo("Default Title", subtitle: nil, duration: SVNotification.Permanent, parent: self) { notification in
                    notification.hide()
                }
            case btnNavBarSubtitle:
                SVNotification.showNavBarInfo("Default Title", subtitle: "Subtitle", duration: SVNotification.Permanent, parent: self) { notification in
                    notification.hide()
                }
            case btnNavBarDuration:
                SVNotification.showNavBarInfo("I will be gone after 3 seconds", subtitle: nil, duration: 3.0, parent: self)
            case btnNavBarSuccess:
                SVNotification.showNavBarSuccess("Horraaayy!!", subtitle: "We did it!", duration: SVNotification.Permanent, parent: self) { n in
                    n.hide()
                }
            case btnNavBarWarning:
                SVNotification.showNavBarWarning("Careful, mate!", subtitle: "This is just a warning", duration: SVNotification.Permanent, parent: self) { n in
                    n.hide()
                }
            case btnNavBarError:
                SVNotification.showNavBarError("Ooooops!", subtitle: "S*it happened :(", duration: SVNotification.Permanent, parent: self) { n in
                    n.hide()
                }
        case btmTinyNotification:
            SVNotification.showTinyNotification("I'm slim :)", parent: self)
        default: break
        }
    }

    @IBAction func actionShowDefaultNotification(sender: AnyObject) {
        SVNotification.showNavBarSuccess("default", subtitle: nil, duration: SVNotification.Permanent, parent: self) { notification in
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

