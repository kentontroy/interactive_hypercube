import Foundation

struct Grid2DConstants
{
    static let MIN_ROWS = 1
    static let MIN_COLS = 1
    static let MAX_ROWS = 1000
    static let MAX_COLS = 1000
}
enum GridAccessError : Error, CustomStringConvertible
{
    case SubscriptExceedsLimits
    case SubscriptOutOfRange
    var description : String {
        switch self {
        case .SubscriptExceedsLimits:
            return """
            Subscripts must reside within allowed limits:
            Rows: \(Grid2DConstants.MIN_ROWS), \(Grid2DConstants.MAX_ROWS)
            Cols: \(Grid2DConstants.MIN_COLS), \(Grid2DConstants.MAX_COLS)
            """
        case .SubscriptOutOfRange:
            return "Subscripts not within allocated range"
        }
    }
}
struct GridIterator<Element> : IteratorProtocol where Element : Hashable
{
    var i = 0
    var grid : Grid2D<Element>
    init(_ grid: Grid2D<Element>)
    {
        self.grid = grid
    }
    mutating func next() -> Element?
    {
        do
        {
            while true
            {
                var (row, col) : (Int, Int)
                try (row, col) = self.grid.getIndices(self.i)
                self.i += 1
                guard let val = self.grid[row, col]
                    else {
                        continue
                }
                return val
            }
        }
        catch
        {
            return nil
        }
    }
}
protocol GridSequence : Sequence
{
    associatedtype Element
    func makeIterator() -> Iterator
}
struct Cell : Hashable
{
    let x : Int
    let y : Int
}
class Grid2D<Element> : GridSequence where Element : Hashable
{
    private var data = Array<Array<Element?>>()
    private var dict = [Element : Set<Cell>]()
    init(rows r: Int, cols c: Int) throws
    {
        if !areDimensionsValid(r, c)
        {
            throw GridAccessError.SubscriptExceedsLimits
        }
        for _ in 1...r
        {
            let col = Array<Element?>(repeating: nil, count: c)
            data.append(col)
        }
    }
    convenience init(rows r: Int, cols c: Int, _ columnData: [Element?]...) throws
    {
        if c != columnData.count {
            throw GridAccessError.SubscriptOutOfRange
        }
        for column in columnData
        {
            if r != column.count {
                throw GridAccessError.SubscriptOutOfRange
            }
        }
        try self.init(rows: r, cols: c)
        for col in 0..<c
        {
            let column = columnData[col]
            for row in 0..<r
            {
                self[row, col] = column[row]
            }
        }
    }
    func makeIterator() -> GridIterator<Element>
    {
        return GridIterator<Element>(self)
    }
    var rows : Int {
        get {
            return data.count
        }
    }
    var cols : Int {
        get {
            return data[0].count
        }
    }
    func areDimensionsValid(_ nRows: Int, _ nCols: Int) -> Bool
    {
        var isValid = nRows >= Grid2DConstants.MIN_ROWS && nRows <= Grid2DConstants.MAX_ROWS
        isValid = isValid && nCols >= Grid2DConstants.MIN_COLS && nCols <= Grid2DConstants.MAX_COLS
        return isValid
    }
    func areIndicesValid(_ row: Int, _ col: Int) -> Bool
    {
        return row >= 0 && row < self.rows && col >= 0 && col < self.cols
    }
    func isIndexValid(_ i: Int) -> Bool
    {
        return i >= 0 && i < (self.rows * self.cols)
    }
    subscript(i: Int, j: Int) -> Element?
    {
        get
        {
            assert(areIndicesValid(i, j), GridAccessError.SubscriptOutOfRange.description)
            return data[i][j]
        }
        set(value)
        {
            assert(areIndicesValid(i, j), GridAccessError.SubscriptOutOfRange.description)
            data[i][j] = value
            if let e = value
            {
                if var cells = dict[e]
                {
                    cells.insert(Cell(x: i, y: j))
                    return
                }
                var cells = Set<Cell>()
                cells.insert(Cell(x: i, y: j))
                dict[e] = cells
            }
        }
    }
    func partition(rows r : ClosedRange<Int>, cols c : ClosedRange<Int>) -> Grid2D<Element>?
    {
        var grid : Grid2D<Element>
        do {
            try grid = Grid2D<Element>(rows: r.count, cols: c.count)
            var i = 0
            for row in r
            {
                var j = 0
                for col in c
                {
                    grid[i, j] = self[row, col]
                    j += 1
                }
                i += 1
            }
            return grid
        }
        catch {
            return nil
        }
    }
    func sliceByColumn(_ col : Int) throws -> [Element?]
    {
        if col < 0 || col >= self.cols {
            throw GridAccessError.SubscriptOutOfRange
        }
        var colValue = [Element?]()
        for row in self.data
        {
            colValue.append(row[col])
        }
        return colValue
    }
    func sliceByRow(_ row : Int) throws -> [Element?]
    {
        if row < 0 || row >= self.rows {
            throw GridAccessError.SubscriptOutOfRange
        }
        return self.data[row];
    }
    func filter(_ expr: (Element) -> Bool) -> [Cell]
    {
        var filtered = [Cell]()
        for entry in self.dict
        {
            if expr(entry.key)
            {
                for cells in entry.value
                {
                    filtered.append(cells)
                }
            }
        }
        return filtered
    }
    func query(_ element : Element) -> [Cell]
    {
        var cells = [Cell]()
        if let v = self.dict[element]
        {
            for cell in v
            {
                cells.append(cell)
            }
        }
        return cells
    }
    fileprivate func getIndices(_ i : Int) throws -> (Int, Int)
    {
        if !isIndexValid(i)
        {
            throw GridAccessError.SubscriptOutOfRange
        }
        if i < self.rows
        {
            return (0, i)
        }
        let row = Int(floor(Double(i / self.cols)))
        let col = i - (row * self.cols)
        return (row, col)
    }
}
extension Grid2D : Hashable, CustomStringConvertible
{
    static func == (l: Grid2D, r: Grid2D) -> Bool {
        return false
    }
    func hash(into hasher: inout Hasher) {
        UUID().hash(into: &hasher)
    }
    var description : String {
        var desc : String = ""
        for row in 0..<self.rows
        {
            for col in 0..<self.cols
            {
                desc += "Row: \(row), Col: \(col) = \(self[row, col])\n"
            }
        }
        return desc
    }
}

