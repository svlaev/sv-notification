//
//  ViewController.swift
//  SVNotification
//
//  Created by Stanislav Vlaev on 08/19/2016.
//  Copyright (c) 2016 Stanislav Vlaev. All rights reserved.
//

import UIKit
import SVNotification

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

    @IBAction func actionShowNotification(_ sender: UIButton) {
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
            style.bgrColor = UIColor.purple
            style.fontTitle = UIFont(name: "Arial", size: 16.0)!
            style.fontSubtitle = UIFont(name: "AmericanTypewriter-Bold", size: 14.0)!
            SVNotification.showCustomAboveNavBar("Custom",
                                                 subtitle: "Custom Subtitle",
                                                 duration: SVNotification.Permanent,
                                                 type: .default,
                                                 parent: self,
                                                 style: style){ n in
                                                    n.hide()
            }

        case btmTinyNotification:
            SVNotification.showTinyNotification(title: "I'm slim :)",
                                                duration: SVNotification.Permanent,
                                                parent: self
            )

        case btnTinyNitificationReconnect:
            SVNotification.showTinyNotification(title: "Reconnecting...",
                                                duration: SVNotification.Permanent,
                                                parent: self,
                                                type: .warning
            )
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
                SVNotification.showTinyNotification(title: "Connected!!",
                                                    duration: 1.0,
                                                    parent: self,
                                                    type: .success
                )
            }
            
        default: break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "Very long title"
    }
}
