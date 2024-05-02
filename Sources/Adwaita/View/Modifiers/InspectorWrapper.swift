//
//  InspectorWrapper.swift
//  Adwaita
//
//  Created by david-swift on 10.09.23.
//

import CAdw

/// A widget which executes a custom code on the GTUI widget when being created and updated.
struct InspectorWrapper: Widget {

    /// The custom code to edit the widget.
    var modify: (ViewStorage) -> Void
    /// The wrapped view.
    var content: AnyView

    /// The debug tree parameters.
    var debugTreeParameters: [(String, value: CustomStringConvertible)] {
        [
            ("modify", value: "(ViewStorage) -> Void")
        ]
    }

    /// The debug tree's content.
    var debugTreeContent: [(String, body: Body)] {
        [("content", body: [content])]
    }

    /// Get the content's container.
    /// - Parameter modifiers: Modify views before being updated.
    /// - Returns: The content's container.
    func container(modifiers: [(AnyView) -> AnyView]) -> ViewStorage {
        let storage = content.storage(modifiers: modifiers)
        modify(storage)
        return storage
    }

    /// Update the content.
    /// - Parameters:
    ///     - storage: The content's storage.
    ///     - modifiers: Modify views before being updated.
    ///     - updateProperties: Whether to update properties.
    func update(_ storage: ViewStorage, modifiers: [(AnyView) -> AnyView], updateProperties: Bool) {
        content.updateStorage(storage, modifiers: modifiers, updateProperties: updateProperties)
        modify(storage)
    }

}

extension AnyView {

    /// The identifier for the focus event controller.
    static var focus: String { "focus" }

    /// Modify a GTUI widget before being displayed and when being updated.
    /// - Parameter modify: Modify the widget.
    /// - Returns: A view.
    public func inspect(_ modify: @escaping (ViewStorage) -> Void) -> AnyView {
        InspectorWrapper(modify: modify, content: self)
    }

    /// Add padding around a view.
    /// - Parameters:
    ///   - padding: The size of the padding.
    ///   - edges: The edges which are affected by the padding.
    /// - Returns: A view.
    public func padding(_ padding: Int = 10, _ edges: Set<Edge> = .all) -> AnyView {
        inspect { widget in
            if edges.contains(.leading) { gtk_widget_set_margin_start(widget.pointer?.cast(), padding.cInt) }
            if edges.contains(.trailing) { gtk_widget_set_margin_end(widget.pointer?.cast(), padding.cInt) }
            if edges.contains(.top) { gtk_widget_set_margin_top(widget.pointer?.cast(), padding.cInt) }
            if edges.contains(.bottom) { gtk_widget_set_margin_bottom(widget.pointer?.cast(), padding.cInt) }
        }
    }

    /// Enable or disable the horizontal expansion.
    /// - Parameter enabled: Whether it is enabled or disabled.
    /// - Returns: A view.
    public func hexpand(_ enabled: Bool = true) -> AnyView {
        inspect { gtk_widget_set_hexpand($0.pointer?.cast(), enabled.cBool) }
    }

    /// Enable or disable the vertical expansion.
    /// - Parameter enabled: Whether it is enabled or disabled.
    /// - Returns: A view.
    public func vexpand(_ enabled: Bool = true) -> AnyView {
        inspect { gtk_widget_set_vexpand($0.pointer?.cast(), enabled.cBool) }
    }

    /// Set the horizontal alignment.
    /// - Parameter align: The alignment.
    /// - Returns: A view.
    public func halign(_ align: Alignment) -> AnyView {
        inspect { gtk_widget_set_halign($0.pointer?.cast(), align.cAlign) }
    }

    /// Set the vertical alignment.
    /// - Parameter align: The alignment.
    /// - Returns: A view.
    public func valign(_ align: Alignment) -> AnyView {
        inspect { gtk_widget_set_valign($0.pointer?.cast(), align.cAlign) }
    }

    /// Set the view's minimal width or height.
    /// - Parameters:
    ///   - minWidth: The minimal width.
    ///   - minHeight: The minimal height.
    /// - Returns: A view.
    public func frame(minWidth: Int? = nil, minHeight: Int? = nil) -> AnyView {
        inspect { gtk_widget_set_size_request($0.pointer?.cast(), minWidth?.cInt ?? 1, minHeight?.cInt ?? -1) }
    }

    /// Set the view's transition.
    /// - Parameter transition: The transition.
    /// - Returns: A view.
    public func transition(_ transition: Transition) -> AnyView {
        inspect { $0.fields[.transition] = transition }
    }

    /// Set the view's navigation title.
    /// - Parameter label: The navigation title.
    /// - Returns: A view.
    public func navigationTitle(_ label: String) -> AnyView {
        inspect { $0.fields[.navigationLabel] = label }
    }

    /// Add a style class to the view.
    /// - Parameter style: The style class.
    /// - Returns: A view.
    public func style(_ style: String) -> AnyView {
        inspect { gtk_widget_add_css_class($0.pointer?.cast(), style) }
    }

    /// Run a function when the view gets an update.
    /// - Parameter onUpdate: The function.
    /// - Returns: A view.
    public func onUpdate(_ onUpdate: @escaping () -> Void) -> AnyView {
        inspect { _ in onUpdate() }
    }

    /// Make the view insensitive (useful e.g. in overlays).
    /// - Parameter insensitive: Whether the view is insensitive.
    /// - Returns: A view.
    public func insensitive(_ insensitive: Bool = true) -> AnyView {
        inspect { gtk_widget_set_sensitive($0.pointer?.cast(), insensitive ? 0 : 1) }
    }

    /// Set the view's visibility.
    /// - Parameter visible: Whether the view is visible.
    /// - Returns: A view.
    public func visible(_ visible: Bool = true) -> AnyView {
        inspect { gtk_widget_set_visible($0.pointer?.cast(), visible.cBool) }
    }

    /// Bind to the view's focus.
    /// - Parameter focus: Whether the view is focused.
    /// - Returns: A view.
    public func focused(_ focused: Binding<Bool>) -> AnyView {
        inspectOnAppear { storage in
            let controller = gtk_event_controller_focus_new()
            storage.content[Self.focus] = [.init(controller)]
            gtk_widget_add_controller(storage.pointer?.cast(), controller)
        }
        .inspect { storage in
            guard let controller = storage.content[Self.focus]?.first else {
                return
            }
            controller.notify(name: "contains-focus", id: "focused") {
                let newValue = gtk_event_controller_focus_contains_focus(controller.pointer) != 0
                if focused.wrappedValue != newValue {
                    focused.wrappedValue = newValue
                }
            }
            if gtk_event_controller_focus_contains_focus(controller.pointer) == 0, focused.wrappedValue {
                gtk_widget_grab_focus(storage.pointer?.cast())
            }
        }
    }

    /// Bind a signal that focuses the view.
    /// - Parameter focus: Whether the view is focused.
    /// - Returns: A view.
    public func focus(_ signal: Signal) -> AnyView {
        inspect { storage in
            if signal.update {
                gtk_widget_grab_focus(storage.pointer?.cast())
            }
        }
    }

    /// Add a tooltip to the widget.
    /// - Parameter tooltip: The tooltip text.
    /// - Returns: A view.
    public func tooltip(_ tooltip: String) -> AnyView {
        inspect { gtk_widget_set_tooltip_markup($0.pointer?.cast(), tooltip) }
    }

}
