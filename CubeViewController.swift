import SceneKit

class CubeViewController: UIViewController, Storyboarded
{
    weak var _coordinator: VisualizeCoordinator?
    
    var _scene = CubeScene()
    var _cell  = CubeCellView(frame: CGRect(x: 0, y: 0, width: 300, height: 250))
    var _heat  = HeatMapConfigView(frame: CGRect(x: 300, y: 0, width: 300, height: 250))
    var _filter : FilterValuesView?
    
    var _previousSelectedNode : SCNNode?
    var _previousSelectedNodeColor : UIColor?
    
    var _runDemo = true
    
    var _pickerHeatMap : HeatMapConfigPicker?
    var _pickerFilterValues : FilterValuesPicker?
    var _pickerConjunction : ConjunctionPicker?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        _filter = FilterValuesView(scene: self._scene, frame: CGRect(x: 700, y: 0, width: 350, height: 230))
        
        _pickerHeatMap = HeatMapConfigPicker(scene: self._scene, heat: self._heat)
        _heat._picker.dataSource = _pickerHeatMap!
        _heat._picker.delegate = _pickerHeatMap!
        _pickerFilterValues = FilterValuesPicker()
        _filter?._pickerFilter1.dataSource = _pickerFilterValues!
        _filter?._pickerFilter1.delegate = _pickerFilterValues!
        _filter?._pickerFilter2.dataSource = _pickerFilterValues!
        _filter?._pickerFilter2.delegate = _pickerFilterValues!
        _pickerConjunction = ConjunctionPicker()
        _filter?._pickerConjunction.dataSource = _pickerConjunction!
        _filter?._pickerConjunction.delegate = _pickerConjunction!
        
        let scnView = self.view as! SCNView
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(sceneTapped))
        tapRecognizer.numberOfTapsRequired = 1
        scnView.addGestureRecognizer(tapRecognizer)
        scnView.autoenablesDefaultLighting = true
        scnView.allowsCameraControl = true
        scnView.scene = _scene
        scnView.backgroundColor = _scene.backgroundColor
        
        do
        {
            if (_runDemo)
            {
                _ = Demo(cubeScene: _scene, cubeCellView: _cell, heatMapConfigView: _heat)
            }
            else
            {
            }
            self.view.addSubview(_cell)
            self.view.addSubview(_heat)
            self.view.addSubview(_filter!)
 
//Buy the image: https://sp.depositphotos.com/98049632/stock-illustration-abstract-grid-background.html
            let backgroundImage = UIImageView(frame: scnView.bounds)
            backgroundImage.image = UIImage(named: "background_image.jpg")
            backgroundImage.alpha = 0.10
            backgroundImage.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            scnView.insertSubview(backgroundImage, at: 0)

        }
        catch
        {
            print("Unexpected error:\n\(error).")
        }
    }
    
    @objc func sceneTapped(sender: UITapGestureRecognizer)
    {
        let tappedView = sender.view as! SCNView
        let location = sender.location(in: tappedView)
        let hitResults = tappedView.hitTest(location, options: nil)
        if !hitResults.isEmpty
        {
            guard let hitNode = hitResults.first else {
                return
            }
            if let previousNode = self._previousSelectedNode {
                previousNode.geometry?.firstMaterial?.diffuse.contents = self._previousSelectedNodeColor
            }
            
            if hitNode.node == self._previousSelectedNode {
                self._previousSelectedNode = nil
                self._previousSelectedNodeColor = nil
                self._cell.showCellDimensions(x: "", y: "", z: "")
                self._cell.showCellValue(value: nil)
                return
            }
            
            self._previousSelectedNodeColor = hitNode.node.geometry?.firstMaterial?.diffuse.contents as? UIColor
            self._previousSelectedNode = hitNode.node
            self._previousSelectedNode?.geometry?.firstMaterial?.diffuse.contents = UIColor.gray

            if let text = hitNode.node.geometry as? SCNText
            {
                if let z = text.string as? String
                {
                    if let cube = self._scene._model
                    {
                        if let face = cube.getSliceByZ(z: z) {
                            self._coordinator?.sliceGridFromCube(slice: face)
                        }
                    }
                }
                return
            }
            
            guard let (x, y, z, value) = _scene.getCubeCellValue(node: hitNode.node) else {
                return
            }
            self._cell.showCellDimensions(x: x, y: y, z: z)
            self._cell.showCellValue(value: value)
        }
    }
}

