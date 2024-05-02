//
//  Optional.swift
//  Adwaita
//
//  Created by david-swift on 01.05.20204.
//

extension Optional: CustomStringConvertible where Wrapped: CustomStringConvertible {

    /// A textual description of the wrapped value.
    public var description: String {
        self?.description ?? "nil"
    }

}
