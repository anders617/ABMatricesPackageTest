import Foundation

public enum ABMatrixSide {
    case Left,Right,Top,Bottom
}

public struct ABMatrix <T>:CustomStringConvertible,ArrayLiteralConvertible {
    public typealias Element = [T]
    private var innerRowCount: Int, innerColumnCount: Int
    internal var grid: [T]
    
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
    
    public var transpose:ABMatrix {
        var transposedABMatrix = ABMatrix(rowCount: innerColumnCount, columnCount: innerRowCount, withValue: grid[0])
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
    
    public func merge(other:ABMatrix, onSide side:ABMatrixSide) -> ABMatrix {
        switch side {
        case .Right: return self.mergeRight(other)
        case .Left: return other.mergeRight(self)
        case .Bottom: return self.mergeBottom(other)
        case .Top: return other.mergeBottom(self)
        }
    }
    
    private func mergeRight(other: ABMatrix) -> ABMatrix {
        var newABMatrix = ABMatrix(rowCount: innerRowCount, columnCount: innerColumnCount+other.innerColumnCount, withValue: grid[0])
        for rowNum in 0..<innerRowCount {for columnNum in 0..<innerColumnCount {
                newABMatrix[rowNum,columnNum] = self[rowNum,columnNum]
        }}
        for rowNum in 0..<other.innerRowCount {for columnNum in 0..<other.innerColumnCount {
                newABMatrix[rowNum,innerColumnCount+columnNum] = other[rowNum,columnNum]
        }}
        return newABMatrix
    }
    
    private func mergeBottom(other: ABMatrix) -> ABMatrix {
        var newABMatrix = ABMatrix(rowCount: innerRowCount+other.innerRowCount, columnCount: innerColumnCount, withValue: grid[0])
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
        innerRowCount += 1
    }
    
    public mutating func removeRow(rowIndex:Int) {
        let start = index(rowIndex,0)
        let end = index(rowIndex,innerColumnCount-1)
        grid.removeRange(start...end)
        innerRowCount -= 1
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
        innerColumnCount += 1
    }
    
    public mutating func removeColumn(columnIndex:Int) {
        for rowNum in 0..<innerRowCount {
            grid.removeAtIndex(index(rowNum, columnIndex) - rowNum)
        }
        innerColumnCount -= 1
    }
    
    public mutating func appendColumn(column:ABVector<T>) {
        assert(column.count == innerRowCount, "Column:\(column.count) innerRowCount:\(innerRowCount)\nColumn must have compatible dimensions with matrix")
        insertColumn(column, atColumnIndex: innerColumnCount)
    }
    
    private func indexIsValidForRow(row: Int, column: Int) -> Bool {
        return row >= 0 && row < innerRowCount && column >= 0 && column < innerColumnCount
    }
    
    public func column(columnNum:Int) -> ABVector<T> {
        assert(indexIsValidForRow(0, column: columnNum), "Index out of range.")
        var column = ABVector<T>(count: innerRowCount, repeatedValue: grid[0])
        for rowNum in 0..<innerRowCount {
            column[rowNum] = grid[index(rowNum, columnNum)]
        }
        return column
    }
    
    public mutating func setColumn(columnNum:Int, newColumn: ABVector<T>) {
        assert(indexIsValidForRow(0, column: columnNum), "Index out of range.")
        assert(newColumn.count == innerColumnCount, "New column count must match current matrix.")
        for rowNum in 0..<newColumn.count {
            self[rowNum,columnNum] = newColumn[rowNum]
        }
    }
    
    public func row(rowNum:Int) -> ABVector<T> {
        assert(indexIsValidForRow(rowNum, column: 0), "Index out of range.")
        let start = index(rowNum, 0)
        let end = index(rowNum, innerColumnCount-1)
        return ABVector(Array(grid[start...end]))
    }
    
    public mutating func setRow(rowNum:Int, newRow: ABVector<T>) {
        assert(indexIsValidForRow(rowNum, column: 0), "Index out of range")
        let start = index(rowNum, 0)
        let end = index(rowNum, innerColumnCount-1)
        grid.replaceRange(start...end, with: newRow.cells)
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
    
    public subscript(rowNum:Int) -> ABVector<T> {
        get {
            return row(rowNum)
        }
        set {
            setRow(rowNum, newRow: newValue)
        }
    }
    
    private func index(row:Int,_ column:Int) -> Int {
        return row * innerColumnCount + column
    }
}

//TODO: Move Elsewhere
public func ==<T:Equatable>(lhs:ABMatrix<T>,rhs:ABMatrix<T>) -> Bool {
    if !(lhs.innerRowCount==rhs.innerRowCount && lhs.innerColumnCount==rhs.innerColumnCount) {return false}
    for rowNum in 0..<lhs.innerRowCount {
        for columnNum in 0..<lhs.innerColumnCount {
            if(lhs[rowNum, columnNum] != rhs[rowNum, columnNum]) {return false}
        }
    }
    return true
}
