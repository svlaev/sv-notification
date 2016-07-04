//
//  SVNotification.swift
//  SVNotification
//
//  Created by Stanislav Vlaev on 6/27/16.
//  Copyright © 2016 Test. All rights reserved.
//

import UIKit

class SVNotification: UIButton {
    enum LayoutType: Int {
        /**
         Default type. Shows notification overlaying the nav bar
         */
        case Default

        /**
         Displays notification with 20pt height
         */
        case Tiny
    }

    enum NotificationType {
        /*
         Displays default notification with blue background
         */
        case Default
        /*
         Displays notification with green background
         */
        case Success
        /*
         Displays notification with red background
         */
        case Error
        /*
         Displays notification with yellow background
         */
        case Warning

        /*
         Displays tiny notification with yellow background
         */
        case NetworkUnreachableStatus
        /*
         Displays tiny notification with green background
         */
        case NetworkReachableStatus
    }

    // MARK: - Static classes
    class Settings {
        var bgrColor: UIColor = UIColor.withDecimal(90, g: 192, b: 222)
        var textColorTitle: UIColor = UIColor.whiteColor()
        var textColorSubtitle: UIColor = UIColor.whiteColor()
        var textSizeTitle: CGFloat = 14.0
        var textSizeSubtitle: CGFloat = 13.0
        var fontTitle: UIFont = UIFont(name: "Avenir-Bold", size: 14.0) ?? UIFont.boldSystemFontOfSize(14.0)
        var fontSubtitle: UIFont = UIFont(name: "Avenir-Bold", size: 13.0) ?? UIFont.boldSystemFontOfSize(13.0)
        var textAlignmentTitle: NSTextAlignment = .Center
        var textAlignmentSubtitle: NSTextAlignment = .Center
    }

    class SuccessSettings: Settings {
        override init() {
            super.init()
            bgrColor = UIColor.withDecimal(92, g: 184, b: 92)
        }
    }

    class WarningSettings: Settings {
        override init() {
            super.init()
            bgrColor = UIColor.withDecimal(240, g: 173, b: 78)
        }
    }

    class ErrorSettings: Settings {
        override init() {
            super.init()
            bgrColor = UIColor.withDecimal(213, g: 83, b: 79)
        }
    }

    // MARK: - Public properties
    var tapClosure: (SVNotification -> Void)? = nil

    // MARK: - Private properties
    private var layout: LayoutType = .Default
    private var type: NotificationType = NotificationType.Default
    private var titleString: String! = nil
    private var subtitleString: String! = nil
    private var lblTitle: UILabel! = nil
    private var lblSubtitle: UILabel! = nil
    private var parentVC: UIViewController! = nil
    private var currentSettings: Settings! = nil

    // MARK: - Private constraints
    private weak var constrNotificationTopMargin: NSLayoutConstraint! = nil
    private weak var constrNotificationHeight: NSLayoutConstraint! = nil
    private weak var constrLblTitleTopMargin: NSLayoutConstraint! = nil
    private weak var constrLblSubtitleHeight: NSLayoutConstraint! = nil

    //// MARK: - Private static properties
    private static var notification: SVNotification! = nil
    private static var hideTimer: NSTimer! = nil

    // MARK: - Static properties
    static var Permanent: Double = 0.0

    // MARK: - Public Static methods
    /**
     Shows info notification above the Navigation Bar

     - parameter title:      title
     - parameter subtitle:   subtitle
     - parameter duration:   time(in seconds) before the notification will get hidden. Enter 0 if you want it to be permanent.
     - parameter parent:     parent view controller (may be UINavigationController)
     - parameter settings:   visual settings. Leave nil for default ones
     - parameter tapClosure: closure, executed when the view is tapped

     - returns: the notification which has been shown
     */
    class func showNavBarInfo(title: String, subtitle: String?, duration: Double, parent: UIViewController, settings: Settings?, tapClosure: (SVNotification->Void)? = nil) -> SVNotification {
        return showNotification(title, subTitle: subtitle ?? "", duration: duration, parent: parent, layout: .Default, type: .Default, settings: settings, tapClosure: tapClosure)
    }

    /**
     Shows success notification above the Navigation Bar

     - parameter title:      title
     - parameter subtitle:   subtitle
     - parameter duration:   time(in seconds) before the notification will get hidden. Enter 0 if you want it to be permanent.
     - parameter parent:     parent view controller (may be UINavigationController)
     - parameter settings:   visual settings. Leave nil for default ones
     - parameter tapClosure: closure, executed when the view is tapped

     - returns: the notification which has been shown
     */
    class func showNavBarSuccess(title: String, subtitle: String?, duration: Double, parent: UIViewController, settings: Settings?, tapClosure: (SVNotification->Void)? = nil) -> SVNotification {
        return showNotification(title, subTitle: subtitle ?? "", duration: duration, parent: parent, layout: .Default, type: .Success, settings: settings, tapClosure: tapClosure)
    }

    /**
     Shows warning notification above the Navigation Bar

     - parameter title:      title
     - parameter subtitle:   subtitle
     - parameter duration:   time(in seconds) before the notification will get hidden. Enter 0 if you want it to be permanent.
     - parameter parent:     parent view controller (may be UINavigationController)
     - parameter settings:   visual settings. Leave nil for default ones
     - parameter tapClosure: closure, executed when the view is tapped

     - returns: the notification which has been shown
     */
    class func showNavBarWarning(title: String, subtitle: String?, duration: Double, parent: UIViewController, settings: Settings?, tapClosure: (SVNotification->Void)? = nil) -> SVNotification {
        return showNotification(title, subTitle: subtitle ?? "", duration: duration, parent: parent, layout: .Default, type: .Warning, settings: settings, tapClosure: tapClosure)
    }

    /**
     Shows error notification above the Navigation Bar

     - parameter title:      title
     - parameter subtitle:   subtitle
     - parameter duration:   time(in seconds) before the notification will get hidden. Enter 0 if you want it to be permanent.
     - parameter parent:     parent view controller (may be UINavigationController)
     - parameter settings:   visual settings. Leave nil for default ones
     - parameter tapClosure: closure, executed when the view is tapped

     - returns: the notification which has been shown
     */
    class func showNavBarError(title: String, subtitle: String?, duration: Double, parent: UIViewController, settings: Settings?, tapClosure: (SVNotification->Void)? = nil) -> SVNotification {
        return showNotification(title, subTitle: subtitle ?? "", duration: duration, parent: parent, layout: .Default, type: .Error, settings: settings, tapClosure: tapClosure)
    }

    /**
     Shows tiny nitification below the nav bar

     - parameter title:    title
     - parameter parent:   parent view controller
     - parameter settings: visual settings. Leave nil for default ones

     - returns: the notification which has been shown
     */
    class func showTinyNotification(title t: String, parent: UIViewController, settings: Settings? = nil) -> SVNotification {
        return showNotification(t, subTitle: "", parent: parent, layout: .Tiny, type: .Default, settings: settings, tapClosure: nil)
    }

    // MARK: - Public methods
    func show() {
        guard NSThread.isMainThread() else {
            dispatch_async(dispatch_get_main_queue()) {
                self.show()
            }
            return
        }

        constrNotificationTopMargin.constant = yCoordForShowing()
        UIView.animateWithDuration(0.3) {
            self.setNeedsUpdateConstraints()
            self.layoutIfNeeded()
        }
    }

    func hide(animated: Bool = true, callback: (Void->Void)? = nil) {
        guard NSThread.isMainThread() else {
            dispatch_async(dispatch_get_main_queue()) {
                self.hide(animated, callback: callback)
            }
            return
        }
        stopHideTimerIfRunning()
        if animated {
            constrNotificationTopMargin.constant = yCoordForHiding()
            UIView.animateWithDuration(0.3, animations: {
                self.setNeedsUpdateConstraints()
                self.layoutIfNeeded()
            }, completion: { finished in
                if finished {
                    self.removeFromSuperview()
                    callback?()
                }
            })
        } else {
            constrNotificationTopMargin.constant = yCoordForHiding()
            self.removeFromSuperview()
            callback?()
        }
    }

    func hideAnimated() {
        hide(true)
    }

    func viewTapped() {
        tapClosure?(self)
    }

    // MARK: - Private static methods
    private class func setupView(layout: LayoutType, type: NotificationType, parent: UIViewController, settings: Settings) {
        guard notification == nil else {
            notification.stopHideTimerIfRunning()
            notification.currentSettings = settings
            notification.applyCurrentVisualSettings()
            notification.layout = layout
            notification.constrNotificationTopMargin?.constant = notification.yCoordForHiding()
            notification.constrNotificationHeight?.constant = SVNotification.heightForType(layout)
            return
        }

        let topMargin = (layout == .Default ? 0 : parent.topLayoutGuide.length) - heightForType(layout)
        notification = SVNotification(type: .Custom)
        notification.currentSettings = settings
        notification.layout = layout
        notification.setTitle("", forState: .Normal)
        notification.frame = CGRectMake(0, topMargin, UIScreen.mainScreen().bounds.width , heightForType(layout))
        setupShadow()

        let isTiny = layout == .Tiny
        let lblTopMargin = layout == .Tiny ? 0.0 : statusBarHeight()
        let centerYCoord = (notification.frame.size.height - lblTopMargin) / (isTiny ? 1.0 : 2.0)
        notification.lblTitle = UILabel(frame: CGRectMake(0, lblTopMargin, notification.frame.size.width, centerYCoord))
        notification.lblTitle.textAlignment = notification.currentSettings.textAlignmentTitle
        notification.lblTitle.numberOfLines = 0
        notification.addSubview(notification.lblTitle)

        let lblTitleBottomBorder = notification.lblTitle.frame.origin.y + notification.lblTitle.frame.size.height
        notification.lblSubtitle = UILabel(frame: CGRectMake(0, lblTitleBottomBorder, notification.frame.size.width, notification.frame.size.height - lblTitleBottomBorder))
        notification.lblSubtitle.textAlignment = notification.currentSettings.textAlignmentSubtitle
        notification.addSubview(notification.lblSubtitle)

        notification.applyCurrentVisualSettings()
        populateData()

        notification.addTarget(notification, action: #selector(viewTapped), forControlEvents: .TouchUpInside)
    }

    private class func populateData() {
        notification.lblTitle.text = notification.titleString
        notification.lblSubtitle.text = notification.subtitleString
    }

    private class func setupShadow() {
        notification.layer.masksToBounds = false
        notification.layer.shadowColor = UIColor.grayColor().CGColor
        notification.layer.shadowRadius = 5.0
        notification.layer.shadowOffset = CGSizeMake(0.0, 1.0)
        notification.layer.shadowOpacity = 1.0
    }

    private class func heightForType(type: LayoutType) -> CGFloat {
        switch type {
            case .Default:
                return 44.0 + statusBarHeight()
            case.Tiny:
                return 20.0
        }
    }

    private class func statusBarHeight() -> CGFloat {
        return UIApplication.sharedApplication().statusBarFrame.size.height
    }

    // MARK: - Private static initialization methods
    private class func initWithTitle(title: String, subtitle: String, duration: Double, parent: UIViewController, layout: LayoutType, type: NotificationType, settings: Settings, closure: (SVNotification->Void)?) -> SVNotification {
        // If we want to display nav bar notification, but we have specified a VC as parent, we must find the NavigationVC
        let realParent = layout == .Default && !(parent is UINavigationController) && parent.navigationController != nil ? parent.navigationController! : parent
        if notification?.superview != nil && notification.superview! != parent {
            notification.removeFromSuperview()
        }
        setupView(layout, type: type, parent: realParent, settings: settings)
        notification.tapClosure = closure
        notification.titleString = title
        notification.subtitleString = subtitle

        populateData()
        notification.parentVC = realParent
        realParent.view.addSubview(notification)
        notification.setupConstraints()
        if duration > SVNotification.Permanent {
            notification.startHideCountdownFor(duration)
        }
        return notification
    }

    /**
     Shows permanent notification
     */
    private class func showNotification(title: String, subTitle: String, parent: UIViewController, layout: LayoutType, type: NotificationType, settings: Settings?, tapClosure: (SVNotification->Void)?) -> SVNotification {
        return showNotification(title, subTitle: subTitle, duration: SVNotification.Permanent, parent: parent, layout: layout, type: type, settings: settings, tapClosure: tapClosure)
    }

    /**
     Shows notification with duration
     */
    private class func showNotification(title: String, subTitle: String, duration: Double, parent: UIViewController, layout: LayoutType, type: NotificationType, settings: Settings?, tapClosure: (SVNotification->Void)?) -> SVNotification {
        var s: Settings! = settings
        if s == nil {
            switch type {
                case .Success:
                    s = SuccessSettings()
                case .Warning:
                    s = WarningSettings()
                case .Error:
                    s = ErrorSettings()
                default:
                    s = Settings()
            }
        }
        notification = SVNotification.initWithTitle(title, subtitle: subTitle, duration: duration, parent: parent, layout: layout, type: type, settings: s, closure: tapClosure)
        notification.show()
        return notification
    }

    // MARK: - Private methods
    private func yCoordForHiding() -> CGFloat {
        return (layout == .Default ? 0 : parentVC.topLayoutGuide.length) - (constrNotificationHeight?.constant ?? frame.size.height)
    }

    private func yCoordForShowing() -> CGFloat {
        return layout == .Default ? 0.0 : parentVC.topLayoutGuide.length
    }

    private func startHideCountdownFor(duration: Double) {
        stopHideTimerIfRunning()
        SVNotification.hideTimer = NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector: #selector(SVNotification.hideAnimated), userInfo: nil, repeats: false)
    }

    private func stopHideTimerIfRunning() {
        if SVNotification.hideTimer != nil {
            SVNotification.hideTimer.invalidate()
            SVNotification.hideTimer = nil
        }
    }

    private func applyCurrentVisualSettings() {
        backgroundColor = currentSettings.bgrColor
        lblTitle.textColor = currentSettings.textColorTitle
        lblSubtitle.textColor = currentSettings.textColorSubtitle
        lblTitle.font = currentSettings.fontTitle.fontWithSize(currentSettings.textSizeTitle)
        lblSubtitle.font = currentSettings.fontSubtitle.fontWithSize(currentSettings.textSizeSubtitle)
    }

    private func setupConstraints() {
        if constrNotificationTopMargin == nil {
            self.translatesAutoresizingMaskIntoConstraints = false
            let topMargin = (layout == .Default ? 0 : parentVC.topLayoutGuide.length) - SVNotification.heightForType(layout)
            let dict = ["notification" : self]
            let height = SVNotification.heightForType(layout)
            // resize down the subtitle if it's height is greater than the notification height
            if constrLblSubtitleHeight != nil && constrLblSubtitleHeight.constant > height {
                constrLblSubtitleHeight.constant = 0.0
            }
            var constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[notification]-0-|",
                 options: NSLayoutFormatOptions(rawValue: 0),
                 metrics: nil,
                 views: dict)
            constrNotificationTopMargin = NSLayoutConstraint(item: self,
                 attribute: .Top,
                 relatedBy: .Equal,
                 toItem: parentVC.view,
                 attribute: .TopMargin,
                 multiplier: 1.0,
                 constant: topMargin)
            constraints.append(constrNotificationTopMargin)
            constrNotificationHeight = NSLayoutConstraint(item: self,
                  attribute: .Height,
                  relatedBy: .Equal,
                  toItem: nil,
                  attribute: .NotAnAttribute,
                  multiplier: 1.0,
                  constant: height)
            constraints.append(constrNotificationHeight)
            parentVC.view.addConstraints(constraints)
        }

        let isTiny = layout == .Tiny
        let lblTopMargin = isTiny ? 0.0 : SVNotification.statusBarHeight()
        let hasSubtitle = (subtitleString?.characters.count ?? 0) > 0
        let subTitleHeight = isTiny ? 0 : (hasSubtitle ? (constrNotificationHeight.constant - lblTopMargin) / 2.0 : 0)
        if constrLblSubtitleHeight == nil {
            let dict = ["lbl" : lblSubtitle]
            lblSubtitle.translatesAutoresizingMaskIntoConstraints = false
            var constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[lbl]-0-|",
                 options: NSLayoutFormatOptions(rawValue: 0),
                 metrics: nil,
                 views: dict)
            constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[lbl]-0-|",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: nil,
                views: dict))
            constrLblSubtitleHeight = NSLayoutConstraint(item: lblSubtitle,
                 attribute: .Height,
                 relatedBy: .Equal,
                 toItem: nil,
                 attribute: .NotAnAttribute,
                 multiplier: 1.0,
                 constant: subTitleHeight)
            constraints.append(constrLblSubtitleHeight)
            self.addConstraints(constraints)
        } else {
            constrLblSubtitleHeight.constant = subTitleHeight
        }

        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        if constrLblTitleTopMargin == nil {
            let dict = ["lblTitle" : lblTitle, "lblSubtitle" : lblSubtitle]
            var arr = NSLayoutConstraint.constraintsWithVisualFormat("V:[lblTitle]-0-[lblSubtitle]",
                 options: NSLayoutFormatOptions(rawValue:0),
                 metrics: nil,
                 views: dict)
            constrLblTitleTopMargin = NSLayoutConstraint(item: lblTitle,
                 attribute: .Top,
                 relatedBy: .Equal,
                 toItem: self,
                 attribute: .Top,
                 multiplier: 1.0,
                 constant: lblTopMargin)
            arr.append(constrLblTitleTopMargin)
            arr.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[lblTitle]-0-|",
                options: NSLayoutFormatOptions(rawValue:0),
                metrics: nil,
                views: dict))
            self.addConstraints(arr)
        } else {
            constrLblTitleTopMargin.constant = lblTopMargin
        }

        constrNotificationHeight.constant = SVNotification.heightForType(layout)
    }
}

extension UIColor {
    /**
     Make UIColor from decimal values

     - parameter r:     red component. Values: [0, 255]
     - parameter g:     green component. Values: [0, 255]
     - parameter b:     blue component. Values: [0, 255]
     - parameter alpha: alpha component. Values: [0.0, 1.0]

     - returns: UIColor object from the specified values
     */
    static func withDecimal(r: Int, g: Int, b: Int, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    }
}
