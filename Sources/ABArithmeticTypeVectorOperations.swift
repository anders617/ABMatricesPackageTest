
/**
 ABMatrixOperableType ABVector addition.
*/
@warn_unused_result public func +<T:ABMatrixOperableType>(lhs:ABVector<T>,_ rhs:ABVector<T>) -> ABVector<T> {
    assert(lhs.count==rhs.count, "Summands must be of same length in ABVector addition.")
    var newABVector = ABVector<T>(count: lhs.count, repeatedValue: lhs[0])
    for i in 0..<newABVector.count {
        newABVector[i] = lhs[i] + rhs[i]
    }
    return newABVector
}

@warn_unused_result public func +=<T:ABMatrixOperableType>(inout lhs:ABVector<T>,_ rhs:ABVector<T>) {
    lhs = lhs + rhs
}

/**
 ABMatrixOperableType ABVector subtraction.
*/
@warn_unused_result public func -<T:ABMatrixOperableType>(lhs:ABVector<T>,_ rhs:ABVector<T>) -> ABVector<T> {
    assert(lhs.count==rhs.count, "Minuend and subtrahend must be of same length in ABVector subtraction.")
    var newABVector = ABVector<T>(count: lhs.count, repeatedValue: lhs[0])
    for i in 0..<newABVector.count {
        newABVector[i] = lhs[i] - rhs[i]
    }
    return newABVector
}

@warn_unused_result public func -=<T:ABMatrixOperableType>(inout lhs:ABVector<T>,_ rhs:ABVector<T>) {
    lhs = lhs - rhs
}

/**
 ABMatrixOperableType ABVector scalar multiplication.
*/
@warn_unused_result public func *<T:ABMatrixOperableType>(lhs:T,_ rhs:ABVector<T>) -> ABVector<T> {
    var newABVector = ABVector<T>(count: rhs.count, repeatedValue: rhs[0])
    for i in 0..<newABVector.count {
        newABVector[i] = lhs * rhs[i]
    }
    return newABVector
}

/**
 ABMatrixOperableType ABVector scalar multiplication
*/
@warn_unused_result public func *<T:ABMatrixOperableType>(lhs:ABVector<T>,_ rhs:T) -> ABVector<T> {
    return rhs * lhs
}

@warn_unused_result public func *=<T:ABMatrixOperableType>(inout lhs:ABVector<T>,_ rhs:T) {
    lhs = lhs * rhs
}

/**
 ABMatrixOperableType ABVector dot product.
*/
@warn_unused_result public func *<T:ABMatrixOperableType>(lhs:ABVector<T>,_ rhs:ABVector<T>) -> T {
    assert(lhs.count==rhs.count, "Factors must be of same length in ABVector dot product.")
    var sum = T.defaultValue
    for i in 0..<lhs.count {
        sum += lhs[i] * rhs[i]
    }
    return sum
}

