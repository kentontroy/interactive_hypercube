import Foundation

enum DataSimulatorError : Error, CustomStringConvertible
{
    case InvalidNumberOfParameters
    case InvalidParameterSpecification
    var description : String {
        switch self {
        case .InvalidNumberOfParameters:
            return "Invalid number of parameters"
        case .InvalidParameterSpecification:
            return "Invalid parameter specification"
        }
    }
}

class DataSimulator
{
    static func createIterativeLabel(prefix l: String, size n: Int) throws -> [String]
    {
        if n <= 0
        {
            throw DataSimulatorError.InvalidParameterSpecification
        }
        var labels = [String]()
        for i in 0..<n
        {
            labels.append(l + String(i))
        }
        return labels
    }
    static func createRandomExponentialGrid(rows r: Int, cols c: Int, mu m: Double) throws -> Grid2D<Double>
    {
        if m < 0
        {
            throw DataSimulatorError.InvalidParameterSpecification
        }
        let randomGrid = try Grid2D<Double>(rows: r, cols: c)
        for col in 0..<c
        {
            for row in 0..<r
            {
                let x = -(1/m) * log(Double.random(in: 0...1))
                randomGrid[row, col] = x.roundToDecimal(4)
            }
        }
        return randomGrid
    }
}
