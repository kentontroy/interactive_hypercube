import Foundation

//From exceptionshub.com
extension Double
{
    func roundToDecimal(_ digits: Int) -> Double
    {
        let multiplier = pow(10, Double(digits))
        return Darwin.round(self * multiplier) / multiplier
    }
}

struct ScalingError : Error {}

class Scaled
{
    let _maximum : Double
    let _minimum : Double
    
    init(values v: inout [Double]) throws
    {
        guard let maximum = v.max() else {
            throw ScalingError()
        }
        guard let minimum = v.min() else {
            throw ScalingError()
        }
        _maximum = maximum
        _minimum = minimum
    }
    func getValue(value v: Double) -> Double
    {
        return (v - _minimum) / (_maximum - _minimum)
    }
}

//Translated into Swift from: https://stackoverflow.com/questions/8137391/percentile-calculation
class Percentile
{
    let _data : [Double]
    
    init(values v: inout [Double])
    {
        _data = v.sorted()
    }
    func getPercentile(percent p: Double) -> Double
    {
        let N = _data.count
        let n = Double(N - 1) * p + 1
        if n == 1
        {
            return _data[0]
        }
        else if n == Double(N)
        {
            return _data[N - 1]
        }
        else
        {
            let k = Int(n)
            let d = n - Double(k)
            return _data[k - 1] + d * (_data[k] - _data[k - 1])
        }
    }
}
