//
//  Freeze.swift
//  Adwaita
//
//  Created by david-swift on 13.02.24.
//

/// State whether to update the child views or not.
struct Freeze: Widget {

    /// Whether not to update the child view.
    var freeze: Bool
    /// The wrapped view.
    var content: AnyView

    /// Get the content's container.
    /// - Parameter modifiers: Modify views before being updated.
    /// - Returns: The content's container.
    func container(modifiers: [(AnyView) -> AnyView]) -> ViewStorage {
        let storage = content.storage(modifiers: [])
        return storage
    }

    /// Update the content.
    /// - Parameters:
    ///     - storage: The content's storage.
    ///     - modifiers: Modify views before being updated.
    ///     - updateProperties: Whether to update properties.
    func update(_ storage: ViewStorage, modifiers: [(AnyView) -> AnyView], updateProperties: Bool) {
        if !freeze {
            content.updateStorage(storage, modifiers: [], updateProperties: updateProperties)
        }
    }

}

extension AnyView {

    /// Prevent a view from being updated.
    /// - Parameter freeze: Whether to freeze the view.
    /// - Returns: A view.
    public func freeze(_ freeze: Bool = true) -> AnyView {
        Freeze(freeze: freeze, content: self)
    }

}
