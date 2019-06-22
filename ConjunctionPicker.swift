import UIKit

enum ConjunctionOperator
{
    case And
    case Or
    case Not
    var description : String {
        switch self {
        case .And:
            return "And"
        case .Or:
            return "Or"
        case .Not:
            return "Not"
        }
    }
}

class ConjunctionPicker : SingleColumnPicker
{    
    override init()
    {
        super.init()
        _pickerData.append(ConjunctionOperator.And.description)
        _pickerData.append(ConjunctionOperator.Or.description)
    }
    
    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
    }
}
