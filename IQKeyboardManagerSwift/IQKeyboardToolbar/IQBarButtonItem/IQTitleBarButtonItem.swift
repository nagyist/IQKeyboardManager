//
//  IQTitleBarButtonItem.swift
//  https://github.com/hackiftekhar/IQKeyboardManager
//  Copyright (c) 2013-24 Iftekhar Qurashi.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

@available(iOSApplicationExtension, unavailable)
@MainActor
@objcMembers open class IQTitleBarButtonItem: IQBarButtonItem {

    open var titleFont: UIFont? {

        didSet {
            if let titleFont: UIFont = titleFont {
                titleButton?.titleLabel?.font = titleFont
            } else {
                titleButton?.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            }
        }
    }

    override open var title: String? {
        didSet {
            titleButton?.setTitle(title, for: .normal)
            updateAccessibility()
        }
    }

    /**
     titleColor to be used for displaying button text when displaying title (disabled state).
     */
    open var titleColor: UIColor? {

        didSet {

            if let titleColor: UIColor = titleColor {
                titleButton?.setTitleColor(titleColor, for: .disabled)
            } else {
                titleButton?.setTitleColor(UIColor.lightGray, for: .disabled)
            }
        }
    }

    /**
     selectableTitleColor to be used for displaying button text when button is enabled.
     */
    open var selectableTitleColor: UIColor? {

        didSet {

            if let selectableTitleColor: UIColor = selectableTitleColor {
                titleButton?.setTitleColor(selectableTitleColor, for: .normal)
            } else {
                titleButton?.setTitleColor(UIColor.systemBlue, for: .normal)
            }
        }
    }

    internal var titleButton: UIButton?
    private var _titleView: UIView?

    override init() {
        super.init()
    }

    public convenience init(title: String?) {

        self.init(title: nil, style: .plain, target: nil, action: nil)

        _titleView = UIView()
        _titleView?.backgroundColor = UIColor.clear

        titleButton = UIButton(type: .system)
        titleButton?.isAccessibilityElement = false
        titleButton?.isEnabled = false
        titleButton?.titleLabel?.numberOfLines = 3
        titleButton?.setTitleColor(UIColor.lightGray, for: .disabled)
        titleButton?.setTitleColor(UIColor.systemBlue, for: .normal)
        titleButton?.backgroundColor = UIColor.clear
        titleButton?.titleLabel?.textAlignment = .center
        titleButton?.setTitle(title, for: .normal)
        titleFont = UIFont.systemFont(ofSize: 13.0)
        titleButton?.titleLabel?.font = self.titleFont
        _titleView?.addSubview(titleButton!)

        let lowPriority: UILayoutPriority = UILayoutPriority(rawValue: UILayoutPriority.defaultLow.rawValue-1)
        let highPriority: UILayoutPriority = UILayoutPriority(rawValue: UILayoutPriority.defaultHigh.rawValue-1)

        _titleView?.translatesAutoresizingMaskIntoConstraints = false
        _titleView?.setContentHuggingPriority(lowPriority, for: .vertical)
        _titleView?.setContentHuggingPriority(lowPriority, for: .horizontal)
        _titleView?.setContentCompressionResistancePriority(highPriority, for: .vertical)
        _titleView?.setContentCompressionResistancePriority(highPriority, for: .horizontal)

        titleButton?.translatesAutoresizingMaskIntoConstraints = false
        titleButton?.setContentHuggingPriority(lowPriority, for: .vertical)
        titleButton?.setContentHuggingPriority(lowPriority, for: .horizontal)
        titleButton?.setContentCompressionResistancePriority(highPriority, for: .vertical)
        titleButton?.setContentCompressionResistancePriority(highPriority, for: .horizontal)

        let top: NSLayoutConstraint = NSLayoutConstraint(item: titleButton!, attribute: .top,
                                                         relatedBy: .equal,
                                                         toItem: _titleView, attribute: .top,
                                                         multiplier: 1, constant: 0)
        let bottom: NSLayoutConstraint = NSLayoutConstraint(item: titleButton!, attribute: .bottom,
                                                            relatedBy: .equal,
                                                            toItem: _titleView, attribute: .bottom,
                                                            multiplier: 1, constant: 0)
        let leading: NSLayoutConstraint = NSLayoutConstraint(item: titleButton!, attribute: .leading,
                                                             relatedBy: .equal,
                                                             toItem: _titleView, attribute: .leading,
                                                             multiplier: 1, constant: 0)
        let trailing: NSLayoutConstraint = NSLayoutConstraint(item: titleButton!, attribute: .trailing,
                                                              relatedBy: .equal,
                                                              toItem: _titleView, attribute: .trailing,
                                                              multiplier: 1, constant: 0)

        _titleView?.addConstraints([top, bottom, leading, trailing])

        customView = _titleView
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func updateAccessibility() {
        if title == nil || title?.isEmpty == true {
            isAccessibilityElement = false
            // Swift 6: Reference to static property 'none'
            // is not concurrency-safe because it involves shared mutable state
//            accessibilityTraits = .none
            accessibilityTraits = .init(rawValue: 0)
        } else if titleButton?.isEnabled == true {
            isAccessibilityElement = true
            // Swift 6: Reference to static property 'button'
            // is not concurrency-safe because it involves shared mutable state
//            accessibilityTraits = .button
            accessibilityTraits = .init(rawValue: 1)
        } else {
            isAccessibilityElement = true

            // Swift 6: Reference to static property 'staticText'
            // is not concurrency-safe because it involves shared mutable state
//            accessibilityTraits = .staticText
            accessibilityTraits = .init(rawValue: 64)
        }
    }
}
