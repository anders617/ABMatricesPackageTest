import Foundation


public struct ABMatrixRowGenerator<Element> {
    let matrix:ABMatrix<Element>
    
    init(_ matrix:ABMatrix<Element>) {
        self.matrix = matrix
    }
    
    public subscript(position:Int) -> ABVector<Element> {
        assert((0..<matrix.rowCount) ~= position, "Index out of range.")
        var row = ABVector<Element>(count: matrix.columnCount, repeatedValue: matrix.grid[0])
        for col in 0..<matrix.columnCount {
            row[col] = matrix.grid[(position * matrix.columnCount) + col]
        }
        return row
    }
}

public struct ABMatrixColumnGenerator<Element> {
    var matrix:ABMatrix<Element>
    init(_ matrix:ABMatrix<Element>) {
        self.matrix = matrix
    }
    
    public subscript(position:Int) -> ABVector<Element> {
        assert((0..<matrix.columnCount) ~= position, "Index out of range.")
        var column = ABVector<Element>(count: matrix.rowCount, repeatedValue: matrix.grid[0])
        for row in 0..<matrix.rowCount {
            column[row] = matrix.grid[(row * matrix.columnCount) + position]
        }
        return column
    }
}

public enum ABMatrixSide {
    case Left,Right,Top,Bottom
}

public struct ABMatrix <T>:CustomStringConvertible,ArrayLiteralConvertible {
    public typealias Element = [T]
    
    public let rowCount: Int, columnCount: Int
    internal var grid: [T]
    public var row:ABMatrixRowGenerator<T>{return ABMatrixRowGenerator<T>(self)}
    public var column:ABMatrixColumnGenerator<T>{return ABMatrixColumnGenerator<T>(self)}
    
    public var description:String {
        var output = ""
        for row in 0..<rowCount {
            for col in 0..<columnCount {
                output += "\(self[row,col]) "
            }
            output += "\n"
        }
        return output
    }
    
    public var transpose:ABMatrix<T> {
        var transposedABMatrix = ABMatrix<T>(rowCount: columnCount, columnCount: rowCount, withValue: grid[0])
        for rowNum in 0..<rowCount {
            for colNum in 0..<columnCount {
                transposedABMatrix[colNum,rowNum] = self[rowNum,colNum]
            }
        }
        return transposedABMatrix
    }
    
    public init(rowCount: Int, columnCount: Int, withValue value: T) {
        assert(rowCount>0, "Number of rowCount in a ABMatrix must be greater than zero")
        assert(columnCount>0, "Number of columnCount in a ABMatrix must be greater than zero")
        self.rowCount = rowCount
        self.columnCount = columnCount
        grid = Array(count: rowCount * columnCount, repeatedValue: value)
    }
    
    public init(arrayLiteral elements: ABMatrix.Element...) {
        assert(elements.count>0,"Invalid ABMatrix Size")
        assert(elements.first!.count>0,"Invalid ABMatrix size")
        self.init(rowCount:elements.count, columnCount: elements.first!.count, withValue: elements.first!.first!)
        for rowNum in 0..<rowCount {
            for colNum in 0..<columnCount {
                self[rowNum,colNum] = elements[rowNum][colNum]
            }
        }
    }
    
    public func merge(other:ABMatrix<T>, onSide side:ABMatrixSide) -> ABMatrix<T> {
        switch side {
        case .Right: return self.mergeRight(other)
        case .Left: return other.mergeRight(self)
        case .Bottom: return self.mergeBottom(other)
        case .Top: return other.mergeBottom(self)
        }
    }
    
    private func mergeRight(other: ABMatrix<T>) -> ABMatrix<T> {
        var newABMatrix = ABMatrix<T>(rowCount: self.rowCount, columnCount: self.columnCount+other.columnCount, withValue: grid[0])
        for rowNum in 0..<self.rowCount {for columnNum in 0..<self.columnCount {
                newABMatrix[rowNum,columnNum] = self[rowNum,columnNum]
        }}
        for rowNum in 0..<other.rowCount {for columnNum in 0..<other.columnCount {
                newABMatrix[rowNum,self.columnCount+columnNum] = other[rowNum,columnNum]
        }}
        return newABMatrix
    }
    
    private func mergeBottom(other: ABMatrix<T>) -> ABMatrix<T> {
        var newABMatrix = ABMatrix<T>(rowCount: self.rowCount+other.rowCount, columnCount: self.columnCount, withValue: grid[0])
        for rowNum in 0..<self.rowCount { for columnNum in 0..<self.columnCount {
                newABMatrix[rowNum,columnNum] = self[rowNum,columnNum]
        }}
        for rowNum in 0..<other.rowCount { for columnNum in 0..<other.columnCount {
            newABMatrix[self.rowCount+rowNum-1,columnNum] = other[rowNum,columnNum]
        }}
        return newABMatrix
    }
    
    public mutating func insertRow(row: ABVector<T>, atRowIndex rowIndex:Int) {
        assert(row.count == columnCount, "Row:\(row.count) ColumnCount:\(columnCount)\nRow must have compatible dimensions with matrix")
        grid.insertContentsOf(row.cells, at: index(rowIndex,0))
    }
    
    public mutating func removeRowAtRowIndex(rowIndex:Int) {
        grid.removeRange(Range(start: index(rowIndex,0), end: index(rowIndex,rowCount-1)))
    }
    
    public mutating func appendRow(row: ABVector<T>) {
        assert(row.count == columnCount, "Row:\(row.count) columnCount:\(columnCount)\nRow must have compatible dimensions with matrix")
        insertRow(row, atRowIndex: rowCount)
    }
    
    public mutating func insertColumn(column: ABVector<T>, atColumnIndex columnIndex:Int) {
        assert(column.count == rowCount, "Column:\(column.count) rowCount:\(rowCount)\nColumn must have compatible dimensions with matrix")
        for rowNum in 0..<column.count {
            grid.insert(column[rowNum], atIndex: index(rowNum, columnIndex))
        }
    }
    
    public mutating func removeColumnAtColumnIndex(columnIndex:Int) {
        for rowNum in 0..<rowCount {
            grid.removeAtIndex(index(rowNum, columnIndex))
        }
    }
    
    public mutating func appendColumn(column:ABVector<T>) {
        assert(column.count == rowCount, "Column:\(column.count) rowCount:\(rowCount)\nColumn must have compatible dimensions with matrix")
        insertColumn(column, atColumnIndex: columnCount)
    }
    
    private func indexIsValidForRow(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rowCount && column >= 0 && column < columnCount
    }
    
    public subscript(row: Int, column: Int) -> T {
        get {
            return grid[index(row, column)]
        }
        set {
            grid[index(row, column)] = newValue
        }
    }
    
    private func index(row:Int,_ column:Int) -> Int {
        assert(indexIsValidForRow(row, column: column), "Index out of range")
        return row * columnCount + column
    }
}

//TODO: Move Elsewhere
public func ==<T:Equatable>(lhs:ABMatrix<T>,_ rhs:ABMatrix<T>) -> Bool {
    if !(lhs.rowCount==rhs.rowCount && lhs.columnCount==rhs.columnCount) {return false}
    for rowNum in 0..<lhs.rowCount { for columnNum in 0..<lhs.columnCount {
        if(lhs[rowNum, columnNum] != rhs[rowNum, columnNum]) {return false}
    }}
    return true
}
