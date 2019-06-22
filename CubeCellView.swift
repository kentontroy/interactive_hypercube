import UIKit

class CubeCellView: UIView
{
    var _dimensionFont = UIFont(name: "Helvetica", size: 22.0)
    var _dimensionColor = UIColor.black
    
    var _cellValueFont = UIFont(name: "Helvetica", size: 22.0)
    var _cellValueColor = UIColor.black

    let _dimensionXLabel = UILabel(frame: CGRect(x: 1, y: 65, width: 100, height: 45))
    let _dimensionYLabel = UILabel(frame: CGRect(x: 1, y: 110, width: 100, height: 45))
    let _dimensionZLabel = UILabel(frame: CGRect(x: 1, y: 155, width: 100, height: 45))
    let _cellValueLabel = UILabel(frame: CGRect(x: 1, y: 200, width: 100, height: 45))
    
    let _dimensionX = UITextView(frame: CGRect(x: 102, y: 65, width: 200, height: 45))
    let _dimensionY = UITextView(frame: CGRect(x: 102, y: 110, width: 200, height: 45))
    let _dimensionZ = UITextView(frame: CGRect(x: 102, y: 155, width: 200, height: 45))

    let _cellValue = UITextView(frame: CGRect(x: 102, y: 200, width: 200, height: 45))
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 0.10
        self.layer.borderColor = UIColor.black.cgColor
        self.addSubview(_dimensionXLabel)
        self.addSubview(_dimensionYLabel)
        self.addSubview(_dimensionZLabel)
        self.addSubview(_cellValueLabel)
        self.addSubview(_dimensionX)
        self.addSubview(_dimensionY)
        self.addSubview(_dimensionZ)
        self.addSubview(_cellValue)
        self.showLabel(text: "X Axis", label: _dimensionXLabel)
        self.showLabel(text: "Y Axis", label: _dimensionYLabel)
        self.showLabel(text: "Z Axis", label: _dimensionZLabel)
        self.showLabel(text: "Cell", label: _cellValueLabel)
        _dimensionX.isEditable = false
        _dimensionX.layer.borderWidth = 0.25
        _dimensionX.backgroundColor = UIColor(red: 250.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 0.25)
        _dimensionY.isEditable = false
        _dimensionY.layer.borderWidth = 0.25
        _dimensionZ.isEditable = false
        _dimensionZ.layer.borderWidth = 0.25
        _dimensionZ.backgroundColor = UIColor(red: 250.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 0.25)
        _cellValue.isEditable = false
        _cellValue.layer.borderWidth = 0.25
    }
    
    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showLabel(text t: String, label l: UILabel)
    {
        let  attributes : [ NSAttributedString.Key : Any] =
            [ NSAttributedString.Key.font : _dimensionFont,
              NSAttributedString.Key.obliqueness : 0.33,
              NSAttributedString.Key.underlineStyle : 0,
              NSAttributedString.Key.foregroundColor : _dimensionColor,
              NSAttributedString.Key.strokeWidth : 5.0
        ]
        l.attributedText = NSAttributedString(string: t, attributes: attributes)
    }
    
    func showCellDimensions(x dimX: String, y dimY: String, z dimZ: String)
    {
        let  dimAttributes : [ NSAttributedString.Key : Any] =
            [ NSAttributedString.Key.font : _dimensionFont,
              NSAttributedString.Key.obliqueness : 0.33,
              NSAttributedString.Key.underlineStyle : 0,
              NSAttributedString.Key.foregroundColor : _dimensionColor,
              NSAttributedString.Key.strokeWidth : 5.0
            ]
        _dimensionX.attributedText = NSAttributedString(string: dimX, attributes: dimAttributes)
        _dimensionY.attributedText = NSAttributedString(string: dimY, attributes: dimAttributes)
        _dimensionZ.attributedText = NSAttributedString(string: dimZ, attributes: dimAttributes)
    }
    
    func showCellValue(value v: Double?)
    {
        let  dimAttributes : [ NSAttributedString.Key : Any] =
            [ NSAttributedString.Key.font : _cellValueFont,
              NSAttributedString.Key.underlineStyle : 0,
              NSAttributedString.Key.foregroundColor : _cellValueColor,
              NSAttributedString.Key.strokeWidth : 5.0
        ]
        guard let v = v else {
            _cellValue.attributedText = NSAttributedString(string: "", attributes: dimAttributes)
            return
        }
        _cellValue.attributedText = NSAttributedString(string: v.description, attributes: dimAttributes)
    }

}

