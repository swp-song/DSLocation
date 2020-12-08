//
//  DSBase.swift
//  DSBase
//
//  Created by Dream on 2020/12/8.
//

public struct DS<DSBase> {
    public var ds : DSBase
    public init(_ ds : DSBase) {
        self.ds = ds
    }
}

public protocol DSCompatible { }

public extension DSCompatible {
    
    var ds : DS<Self> {
        set { }
        get { DS(self) }
    }
    
    static var ds : DS<Self>.Type {
        set { }
        get { DS<Self>.self }
    }
}



