//
//  ModifierStopper.swift
//  Adwaita
//
//  Created by david-swift on 11.11.23.
//

/// Remove all of the content modifiers for the wrapped views.
struct ModifierStopper: Widget {

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
        content.updateStorage(storage, modifiers: [], updateProperties: updateProperties)
    }

}

extension AnyView {

    /// Remove all of the content modifiers for the wrapped views.
    /// - Returns: A view.
    public func stopModifiers() -> AnyView {
        ModifierStopper(content: self)
    }

}
