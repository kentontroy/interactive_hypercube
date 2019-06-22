import Foundation

class QueryParser
{
    func createPredicate(condition1 c1: String, value1 v1: Double,
                         conjunction conj: String?,
                         condition2 c2: String?, value2 v2: Double?) -> String
    {
        var predicate = ""
        if let conj = conj
        {
            if let c2 = c2
            {
                if let v2 = v2
                {
                    predicate = "Value \(c1) \(v1) \(conj) \(c2) \(v2)"

                    if c1 == FilterOperator.LessThan.description || c1 == FilterOperator.LessThanOrEqual.description
                    {
                        if c2 == FilterOperator.LessThan.description || c2 == FilterOperator.LessThanOrEqual.description
                        {
                            if conj == ConjunctionOperator.And.description
                            {
                                let value = v1 <= v2 ? v1 : v2
                                let filter = v1 <= v2 ? c1 : c2
                                predicate = "Value \(filter) \(value)"
                            }
                            else if conj == ConjunctionOperator.Or.description
                            {
                                let value = v1 >= v2 ? v1 : v2
                                let filter = v1 >= v2 ? c1: c2
                                predicate = "Value \(filter) \(value)"
                            }
                        }
                    }
                    else if c1 == FilterOperator.GreaterThan.description || c1 == FilterOperator.GreaterThanOrEqual.description
                    {
                        if c2 == FilterOperator.GreaterThan.description || c2 == FilterOperator.GreaterThanOrEqual.description
                        {
                            if conj == ConjunctionOperator.And.description
                            {
                                let value = v1 >= v2 ? v1 : v2
                                let filter = v1 >= v2 ? c1 : c2
                                predicate = "Value \(filter) \(value)"
                            }
                            else if conj == ConjunctionOperator.Or.description
                            {
                                let value = v1 <= v2 ? v1 : v2
                                let filter = v1 <= v2 ? c1 : c2
                                predicate = "Value \(filter) \(value)"
                            }
                        }
                    }
                }
            }
        }
        else
        {
            predicate = "Value \(c1) \(v1)"
        }
        
        print(predicate)
        return predicate
    }
    
    func parsePredicate(predicate p: String) -> (Double) -> Bool
    {
        if let conjunction = p.range(of: ConjunctionOperator.And.description)
        {
            let condition1 = String(p[..<conjunction.lowerBound])
            let condition2 = String(p[conjunction.upperBound..<p.endIndex])
            let f1 =  getExpression(condition: condition1)
            let f2 = getExpression(condition: condition2)
            let f : (Double) -> Bool = { f1($0) && f2($0)}
            return f
        }
        else if let conjunction = p.range(of: ConjunctionOperator.Or.description)
        {
            let condition1 = String(p[..<conjunction.lowerBound])
            let condition2 = String(p[conjunction.upperBound..<p.endIndex])
            let f1 =  getExpression(condition: condition1)
            let f2 = getExpression(condition: condition2)
            let f : (Double) -> Bool = { f1($0) || f2($0)}
            return f
        }
        else
        {
            let condition = String(p)
            return getExpression(condition: condition)
        }
    }
    
    func getExpression(condition c: String) -> (Double) -> Bool
    {
        var f : (Double) -> Bool = { $0 == $0 }
        if let o = c.range(of: FilterOperator.LessThanOrEqual.description)
        {
            let v = c[o.upperBound..<c.endIndex].trimmingCharacters(in: .whitespacesAndNewlines)
            if let bound = Double(v)
            {
                f = { $0 <= bound }
            }
        }
        else if let o = c.range(of: FilterOperator.LessThan.description)
        {
            let v = c[o.upperBound..<c.endIndex].trimmingCharacters(in: .whitespacesAndNewlines)
            if let bound = Double(v)
            {
                f = { $0 < bound }
            }
        }
        else if let o = c.range(of: FilterOperator.GreaterThanOrEqual.description)
        {
            let v = c[o.upperBound..<c.endIndex].trimmingCharacters(in: .whitespacesAndNewlines)
            if let bound = Double(v)
            {
                f = { $0 >= bound }
            }
        }
        else if let o = c.range(of: FilterOperator.GreaterThan.description)
        {
            let v = c[o.upperBound..<c.endIndex].trimmingCharacters(in: .whitespacesAndNewlines)
            if let bound = Double(v)
            {
                f = { $0 > bound }
            }
        }
        else if let o = c.range(of: FilterOperator.Equal.description)
        {
            let v = c[o.upperBound..<c.endIndex].trimmingCharacters(in: .whitespacesAndNewlines)
            if let bound = Double(v)
            {
                f = { $0 == bound }
            }
        }
        return f
    }
}
