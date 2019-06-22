import SceneKit
import UIKit

let _DEBUG = false

struct CubeSceneCellSizing
{
    var cell: Float
    var minorXLabelPosFactor: Float
    var minorYLabelPosFactor: Float
    var minorZLabelPosFactor: Float
    var minorXLabelHeight: Float
    var minorZLabelHeight: Float
    var minorYLabelDepth: Float
    var dimXHeightMargin: Float
    var dimYHeightMargin: Float
    var dimZHeightMargin: Float
    var dimXWidthMargin: Float
    var dimYWidthMargin: Float
    var dimZWidthMargin: Float
    var dimXDepthMargin: Float
    var dimYDepthMargin: Float
    var dimZDepthMargin: Float
    var camera: SCNVector3
}
enum CubeSceneCellSizingEnum
{
    case small
    case medium
    var size : CubeSceneCellSizing
    {
        switch self
        {
        case .small:
            return CubeSceneCellSizing(cell: 0.25,
                                       minorXLabelPosFactor: 1.1,
                                       minorYLabelPosFactor: -1.0,
                                       minorZLabelPosFactor: 1.65,
                                       minorXLabelHeight: -0.5,
                                       minorZLabelHeight: -0.5,
                                       minorYLabelDepth: -0.3,
                                       dimXHeightMargin: -1.5, dimYHeightMargin: 0.5, dimZHeightMargin: -1.5,
                                       dimXWidthMargin: 0.5, dimYWidthMargin: 1.1,  dimZWidthMargin: 1.1,
                                       dimXDepthMargin: 1.6,  dimYDepthMargin: -0.6, dimZDepthMargin: 1.8,
                                       camera: SCNVector3Make(2, 0, 6))
        case .medium:
            return CubeSceneCellSizing(cell: 0.5,
                                       minorXLabelPosFactor: 1.3,
                                       minorYLabelPosFactor: -1.0,
                                       minorZLabelPosFactor: 1.25,
                                       minorXLabelHeight: -0.5,
                                       minorZLabelHeight: -0.5,
                                       minorYLabelDepth: -0.3,
                                       dimXHeightMargin: -1.5, dimYHeightMargin: 0.85, dimZHeightMargin: -1.5,
                                       dimXWidthMargin: 0.25, dimYWidthMargin: 1.1,  dimZWidthMargin: 1.1,
                                       dimXDepthMargin: 1.6,  dimYDepthMargin: -0.5, dimZDepthMargin: 1.5,
                                       camera: SCNVector3Make(8, 10, 8)) //SCNVector3Make(2, 2, 12)
        }
    }
}

class CubeScene: SCNScene
{
    var _model : HyperCube?
    
    var _dimXLabel : String?
    var _dimYLabel : String?
    var _dimZLabel : String?
    
    var _cameraNode = SCNNode()
    
    private var _backgroundColor = UIColor.white
    var backgroundColor: UIColor {
        get {
            return _backgroundColor
        }
        set (color) {
            _backgroundColor = color
        }
    }
    
    var _size:CubeSceneCellSizing = CubeSceneCellSizingEnum.medium.size
    
//Map the visual node to the Cell specific to an Integer-indexed z-dimension
    var _mapping = [SCNNode : (Int, Cell)]()
//Map the visual text nodes to the dimension labels
    var _mappingXDim = [SCNNode : String]()
    var _mappingYDim = [SCNNode : String]()
    var _mappingZDim = [SCNNode : String]()
    
//Hidden node list
    var _hidden = [SCNNode]()
//Heat map used to color each visual node based upon the scaled node value
    var _heatMap : HeatMap?
    
    override init()
    {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setVisible(node n: SCNNode, visibility v: Bool)
    {
        if !v
        {
            if !_hidden.contains(n)
            {
                _hidden.append(n)
                n.removeFromParentNode()
            }
        }
        else
        {
            for (index, h) in _hidden.enumerated()
            {
//Use the triple equal operator to ensure that equality is identified by verifying that
//both node references point to the same instance in the heap
                if h === n
                {
                    _hidden.remove(at: index)
                    self.rootNode.addChildNode(n)
                    break
                }
            }
        }
    }
    
    func setAllVisible()
    {
        for h in _hidden
        {
            self.rootNode.addChildNode(h)
        }
        _hidden.removeAll()
    }
    
    func setupScene(model m: HyperCube, heatMap heat: HeatMap = HeatMap(range: HeatMapColorRange.Three))
    {
        _heatMap = heat
        
        self._model = m
        
        _cameraNode.camera = SCNCamera()
        self.rootNode.addChildNode(_cameraNode)
 
        self._dimXLabel = m.xLabel
        self._dimYLabel = m.yLabel
        self._dimZLabel = m.zLabel
        
//Creation of the grid scene
        var y:Float = 0.0
        let xCount = m._faces[0].cols
        let yCount = m._faces[0].rows
        let zCount = m._faces.count
        
        for row in 0..<yCount
        {
            var z:Float = 0.0
            for zDimCounter in stride(from: (zCount-1), through: 0, by: -1)
            {
                var x:Float = 0.0
                for xDimCounter in 0..<xCount
                {
                    let cellGeometry = SCNBox(width: CGFloat(self._size.cell),
                                              height: CGFloat(self._size.cell),
                                              length: CGFloat(self._size.cell),
                                              chamferRadius: 0.0)
                    if (row % 2 == 0)
                    {
                        cellGeometry.firstMaterial?.diffuse.contents = UIColor.red
                    }
                    else
                    {
                        cellGeometry.firstMaterial?.diffuse.contents = UIColor.white
                    }
                    let cellNode = SCNNode(geometry: cellGeometry)
                    cellNode.position = SCNVector3(x: x, y: y, z: z)
                    self.rootNode.addChildNode(cellNode)
                    x += 1.1 * Float(self._size.cell)
                    
//Mapping of scene node to data model
                    _mapping[cellNode] = ( zDimCounter, Cell(x: xDimCounter, y: row) )
//HeatMap
                    if let value = self.getCubeCellValue(node: cellNode)?.3
                    {
                        if let heatMap = self._heatMap
                        {
                            if let scaled = self._model?._scaled
                            {
                                let scaledVal = scaled.getValue(value: value)
                                let color = heatMap.getColor(CGFloat(scaledVal))
                                cellNode.geometry?.firstMaterial?.diffuse.contents = color
                                cellNode.geometry?.firstMaterial?.transparencyMode = SCNTransparencyMode.aOne
                                cellNode.geometry?.firstMaterial?.transparency = 0.4
                            }
                        }
                    }
                }
                z += 1.1 * Float(self._size.cell)
            }
            y += 1.1 * Float(self._size.cell)
        }
        
//Major axis labels
//Dimension: X
        let dimXText = SCNText(string: self._dimXLabel, extrusionDepth: 0.1)
        dimXText.font = UIFont (name: "Helvetica", size: CGFloat(self._size.cell))
        dimXText.firstMaterial!.diffuse.contents = UIColor.red
        dimXText.firstMaterial!.specular.contents = UIColor.black
        let dimXNode = SCNNode(geometry: dimXText)
        dimXNode.position = SCNVector3(x: self._size.dimXWidthMargin,
                                       y: self._size.dimXHeightMargin,
                                       z: Float(zCount) * self._size.cell * self._size.dimXDepthMargin)
        dimXNode.eulerAngles.z += Float(Double.pi/2)
        dimXNode.eulerAngles.y += Float(Double.pi/2)
        self.rootNode.addChildNode(dimXNode)
//Dimension: Y
        let dimYText = SCNText(string: self._dimYLabel, extrusionDepth: 0.1)
        dimYText.font = UIFont (name: "Helvetica", size: CGFloat(self._size.cell))
        dimYText.firstMaterial!.diffuse.contents = UIColor.red
        dimYText.firstMaterial!.specular.contents = UIColor.black
        let dimYNode = SCNNode(geometry: dimYText)
        dimYNode.position = SCNVector3(x: Float(xCount) * self._size.cell * self._size.dimYWidthMargin,
                                          y: Float(yCount) * self._size.cell * self._size.dimYHeightMargin,
                                          z: Float(zCount) * self._size.cell * self._size.dimYDepthMargin)
        self.rootNode.addChildNode(dimYNode)
//Dimension: Z
        let dimZText = SCNText(string: self._dimZLabel, extrusionDepth: 0.1)
        dimZText.font = UIFont (name: "Helvetica", size: CGFloat(self._size.cell))
        dimZText.firstMaterial!.diffuse.contents = UIColor.red
        dimZText.firstMaterial!.specular.contents = UIColor.black
        let dimZNode = SCNNode(geometry: dimZText)
        dimZNode.position = SCNVector3(x: Float(xCount) * self._size.cell * self._size.dimZWidthMargin,
                                         y: self._size.dimZHeightMargin,
                                         z: Float(zCount) * self._size.cell * self._size.dimZDepthMargin)
        dimZNode.eulerAngles.x -= Float(Double.pi/2)
        self.rootNode.addChildNode(dimZNode)
        
//Minor axis labels: X
        var i = 0
        for l in m._faces[0].dimensionX
        {
            createMinorAxisX(label: l, position: SCNVector3(x: self._size.minorXLabelPosFactor + Float(i) * self._size.cell,
                                                               y: self._size.minorXLabelHeight,
                                                               z: Float(zCount) * self._size.cell * self._size.dimXDepthMargin))
           i += 1
        }
//Minor axis labels: Y
        i = 0
        for l in m._faces[0].dimensionY
        {
            createMinorAxisY(label: l, position: SCNVector3(x: Float(xCount) * self._size.cell * self._size.dimYWidthMargin,
                                                            y: self._size.minorYLabelPosFactor + Float(i) * self._size.cell,
                                                            z: Float(zCount) * self._size.cell * self._size.minorYLabelDepth))
            i += 1
        }
//Minor axis labels: Z
        i = 0
        for f in m._faces
        {
            let l = f.dimensionZ
            createMinorAxisZ(label: l,
                             position: SCNVector3(x: Float(xCount) * self._size.cell * self._size.dimZWidthMargin,
                                                  y: self._size.minorZLabelHeight,
                                                  z: self._size.cell * (Float(zCount) * self._size.minorZLabelPosFactor - Float(i))))
            i += 1
        }
//Rotate and position the camera
        let r1 = SCNAction.rotateBy(x: CGFloat(-Float.pi/4.0), y: 0.0, z: 0.0, duration: 1.0)
        let r2 = SCNAction.rotateBy(x: 0.0, y: CGFloat(Float.pi/6.0), z: 0.0, duration: 1.0)
        let rSeq = SCNAction.sequence([r1, r2])
        self._cameraNode.runAction(rSeq)
        self._cameraNode.position = self._size.camera

    }
    
    func createMinorAxisY(label: String, position: SCNVector3)
    {
        let nodeText = SCNText(string: label, extrusionDepth: 0.05)
        nodeText.font = UIFont (name: "Helvetica", size: CGFloat(self._size.cell) * 0.60)
        nodeText.firstMaterial!.diffuse.contents = UIColor.black
        nodeText.firstMaterial!.specular.contents = UIColor.red
        let node = SCNNode(geometry: nodeText)
        node.position = position
        self.rootNode.addChildNode(node)
        _mappingYDim[node] = label
    }
    
    func createMinorAxisX(label: String, position: SCNVector3)
    {
        let nodeText = SCNText(string: label, extrusionDepth: 0.05)
        nodeText.font = UIFont (name: "Helvetica", size: CGFloat(self._size.cell) * 0.60)
        nodeText.firstMaterial!.diffuse.contents = UIColor.black
        nodeText.firstMaterial!.specular.contents = UIColor.red
        let node = SCNNode(geometry: nodeText)
        node.position = position
        node.eulerAngles.z += Float(Double.pi/2)
        node.eulerAngles.y += Float(Double.pi/2)
        self.rootNode.addChildNode(node)
        _mappingXDim[node] = label
    }
    
    func createMinorAxisZ(label: String, position: SCNVector3)
    {
        let nodeText = SCNText(string: label, extrusionDepth: 0.05)
        nodeText.font = UIFont (name: "Helvetica", size: CGFloat(self._size.cell) * 0.60)
        nodeText.firstMaterial!.diffuse.contents = UIColor.black
        nodeText.firstMaterial!.specular.contents = UIColor.red
        let node = SCNNode(geometry: nodeText)
        node.position = position
        node.eulerAngles.x -= Float(Double.pi/2)
        self.rootNode.addChildNode(node)
        _mappingZDim[node] = label
    }
    
    func getCubeCellValue(node n: SCNNode) -> (String, String, String, Double)?
    {
        guard let face = self._mapping[n]?.0 as Int? else {
            return nil
        }
        guard let cell = self._mapping[n]?.1 as Cell? else {
            return nil
        }
        guard let value = self._model?._faces[face][cell.x, cell.y] else {
            return nil
        }
        guard let x = self._model?._faces[face].dimensionX[cell.x] else {
            return nil
        }
        guard let y = self._model?._faces[face].dimensionY[cell.y] else {
            return nil
        }
        guard let z = self._model?._faces[face].dimensionZ else {
            return nil
        }
        return (x, y, z, value)
    }
    
    func recolorNodes(heatMapColors heat: HeatMapColorRange)
    {
        if let heatMap = self._heatMap
        {
            if heatMap._range == heat {
                return
            }
        }
        self._heatMap = HeatMap(range: heat)
        guard let scaled = self._model?._scaled else {
            return
        }
        for m in self._mapping
        {
            guard let value = self.getCubeCellValue(node: m.key)?.3 else {
                return
            }
            let scaledVal = scaled.getValue(value: value)
            let color = self._heatMap!.getColor(CGFloat(scaledVal))
            m.key.geometry?.firstMaterial?.diffuse.contents = color
            m.key.geometry?.firstMaterial?.transparencyMode = SCNTransparencyMode.aOne
            m.key.geometry?.firstMaterial?.transparency = 0.4
        }
    }
}
