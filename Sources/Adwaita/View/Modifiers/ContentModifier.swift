//
//  ContentModifier.swift
//  Adwaita
//
//  Created by david-swift on 11.11.23.
//

/// A widget which replaces views of a specific type in its content.
struct ContentModifier<Content>: Widget where Content: AnyView {

    /// The wrapped view.
    var content: AnyView
    /// The closure for the modification.
    var modify: (Content) -> AnyView

    /// The debug tree parameters.
    var debugTreeParameters: [(String, value: CustomStringConvertible)] {
        [("Attention", value: "Content modifiers are unsupported in the debugging view.")]
    }

    /// The debug tree's content.
    var debugTreeContent: [(String, body: Body)] {
        [("content", body: [content])]
    }

    /// Get the content's container.
    /// - Parameter modifiers: Modify views before being updated.
    /// - Returns: The content's container.
    func container(modifiers: [(AnyView) -> AnyView]) -> ViewStorage {
        let storage = content.storage(modifiers: modifiers + [modifyView])
        return storage
    }

    /// Update the content.
    /// - Parameters:
    ///     - storage: The content's storage.
    ///     - modifiers: Modify views before being updated.
    ///     - updateProperties: Whether to update properties.
    func update(_ storage: ViewStorage, modifiers: [(AnyView) -> AnyView], updateProperties: Bool) {
        content.updateStorage(storage, modifiers: modifiers + [modifyView], updateProperties: updateProperties)
    }

    /// Apply the modifier to a view.
    /// - Parameter view: The view.
    func modifyView(_ view: AnyView) -> AnyView {
        if let view = view as? Content {
            return modify(view).stopModifiers()
        } else {
            return view
        }
    }

}

extension AnyView {

    /// Replace every occurrence of a certain view type in the content.
    /// - Parameters:
    ///     - type: The view type.
    ///     - modify: Modify the view.
    /// - Returns: A view.
    public func modifyContent<Content>(
        _ type: Content.Type,
        modify: @escaping (Content) -> AnyView
    ) -> AnyView where Content: AnyView {
        ContentModifier(content: self, modify: modify)
    }

}
