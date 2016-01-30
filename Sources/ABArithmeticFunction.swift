import Foundation


/**
 Wraps a function into a struct. The function must take a ABVector and return the given type of ABMatrixOperableType This allows for generic typing of the function.
*/
public struct ArithmeticFunction<T:ABMatrixOperableType>:ArrayLiteralConvertible {
    public typealias Element = ABVector<T>->T
    
    public var function:(ABVector<T>->T)
    
    /**
     Provides a more convenient way of initializing ArithmeticFunctions without having to directy call the initializer. Wrapping a single function in square brackets will now be convertible to an ArithmeticFunction.
    */
    public init(arrayLiteral elements: ArithmeticFunction.Element...) {
        assert(elements.count == 1)
        self.init(elements.first!)
    }
    
    public init(_ function:ABVector<T>->T) {
        self.function = function
    }
}

//Comformance to ABMatrixOperableType protocol.
extension ArithmeticFunction:ABMatrixOperableType{
    public static var defaultValue:ArithmeticFunction<T> {return [{_ in T.defaultValue}]}
    public static func abs(x: ArithmeticFunction<T>) -> ArithmeticFunction<T> {return x}
}

public func ==<T:ABMatrixOperableType>(lhs:ArithmeticFunction<T>,rhs:ArithmeticFunction<T>) -> Bool {
    return false
}

public func <<T:ABMatrixOperableType>(lhs:ArithmeticFunction<T>, rhs:ArithmeticFunction<T>) -> Bool {
    return false
}

@warn_unused_result public func +<T:ABMatrixOperableType>(lhs:ArithmeticFunction<T>,rhs:ArithmeticFunction<T>) -> ArithmeticFunction<T> {
    return [{lhs.function($0) + rhs.function($0)}]
}

@warn_unused_result public func +=<T:ABMatrixOperableType>(inout lhs:ArithmeticFunction<T>, rhs:ArithmeticFunction<T>) {
    lhs = lhs + rhs
}

@warn_unused_result public func -<T:ABMatrixOperableType>(lhs:ArithmeticFunction<T>, rhs:ArithmeticFunction<T>) -> ArithmeticFunction<T> {
    return [{lhs.function($0) - rhs.function($0)}]
}

@warn_unused_result public func -=<T:ABMatrixOperableType>(inout lhs:ArithmeticFunction<T>, rhs:ArithmeticFunction<T>) {
    lhs = lhs - rhs
}

@warn_unused_result public func *<T:ABMatrixOperableType>(lhs:ArithmeticFunction<T>, rhs:ArithmeticFunction<T>) -> ArithmeticFunction<T> {
    return [{lhs.function($0) * rhs.function($0)}]
}

@warn_unused_result public func *=<T:ABMatrixOperableType>(inout lhs:ArithmeticFunction<T>, rhs:ArithmeticFunction<T>) {
    lhs = lhs * rhs
}

@warn_unused_result public func /<T:ABMatrixOperableType>(lhs:ArithmeticFunction<T>, rhs:ArithmeticFunction<T>) -> ArithmeticFunction<T> {
    return [{lhs.function($0) / rhs.function($0)}]
}

@warn_unused_result public func /=<T:ABMatrixOperableType>(inout lhs:ArithmeticFunction<T>, rhs:ArithmeticFunction<T>) {
    lhs = lhs / rhs
}

@warn_unused_result public func %<T:ABMatrixOperableType>(lhs:ArithmeticFunction<T>, rhs:ArithmeticFunction<T>) -> ArithmeticFunction<T> {
    return [{lhs.function($0) % rhs.function($0)}]
}

@warn_unused_result public func %=<T:ABMatrixOperableType>(inout lhs:ArithmeticFunction<T>, rhs:ArithmeticFunction<T>) {
    lhs = lhs % rhs
}
