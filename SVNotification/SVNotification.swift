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

    // MARK: - Public properties
    var tapClosure: (SVNotification -> Void)? = nil

    // MARK: - Private properties
    private var notificationType: LayoutType = .Default
    private var titleString: String! = nil
    private var subtitleString: String! = nil
    private var lblTitle: UILabel! = nil
    private var lblSubtitle: UILabel! = nil
    private var parentVC: UIViewController! = nil

    //// MARK: - Private static properties
    private static var notification: SVNotification! = nil
    private static let defaultBgrColor = UIColor.orangeColor()
    private static let defaultTextColor = UIColor.whiteColor()
    private static let defaultTextSize: CGFloat = 13.0
    private static var hideTimer: NSTimer! = nil

    // MARK: - Static properties
    static var Permanent: Double = 0.0
    static var bgrColor: UIColor! = SVNotification.defaultBgrColor
    static var textColor: UIColor! = SVNotification.defaultTextColor
    static var textSize: CGFloat = SVNotification.defaultTextSize

    // MARK: - Public Static methods
    class func showPermanentNavBarNotification(title: String, subtitle: String?, parent: UIViewController, tapClosure: (SVNotification->Void)?) -> SVNotification {
        return showNotification(title, subTitle: subtitle ?? "", parent: parent, type: .Default, tapClosure: tapClosure)
    }

    class func showTempNavBarNotification(title: String, subtitle: String?, duration: Double, parent: UIViewController, tapClosure: (SVNotification->Void)?) -> SVNotification {
        return showNotification(title, subTitle: subtitle ?? "", duration: duration, parent: parent, type: .Default, tapClosure: tapClosure)
    }

    class func showTinyNotification(t: String, parent: UIViewController) -> SVNotification {
        return showNotification(t, subTitle: "", parent: parent, type: .Tiny, tapClosure: nil)
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
    private class func setupView(type: LayoutType, parent: UIViewController) {
        guard notification == nil else {
            notification.notificationType = type
            var f = notification.frame
            f.origin.y = parent.topLayoutGuide.length - f.size.height
            f.size.height = heightForType(type)
            notification.frame = f
            adjustSubviews()
            return
        }

        let topMargin = (type == .Default ? 0 : parent.topLayoutGuide.length) - heightForType(type)
        notification = SVNotification(type: .Custom)
        notification.notificationType = type
        notification.setTitle("", forState: .Normal)
        notification.frame = CGRectMake(0, topMargin, UIScreen.mainScreen().bounds.width , heightForType(type))
        notification.backgroundColor = defaultBgrColor
        setupShadow()

        let isTiny = type == .Tiny
        let lblTopMargin = type == .Tiny ? 0.0 : statusBarHeight()
        let centerYCoord = (notification.frame.size.height - lblTopMargin) / (isTiny ? 1.0 : 2.0)
        notification.lblTitle = UILabel(frame: CGRectMake(0, lblTopMargin, notification.frame.size.width, centerYCoord))
        notification.lblTitle.textColor = textColor
        notification.lblTitle.textAlignment = .Center
        notification.lblTitle.font = notification.lblTitle.font.fontWithSize(textSize)
        notification.addSubview(notification.lblTitle)

        let lblTitleBottomBorder = notification.lblTitle.frame.origin.y + notification.lblTitle.frame.size.height
        notification.lblSubtitle = UILabel(frame: CGRectMake(0, lblTitleBottomBorder, notification.frame.size.width, notification.frame.size.height - lblTitleBottomBorder))
        notification.lblSubtitle.textColor = textColor
        notification.lblSubtitle.textAlignment = .Center
        notification.lblSubtitle.font = notification.lblSubtitle.font.fontWithSize(notification.lblTitle.font.pointSize - 1.0)
        notification.addSubview(notification.lblSubtitle)

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
        let isTiny = notification.notificationType == .Tiny
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
    private class func initWithTitle(title: String, subtitle: String, duration: Double, parent: UIViewController, andLayout layout: LayoutType, closure: (SVNotification->Void)?) -> SVNotification {
        // If we want to display nav bar notification, but we have specified a VC as parent, we must find the NavigationVC
        let realParent = layout == .Default && !(parent is UINavigationController) && parent.navigationController != nil ? parent.navigationController! : parent
        if notification?.superview != nil && notification.superview! != parent {
            notification.removeFromSuperview()
        }
        setupView(layout, parent: realParent)
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

    private class func showNotification(title: String, subTitle: String, parent: UIViewController, type: LayoutType, tapClosure: (SVNotification->Void)?) -> SVNotification {
        notification = SVNotification.initWithTitle(title, subtitle: subTitle, duration: SVNotification.Permanent, parent: parent, andLayout: type, closure: tapClosure)
        notification.show()
        return notification
    }

    private class func showNotification(title: String, subTitle: String, duration: Double, parent: UIViewController, type: LayoutType, tapClosure: (SVNotification->Void)?) -> SVNotification {
        notification = SVNotification.initWithTitle(title, subtitle: subTitle, duration: duration, parent: parent, andLayout: type, closure: tapClosure)
        notification.show()
        return notification
    }

    // MARK: - Private methods
    private func frameForHiding() -> CGRect {
        var f = self.frame
        f.origin.y = (notificationType == .Default ? 0 : parentVC.topLayoutGuide.length) - f.size.height
        return f
    }

    private func frameForShowing() -> CGRect {
        var f = self.frame
        f.origin.y = notificationType == .Default ? 0 : parentVC.topLayoutGuide.length
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
}
