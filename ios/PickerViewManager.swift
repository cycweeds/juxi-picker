import UIKit

@objc(PickerViewManager)
class PickerViewManager: RCTViewManager {
    
    override func view() -> (PickerView) {
        let pickerView = PickerView()
        return pickerView
    }
    
    @objc override static func requiresMainQueueSetup() -> Bool {
        return false
    }
    
}

class PickerView: UIView {
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    @objc var data: [Any] = [] {
        didSet {
            pickerView.reloadAllComponents()
        }
    }
    
    @objc var numColumns: Int = 1 {
        didSet {
            pickerView.reloadAllComponents()
        }
    }
    
    @objc var textFontSize: NSNumber = NSNumber(value: 23.5) {
        didSet {
            pickerView.reloadAllComponents()
        }
    }
    
    @objc var textColor: [Int]? {
        didSet {
            pickerView.reloadAllComponents()
        }
    }
    
    @objc var textFontWeight: NSString? {
        didSet {
            pickerView.reloadAllComponents()
            
        }
    }
    
    @objc var textFontFamily: String? {
        didSet {
            pickerView.reloadAllComponents()
            
        }
    }
    
    // select text props
    @objc var textSelectFontSize: NSNumber? {
        didSet {
            pickerView.reloadAllComponents()
        }
    }
    
    @objc var textSelectColor: [Int]? {
        didSet {
            pickerView.reloadAllComponents()
        }
    }
    
    @objc var textSelectFontWeight: NSString? {
        didSet {
            pickerView.reloadAllComponents()
        }
    }
    
    @objc var textSelectFontFamily: NSString? {
        didSet {
            pickerView.reloadAllComponents()
        }
    }
    
    // 【Note】all RCTBubblingEventBlock must be prefixed with on
    @objc var onSelectCallback: RCTBubblingEventBlock?

    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(pickerView)
        
        self.translatesAutoresizingMaskIntoConstraints = true
        let centerXContraint = NSLayoutConstraint(item: pickerView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let centerYContraint = NSLayoutConstraint(item: pickerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(centerXContraint)
        self.addConstraint(centerYContraint)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pickerView.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
    }
}

extension PickerView : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return numColumns
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var tempData: Any? = data
        for i in 0..<numColumns {
            // last data type should always be [String]
            if i == numColumns - 1 {
                return (tempData as? [Any])?.count ?? 0
            } else if i == component {
                return (tempData as? [Any])?.count ?? 0
            } else {
                let selectedRow = pickerView.selectedRow(inComponent: i)
                tempData = ((tempData as? [Any])?[jx_safe: selectedRow] as? [String : Any])?.values.first
                if tempData == nil {
                    tempData = (tempData as? [Any])?[selectedRow]
                }
            }
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        onSelectCallback?(["row": row, "column": component])
                
        for i in (component + 1)..<self.numColumns {
            if pickerView.numberOfRows(inComponent: i) >= 1 {
                pickerView.selectRow(0, inComponent: i, animated: false)
            }
        }
        pickerView.reloadAllComponents()
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        func getAttributedTitle(string: String?, attributedTitleForRow row: Int, forComponent component: Int) -> NSMutableAttributedString? {
            
            guard let string = string else { return nil }
            let attStr = NSMutableAttributedString(string: string)
            
            let range = NSRange(location: 0, length: attStr.length)
            if let selectedColor = textSelectColor, pickerView.selectedRow(inComponent: component) == row {
                let red = CGFloat(Float((selectedColor[jx_safe: 0] ?? 0)) / 255.0)
                let green = CGFloat(Float((selectedColor[jx_safe: 1] ?? 0)) / 255.0)
                let blue = CGFloat(Float((selectedColor[jx_safe: 2] ?? 0)) / 255.0)
                let alpha = CGFloat(Float((selectedColor[jx_safe: 3] ?? 1)))
                var arrtributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(red: red, green: green, blue: blue, alpha: alpha)]
                
                var font: UIFont?
                
                if let textFamily = textSelectFontFamily {
                    font = UIFont(name: textFamily as String, size: CGFloat((textSelectFontSize ?? textFontSize) .floatValue)) ?? UIFont.systemFont(ofSize: CGFloat((textSelectFontSize ?? textFontSize).floatValue))
                } else {
                    font = UIFont.systemFont(ofSize: CGFloat((textSelectFontSize ?? textFontSize).floatValue), weight: ((textSelectFontWeight ?? textFontWeight) as? String)?.jx_toWeight() ?? .regular)
                }

                arrtributes.updateValue(font, forKey: .font)
                attStr.setAttributes(arrtributes, range: range)
            } else {
                var font: UIFont?
                
                if let textFamily = textFontFamily {
                    font = UIFont(name: textFamily, size: CGFloat(textFontSize.floatValue))
                } else {
                    font = UIFont.systemFont(ofSize: CGFloat(textFontSize.floatValue), weight: (textFontWeight as String?)?.jx_toWeight() ?? .regular)
                }
                if font == nil {
                    font = UIFont.systemFont(ofSize: 16, weight: .regular)
                }
                
                let red = CGFloat(Float((textColor?[jx_safe: 0] ?? 0)) / 255.0)
                let green = CGFloat(Float((textColor?[jx_safe: 1] ?? 0)) / 255.0)
                let blue = CGFloat(Float((textColor?[jx_safe: 2] ?? 0)) / 255.0)
                let alpha = CGFloat(Float((textColor?[jx_safe: 3] ?? 1)))
                attStr.setAttributes([.font: font!, .foregroundColor: UIColor(red: red, green: green, blue: blue, alpha: alpha)], range: range)
                
            }
            return attStr
        }
        
        var tempData: Any? = data
        for i in 0..<numColumns {
            // last data type should always be [String]
            if i == numColumns - 1 {
                let str = (tempData as? [String])?[jx_safe:row]
                return getAttributedTitle(string: str, attributedTitleForRow: row, forComponent: component)
            } else if i == component {
                let str = ((tempData as? [Any])?[jx_safe: row] as? [String: Any])?.keys.first ?? (tempData as? [String])?[row]
                return getAttributedTitle(string: str, attributedTitleForRow: row, forComponent: component)
            } else {
                let selectedRow = pickerView.selectedRow(inComponent: i)
                tempData = ((tempData as? [Any])?[jx_safe:selectedRow] as? [String : Any])?.values.first
                if tempData == nil {
                    tempData = (tempData as? [Any])?[jx_safe:selectedRow]
                }
            }
        }

        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as? UILabel
        if label == nil {
            label = UILabel()
            label?.textAlignment = .center
            label?.numberOfLines = 1
        }
        label?.attributedText = self.pickerView(pickerView, attributedTitleForRow: row, forComponent: component)
        return label!
    }
}

fileprivate extension Collection {
    // name jx_safe to prevent repeat
    subscript(jx_safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension String {
    public func jx_toWeight() -> UIFont.Weight {
        if self == "100" {
            return .thin
        } else if self == "200" {
            return .ultraLight
        } else if self == "300" {
            return .light
        } else if self == "400" || self == "normal" {
            return .regular
        } else if self == "500" {
            return .medium
        } else if self == "600" {
            return .semibold
        } else if self == "700" || self == "bold" {
            return .bold
        } else if self == "800" {
            return .heavy
        } else if self == "900" {
            return .black
        }
        return .regular
    }
}





