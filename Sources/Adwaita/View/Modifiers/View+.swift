//
//  View+.swift
//  Adwaita
//
//  Created by david-swift on 03.01.24.
//

extension AnyView {

    /// Wrap the view in a vertical stack and center vertically.
    /// - Returns: The view.
    public func verticalCenter() -> AnyView {
        VStack { self }
            .valign(.center)
    }

    /// Wrap the view in a horizontal stack and center horizontally.
    /// - Returns: The view.
    public func horizontalCenter() -> AnyView {
        HStack { self }
            .halign(.center)
    }

    /// Add a top toolbar to the view.
    /// - Parameters:
    ///   - toolbar: The toolbar's content.
    ///   - visible: Whether the toolbar is visible.
    /// - Returns: A view.
    public func topToolbar(visible: Bool = true, @ViewBuilder _ toolbar: @escaping () -> Body) -> ToolbarView {
        .init()
            .content { self }
            .top(toolbar)
            .revealTopBars(visible)
    }

    /// Add a bottom toolbar to the view.
    /// - Parameters:
    ///   - toolbar: The toolbar's content.
    ///   - visible: Whether the toolbar is visible.
    /// - Returns: A view.
    public func bottomToolbar(visible: Bool = true, @ViewBuilder _ toolbar: @escaping () -> Body) -> ToolbarView {
        .init()
            .content { self }
            .bottom(toolbar)
            .revealBottomBars(visible)
    }

    /// Add an overlay view.
    /// - Parameters:
    ///     - overlay: The overlay view.
    /// - Returns: A view.
    public func overlay(@ViewBuilder _ overlay: @escaping () -> Body) -> Overlay {
        .init()
            .child { self }
            .overlay(overlay)
    }

}
