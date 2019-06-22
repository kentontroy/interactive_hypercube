import UIKit

class HeatMapConfigView : UIView
{
    let _title  = UILabel(frame: CGRect(x: 38, y: 65, width: 220, height: 45))
    let _titleText = "Heat Map Colors"
    let _defaultAttributes : [ NSAttributedString.Key : Any]
    var _defaultFont = UIFont(name: "Helvetica", size: 22.0)
    var _defaultColor = UIColor.black
    var _picker = UIPickerView(frame: CGRect(x: 38, y: 110, width: 220, height: 45))
    var _heatMapRange : HeatMapColorRange?
    var _heatMapLegend = UIView(frame: CGRect(x: 38, y: 155, width: 220, height: 45))
    
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
        self.addSubview(_picker)
        self.addSubview(_heatMapLegend)
        _title.attributedText = NSAttributedString(string: _titleText, attributes: _defaultAttributes)
        _picker.backgroundColor = UIColor.white
    }
    
    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawHeatMapLegend(heatMapColors c: HeatMapColorRange, cube d: HyperCube)
    {
        if self._heatMapRange == c {
            return
        }
        self._heatMapRange = c
        for v in self._heatMapLegend.subviews {
            v.removeFromSuperview()
        }
        var x = 0
        var i = 0
        let heatMap = HeatMap(range: self._heatMapRange!)
        for point in d._percentiles
        {
            let v = d._scaled?.getValue(value: point) as! Double
            let color = heatMap.getColor(CGFloat(v))
            let l = UILabel(frame: CGRect(x: x, y: 45, width: 10, height: 40))
            l.backgroundColor = color
            self._heatMapLegend.addSubview(l)
            if (Double(i).remainder(dividingBy: 10.0) == 0)
            {
                let t = UILabel(frame: CGRect(x: x, y: 5, width: 80, height: 40))
                t.backgroundColor = UIColor.white
                let tValue = point.roundToDecimal(2)
                t.attributedText = NSAttributedString(string: "\(tValue)", attributes: _defaultAttributes)
                self._heatMapLegend.addSubview(t)
            }   
            x += 10
            i += 1
        }
    }
}
