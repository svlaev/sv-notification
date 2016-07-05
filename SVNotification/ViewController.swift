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
    @IBOutlet weak var btnNavBarCustom: UIButton!
    @IBOutlet weak var btmTinyNotification: UIButton!
    @IBOutlet weak var btnTinyNitificationReconnect: UIButton!

    // MARK: - Actions

    @IBAction func actionShowNotification(sender: UIButton) {
        switch sender {
            case btnNavBarDefault:
                SVNotification.showDefaultAboveNavBar("Default Title",
                  duration: SVNotification.Permanent,
                  parent: self) { notification in
                    notification.hide()
                }
            case btnNavBarSubtitle:
                SVNotification.showDefaultAboveNavBar("Default Title",
                  subtitle: "Subtitle",
                  duration: SVNotification.Permanent,
                  parent: self) { notification in
                    notification.hide()
                }
            case btnNavBarDuration:
                SVNotification.showDefaultAboveNavBar("I will be gone after 3 seconds",
                  duration: 3.0,
                  parent: self)
            case btnNavBarSuccess:
                SVNotification.showSuccessAboveNavBar("Horraaayy!!",
                 subtitle: "We did it!",
                 duration: SVNotification.Permanent,
                 parent: self) { n in
                    n.hide()
                }
            case btnNavBarWarning:
                SVNotification.showWarningAboveNavBar("Careful, mate!",
                 subtitle: "This is just a warning",
                 duration: SVNotification.Permanent,
                 parent: self) { n in
                    n.hide()
                }
            case btnNavBarError:
                SVNotification.showErrorAboveNavBar("Ooooops!",
                   subtitle: "S*it happened :(",
                   duration: SVNotification.Permanent,
                   parent: self) { n in
                    n.hide()
                }
            case btnNavBarCustom:
                let style = SVNotification.Style()
                style.bgrColor = UIColor.purpleColor()
                style.fontTitle = UIFont(name: "Arial", size: 16.0)!
                style.fontSubtitle = UIFont(name: "AmericanTypewriter-Bold", size: 14.0)!
                SVNotification.showCustomAboveNavBar("Custom",
                  subtitle: "Custom Subtitle",
                  duration: SVNotification.Permanent,
                  type: .Default,
                  parent: self,
                  style: style
                )
            case btmTinyNotification:
                SVNotification.showTinyNotification(title: "I'm slim :)",
                    duration: SVNotification.Permanent,
                    parent: self
                )

            case btnTinyNitificationReconnect:
                    SVNotification.showTinyNotification(title: "Reconnecting...",
                        duration: SVNotification.Permanent,
                        parent: self,
                        type: .Warning
                    )
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                        SVNotification.showTinyNotification(title: "Connected!!",
                            duration: 1.0,
                            parent: self,
                            type: .Success
                        )
                }

            default: break
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        title = "Very long title"
    }
}

