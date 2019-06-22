import UIKit

class HeatMapConfigPicker : SingleColumnPicker
{
    var _scene : CubeScene?
    var _heat  : HeatMapConfigView?
    
    override init()
    {
        super.init()
    }
    
    convenience init(scene s: CubeScene, heat h: HeatMapConfigView)
    {
        self.init()
        self._scene = s
        self._heat = h
        _pickerData.append(HeatMapColorRange.Three.description)
        _pickerData.append(HeatMapColorRange.Five.description)
    }
    
    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if self._pickerData[row] == HeatMapColorRange.Three.description
        {
            self._scene?.recolorNodes(heatMapColors: HeatMapColorRange.Three)
            if let cube = self._scene?._model
            {
                self._heat?.drawHeatMapLegend(heatMapColors: HeatMapColorRange.Three, cube: cube)
            }
        }
        else
        {
            self._scene?.recolorNodes(heatMapColors: HeatMapColorRange.Five)
            if let cube = self._scene?._model
            {
                self._heat?.drawHeatMapLegend(heatMapColors: HeatMapColorRange.Five, cube: cube)
            }
        }
    }

}
