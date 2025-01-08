//
//  MaterialField.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 13/06/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class MaterialField: UITextField {
    
    // MARK: - Properties
    public var coder = NSCoder()
    public let lettersAndDigitsReplacementChar: String = "*"
    public let anyLetterReplecementChar: String = "@"
    public let lowerCaseLetterReplecementChar: String = "a"
    public let upperCaseLetterReplecementChar: String = "A"
    public let digitsReplecementChar: String = "#"
    @IBInspectable open var formatPattern: String = ""
    
    public var textEdited = [String]()
    
    private var lblMessage: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private var color = UIColor(hexString: Constants.Colors.Hex.colorQiwiOrange)
    private var maxLenght = 200
    private var lastTextWithError = ""
    var rightButton = UIButton()
    
    open var maxLength: Int {
        get { return formatPattern.count }
    }
    
    override open var text: String? {
        get { return super.text }
        set {
            super.text = newValue
            self.formatText()
        }
    }
    
    var isVisibleRightView: Bool = true {
        didSet { self.rightViewMode = isVisibleRightView ? .never : .always }
    }
    
    override var isSecureTextEntry: Bool {
        didSet {
            if isSecureTextEntry {
                let img = #imageLiteral(resourceName: "ic_visibility_off").withRenderingMode(.alwaysTemplate)
                rightButton.setImage(img, for: .normal)
                rightButton.tintColor = color
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        self.coder = coder
        super.init(coder: coder)
        self.prepareSetup()
        self.setup()
    }
    
    deinit {
        self.deRegisterForNotifications()
    }
    
    fileprivate func prepareSetup() {
        self.delegate = self
        self.borderStyle = .roundedRect
        self.adjustsFontForContentSizeCategory = true
        
        self.prepareSubViews()
        self.prepareColor()
        self.prepareConstraints()
        self.prepareRightView()
        
        self.backgroundColor = Theme.default.white
        self.tintColor = .gray
        self.layer.borderColor = self.color.cgColor
        self.layer.borderWidth = 0.6
        self.layer.cornerRadius = 6
        
        self.showEditing(enable: false)
    }
    
    fileprivate func prepareSubViews() {
        self.addSubview(self.lblMessage)
    }
    
    fileprivate func prepareConstraints() {
        NSLayoutConstraint.activate([
            lblMessage.heightAnchor.constraint(equalToConstant: 20),
            lblMessage.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 2),
            lblMessage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            lblMessage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
        ])
    }
    
    fileprivate func prepareColor() {
        tintColor = self.color
        textColor = UIColor.black
        attributedPlaceholder = NSAttributedString(
            string: self.placeholder ?? "",
            attributes: [
                .foregroundColor: self.color,
                .font: FontCustom.helveticaRegular.font(14)
            ]
        )
        rightButton.tintColor = self.color
    }
    
    func setLenght(_ lenght: Int) {
        self.maxLenght = lenght
    }
    
    func showEditing(enable: Bool) {
        color = UIColor(hexString: enable ? Constants.Colors.Hex.colorQiwiOrange : Constants.Colors.Hex.colorGrey5)
        prepareColor()
        
        if !isVisibleRightView {
            rightButton.tintColor = color
        }
        layer.borderColor = color.cgColor
        layer.borderWidth = enable ? 1.1 : 0.6
        layer.cornerRadius = 6
    }
    
    func setErrorWith(text: String, color: UIColor = UIColor.red) {
        lastTextWithError = self.text ?? ""
        let imgCancel = #imageLiteral(resourceName: "ic_cancel").withRenderingMode(.alwaysTemplate)
        rightButton.setImage(imgCancel, for: .normal)
        rightButton.contentMode = .scaleAspectFit
        rightButton.tintColor = color
        rightButton.isUserInteractionEnabled = false
        rightViewMode = .always
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            self.lblMessage.text = text
            self.lblMessage.font = FontCustom.helveticaRegular.font(14)
            self.lblMessage.textColor = color
            self.layoutIfNeeded()
        }
    }
    
    func clearError() {
        lblMessage.text = ""
        rightViewMode = isVisibleRightView ? .never : .always
        rightButton.isUserInteractionEnabled = !isVisibleRightView
        
        if !isVisibleRightView && isSecureTextEntry {
            let img = #imageLiteral(resourceName: "ic_visibility_off").withRenderingMode(.alwaysTemplate)
            rightButton.setImage(img, for: .normal)
            rightButton.tintColor = color
        }
    }
    
    fileprivate func prepareRightView() {
        let height: CGFloat = 25
        let width: CGFloat = 26
        let frame = CGRect(x: self.frame.size.width - width, y: 0.0, width: width, height: height)
        rightButton = UIButton(frame: frame)
        rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, -(width/2.0), 0, 10)
        rightButton.setImage(#imageLiteral(resourceName: "ic_visibility_off"), for: .normal)
        rightButton.contentMode = .scaleAspectFit
        rightButton.tintColor = color
        rightButton.isUserInteractionEnabled = true
        rightView = rightButton
        rightViewMode = .never
    }
}

// MARK: Delegate TextFields
extension MaterialField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= self.maxLenght
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let field = textField as? MaterialField {
            field.showEditing(enable: true)
            if self.lastTextWithError.count > 0 && self.text ?? "" != self.lastTextWithError {
                field.clearError()
            }
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let field = textField as? MaterialField {
            if let text = field.text {
                self.textEdited.append(text)
            }
            
            field.showEditing(enable: false)
            field.clearError()
        }
        return true
    }
    
    private func textFieldDidEndEditing(_ textField: UITextField) {
        if let field = textField as? MaterialField {
            if let text = field.text, text.isEmpty == false {
                self.textEdited.append(text)
            }
        }
        print("@! >>> TEXT_ON_ARRAY: ", textEdited)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print("@! >>> TEXT_ON_ARRAY: ", textEdited)
        return true
    }
}

// MARK: - Public Extension
extension MaterialField {
    func formatText() {
        var currentTextForFormatting = ""
        
        if let text = super.text {
            if text.count > 0 {
                currentTextForFormatting = text
            }
        }
        
        if self.maxLength > 0 {
            var formatterIndex = self.formatPattern.startIndex, currentTextForFormattingIndex = currentTextForFormatting.startIndex
            var finalText = ""
            
            currentTextForFormatting = self.getFilteredString(currentTextForFormatting)
            
            if currentTextForFormatting.count > 0 {
                while true {
                    let formatPatternRange = formatterIndex ..< formatPattern.index(after: formatterIndex)
//                    let currentFormatCharacter = self.formatPattern.substring(with: formatPatternRange)
                    let currentFormatCharacter = formatPattern[formatPatternRange]
                    
                    let currentTextForFormattingPatterRange = currentTextForFormattingIndex..<currentTextForFormatting.index(after: currentTextForFormattingIndex)
//                    let currentTextForFormattingCharacter = currentTextForFormatting.substring(with: currentTextForFormattingPatterRange)
                    let currentTextForFormattingCharacter = String(currentTextForFormatting[currentTextForFormattingPatterRange])
                    
                    switch currentFormatCharacter {
                    case self.lettersAndDigitsReplacementChar:
                        finalText += currentTextForFormattingCharacter
                        currentTextForFormattingIndex = currentTextForFormatting.index(after: currentTextForFormattingIndex)
                        formatterIndex = formatPattern.index(after: formatterIndex)
                    case self.anyLetterReplecementChar:
                        let filteredChar = self.getOnlyLettersString(currentTextForFormattingCharacter)
                        if !filteredChar.isEmpty {
                            finalText += filteredChar
                            formatterIndex = formatPattern.index(after: formatterIndex)
                        }
                        currentTextForFormattingIndex = currentTextForFormatting.index(after: currentTextForFormattingIndex)
                    case self.lowerCaseLetterReplecementChar:
                        let filteredChar = self.getLowercaseLettersString(currentTextForFormattingCharacter)
                        if !filteredChar.isEmpty {
                            finalText += filteredChar
                            formatterIndex = formatPattern.index(after: formatterIndex)
                        }
                        currentTextForFormattingIndex = currentTextForFormatting.index(after: currentTextForFormattingIndex)
                    case self.upperCaseLetterReplecementChar:
                        let filteredChar = self.getUppercaseLettersString(currentTextForFormattingCharacter)
                        if !filteredChar.isEmpty {
                            finalText += filteredChar
                            formatterIndex = formatPattern.index(after: formatterIndex)
                        }
                        currentTextForFormattingIndex = currentTextForFormatting.index(after: currentTextForFormattingIndex)
                    case self.digitsReplecementChar:
                        let filteredChar = self.getOnlyDigitsString(currentTextForFormattingCharacter)
                        if !filteredChar.isEmpty {
                            finalText += filteredChar
                            formatterIndex = formatPattern.index(after: formatterIndex)
                        }
                        currentTextForFormattingIndex = currentTextForFormatting.index(after: currentTextForFormattingIndex)
                    default:
                        finalText += currentFormatCharacter
                        formatterIndex = formatPattern.index(after: formatterIndex)
                    }
                    
                    if formatterIndex >= self.formatPattern.endIndex ||
                        currentTextForFormattingIndex >= currentTextForFormatting.endIndex {
                        break
                    }
                }
            }
            super.text = finalText
            
            if let text = self.text {
                if text.count > self.maxLength {
//                    super.text = text.substring(to: text.index(text.startIndex, offsetBy: self.maxLength))
                    let textIndex = text.index(text.startIndex, offsetBy: 3)
                    super.text = String(text[..<textIndex])
                }
            }
        }
    }
}

// MARK: - Private Extension
fileprivate extension MaterialField {
    func setup() {
        self.registerForNotifications()
    }
    
    func registerForNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChange),
            name: NSNotification.Name(rawValue: "UITextFieldTextDidChangeNotification"),
            object: self
        )
    }
    
    func deRegisterForNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func textDidChange() {
        self.undoManager?.removeAllActions()
        self.formatText()
    }
    
    func getOnlyDigitsString(_ string: String) -> String {
        let charactersArray = string.components(separatedBy: CharacterSet.decimalDigits.inverted)
        return charactersArray.joined(separator: "")
    }
    
    func getOnlyLettersString(_ string: String) -> String {
        let charactersArray = string.components(separatedBy: CharacterSet.letters.inverted)
        return charactersArray.joined(separator: "")
    }
    
    func getUppercaseLettersString(_ string: String) -> String {
        let charactersArray = string.components(separatedBy: CharacterSet.uppercaseLetters.inverted)
        return charactersArray.joined(separator: "")
    }
    
    func getLowercaseLettersString(_ string: String) -> String {
        let charactersArray = string.components(separatedBy: CharacterSet.lowercaseLetters.inverted)
        return charactersArray.joined(separator: "")
    }
    
    func getFilteredString(_ string: String) -> String {
        let charactersArray = string.components(separatedBy: CharacterSet.alphanumerics.inverted)
        return charactersArray.joined(separator: "")
    }
}

@available(iOS 14.0, *)
extension UITextField {
    func setOnTextChangeListener(onTextChanged: @escaping () -> Void) {
        self.addAction(UIAction() { action in
            onTextChanged()
        }, for: .editingChanged)
    }
    
    func setOnEndChangeListener(onEndEdition: @escaping () -> Void) {
        self.addAction(UIAction() { action in
            onEndEdition()
        }, for: .editingDidEnd)
    }
}
