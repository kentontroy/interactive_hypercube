import UIKit

class SingleColumnPicker : NSObject, UIPickerViewDelegate, UIPickerViewDataSource
{
    var _pickerData = [String]()
    
    override init()
    {
    }
    
    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

// Delegate handling for picker selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
    }
// Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
// The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return self._pickerData.count
    }
// Populate drop-down choices
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString?
    {
        let  attributes : [ NSAttributedString.Key : Any] =
            [ NSAttributedString.Key.font : UIFont(name: "Helvetica", size: 22.0),
              NSAttributedString.Key.obliqueness : 0.33,
              NSAttributedString.Key.underlineStyle : 0,
              NSAttributedString.Key.foregroundColor : UIColor.black,
              NSAttributedString.Key.strokeWidth : 5.0
        ]
        let choice = NSAttributedString(string: self._pickerData[row], attributes: attributes)
        return choice
    }
}
