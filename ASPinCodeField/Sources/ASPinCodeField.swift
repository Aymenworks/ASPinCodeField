//
//  ASPinCodeField.swift
//  ASPinCodeField
//
//  Created by Rebouh Aymen on 02/05/2019.
//  Copyright © 2019 Rebouh Aymen. All rights reserved.
//

import Foundation
import UIKit

public protocol ASPinCodeFieldDelegate: class {
    func pinCodeField(_ pinCodeField: ASPinCodeField, didChangeText text: String)
}

public protocol ASPinCodeFieldDataSource: class {
    func numberOfDigits(in pinCodeField: ASPinCodeField) -> Int
    func canPasteFromPasteBoard(_ pinCodeField: ASPinCodeField, pasteboard: String) -> Bool
}

public final class ASPinCodeField: UIControl, UIKeyInput {
    
    // MARK: Developer Experience - How to use this component
    
    /// The receiver delegate
    public weak var delegate: ASPinCodeFieldDelegate?
    public weak var dataSource: ASPinCodeFieldDataSource? {
        didSet {
            setup()
        }
    }

    /// Use that method to set code directly to the component.
    /// You have to check by yourself that the `code` value is appropriate e.g  fits the number of digits, integers values..
    public func set(code: String) {
        guard let numberOfDigits = self.dataSource?.numberOfDigits(in: self) else { return }
        guard code.count <= numberOfDigits else { return }
        
        self.digits = code
        self.delegate?.pinCodeField(self, didChangeText: digits)
    }
    
    /// Use that method to reset the pin view with no digits
    public func reset() {
        self.digits = ""
        self.updateUI()
    }
    
    // MARK: Implementation using UIKeyInput
    
    private let stackView: UIStackView = .init()
    private var digitsView: [DigitView] = []
    
    public var keyboardType: UIKeyboardType = .numberPad
    public var returnKeyType: UIReturnKeyType = .done
    public var enablesReturnKeyAutomatically: Bool = false
    
    // MARK: Customization - What can be customized
    
    private var _inputAccessoryView: UIView?
    
    public override var inputAccessoryView: UIView? {
        get {
            return self._inputAccessoryView
        }
        set {
            self._inputAccessoryView = newValue
        }
    }
    
    public var textColor: UIColor = .black {
        didSet {
            digitsView.forEach { $0.label.textColor = textColor }
        }
    }
    
    public var borderColor: UIColor = .black {
        didSet {
            digitsView.forEach { $0.layer.borderColor = borderColor.cgColor }
        }
    }
    
    public var cornerRadius: CGFloat = 4 {
        didSet {
            digitsView.forEach { $0.layer.cornerRadius = cornerRadius }
        }
    }
    
    public var itemsSpacing: CGFloat = 8 {
        didSet {
            stackView.spacing = itemsSpacing
        }
    }
    
    public var textFont: UIFont = UIFont.systemFont(ofSize: 20) {
        didSet {
            digitsView.forEach { $0.label.font = textFont }
        }
    }

    // MARK: Privates
    
    private(set) var digits = "" {
        didSet {
            guard self.digits != oldValue else { return }
            self.updateUI()
        }
    }
    
    // MARK: Lifecycle
    
    convenience init() {
        self.init(frame: .zero)
    }

    private func setup() {
        guard let dataSource = self.dataSource else {
            assertionFailure("DataSource property is not set")
            return
        }
        
        isUserInteractionEnabled = true
        
        // Configure the UIStackView
        addSubview(stackView)
        stackView.isUserInteractionEnabled = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 6
        
        for _ in 0 ..< dataSource.numberOfDigits(in: self) {
            let digitView = DigitView()
            digitsView.append(digitView)
            self.stackView.addArrangedSubview(digitView)
        }
        
        layout: do {
            stackView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                stackView.topAnchor.constraint(equalTo: self.topAnchor),
                stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        }
        
        binding: do {
            addTarget(self, action: #selector(self.becomeFirstResponder), for: .touchDown)
        }
    }

    // MARK: UIControl
    
    public override var canBecomeFirstResponder: Bool {
        return true
    }
    
    public override func becomeFirstResponder() -> Bool {
        guard isFirstResponder == false else { return false }
        
        defer {
            sendActions(for: .editingDidBegin)
        }
        
        guard let numberOfDigits = self.dataSource?.numberOfDigits(in: self)  else {
            assertionFailure("DataSource property is not set")
            return true
        }
        
        if self.digitsView.count <= numberOfDigits {
            self.digitsView[digits.count].state = .focus
        }
        
        return super.becomeFirstResponder()
    }
    
    public override func resignFirstResponder() -> Bool {
        defer {
            sendActions(for: .editingDidEnd)
        }
        
        return super.resignFirstResponder()
    }
    
    // MARK: UIResponder
    
    public override func paste(_ sender: Any?) {
        if let pasteboard = UIPasteboard.general.string, self.dataSource?.canPasteFromPasteBoard(self, pasteboard: pasteboard) == true  {
            self.digits = pasteboard
            self.delegate?.pinCodeField(self, didChangeText: digits)
        }
    }
    
    // MARK: UI Appareance
    
    private func updateUI() {
        // Reset all to empty
        self.digitsView.forEach { $0.state = .empty }
        
        // If there is no digits, we put the focus to the first character
        if self.digits.isEmpty {
            self.digitsView.first?.state = .focus
            return
        }
        
        // we set all digits
        for (digit, digitView) in zip(self.digits, self.digitsView) {
            digitView.state = .filled(String(digit))
        }
        
        guard let numberOfDigits = self.dataSource?.numberOfDigits(in: self)  else {
            assertionFailure("DataSource property is not set")
            return
        }
        
        // and put the focus to the next one if the code if not complete
        if self.digits.count < numberOfDigits {
            self.digitsView[digits.count].state = .focus
        }
    }
    
    // MARK: UIKeyInput
    
    public var hasText: Bool {
        return self.digits.isEmpty == false
    }
    
    public func insertText(_ text: String) {
        guard let numberOfDigits = self.dataSource?.numberOfDigits(in: self)  else {
            assertionFailure("DataSource property is not set")
            return
        }
        
        // We verify that it's one character setted by the number pad and not called by the delegate. If it's full, we do nothing.
        guard text.count == 1, self.digits.count < numberOfDigits, Int(text) != nil else {
            return
        }
        
        self.digits += text
        
        self.delegate?.pinCodeField(self, didChangeText: digits)
    }
    
    public func deleteBackward() {
        // We only delete if the pin code is not empty
        guard self.digits.isEmpty == false else { return }
        self.digits = String(self.digits.dropLast())
        self.delegate?.pinCodeField(self, didChangeText: digits)
    }
}

fileprivate class DigitView: UIView {
   
    // MARK: Properties
    
    enum State {
        case empty
        case focus
        case filled(String)
    }
    
    var state: State = .empty {
        didSet {
            self.updateUI()
        }
    }
    
    let label = UILabel()
    private var highlightAnimation: CABasicAnimation?
    
    // MARK: Lifecycle
    
    init() {
        super.init(frame: .zero)
        
        layer.borderWidth = 1
        
        label.textAlignment = .center
        
        addSubview(label)
        
        layout: do {
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                label.topAnchor.constraint(equalTo: self.topAnchor),
                label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                label.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        }
        
        binding: do {
            // Restart the highlight animation which is automatically deleted when the application leave the foreground
            NotificationCenter.default.addObserver(self, selector: #selector(resumeHighlightAnimation), name: UIApplication.willEnterForegroundNotification, object: nil)
        }
    }
    
    @objc func resumeHighlightAnimation() {
        if let highlightAnimation = self.highlightAnimation {
            self.label.layer.add(highlightAnimation, forKey: "highlightAnimation")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI Appareance
    
    private func updateUI() {
        self.label.layer.removeAnimation(forKey: "highlightAnimation")
        
        switch self.state {
        case .empty:
            self.label.text = " "
        case .focus:
            self.label.text = "|"
            
            self.highlightAnimation = CABasicAnimation(keyPath: "opacity")
            guard let highlightAnimation = highlightAnimation else { return }
            highlightAnimation.duration = 0.4
            highlightAnimation.autoreverses = true
            highlightAnimation.fromValue = 1
            highlightAnimation.toValue = 0
            highlightAnimation.timingFunction = .init(name: .easeInEaseOut)
            highlightAnimation.repeatCount = .greatestFiniteMagnitude
            label.layer.add(highlightAnimation, forKey: "highlightAnimation")
            
        case .filled(let digit):
            self.label.text = digit
        }
    }
}
