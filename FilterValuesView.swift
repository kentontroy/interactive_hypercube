import UIKit

class FilterValuesView: UIView
{
    var _scene : CubeScene?
//Filter predicate
    var _resultingFilter = ""
    
    let _queryParser = QueryParser()
    
//Row 1
    let _title  = UILabel(frame: CGRect(x: 38, y: 65, width: 220, height: 45))
    let _titleText = "Filter Settings"
    let _labelValues = UILabel(frame: CGRect(x: 38, y: 110, width: 70, height: 45))
    let _labelValuesText = "Values"
    let _pickerFilter1 = UIPickerView(frame: CGRect(x: 108, y: 110, width: 40, height: 45))
    let _textValue1 = UITextView(frame: CGRect(x: 148, y: 110, width: 140, height: 45))
    let _btnAddFilter = UIButton(frame: CGRect(x: 288, y: 110, width: 30, height: 45))
    var _btnAddFilterText = "+"
//Row 2
    let _pickerConjunction = UIPickerView(frame: CGRect(x: 38, y: 155, width: 70, height: 45))
    let _pickerFilter2 = UIPickerView(frame: CGRect(x: 108,  y: 155, width: 40, height: 45))
    let _textValue2 = UITextView(frame: CGRect(x: 148, y: 155, width: 140, height: 45))
    
//Row 3
    let _btnFilter = UIButton(frame: CGRect(x: 58, y: 200, width: 80, height: 45))
    let _btnFilterText = "Filter"
    let _btnReset = UIButton(frame: CGRect(x: 160, y: 200, width: 80, height: 45))
    let _btnResetText = "Reset"
    
    let _defaultAttributes : [ NSAttributedString.Key : Any]
    var _defaultFont = UIFont(name: "Helvetica", size: 22.0)
    var _defaultColor = UIColor.black

    override init(frame: CGRect)
    {
        self._defaultAttributes =
            [ NSAttributedString.Key.font : _defaultFont,
              NSAttributedString.Key.obliqueness : 0.33,
              NSAttributedString.Key.underlineStyle : 0,
              NSAttributedString.Key.foregroundColor : _defaultColor,
              NSAttributedString.Key.strokeWidth : 5.0
        ]
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 0.10
        self.layer.borderColor = UIColor.black.cgColor
        self.addSubview(_title)
        self.addSubview(_labelValues)
        self.addSubview(_pickerFilter1)
        self.addSubview(_textValue1)
        self.addSubview(_btnAddFilter)
        self.addSubview(_btnFilter)
        self.addSubview(_btnReset)
        
        _title.attributedText = NSAttributedString(string: _titleText, attributes: _defaultAttributes)
        _labelValues.attributedText = NSAttributedString(string: _labelValuesText, attributes: _defaultAttributes)
        _pickerFilter1.backgroundColor = UIColor.white
        _textValue1.isEditable = true
        _textValue1.layer.borderWidth = 0.25
        _textValue1.attributedText = NSAttributedString(string: " ", attributes: self._defaultAttributes)

        _btnAddFilter.layer.borderWidth = 0.25
        _btnAddFilter.setAttributedTitle(NSAttributedString(string: _btnAddFilterText, attributes: _defaultAttributes), for: .normal)
        _btnAddFilter.addTarget(self, action: #selector(self.addFilterPressed), for: .touchUpInside)
        
        _pickerConjunction.backgroundColor = UIColor.white
        _textValue2.isEditable = true
        _textValue2.layer.borderWidth = 0.25
        _textValue2.attributedText = NSAttributedString(string: " ", attributes: self._defaultAttributes)
        
        _btnFilter.layer.borderWidth = 0.25
        _btnFilter.setAttributedTitle(NSAttributedString(string: _btnFilterText, attributes: _defaultAttributes), for: .normal)
        _btnFilter.addTarget(self, action: #selector(self.applyFilters), for: .touchUpInside)
        _btnReset.layer.borderWidth = 0.25
        _btnReset.setAttributedTitle(NSAttributedString(string: _btnResetText, attributes: _defaultAttributes), for: .normal)
        _btnReset.addTarget(self, action: #selector(self.resetFilters), for: .touchUpInside)

    }
 
    convenience init(scene: CubeScene, frame: CGRect)
    {
        self.init(frame: frame)
        _scene = scene
    }
    
    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    @objc fileprivate func addFilterPressed()
    {
        if self._btnAddFilterText == "+"
        {
            self._btnAddFilterText = "--"
            self.addSubview(_pickerConjunction)
            self.addSubview(_pickerFilter2)
            self.addSubview(_textValue2)
        }
        else
        {
            self._btnAddFilterText = "+"
            _pickerConjunction.removeFromSuperview()
            _pickerFilter2.removeFromSuperview()
            _textValue2.removeFromSuperview()
        }
        _btnAddFilter.setAttributedTitle(NSAttributedString(string: _btnAddFilterText, attributes: _defaultAttributes), for: .normal)
    }
    
    @objc fileprivate func applyFilters()
    {
        _resultingFilter = ""
        
        var filter1 : String?
        var value1 : Double?
        var conjunction : String?
        var filter2 : String?
        var value2 : Double?
        
        var isValid = false
        
        if validate(_textValue1.text)
        {
            _textValue1.backgroundColor = UIColor.white
            isValid = true

            let delegateFilter = _pickerFilter1.delegate as! FilterValuesPicker
            filter1 = delegateFilter._pickerData[_pickerFilter1.selectedRow(inComponent: 0)]
            value1 = Double(_textValue1.text.trimmingCharacters(in: .whitespacesAndNewlines))!
 
            if _btnAddFilterText == "--"
            {
                let delegateConjunction = _pickerConjunction.delegate as! ConjunctionPicker
                conjunction = delegateConjunction._pickerData[_pickerConjunction.selectedRow(inComponent: 0)]
                filter2 = delegateFilter._pickerData[_pickerFilter2.selectedRow(inComponent: 0)]
            
                if validate(_textValue2.text)
                {
                    _textValue2.backgroundColor = UIColor.white
                    value2 = Double(_textValue2.text.trimmingCharacters(in: .whitespacesAndNewlines))!
                }
                else
                {
                    _textValue2.backgroundColor = UIColor.yellow
                    isValid = false
                }
            }
        }
        else
        {
            _textValue1.backgroundColor = UIColor.yellow
            isValid = false
        }
                
        if isValid
        {
            _resultingFilter = _queryParser.createPredicate(condition1: filter1!, value1: value1!,
                                                            conjunction: conjunction,
                                                            condition2: filter2, value2: value2)
            
            let f = _queryParser.parsePredicate(predicate: _resultingFilter)
            guard let scene = _scene else {
                return
            }
            for pair in scene._mapping
            {
                if let value = scene.getCubeCellValue(node: pair.key)?.3
                {
                    if !f(value)
                    {
                        _scene?.setVisible(node: pair.key, visibility: false)
                    }
                }
            }
        }
    }
    
    @objc fileprivate func resetFilters()
    {
        _resultingFilter = ""
        _textValue1.attributedText = NSAttributedString(string: " ", attributes: self._defaultAttributes)
        _textValue2.attributedText = NSAttributedString(string: " ", attributes: self._defaultAttributes)
        _scene?.setAllVisible()
    }
    
    fileprivate func validate(_ text: String) -> Bool
    {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.count == 0
        {
            return false
        }
        if Double(trimmed) == nil
        {
            return false
        }
        return true
    }
}
