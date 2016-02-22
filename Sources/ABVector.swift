import Foundation

public struct ABVector<T>:CustomStringConvertible, ArrayLiteralConvertible{
    public typealias Element = T
    
    internal(set) var cells:[T]
    
    public var count:Int {
        return cells.count
    }
    
    public var description:String {
        var output = ""
        for cell in cells {output += "\(cell) "}
        return output
    }
    
    public init(count:Int, repeatedValue:T) {
        assert(count>0, "ABVector count must be greater than 0.")
        cells = [T](count: count, repeatedValue: repeatedValue)
    }
    
    public init(_ elements:[ABVector.Element]) {
        self.init(count:elements.count, repeatedValue: elements.first!)
        cells = elements
    }
    
    public init(arrayLiteral elements: ABVector.Element...) {
        self.init(count:elements.count, repeatedValue: elements.first!)
        cells = elements
    }
    
    public subscript(position:Int) -> T {
        get {
            assert((0..<count) ~= position, "Index out of range.")
            return cells[position]
        }
        set {
            assert((0..<count) ~= position, "Index out of range.")
            cells[position] = newValue
        }
    }
    
    public mutating func append(element:ABVector.Element) {
        cells.append(element)
    }
    
    public mutating func removeAtIndex(index:Int) {
        cells.removeAtIndex(index)
    }
}