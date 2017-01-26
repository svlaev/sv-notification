//
//  SVNotification.swift
//  SVNotification
//
//  Created by Stanislav Vlaev on 6/27/16.
//  Copyright © 2016 Test. All rights reserved.
//

import UIKit

open class SVNotification: UIButton {
    public enum LayoutType: Int {
        /**
         Default type. Shows notification overlaying the nav bar
         */
        case `default`

        /**
         Displays notification with 20pt height
         */
        case tiny
    }

    public enum NotificationType {
        /*
         Displays default notification with blue background
         */
        case `default`
        /*
         Displays notification with green background
         */
        case success
        /*
         Displays notification with red background
         */
        case error
        /*
         Displays notification with yellow background
         */
        case warning
    }

    // MARK: - Static classes
    open class Style {
        open var bgrColor: UIColor = UIColor.withDecimal(175, g: 15, b: 23)
        open var textColorTitle: UIColor = UIColor.white
        open var textColorSubtitle: UIColor = UIColor.white
        open var textSizeTitle: CGFloat = 14.0
        open var textSizeSubtitle: CGFloat = 13.0
        open var fontTitle: UIFont = UIFont(name: "Avenir-Bold", size: 14.0) ?? UIFont.boldSystemFont(ofSize: 14.0)
        open var fontSubtitle: UIFont = UIFont(name: "Avenir-Bold", size: 13.0) ?? UIFont.boldSystemFont(ofSize: 13.0)
        open var textAlignmentTitle: NSTextAlignment = .left
        open var textAlignmentSubtitle: NSTextAlignment = .left

        public init(){
            
        }
    }

    open class SuccessStyle: Style {
        override init() {
            super.init()
            bgrColor = UIColor.withDecimal(92, g: 184, b: 92)
        }
    }

    open class WarningStyle: Style {
        override init() {
            super.init()
            bgrColor = UIColor.withDecimal(240, g: 173, b: 78)
        }
    }

    open class ErrorStyle: Style {
        override init() {
            super.init()
            bgrColor = UIColor.withDecimal(213, g: 83, b: 79)
        }
    }

    // MARK: - Public properties
    open var tapClosure: ((SVNotification) -> Void)? = nil

    // MARK: - Private properties
    fileprivate var layout: LayoutType = .default
    fileprivate var type: NotificationType = NotificationType.default
    fileprivate var blurView: UIVisualEffectView! = nil
    fileprivate var titleString: String! = nil
    fileprivate var subtitleString: String! = nil
    fileprivate var lblTitle: UILabel! = nil
    fileprivate var lblSubtitle: UILabel! = nil
    fileprivate var parentVC: UIViewController! = nil
    fileprivate var currentStyle: Style! = nil

    // MARK: - Private constraints
    fileprivate weak var constrNotificationTopMargin: NSLayoutConstraint! = nil
    fileprivate weak var constrNotificationHeight: NSLayoutConstraint! = nil
    fileprivate weak var constrLblTitleTopMargin: NSLayoutConstraint! = nil
    fileprivate weak var constrLblSubtitleHeight: NSLayoutConstraint! = nil

    //// MARK: - Private static properties
    fileprivate static var notification: SVNotification! = nil
    fileprivate static var hideTimer: Timer! = nil

    // MARK: - Static properties
    open static var Permanent: Double = 0.0

    // MARK: - Public Static methods
    /**
     Shows default notification above the Navigation bar

     - parameter title:      title
     - parameter subtitle:   subtitle (if any)
     - parameter duration:   time(in seconds) before the notification will dissappear. Enter `SVNotification.Permanent` for non-dissappearing notification
     - parameter parent:     parent view controller (may be UINavigationController)
     - parameter tapClosure: closure, executed when view is tapped

     - returns: the notification which has been shown
     */
    @discardableResult
    open class func showDefaultAboveNavBar(_ title: String, subtitle: String? = nil, duration: Double, parent: UIViewController, tapClosure: ((SVNotification) -> Void)? = nil) -> SVNotification {
        return showNotification(title, subTitle: subtitle ?? "", duration: duration, parent: parent, layout: .default, type: .default, style: nil, tapClosure: tapClosure)
    }

    /**
     Shows success notification above the Navigation bar

     - parameter title:      title
     - parameter subtitle:   subtitle (if any)
     - parameter duration:   time(in seconds) before the notification will dissappear. Enter `SVNotification.Permanent` for non-dissappearing notification
     - parameter parent:     parent view controller (may be UINavigationController)
     - parameter tapClosure: closure, executed when view is tapped

     - returns: the notification which has been shown
     */
    @discardableResult
    open class func showSuccessAboveNavBar(_ title: String, subtitle: String? = nil, duration: Double, parent: UIViewController, tapClosure: ((SVNotification) -> Void)? = nil) -> SVNotification {
        return showNotification(title, subTitle: subtitle ?? "", duration: duration, parent: parent, layout: .default, type: .success, style: nil, tapClosure: tapClosure)
    }

    /**
     Shows warning notification above the Navigation bar

     - parameter title:      title
     - parameter subtitle:   subtitle (if any)
     - parameter duration:   time(in seconds) before the notification will dissappear. Enter `SVNotification.Permanent` for non-dissappearing notification
     - parameter parent:     parent view controller (may be UINavigationController)
     - parameter tapClosure: closure, executed when view is tapped

     - returns: the notification which has been shown
     */
    @discardableResult
    open class func showWarningAboveNavBar(_ title: String, subtitle: String? = nil, duration: Double, parent: UIViewController, tapClosure: ((SVNotification) -> Void)? = nil) -> SVNotification {
        return showNotification(title, subTitle: subtitle ?? "", duration: duration, parent: parent, layout: .default, type: .warning, style: nil, tapClosure: tapClosure)
    }

    /**
     Shows error notification above the Navigation bar

     - parameter title:      title
     - parameter subtitle:   subtitle (if any)
     - parameter duration:   time(in seconds) before the notification will dissappear. Enter `SVNotification.Permanent` for non-dissappearing notification
     - parameter parent:     parent view controller (may be UINavigationController)
     - parameter tapClosure: closure, executed when view is tapped

     - returns: the notification which has been shown
     */
    @discardableResult
    open class func showErrorAboveNavBar(_ title: String, subtitle: String? = nil, duration: Double, parent: UIViewController, tapClosure: ((SVNotification) -> Void)? = nil) -> SVNotification {
        return showNotification(title, subTitle: subtitle ?? "", duration: duration, parent: parent, layout: .default, type: .error, style: nil, tapClosure: tapClosure)
    }

    /**
     Shows notification above the Navigation bar

     - parameter title:      title
     - parameter subtitle:   subtitle (if any)
     - parameter duration:   time(in seconds) before the notification will dissappear. Enter `SVNotification.Permanent` for non-dissappearing notification
     - parameter type:       the type of notification
     - parameter parent:     parent view controller (may be UINavigationController)
     - parameter style:      visual styles. Leave nil for default ones
     - parameter tapClosure: closure, executed when view is tapped

     - returns: the notification which has been shown
     */
    @discardableResult
    open class func showCustomAboveNavBar(_ title: String, subtitle: String? = nil, duration: Double, type: NotificationType, parent: UIViewController, style: Style? = nil, tapClosure: ((SVNotification) -> Void)? = nil) -> SVNotification {
        return showNotification(title, subTitle: subtitle ?? "", duration: duration, parent: parent, layout: .default, type: .success, style: style, tapClosure: tapClosure)
    }

    /**
     Shows tiny notification below the nav bar for limited time

     - parameter t:        title
     - parameter duration: time(in seconds) before the notification will dissappear. Enter `SVNotification.Permanent` for non-dissappearing notification
     - parameter parent:   parent view controller
     - parameter style:    visual styles. Leave nil for default ones

     - returns: the notification which has been shown
     */
    @discardableResult
    open class func showTinyNotification(title t: String, duration: Double, parent: UIViewController, type: NotificationType = .default, style: Style? = nil) -> SVNotification {
        return showNotification(t, subTitle: "", duration: duration, parent: parent, layout: .tiny, type: type, style: style, tapClosure: nil)
    }

    // MARK: - Public methods
    open func show() {
        guard Thread.isMainThread else {
            DispatchQueue.main.async {
                self.show()
            }
            return
        }

        constrNotificationTopMargin.constant = yCoordForShowing()
        UIView.animate(withDuration: 0.3, animations: {
            self.setNeedsUpdateConstraints()
            self.layoutIfNeeded()
        }) 
    }

    open func hide(_ animated: Bool = true, callback: ((Void)->Void)? = nil) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async {
                self.hide(animated, callback: callback)
            }
            return
        }
        stopHideTimerIfRunning()
        if animated {
            constrNotificationTopMargin.constant = yCoordForHiding()
            UIView.animate(withDuration: 0.3, animations: {
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

    open func hideAnimated() {
        hide(true)
    }

    func viewTapped() {
        tapClosure?(self)
    }

    // MARK: - Private static methods
    fileprivate class func setupView(_ layout: LayoutType, type: NotificationType, parent: UIViewController, style: Style) {
        guard notification == nil else {
            notification.stopHideTimerIfRunning()
            notification.currentStyle = style
            notification.type = type
            notification.setupBlurView()
            notification.applyCurrentVisualStyles()
            notification.layout = layout
            notification.constrNotificationTopMargin?.constant = notification.yCoordForHiding()
            notification.constrNotificationHeight?.constant = SVNotification.heightForType(layout)
            return
        }

        let topMargin = (layout == .default ? 0 : parent.topLayoutGuide.length) - heightForType(layout)
        notification = SVNotification(type: .custom)
        notification.currentStyle = style
        notification.layout = layout
        notification.type = type
        notification.setTitle("", for: UIControlState())
        notification.frame = CGRect(x: 0, y: topMargin, width: UIScreen.main.bounds.width , height: heightForType(layout))
        setupShadow()
        notification.setupBlurView()

        let isTiny = layout == .tiny
        let lblTopMargin = layout == .tiny ? 0.0 : statusBarHeight()
        let centerYCoord = (notification.frame.size.height - lblTopMargin) / (isTiny ? 1.0 : 2.0)
        notification.lblTitle = UILabel(frame: CGRect(x: 0, y: lblTopMargin, width: notification.frame.size.width, height: centerYCoord))
        notification.lblTitle.textAlignment = notification.currentStyle.textAlignmentTitle
        notification.lblTitle.numberOfLines = 0
        notification.addSubview(notification.lblTitle)

        let lblTitleBottomBorder = notification.lblTitle.frame.origin.y + notification.lblTitle.frame.size.height
        notification.lblSubtitle = UILabel(frame: CGRect(x: 0, y: lblTitleBottomBorder, width: notification.frame.size.width, height: notification.frame.size.height - lblTitleBottomBorder))
        notification.lblSubtitle.textAlignment = notification.currentStyle.textAlignmentSubtitle
        notification.lblSubtitle.numberOfLines = 0
        notification.addSubview(notification.lblSubtitle)

        notification.applyCurrentVisualStyles()
        populateData()

        notification.addTarget(notification, action: #selector(viewTapped), for: .touchUpInside)
    }

    fileprivate class func populateData() {
        notification.lblTitle.text = notification.titleString
        notification.lblTitle.textAlignment = notification.subtitleString != nil && notification.subtitleString.characters.count > 0 ? .left : .center
        notification.lblSubtitle.text = notification.subtitleString
    }

    fileprivate class func setupShadow() {
        notification.layer.masksToBounds = false
        notification.layer.shadowColor = UIColor.gray.cgColor
        notification.layer.shadowRadius = 5.0
        notification.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        notification.layer.shadowOpacity = 1.0
    }

    fileprivate class func heightForType(_ type: LayoutType) -> CGFloat {
        switch type {
        case .default:
            return 44.0 + statusBarHeight()
        case.tiny:
            return 20.0
        }
    }

    fileprivate class func statusBarHeight() -> CGFloat {
        return UIApplication.shared.statusBarFrame.size.height
    }

    // MARK: - Private static initialization methods
    fileprivate class func initWithTitle(_ title: String, subtitle: String, duration: Double, parent: UIViewController, layout: LayoutType, type: NotificationType, style: Style, closure: ((SVNotification)->Void)?) -> SVNotification {
        // If we want to display nav bar notification, but we have specified a VC as parent, we must find the NavigationVC
        let realParent = layout == .default && !(parent is UINavigationController) && parent.navigationController != nil ? parent.navigationController! : parent
        if notification?.superview != nil && notification.superview! != parent {
            notification.removeFromSuperview()
        }
        setupView(layout, type: type, parent: realParent, style: style)
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
    fileprivate class func showNotification(_ title: String, subTitle: String, parent: UIViewController, layout: LayoutType, type: NotificationType, style: Style?, tapClosure: ((SVNotification)->Void)?) -> SVNotification {
        return showNotification(title, subTitle: subTitle, duration: SVNotification.Permanent, parent: parent, layout: layout, type: type, style: style, tapClosure: tapClosure)
    }

    /**
     Shows notification with duration
     */
    fileprivate class func showNotification(_ title: String, subTitle: String, duration: Double, parent: UIViewController, layout: LayoutType, type: NotificationType, style: Style?, tapClosure: ((SVNotification)->Void)?) -> SVNotification {
        var s: Style! = style
        if s == nil {
            switch type {
            case .success:
                s = SuccessStyle()
            case .warning:
                s = WarningStyle()
            case .error:
                s = ErrorStyle()
            default:
                s = Style()
            }
        }
        notification = SVNotification.initWithTitle(title, subtitle: subTitle, duration: duration, parent: parent, layout: layout, type: type, style: s, closure: tapClosure)
        notification.show()
        return notification
    }

    // MARK: - Private methods
    fileprivate func yCoordForHiding() -> CGFloat {
        return (layout == .default ? 0 : parentVC.topLayoutGuide.length) - (constrNotificationHeight?.constant ?? frame.size.height)
    }

    fileprivate func yCoordForShowing() -> CGFloat {
        return layout == .default ? 0.0 : parentVC.topLayoutGuide.length
    }

    fileprivate func startHideCountdownFor(_ duration: Double) {
        stopHideTimerIfRunning()
        SVNotification.hideTimer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(SVNotification.hideAnimated), userInfo: nil, repeats: false)
    }

    fileprivate func stopHideTimerIfRunning() {
        if SVNotification.hideTimer != nil {
            SVNotification.hideTimer.invalidate()
            SVNotification.hideTimer = nil
        }
    }

    fileprivate func applyCurrentVisualStyles() {
        backgroundColor = type == .default ? UIColor.clear : currentStyle.bgrColor
        lblTitle.textColor = currentStyle.textColorTitle
        lblSubtitle.textColor = currentStyle.textColorSubtitle
        lblTitle.font = currentStyle.fontTitle.withSize(currentStyle.textSizeTitle)
        lblSubtitle.font = currentStyle.fontSubtitle.withSize(currentStyle.textSizeSubtitle)
    }

    fileprivate func setupConstraints() {
        if constrNotificationTopMargin == nil {
            self.translatesAutoresizingMaskIntoConstraints = false
            let topMargin = (layout == .default ? 0 : parentVC.topLayoutGuide.length) - SVNotification.heightForType(layout)
            let dict = ["notification" : self]
            let height = SVNotification.heightForType(layout)
            // resize down the subtitle if it's height is greater than the notification height
            if constrLblSubtitleHeight != nil && constrLblSubtitleHeight.constant > height {
                constrLblSubtitleHeight.constant = 0.0
            }
            var constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[notification]-0-|",
                                                                             options: NSLayoutFormatOptions(rawValue: 0),
                                                                             metrics: nil,
                                                                             views: dict)
            constrNotificationTopMargin = NSLayoutConstraint(item: self,
                                                             attribute: .top,
                                                             relatedBy: .equal,
                                                             toItem: parentVC.view,
                                                             attribute: .topMargin,
                                                             multiplier: 1.0,
                                                             constant: topMargin)
            constraints.append(constrNotificationTopMargin)
            constrNotificationHeight = NSLayoutConstraint(item: self,
                                                          attribute: .height,
                                                          relatedBy: .equal,
                                                          toItem: nil,
                                                          attribute: .notAnAttribute,
                                                          multiplier: 1.0,
                                                          constant: height)
            constraints.append(constrNotificationHeight)
            parentVC.view.addConstraints(constraints)
        }

        let isTiny = layout == .tiny
        let lblTopMargin = isTiny ? 0.0 : SVNotification.statusBarHeight()
        let hasSubtitle = (subtitleString?.characters.count ?? 0) > 0
        let subTitleHeight = isTiny ? 0 : (hasSubtitle ? (constrNotificationHeight.constant - lblTopMargin) / 2.0 : 0)
        if constrLblSubtitleHeight == nil {
            let dict: [String : Any] = ["lbl" : lblSubtitle]
            lblSubtitle.translatesAutoresizingMaskIntoConstraints = false
            var constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[lbl]-0-|",
                                                                             options: NSLayoutFormatOptions(rawValue: 0),
                                                                             metrics: nil,
                                                                             views: dict)
            constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[lbl]-10-|",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: nil,
                views: dict))
            constrLblSubtitleHeight = NSLayoutConstraint(item: lblSubtitle,
                                                         attribute: .height,
                                                         relatedBy: .equal,
                                                         toItem: nil,
                                                         attribute: .notAnAttribute,
                                                         multiplier: 1.0,
                                                         constant: subTitleHeight)
            constraints.append(constrLblSubtitleHeight)
            self.addConstraints(constraints)
        } else {
            constrLblSubtitleHeight.constant = subTitleHeight
        }

        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        if constrLblTitleTopMargin == nil {
            let dict: [String : Any] = ["lblTitle" : lblTitle, "lblSubtitle" : lblSubtitle]
            var arr = NSLayoutConstraint.constraints(withVisualFormat: "V:[lblTitle]-0-[lblSubtitle]",
                                                                     options: NSLayoutFormatOptions(rawValue:0),
                                                                     metrics: nil,
                                                                     views: dict)
            constrLblTitleTopMargin = NSLayoutConstraint(item: lblTitle,
                                                         attribute: .top,
                                                         relatedBy: .equal,
                                                         toItem: self,
                                                         attribute: .top,
                                                         multiplier: 1.0,
                                                         constant: lblTopMargin)
            arr.append(constrLblTitleTopMargin)
            arr.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[lblTitle]-10-|",
                options: NSLayoutFormatOptions(rawValue:0),
                metrics: nil,
                views: dict))
            self.addConstraints(arr)
        } else {
            constrLblTitleTopMargin.constant = lblTopMargin
        }
        
        constrNotificationHeight.constant = SVNotification.heightForType(layout)
    }
    
    fileprivate func setupBlurView() {
        if blurView != nil && blurView.superview != nil  {
            return
        }
        
        let effect = UIBlurEffect(style: .light)
        blurView = UIVisualEffectView(effect: effect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.isUserInteractionEnabled = false
        blurView.isHidden = true
        let d: [String: Any] = ["blur" : blurView]
        self.addSubview(blurView)
        self.sendSubview(toBack: blurView)
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[blur]-0-|",
                                                                         options: NSLayoutFormatOptions(rawValue: 0),
                                                                         metrics: nil,
                                                                         views: d)
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[blur]-0-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: d))
        self.addConstraints(constraints)
        self.setNeedsUpdateConstraints()
        self.layoutIfNeeded()
        blurView.isHidden = false
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
    static func withDecimal(_ r: Int, g: Int, b: Int, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    }
}
