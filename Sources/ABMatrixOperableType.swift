import Foundation

public protocol ABMatrixOperableType:Comparable, Equatable {
    static var defaultValue:Self {get}
    
    func +(lhs:Self, rhs:Self) -> Self
    func +=(inout lhs:Self, rhs:Self)
    func -(lhs:Self, rhs:Self) -> Self
    func -=(inout lhs:Self, rhs:Self)
    func *(lhs:Self, rhs:Self) -> Self
    func *=(inout lhs:Self, rhs:Self)
    func /(lhs:Self, rhs:Self) -> Self
    func/=(inout lhs:Self, rhs:Self)
    func %(lhs:Self, rhs:Self) -> Self
    func %=(inout lhs:Self, rhs:Self)
    
    static func abs(x:Self)->Self
}


//Standard Type Conformance
extension Double:ABMatrixOperableType {public static var defaultValue:Double {return 0}}
extension Float:ABMatrixOperableType {public static var defaultValue:Float {return 0}}
extension Float80:ABMatrixOperableType {public static var defaultValue: Float80 {return 0}}
extension Int:ABMatrixOperableType {
    public static var defaultValue:Int {return 0}
    public static func abs(x: Int) -> Int {
        return x>=0 ? x : -x
    }}
extension Int8:ABMatrixOperableType {
    public static var defaultValue:Int8 {return 0}
    public static func abs(x: Int8) -> Int8 {
        return x>=0 ? x : -x
    }
}
extension Int16:ABMatrixOperableType {
    public static var defaultValue:Int16 {return 0}
    public static func abs(x: Int16) -> Int16 {
        return x>=0 ? x : -x
    }
}
extension Int32:ABMatrixOperableType {
    public static var defaultValue:Int32 {return 0}
    public static func abs(x: Int32) -> Int32 {
        return x>=0 ? x : -x
    }
}
extension Int64:ABMatrixOperableType {
    public static var defaultValue: Int64 {return 0}
    public static func abs(x: Int64) -> Int64 {
        return x>=0 ? x : -x
    }
}
extension UInt:ABMatrixOperableType {
    public static var defaultValue:UInt {return 0}
    public static func abs(x: UInt) -> UInt {return x}
}
extension UInt8:ABMatrixOperableType {
    public static var defaultValue:UInt8 {return 0}
    public static func abs(x: UInt8) -> UInt8 {return x}
}
extension UInt16:ABMatrixOperableType {
    public static var defaultValue:UInt16 {return 0}
    public static func abs(x: UInt16) -> UInt16 {return x}
}
extension UInt32:ABMatrixOperableType {
    public static var defaultValue:UInt32 {return 0}
    public static func abs(x: UInt32) -> UInt32 {return x}
}
extension UInt64:ABMatrixOperableType {
    public static var defaultValue:UInt64 {return 0}
    public static func abs(x: UInt64) -> UInt64 {return x}
}

