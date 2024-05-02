//
//  StateWrapper.swift
//  Adwaita
//
//  Created by david-swift on 26.09.23.
//

import CAdw
import Observation

/// A storage for `@State` properties.
public struct StateWrapper: Widget {

    /// The content.
    var content: () -> Body
    /// The state information (from properties with the `State` wrapper).
    var state: [String: StateProtocol] = [:]

    /// The debug tree parameters.
    public var debugTreeParameters: [(String, value: CustomStringConvertible)] {
        [
            ("state", value: state)
        ]
    }

    /// The debug tree's content.
    public var debugTreeContent: [(String, body: Body)] {
        [("content", body: content())]
    }

    /// The identifier of the field storing whether to update the wrapper's content.
    private var updateID: String { "update" }

    /// Initialize a `StateWrapper`.
    /// - Parameter content: The view content.
    public init(@ViewBuilder content: @escaping () -> Body) {
        self.content = content
    }

    /// Initialize a `StateWrapper`.
    /// - Parameters:
    ///   - content: The view content.
    ///   - state: The state information.
    init(content: @escaping () -> Body, state: [String: StateProtocol]) {
        self.content = content
        self.state = state
    }

    /// Update a view storage.
    /// - Parameters:
    ///     - storage: The view storage.
    ///     - modifiers: Modify views before being updated.
    ///     - updateProperties: Whether to update properties.
    public func update(_ storage: ViewStorage, modifiers: [(AnyView) -> AnyView], updateProperties: Bool) {
        var updateProperties = storage.fields[updateID] as? Bool ?? false
        storage.fields[updateID] = false
        for property in state {
            if let storage = storage.state[property.key]?.content.storage {
                property.value.content.storage = storage
            }
            if property.value.content.storage.update {
                updateProperties = true
                property.value.content.storage.update = false
            }
        }
        if let storage = storage.content[.mainContent]?.first {
            content()
                .widget(modifiers: modifiers)
                .update(storage, modifiers: modifiers, updateProperties: updateProperties)
        }
    }

    /// Get a view storage.
    /// - Parameter modifiers: Modify views before being updated.
    /// - Returns: The view storage.
    public func container(modifiers: [(AnyView) -> AnyView]) -> ViewStorage {
        let content = content().widget(modifiers: modifiers).container(modifiers: modifiers)
        let storage = ViewStorage(content.pointer, content: [.mainContent: [content]], state: state)
        observe(storage: storage)
        return storage
    }

    /// Observe the observable properties accessed in the view.
    /// - Parameter storage: The view storage
    func observe(storage: ViewStorage) {
        withObservationTracking {
            _ = content().getDebugTree(parameters: true)
        } onChange: {
            storage.fields[updateID] = true
            let idleSourceId = g_idle_add({ _ in
                    State<Any>.updateViews()
                    return G_SOURCE_REMOVE
                }, nil)
            observe(storage: storage)
        }
    }

}
