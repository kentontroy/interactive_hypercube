import UIKit

enum FilterOperator
{
    case LessThan
    case LessThanOrEqual
    case Equal
    case GreaterThan
    case GreaterThanOrEqual
    var description : String {
        switch self {
        case .LessThan:
            return "<"
        case .LessThanOrEqual:
            return "<="
        case .Equal:
            return "="
        case .GreaterThan:
            return ">"
        case .GreaterThanOrEqual:
            return ">="
        }
    }
 
}

class FilterValuesPicker : SingleColumnPicker
{
    var _selectedRow : Int?
    
    override init()
    {
        super.init()
        _pickerData.append(FilterOperator.LessThan.description)
        _pickerData.append(FilterOperator.LessThanOrEqual.description)
        _pickerData.append(FilterOperator.Equal.description)
        _pickerData.append(FilterOperator.GreaterThan.description)
        _pickerData.append(FilterOperator.GreaterThanOrEqual.description)
    }
    
    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        _selectedRow = row
    }
}
