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

    // MARK: - Actions

    @IBAction func actionShowNotification(sender: UIButton) {
        switch sender {
            case btnNavBarDefault:
                SVNotification.showNavBarInfo("Default Title",
                  subtitle: nil,
                  duration: SVNotification.Permanent,
                  parent: self,
                  settings: nil) { notification in
                    notification.hide()
                }
            case btnNavBarSubtitle:
                SVNotification.showNavBarInfo("Default Title",
                  subtitle: "Subtitle",
                  duration: SVNotification.Permanent,
                  parent: self,
                  settings: nil) { notification in
                    notification.hide()
                }
            case btnNavBarDuration:
                SVNotification.showNavBarInfo("I will be gone after 3 seconds",
                  subtitle: nil,
                  duration: 3.0,
                  parent: self,
                  settings: nil)
            case btnNavBarSuccess:
                SVNotification.showNavBarSuccess("Horraaayy!!",
                 subtitle: "We did it!",
                 duration: SVNotification.Permanent,
                 parent: self,
                 settings: nil) { n in
                    n.hide()
                }
            case btnNavBarWarning:
                SVNotification.showNavBarWarning("Careful, mate!",
                 subtitle: "This is just a warning",
                 duration: SVNotification.Permanent,
                 parent: self,
                 settings: nil) { n in
                    n.hide()
                }
            case btnNavBarError:
                SVNotification.showNavBarError("Ooooops!",
                   subtitle: "S*it happened :(",
                   duration: SVNotification.Permanent,
                   parent: self,
                   settings: nil) { n in
                    n.hide()
                }
            case btnNavBarCustom:
                let settings = SVNotification.Settings()
                settings.bgrColor = UIColor.purpleColor()
                settings.fontTitle = UIFont(name: "Arial", size: 16.0)!
                settings.fontSubtitle = UIFont(name: "AmericanTypewriter-Bold", size: 14.0)!
                SVNotification.showNavBarInfo("Custom",
                                              subtitle: "Custom Subtitle",
                                              duration: SVNotification.Permanent,
                                              parent: self,
                                              settings: settings)
            case btmTinyNotification:
                SVNotification.showTinyNotification(title: "I'm slim :)", parent: self)
        default: break
        }
    }
}

