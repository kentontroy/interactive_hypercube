import Foundation

class HyperCubeFace : Grid2D<Double>
{
    private let _dimensionX : [String]
    private let _dimensionY : [String]
    private let _dimensionZ : String
    
    var dimensionX: [String] {
        get {
            return _dimensionX
        }
    }
    var dimensionY: [String] {
        get {
            return _dimensionY
        }
    }
    var dimensionZ: String {
        get {
            return _dimensionZ
        }
    }

    init(x dimensionX: [String],
         y dimensionY: [String],
         z dimensionZ: String) throws
    {
        _dimensionX = dimensionX
        _dimensionY = dimensionY
        _dimensionZ = dimensionZ
        try super.init(rows: dimensionX.count, cols: dimensionY.count)
    }
    
    convenience init(x dimensionX: [String],
                     y dimensionY: [String],
                     z dimensionZ: String,
                     grid g: Grid2D<Double>) throws
    {
        try self.init(x: dimensionX, y: dimensionY, z: dimensionZ)
        for r in 0..<g.rows
        {
            for c in 0..<g.cols
            {
                self[r, c] = g[r, c]
            }
        }
    }
}

class HyperCube
{
    let _faces : [HyperCubeFace]
    var _scaled : Scaled?
    var _percentiles = [Double]()
    private let _labelDimX : String
    private let _labelDimY : String
    private let _labelDimZ : String
    
    var xLabel: String {
        get {
            return _labelDimX
        }
    }
    var yLabel: String {
        get {
            return _labelDimY
        }
    }
    var zLabel: String {
        get {
            return _labelDimZ
        }
    }
    
    init(faces f: [HyperCubeFace], xLabel x: String, yLabel y: String, zLabel z: String)
    {
        _faces = f
        _labelDimX = x
        _labelDimY = y
        _labelDimZ = z
    }
    
    func getSliceByZ(z: String) -> HyperCubeFace?
    {
        for face in self._faces
        {
            if z == face.dimensionZ
            {
                return face
            }
        }
        return nil
    }
        
    func scale() throws
    {
        var values = [Double]()
        for face in _faces {
            for i in 0..<face.rows {
                for j in 0..<face.cols {
                    guard let v = face[i, j] else {
                        throw ScalingError()
                    }
                    values.append(v)
                }
            }
        }
        try _scaled = Scaled(values: &values)
    }
    
    func calculatePercentiles() throws
    {
        var values = [Double]()
        for face in _faces {
            for i in 0..<face.rows {
                for j in 0..<face.cols {
                    guard let v = face[i, j] else {
                        throw ScalingError()
                    }
                    values.append(v)
                }
            }
        }
        let p = Percentile(values: &values)
        for v in 0..<36 //37
        {
            let percent = 0.10 + Double(v) * 0.025
            let value = p.getPercentile(percent: percent)
            _percentiles.append(value)
        }
    }
}

enum JSONParsingError: Error
{
    case missing(String)
    case invalid(String, Any)
}

class HyperCubeFactory
{
    static func parseJSON(json str: String) throws -> HyperCube?
    {
        let data = str.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any?]
        
        var cube : HyperCube
        
        guard let dimensionXLabel = json["dimensionXLabel"] as? String else {
            throw JSONParsingError.missing("Dimension X Label")
        }
        guard let dimensionYLabel = json["dimensionYLabel"] as? String else {
            throw JSONParsingError.missing("Dimension Y Label")
        }
        guard let dimensionZLabel = json["dimensionZLabel"] as? String else {
            throw JSONParsingError.missing("Dimension Z Label")
        }
        guard let x = json["x"] as? [String] else {
            throw JSONParsingError.missing("X minor axis labels")
        }
        guard let y = json["y"] as? [String] else {
            throw JSONParsingError.missing("Y minor axis labels")
        }
        guard let z = json["z"] as? [String] else {
            throw JSONParsingError.missing("Z minor axis labels")
        }
        guard let faces = json["faces"] as? [Any] else {
            throw JSONParsingError.missing("HyperCube faces")
        }
        
        var cubeFaces = [HyperCubeFace]()
        for a in faces
        {
            guard let face = a as? [String : Any] else {
                throw JSONParsingError.missing("HyperCube face")
            }
            guard let zDimValue = face["z"] as? String else {
                throw JSONParsingError.missing("HyperCube face Z value")
            }
            if (!z.contains(zDimValue)){
                throw JSONParsingError.invalid("HyperCube face Z value", zDimValue)
            }
            let cubeFace = try HyperCubeFace(x: x, y: y, z: zDimValue)
            var i = 0
            for column in x
            {
                guard let cells = face[column] as? [Double] else {
                    throw JSONParsingError.missing("HyperCube face cells for y value: \(column)")
                }
                var j = 0
                for cell in cells
                {
                    cubeFace[i, j] = cell
                    j += 1
                }
                i += 1
            }
            cubeFaces.append(cubeFace)
        }
        
        cube = HyperCube(faces: cubeFaces, xLabel: dimensionXLabel, yLabel: dimensionYLabel, zLabel: dimensionZLabel)
        return cube
    }
}

