import UIKit

struct ColorPoint
{
    var value : CGFloat
    var red : CGFloat
    var green : CGFloat
    var blue : CGFloat
    
    func getColor(_ alpha: CGFloat=1.0) -> UIColor
    {
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

//Converted into Swift from original C++ code on www.andrewnoske.com/wiki/Code_-heatmaps_and_color_gradients
//Also see http://uicolor.xyz/#/rgb-to-ui
enum HeatMapColorRange
{
    case Three
    case Five
    var description : String {
        switch self {
        case .Three:
            return "Yellow-to-Red"
        case .Five:
            return "Blue-to-Red"
        }
    }
}

class HeatMap
{
    var _points = [ColorPoint]()
    let _range : HeatMapColorRange
    
    init(range r: HeatMapColorRange)
    {
        switch r
        {
        case .Five:
            _points.append(ColorPoint(value: 0.0,  red: 0.0/255.0, green: 0.0/255.0, blue: 255.0/255.0))    //blue
            _points.append(ColorPoint(value: 0.25, red: 0.0/255.0, green: 255.0/255.0, blue: 255.0/255.0))  //cyan
            _points.append(ColorPoint(value: 0.5,  red: 0.0/255.0, green: 255.0/255.0, blue: 0.0/255.0))    //green
            _points.append(ColorPoint(value: 0.75, red: 255.0/255.0, green: 255.0/255.0, blue: 0.0/255.0))  //yellow
            _points.append(ColorPoint(value: 1.0,  red: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0))    //red
        case .Three:
            _points.append(ColorPoint(value: 0.0, red: 255.0/255.0, green: 255.0/255.0, blue: 0.0/255.0))  //yellow
            _points.append(ColorPoint(value: 0.5, red: 255.0/255.0, green: 138.0/255.0, blue: 0.0/255.0))  //orange
            _points.append(ColorPoint(value: 1.0, red: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0))    //red
        }
        _range = r
    }
    func getColor(_ value: CGFloat) -> UIColor
    {
        for i in 0..<_points.count
        {
            let current: ColorPoint = _points[i]
            if (value < current.value)
            {
                let previous = _points[max(0, i-1)]
                let diff = previous.value - current.value
                let frac = (diff==0.0) ? 0.0 : (value - current.value) / diff
                let red = (previous.red - current.red) * frac + current.red
                let green = (previous.green - current.green) * frac + current.green
                let blue = (previous.blue - current.blue) * frac + current.blue
                return ColorPoint(value: value, red: red, green: green, blue: blue).getColor()
            }
        }
        return ColorPoint(value: value,
                          red:   _points[_points.count-1].red,
                          green: _points[_points.count-1].green,
                          blue:  _points[_points.count-1].blue).getColor()
    }

    
}
