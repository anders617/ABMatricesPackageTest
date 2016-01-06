
public struct AugmentedABMatrix<T:ABMatrixOperableType>:CustomStringConvertible, ArrayLiteralConvertible {
    public typealias Element = [T]
    
    private var matrix:ABMatrix<T>
    public let size:Int
    
    public var description:String {
        var output = ""
        var elementSeparator = " "
        for row in 0..<size {
            for col in 0..<size+1 {
                elementSeparator = col==size-1 ? "|" : " "
                output += "\(self[row,col])\(elementSeparator)"
            }
            output += "\n"
        }
        return output
    }
    
    public var values:ABVector<T> {
        var newABVector = ABVector<T>(count: self.size, repeatedValue: T.defaultValue)
        for rowNum in 0..<self.size {
            newABVector[rowNum] = self[rowNum,self.size]
        }
        return newABVector
    }
    
    public init(size:Int) {
        self.size = size
        matrix = ABMatrix<T>(rowCount: size, columnCount: size+1, withValue: T.defaultValue)
    }
    
    public init(coefficients:ABMatrix<T>, values:ABMatrix<T>) {
        self.matrix = coefficients.merge(values, onSide: .Right)
        self.size = self.matrix.rowCount
    }
    
    public init(arrayLiteral elements: AugmentedABMatrix.Element...) {
        assert(elements.count == elements.first!.count-1,"Augmented ABMatrix must have dimensions of (n x n+1)")
        self.init(size: elements.count)
        for rowNum in 0..<elements.count {
            for colNum in 0..<elements.first!.count {
                matrix[rowNum,colNum] = elements[rowNum][colNum]
            }
        }
    }
    
    public mutating func rowSwap(firstIndex:Int, _ secondIndex:Int) {
        let row = matrix.row
        let firstRow = row[firstIndex]
        let secondRow = row[secondIndex]
        for i in 0..<self.size+1 {
            self.matrix[firstIndex, i] = secondRow[i]
            self.matrix[secondIndex, i] = firstRow[i]
        }
    }
    
    public mutating func multiplyRow(rowNum:Int, by factor:T) {
        for columnNum in 0..<self.size+1 {
            self.matrix[rowNum, columnNum] *= factor
        }
    }
    
    public mutating func divideRow(rowNum:Int, by divisor:T) {
        for columnNum in 0..<self.size+1 {
            self.matrix[rowNum,columnNum] /= divisor
        }
    }
    
    public mutating func addRow(firstRowNum:Int, toRow secondRowNum:Int, withFactor factor:T) {
        let firstRow = self.matrix.row[firstRowNum]
        for columnNum in 0..<self.size+1 {
            self.matrix[secondRowNum, columnNum] += (firstRow[columnNum]*factor)
        }
    }
    
    public mutating func subtractRow(firstRowNum:Int, toRow secondRowNum:Int, withFactor factor:T) {
        let firstRow = self.matrix.row[firstRowNum]
        for columnNum in 0..<self.size+1 {
            self.matrix[secondRowNum, columnNum] -= (firstRow[columnNum]*factor)
        }
    }

    
    public mutating func toRREF() {
        //To Echelon Form
        for pivotIndex in 0..<self.size {
            var maxRowNum:Int = pivotIndex
            var tempMax:T = T.defaultValue
            for i in pivotIndex..<self.size {
                if tempMax < T.abs(self[i,pivotIndex]) {tempMax = self[i,pivotIndex]; maxRowNum=i}//TODO:Absolute value instead of simple compare
            }
            self.rowSwap(pivotIndex, maxRowNum)
            for i in pivotIndex+1..<self.size {
                let m = self[i,pivotIndex] / self[pivotIndex,pivotIndex]
                self.subtractRow(pivotIndex, toRow: i, withFactor: m)
            }
        }
        //To Reduced Row Echelon form
        for pivotIndex in 0..<self.size {
            let mirrorIndex = self.size - pivotIndex - 1
            for i in 0..<mirrorIndex {
                let m = self[i,mirrorIndex] / self[mirrorIndex,mirrorIndex]
                self.subtractRow(mirrorIndex, toRow: i, withFactor: m)
            }
        }
        for rowNum in 0..<self.size {
            self.divideRow(rowNum, by: self[rowNum,rowNum])
        }
    }
    
    public subscript(row:Int, column:Int) -> T {
        get {
            return matrix[row,column]
        }
        set {
            matrix[row,column] = newValue
        }
    }
    
}