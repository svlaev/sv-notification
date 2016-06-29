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
    var tapClosure: (SVNotification -> Void)! = nil

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

    // MARK: - Static properties
    static var bgrColor: UIColor! = SVNotification.defaultBgrColor
    static var textColor: UIColor! = SVNotification.defaultTextColor
    static var textSize: CGFloat = SVNotification.defaultTextSize

    // MARK: - Static methods
    class func withTitle(title: String, parent: UIViewController, andLayout type: LayoutType) -> SVNotification {
        return withTitle(title, subtitle: "", parent: parent, andLayout: type)
    }

    class func withTitle(title: String, subtitle: String, parent: UIViewController, andLayout layout: LayoutType) -> SVNotification {
        if notification?.superview != nil && notification.superview! != parent {
            notification.removeFromSuperview()
        }
        setupView(layout)
        notification.titleString = title
        notification.subtitleString = subtitle

        adjustSubviews()
        populateData()
        notification.parentVC = parent
        parent.view.addSubview(notification)
        return notification
    }

    class func show(title: String, parent: UIViewController, type: LayoutType, tapClosure: SVNotification->Void) {
        notification = SVNotification.withTitle(title, parent: parent, andLayout: type)
        notification.tapClosure = tapClosure
        notification.show()
    }

    class func show(title: String, subTitle: String, parent: UIViewController, type: LayoutType, tapClosure: SVNotification->Void) {
        notification = SVNotification.withTitle(title, subtitle: subTitle, parent: parent, andLayout: type)
        notification.tapClosure = tapClosure
        notification.show()
    }

    // MARK: - Public methods
    func show() {
        guard NSThread.isMainThread() else {
            dispatch_async(dispatch_get_main_queue()) {
                self.show()
            }
            return
        }

        var f = self.frame
        f.origin.y =  0.0
        UIView.animateWithDuration(0.3) {
            self.frame = f
        }
    }

    func hide(animated: Bool = true, callback: (Void->Void)? = nil) {
        guard NSThread.isMainThread() else {
            dispatch_async(dispatch_get_main_queue()) {
                self.hide(animated, callback: callback)
            }
            return
        }
        guard self.frame.origin.x >= 0.0 else {
            callback?()
            return
        }
        if animated {
            var f = self.frame
            f.origin.y = -self.frame.size.height
            UIView.animateWithDuration(0.3, animations: {
                self.frame = f
            }, completion: { finished in
                if finished {
                    self.removeFromSuperview()
                    callback?()
                }
            })
        } else {
            var f = self.frame
            f.origin.y = -self.frame.size.height
            self.frame = f
            self.removeFromSuperview()
            callback?()
        }
    }

    func viewTapped() {
        tapClosure?(self)
    }

    // MARK: - Private static methods
    private class func setupView(type: LayoutType) {
        guard notification == nil else {
            notification.notificationType = type
            var f = notification.frame
            f.origin.y = -f.size.height
            f.size.height = heightForType(type)
            notification.frame = f
            adjustSubviews()
            return
        }

        notification = SVNotification(type: .Custom)
        notification.notificationType = type
        notification.setTitle("", forState: .Normal)
        notification.frame = CGRectMake(0, -heightForType(type), UIScreen.mainScreen().bounds.width , heightForType(type))
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

    private static func statusBarHeight() -> CGFloat {
        return UIApplication.sharedApplication().statusBarFrame.size.height
    }
}
