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
