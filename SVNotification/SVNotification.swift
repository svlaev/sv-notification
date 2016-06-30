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
        var textColor: UIColor = UIColor.whiteColor()
        var textSize: CGFloat = 13.0
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

    //// MARK: - Private static properties
    private static var notification: SVNotification! = nil
    private static var hideTimer: NSTimer! = nil

    // MARK: - Static properties
    static var Permanent: Double = 0.0

    // MARK: - Public Static methods
    class func showPermanentNavBarNotification(title: String, subtitle: String?, parent: UIViewController, tapClosure: (SVNotification->Void)?) -> SVNotification {
        return showNotification(title, subTitle: subtitle ?? "", parent: parent, layout: .Default, type: .Default, tapClosure: tapClosure)
    }

    class func showTempNavBarNotification(title: String, subtitle: String?, duration: Double, parent: UIViewController, tapClosure: (SVNotification->Void)?) -> SVNotification {
        return showNotification(title, subTitle: subtitle ?? "", duration: duration, parent: parent, layout: .Default, type: .Default, tapClosure: tapClosure)
    }

    /**
     Shows info notification above the Navigation Bar

     - parameter title:      title
     - parameter subtitle:   subtitle
     - parameter duration:   time(in seconds) before the notification will get hidden. Enter 0 if you want it to be permanent.
     - parameter parent:     parent view controller (may be UINavigationController)
     - parameter tapClosure: closure, executed when the view is tapped

     - returns: the notification which has been shown
     */
    class func showNavBarInfo(title: String, subtitle: String?, duration: Double, parent: UIViewController, tapClosure: (SVNotification->Void)? = nil) -> SVNotification {
        return showNotification(title, subTitle: subtitle ?? "", duration: duration, parent: parent, layout: .Default, type: .Default, tapClosure: tapClosure)
    }

    /**
     Shows success notification above the Navigation Bar

     - parameter title:      title
     - parameter subtitle:   subtitle
     - parameter duration:   time(in seconds) before the notification will get hidden. Enter 0 if you want it to be permanent.
     - parameter parent:     parent view controller (may be UINavigationController)
     - parameter tapClosure: closure, executed when the view is tapped

     - returns: the notification which has been shown
     */
    class func showNavBarSuccess(title: String, subtitle: String?, duration: Double, parent: UIViewController, tapClosure: (SVNotification->Void)? = nil) -> SVNotification {
        return showNotification(title, subTitle: subtitle ?? "", duration: duration, parent: parent, layout: .Default, type: .Success, tapClosure: tapClosure)
    }

    /**
     Shows warning notification above the Navigation Bar

     - parameter title:      title
     - parameter subtitle:   subtitle
     - parameter duration:   time(in seconds) before the notification will get hidden. Enter 0 if you want it to be permanent.
     - parameter parent:     parent view controller (may be UINavigationController)
     - parameter tapClosure: closure, executed when the view is tapped

     - returns: the notification which has been shown
     */
    class func showNavBarWarning(title: String, subtitle: String?, duration: Double, parent: UIViewController, tapClosure: (SVNotification->Void)? = nil) -> SVNotification {
        return showNotification(title, subTitle: subtitle ?? "", duration: duration, parent: parent, layout: .Default, type: .Warning, tapClosure: tapClosure)
    }

    /**
     Shows error notification above the Navigation Bar

     - parameter title:      title
     - parameter subtitle:   subtitle
     - parameter duration:   time(in seconds) before the notification will get hidden. Enter 0 if you want it to be permanent.
     - parameter parent:     parent view controller (may be UINavigationController)
     - parameter tapClosure: closure, executed when the view is tapped

     - returns: the notification which has been shown
     */
    class func showNavBarError(title: String, subtitle: String?, duration: Double, parent: UIViewController, tapClosure: (SVNotification->Void)? = nil) -> SVNotification {
        return showNotification(title, subTitle: subtitle ?? "", duration: duration, parent: parent, layout: .Default, type: .Error, tapClosure: tapClosure)
    }

    class func showTinyNotification(t: String, parent: UIViewController) -> SVNotification {
        return showNotification(t, subTitle: "", parent: parent, layout: .Tiny, type: .Default, tapClosure: nil)
    }

    // MARK: - Public methods
    func show() {
        guard NSThread.isMainThread() else {
            dispatch_async(dispatch_get_main_queue()) {
                self.show()
            }
            return
        }

        UIView.animateWithDuration(0.3) {
            self.frame = self.frameForShowing()
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
            UIView.animateWithDuration(0.3, animations: {
                self.frame = self.frameForHiding()
            }, completion: { finished in
                if finished {
                    self.removeFromSuperview()
                    callback?()
                }
            })
        } else {
            self.frame = frameForHiding()
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
            notification.currentSettings = settings
            notification.applyCurrentVisualSettings()
            notification.layout = layout
            var f = notification.frame
            f.origin.y = parent.topLayoutGuide.length - f.size.height
            f.size.height = heightForType(layout)
            notification.frame = f
            adjustSubviews()
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
        notification.lblTitle.textAlignment = .Center
        notification.addSubview(notification.lblTitle)

        let lblTitleBottomBorder = notification.lblTitle.frame.origin.y + notification.lblTitle.frame.size.height
        notification.lblSubtitle = UILabel(frame: CGRectMake(0, lblTitleBottomBorder, notification.frame.size.width, notification.frame.size.height - lblTitleBottomBorder))
        notification.lblSubtitle.textAlignment = .Center
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

    private class func adjustSubviews() {
        let isTiny = notification.layout == .Tiny
        let lblTopMargin = isTiny ? 0.0 : statusBarHeight()
        let hasSubtitle = (notification.subtitleString?.characters.count ?? 0) > 0
        var f = notification.lblTitle.frame
        f.origin.y = lblTopMargin
        f.size.height = hasSubtitle ? (notification.frame.size.height - lblTopMargin) / (isTiny ? 1.0 : 2.0) : notification.frame.size.height - lblTopMargin
        notification.lblTitle.frame = f

        let lblTitleBottonBorder = f.origin.y + f.size.height
        var f1 = notification.lblSubtitle.frame
        f1.origin.y = lblTitleBottonBorder
        f1.size.height = notification.frame.size.height - lblTitleBottonBorder
        notification.lblSubtitle.frame = f1
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

        adjustSubviews()
        populateData()
        notification.parentVC = realParent
        realParent.view.addSubview(notification)
        if duration > SVNotification.Permanent {
            notification.startHideCountdownFor(duration)
        }
        return notification
    }

    /**
     Shows permanent notification
     */
    private class func showNotification(title: String, subTitle: String, parent: UIViewController, layout: LayoutType, type: NotificationType, tapClosure: (SVNotification->Void)?) -> SVNotification {
        notification = SVNotification.initWithTitle(title, subtitle: subTitle, duration: SVNotification.Permanent, parent: parent, layout: layout, type: type, settings: Settings(), closure: tapClosure)
        notification.show()
        return notification
    }

    /**
     Shows notification with duration
     */
    private class func showNotification(title: String, subTitle: String, duration: Double, parent: UIViewController, layout: LayoutType, type: NotificationType, tapClosure: (SVNotification->Void)?) -> SVNotification {
        var settings: Settings! = nil
        switch type {
            case .Success:
                settings = SuccessSettings()
            case .Warning:
                settings = WarningSettings()
            case .Error:
                settings = ErrorSettings()
            default:
                settings = Settings()
        }
        notification = SVNotification.initWithTitle(title, subtitle: subTitle, duration: duration, parent: parent, layout: layout, type: type, settings: settings, closure: tapClosure)
        notification.show()
        return notification
    }

    // MARK: - Private methods
    private func frameForHiding() -> CGRect {
        var f = self.frame
        f.origin.y = (layout == .Default ? 0 : parentVC.topLayoutGuide.length) - f.size.height
        return f
    }

    private func frameForShowing() -> CGRect {
        var f = self.frame
        f.origin.y = layout == .Default ? 0 : parentVC.topLayoutGuide.length
        return f
    }

    private func startHideCountdownFor(duration: Double) {
        stopHideTimerIfRunning()
        SVNotification.hideTimer = NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector: #selector(hideAnimated), userInfo: nil, repeats: false)
    }

    private func stopHideTimerIfRunning() {
        if SVNotification.hideTimer != nil {
            SVNotification.hideTimer.invalidate()
            SVNotification.hideTimer = nil
        }
    }

    private func applyCurrentVisualSettings() {
        backgroundColor = currentSettings.bgrColor
        lblTitle.textColor = currentSettings.textColor
        lblSubtitle.textColor = currentSettings.textColor
        lblTitle.font = lblTitle.font.fontWithSize(currentSettings.textSize)
        lblSubtitle.font = lblSubtitle.font.fontWithSize(lblTitle.font.pointSize - 1.0)
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
