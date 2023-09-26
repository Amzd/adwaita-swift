//
//  VStack.swift
//  Adwaita
//
//  Created by david-swift on 23.08.23.
//

import GTUI

/// A GtkBox equivalent.
public struct VStack: Widget {

    /// The content.
    var content: () -> Body

    /// Initialize a `VStack`.
    /// - Parameter content: The view content.
    public init(@ViewBuilder content: @escaping () -> Body) {
        self.content = content
    }

    /// Update a view storage.
    /// - Parameter storage: The view storage.
    public func update(_ storage: ViewStorage) {
        content().update(storage.content[.mainContent] ?? [])
    }

    /// Get a view storage.
    /// - Returns: The view storage.
    public func container() -> ViewStorage {
        let box: Box = .init(horizontal: false)
        var content: [ViewStorage] = []
        for element in self.content() {
            let widget = element.storage()
            _ = box.append(widget.view)
            content.append(widget)
        }
        return .init(box, content: [.mainContent: content])
    }

}
