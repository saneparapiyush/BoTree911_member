//
//  NGOPassCodeView.swift
//  andGo
//
//  Created by Stanislav Zhukovskiy on 29.06.15.
//  Copyright (c) 2015 Stas Zhukovskiy. All rights reserved.
//

import Foundation
import UIKit

public protocol NGOPassCodeViewDelegate {
    func NGOPassCodeViewDidFinishEnteringPassword(password: String)
}

public class NGOPassCodeView: UIView, UITextFieldDelegate {
    
    public var delegate: NGOPassCodeViewDelegate?
    public var borderColor: UIColor = UIColor.lightGray {
        didSet {
            self.setupScrollView()
        }
    }
    public var borderWidth: CGFloat = 1 {
        didSet {
            self.setupScrollView()
        }
    }
    public var numberOfDigits: Int = 5 {
        didSet {
            self.setupScrollView()
        }
    }
    public var circleDiameter: CGFloat = 8 {
        didSet {
            self.setupScrollView()
        }
    }
    public var keyboardAppearance: UIKeyboardAppearance = UIKeyboardAppearance.light {
        didSet {
            self.setupTextField()
        }
    }
    
    private var scrollView: UIScrollView = UIScrollView()
    private var textField: UITextField = UITextField()
    
    //MARK: - View Cycle
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.setupScrollView()
        self.setupTextField()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.setupScrollView()
    }
    
    //MARK: - Setup UI
    
    private func setupScrollView() {
        
        self.scrollView.removeFromSuperview()
        self.scrollView = UIScrollView(frame: self.bounds)
        self.addSubview(self.scrollView)
        self.scrollView.isUserInteractionEnabled = false
        
        let viewWidth       = self.bounds.width / CGFloat(self.numberOfDigits)
        let passCharacters  = self.textField.text!.characters.count
        
        for (index, _) in (0...self.numberOfDigits - 1).enumerated() {
            
            let frame   = CGRect(x: CGFloat(index) * viewWidth, y: 0, width: viewWidth, height: self.bounds.height)
            
            let view    = UIView(frame: frame)
            view.isUserInteractionEnabled = false
            view.backgroundColor = UIColor.clear
            
            view.layer.addSublayer(self.borderInFrame(outerFrame: frame))
            if index < passCharacters {
                view.layer.addSublayer(self.circleInFrame(outerFrame: frame, isFilled: true))
            }
            else {
                view.layer.addSublayer(self.circleInFrame(outerFrame: frame, isFilled: false))
            }
            self.scrollView.addSubview(view)
        }
    }
    
    private func setupTextField() {
        self.textField.removeFromSuperview()
        self.textField = UITextField(frame: self.bounds)
        self.addSubview(self.textField)
        self.textField.delegate             = self
        self.textField.textColor            = UIColor.clear
        self.textField.tintColor            = UIColor.clear
        self.textField.keyboardType         = UIKeyboardType.numberPad
        self.textField.keyboardAppearance   = self.keyboardAppearance
    }
    
    private func circleInFrame(outerFrame: CGRect, isFilled filled: Bool) -> CAShapeLayer {
        var innerFrame      = CGRect.zero
        innerFrame.origin.x = (outerFrame.size.width / 2) - (self.circleDiameter / 2)
        innerFrame.origin.y = (outerFrame.size.height / 2) - (self.circleDiameter / 2)
        innerFrame.size     = CGSize(width: self.circleDiameter, height: self.circleDiameter)
        
        
        let circle          = CAShapeLayer()
        circle.path         = UIBezierPath(roundedRect: innerFrame, cornerRadius: self.circleDiameter / 2).cgPath
        circle.fillColor    = filled ?  themeColor.cgColor : self.borderColor.cgColor
        circle.strokeColor  = filled ?  themeColor.cgColor : self.borderColor.cgColor
        circle.lineWidth    = self.borderWidth
        return circle
    }
    
    private func borderInFrame(outerFrame: CGRect) -> CAShapeLayer {
        var innerFrame      = CGRect.zero
        innerFrame.origin.x = (outerFrame.size.width / 2) - (self.circleDiameter / 2)
        innerFrame.origin.y = (outerFrame.size.height / 2) - (self.circleDiameter / 2)
        innerFrame.size     = CGSize(width: self.circleDiameter, height: self.circleDiameter)
        
        let borderFrame         = CAShapeLayer()
        let borderRect          = CGRect(x: innerFrame.origin.x - 14, y: innerFrame.origin.y - 20, width: 36, height: 48)
        
        borderFrame.path        = UIBezierPath(roundedRect: borderRect, cornerRadius: 5).cgPath
        borderFrame.fillColor   = UIColor.clear.cgColor
        borderFrame.strokeColor = UIColor.lightGray.cgColor
        borderFrame.lineWidth   = 0.7
        
        return borderFrame
    }
    
    //MARK: - TextField Delegate
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let length = textField.text!.characters.count
        if string.characters.count == 0 {
            if length == 0 {
                return false
            }
        }
        else {
            if length == self.numberOfDigits - 1 {
                textField.text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                self.setupScrollView()
                self.delegate?.NGOPassCodeViewDidFinishEnteringPassword(password: self.textField.text!)
                return false
            }
            else if length > self.numberOfDigits - 1 {
                return false
            }
        }
        textField.text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        self.setupScrollView()
        return false
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.textField.text = ""
        self.setupScrollView()
        return true
    }
    
    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        OperationQueue.main.addOperation { () -> Void in
            UIMenuController.shared.setMenuVisible(false, animated: false)
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    //MARK: - Delegate functions
    
    public func reset() {
        self.textField.text = ""
        self.setupScrollView()
    }
    
    public func shouldBecomeFirstResponder() {
        self.textField.becomeFirstResponder()
    }
    
    public func shouldResignFirstResponder() {
        self.textField.resignFirstResponder()
    }
    
    public func setTextValue(text: String) {
        self.textField.text = text
        self.setupScrollView()
    }
}
