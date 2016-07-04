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
                SVNotification.showAboveNavBar("Default Title",
                  subtitle: nil,
                  duration: SVNotification.Permanent,
                  type: .Default,
                  parent: self,
                  settings: nil) { notification in
                    notification.hide()
                }
            case btnNavBarSubtitle:
                SVNotification.showAboveNavBar("Default Title",
                  subtitle: "Subtitle",
                  duration: SVNotification.Permanent,
                  type: .Default,
                  parent: self,
                  settings: nil) { notification in
                    notification.hide()
                }
            case btnNavBarDuration:
                SVNotification.showAboveNavBar("I will be gone after 3 seconds",
                  subtitle: nil,
                  duration: 3.0,
                  type: .Default,
                  parent: self,
                  settings: nil)
            case btnNavBarSuccess:
                SVNotification.showAboveNavBar("Horraaayy!!",
                 subtitle: "We did it!",
                 duration: SVNotification.Permanent,
                 type: .Success,
                 parent: self,
                 settings: nil) { n in
                    n.hide()
                }
            case btnNavBarWarning:
                SVNotification.showAboveNavBar("Careful, mate!",
                 subtitle: "This is just a warning",
                 duration: SVNotification.Permanent,
                 type: .Warning,
                 parent: self,
                 settings: nil) { n in
                    n.hide()
                }
            case btnNavBarError:
                SVNotification.showAboveNavBar("Ooooops!",
                   subtitle: "S*it happened :(",
                   duration: SVNotification.Permanent,
                   type: .Error,
                   parent: self,
                   settings: nil) { n in
                    n.hide()
                }
            case btnNavBarCustom:
                let settings = SVNotification.Settings()
                settings.bgrColor = UIColor.purpleColor()
                settings.fontTitle = UIFont(name: "Arial", size: 16.0)!
                settings.fontSubtitle = UIFont(name: "AmericanTypewriter-Bold", size: 14.0)!
                SVNotification.showAboveNavBar("Custom",
                  subtitle: "Custom Subtitle",
                  duration: SVNotification.Permanent,
                  type: .Default,
                  parent: self,
                  settings: settings
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
                    type: .NetworkUnreachableStatus
                )
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                    SVNotification.showTinyNotification(title: "Connected!!",
                        duration: 1.0,
                        parent: self,
                        type: .NetworkReachableStatus
                    )
            }

        default: break
        }
    }
}

