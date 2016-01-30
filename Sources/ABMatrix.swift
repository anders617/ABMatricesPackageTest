import Foundation


public struct ABMatrixRowGenerator<Element> {
    let matrix:ABMatrix<Element>
    
    init(_ matrix:ABMatrix<Element>) {
        self.matrix = matrix
    }
    
    public subscript(position:Int) -> ABVector<Element> {
        assert((0..<matrix.innerRowCount) ~= position, "Index out of range.")
        var row = ABVector<Element>(count: matrix.innerColumnCount, repeatedValue: matrix.grid[0])
        for col in 0..<matrix.innerColumnCount {
            row[col] = matrix.grid[(position * matrix.innerColumnCount) + col]
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
        assert((0..<matrix.innerColumnCount) ~= position, "Index out of range.")
        var column = ABVector<Element>(count: matrix.innerRowCount, repeatedValue: matrix.grid[0])
        for row in 0..<matrix.innerRowCount {
            column[row] = matrix.grid[(row * matrix.innerColumnCount) + position]
        }
        return column
    }
}

public enum ABMatrixSide {
    case Left,Right,Top,Bottom
}

public struct ABMatrix <T>:CustomStringConvertible,ArrayLiteralConvertible {
    public typealias Element = [T]
    private var innerRowCount: Int, innerColumnCount: Int
    internal var grid: [T]
    public var row:ABMatrixRowGenerator<T>{return ABMatrixRowGenerator<T>(self)}
    public var column:ABMatrixColumnGenerator<T>{return ABMatrixColumnGenerator<T>(self)}
    
    public var rowCount:Int {
        return innerRowCount
    }
    public var columnCount:Int {
        return innerColumnCount
    }
    
    public var description:String {
        var output = ""
        for row in 0..<innerRowCount {
            for col in 0..<innerColumnCount {
                output += "\(self[row,col]) "
            }
            output += "\n"
        }
        return output
    }
    
    public var transpose:ABMatrix<T> {
        var transposedABMatrix = ABMatrix<T>(rowCount: innerColumnCount, columnCount: innerRowCount, withValue: grid[0])
        for rowNum in 0..<innerRowCount {
            for colNum in 0..<innerColumnCount {
                transposedABMatrix[colNum,rowNum] = self[rowNum,colNum]
            }
        }
        return transposedABMatrix
    }
    
    public init(rowCount: Int, columnCount: Int, withValue value: T) {
        assert(rowCount>0, "Number of innerRowCount in a ABMatrix must be greater than zero")
        assert(columnCount>0, "Number of innerColumnCount in a ABMatrix must be greater than zero")
        innerRowCount = rowCount
        innerColumnCount = columnCount
        grid = Array(count: innerRowCount * innerColumnCount, repeatedValue: value)
    }
    
    public init(arrayLiteral elements: ABMatrix.Element...) {
        assert(elements.count>0,"Invalid ABMatrix Size")
        assert(elements.first!.count>0,"Invalid ABMatrix size")
        self.init(rowCount:elements.count, columnCount: elements.first!.count, withValue: elements.first!.first!)
        for rowNum in 0..<innerRowCount {
            for colNum in 0..<innerColumnCount {
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
        var newABMatrix = ABMatrix<T>(rowCount: innerRowCount, columnCount: innerColumnCount+other.innerColumnCount, withValue: grid[0])
        for rowNum in 0..<innerRowCount {for columnNum in 0..<innerColumnCount {
                newABMatrix[rowNum,columnNum] = self[rowNum,columnNum]
        }}
        for rowNum in 0..<other.innerRowCount {for columnNum in 0..<other.innerColumnCount {
                newABMatrix[rowNum,innerColumnCount+columnNum] = other[rowNum,columnNum]
        }}
        return newABMatrix
    }
    
    private func mergeBottom(other: ABMatrix<T>) -> ABMatrix<T> {
        var newABMatrix = ABMatrix<T>(rowCount: innerRowCount+other.innerRowCount, columnCount: innerColumnCount, withValue: grid[0])
        for rowNum in 0..<innerRowCount {
            newABMatrix[rowNum] = self[rowNum]
        }
        for rowNum in 0..<other.innerRowCount {
            newABMatrix[innerRowCount+rowNum] = other[rowNum]
        }
        return newABMatrix
    }
    
    public mutating func insertRow(row: ABVector<T>, atRowIndex rowIndex:Int) {
        assert(row.count == innerColumnCount, "Row:\(row.count) innerColumnCount:\(innerColumnCount)\nRow must have compatible dimensions with matrix")
        grid.insertContentsOf(row.cells, at: index(rowIndex,0))
        innerRowCount++
    }
    
    public mutating func removeRow(rowIndex:Int) {
        let start = index(rowIndex,0)
        let end = index(rowIndex,innerColumnCount-1)
        grid.removeRange(start...end)
        innerRowCount--
    }
    
    public mutating func appendRow(row: ABVector<T>) {
        assert(row.count == innerColumnCount, "Row:\(row.count) innerColumnCount:\(innerColumnCount)\nRow must have compatible dimensions with matrix")
        insertRow(row, atRowIndex: innerRowCount)
        //grid.appendContentsOf(row.cells)
    }
    
    public mutating func insertColumn(column: ABVector<T>, atColumnIndex columnIndex:Int) {
        assert(column.count == innerRowCount, "Column:\(column.count) innerRowCount:\(innerRowCount)\nColumn must have compatible dimensions with matrix")
        for rowNum in 0..<column.count {
            grid.insert(column[rowNum], atIndex: index(rowNum, columnIndex) + rowNum)
        }
        innerColumnCount++
    }
    
    public mutating func removeColumn(columnIndex:Int) {
        for rowNum in 0..<innerRowCount {
            grid.removeAtIndex(index(rowNum, columnIndex) - rowNum)
        }
        innerColumnCount--
    }
    
    public mutating func appendColumn(column:ABVector<T>) {
        assert(column.count == innerRowCount, "Column:\(column.count) innerRowCount:\(innerRowCount)\nColumn must have compatible dimensions with matrix")
        insertColumn(column, atColumnIndex: innerColumnCount)
    }
    
    private func indexIsValidForRow(row: Int, column: Int) -> Bool {
        return row >= 0 && row < innerRowCount && column >= 0 && column < innerColumnCount
    }
    
    public subscript(row: Int, column: Int) -> T {
        get {
            assert(indexIsValidForRow(row, column: column), "Index out of range")
            return grid[index(row, column)]
        }
        set {
            assert(indexIsValidForRow(row, column: column), "Index out of range")
            grid[index(row, column)] = newValue
        }
    }
    
    public subscript(row:Int) -> ABVector<T> {
        get {
            assert(indexIsValidForRow(row, column: 0), "Index out of range")
            let start = index(row, 0)
            let end = index(row, innerColumnCount-1)
            return ABVector(Array(grid[start...end]))
        }
        set {
            assert(indexIsValidForRow(row, column: 0), "Index out of range")
            let start = index(row, 0)
            let end = index(row, innerColumnCount-1)
            grid.replaceRange(start...end, with: newValue.cells)
        }
    }
    
    private func index(row:Int,_ column:Int) -> Int {
        return row * innerColumnCount + column
    }
}

//TODO: Move Elsewhere
public func ==<T:Equatable>(lhs:ABMatrix<T>,rhs:ABMatrix<T>) -> Bool {
    if !(lhs.innerRowCount==rhs.innerRowCount && lhs.innerColumnCount==rhs.innerColumnCount) {return false}
    for rowNum in 0..<lhs.innerRowCount { for columnNum in 0..<lhs.innerColumnCount {
        if(lhs[rowNum, columnNum] != rhs[rowNum, columnNum]) {return false}
    }}
    return true
}
