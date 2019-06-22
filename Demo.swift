import Foundation

class Demo
{
    static var USE_SAMPLE_JSON = true
    
    init(cubeScene scene: CubeScene, cubeCellView cell: CubeCellView, heatMapConfigView heat: HeatMapConfigView)
    {
        var cube : HyperCube
        do
        {
            if Demo.USE_SAMPLE_JSON
            {
                let data = self.getSampleJSON()
                cube = try HyperCubeFactory.parseJSON(json: data) as! HyperCube
                try cube.scale()
                scene.setupScene(model: cube, heatMap: HeatMap(range: HeatMapColorRange.Three))
                try cube.calculatePercentiles()
            }
            else
            {
                cube = try getRandomCube()
                try cube.scale()
                scene.setupScene(model: cube, heatMap: HeatMap(range: HeatMapColorRange.Three))
                try cube.calculatePercentiles()
            }
            heat.drawHeatMapLegend(heatMapColors: HeatMapColorRange.Three, cube: cube)
            
        }
        catch
        {
            print("Unexpected error:\n\(error).")
        }
    }
    
    func getRandomCube() throws -> HyperCube
    {
        let g1 = try DataSimulator.createRandomExponentialGrid(rows: 4, cols: 4, mu: 23)
        let g2 = try DataSimulator.createRandomExponentialGrid(rows: 4, cols: 4, mu: 14)
        let g3 = try DataSimulator.createRandomExponentialGrid(rows: 4, cols: 4, mu: 6)
        let g4 = try DataSimulator.createRandomExponentialGrid(rows: 4, cols: 4, mu: 11)
     
        let x = try DataSimulator.createIterativeLabel(prefix: "X", size: 4)
        let y = try DataSimulator.createIterativeLabel(prefix: "Y", size: 4)
        
        let c1 = try HyperCubeFace(x: x, y: y, z: "Z1", grid: g1)
        let c2 = try HyperCubeFace(x: x, y: y, z: "Z2", grid: g2)
        let c3 = try HyperCubeFace(x: x, y: y, z: "Z3", grid: g3)
        let c4 = try HyperCubeFace(x: x, y: y, z: "Z4", grid: g4)
        
        var cubeFaces = [HyperCubeFace]()
        cubeFaces.append(contentsOf: [c1, c2, c3, c4])
        
        let cube = HyperCube(faces: cubeFaces, xLabel: "X", yLabel: "Y", zLabel: "Z")
        return cube
    }

    func getSampleJSON() -> String
    {
        let json = """
        {
            "dimensionXLabel" : "Time",
            "dimensionYLabel" : "Product",
            "dimensionZLabel" : "Market",
            "x" : ["Q1", "Q2", "Q3", "Q4"],
            "y" : ["Game Consoles", "LCDs", "Hard Drives", "Digital Cameras"],
            "z" : ["North America", "South America", "Europe", "Asia"],
            "faces": [ {
                            "z"     : "North America",
                            "Q1" : [ 5, 3, 2, 10 ],
                            "Q2" : [ 15, 2, 6, 10 ],
                            "Q3" : [ 5, 13, 2, 9 ],
                            "Q4" : [ 1, 3, 2, 19 ]
                       },
                       {
                            "z"     : "South America",
                            "Q1" : [ 6, 4, 2, 10 ],
                            "Q2" : [ 16, 3, 3, 11 ],
                            "Q3" : [ 7, 11, 5, 9 ],
                            "Q4" : [ 2, 8, 5, 11 ]
                       },
                       {
                            "z"     : "Europe",
                            "Q1" : [ 6, 4, 2, 10 ],
                            "Q2" : [ 16, 3, 3, 11 ],
                            "Q3" : [ 7, 11, 5, 9 ],
                            "Q4" : [ 2, 8, 5, 11 ]
                       },
                       {
                            "z"     : "Asia",
                            "Q1" : [ 8, 8, 7, 6 ],
                            "Q2" : [ 12, 8, 3, 12 ],
                            "Q3" : [ 7, 1, 9, 9 ],
                            "Q4" : [ 4, 4, 5, 1 ]
                       }
                    ]
        }
        """
        return json
    }
}
