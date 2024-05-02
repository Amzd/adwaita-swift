//
//  LinkButton.swift
//  Adwaita
//
//  Created by auto-generation on 02.05.24.
//

import CAdw
import LevenshteinTransformations

/// A `GtkLinkButton` is a button with a hyperlink.
/// 
/// ![An example GtkLinkButton](link-button.png)
/// 
/// It is useful to show quick links to resources.
/// 
/// A link button is created by calling either [ctor@Gtk.LinkButton.new] or
/// [ctor@Gtk.LinkButton.new_with_label]. If using the former, the URI you
/// pass to the constructor is used as a label for the widget.
/// 
/// The URI bound to a `GtkLinkButton` can be set specifically using
/// [method@Gtk.LinkButton.set_uri].
/// 
/// By default, `GtkLinkButton` calls [method@Gtk.FileLauncher.launch] when the button
/// is clicked. This behaviour can be overridden by connecting to the
/// [signal@Gtk.LinkButton::activate-link] signal and returning %TRUE from
/// the signal handler.
/// 
/// # CSS nodes
/// 
/// `GtkLinkButton` has a single CSS node with name button. To differentiate
/// it from a plain `GtkButton`, it gets the .link style class.
/// 
/// # Accessibility
/// 
/// `GtkLinkButton` uses the %GTK_ACCESSIBLE_ROLE_LINK role.
public struct LinkButton: Widget {

    /// Additional update functions for type extensions.
    var updateFunctions: [(ViewStorage, [(AnyView) -> AnyView], Bool) -> Void] = []
    /// Additional appear functions for type extensions.
    var appearFunctions: [(ViewStorage, [(AnyView) -> AnyView]) -> Void] = []

    /// The accessible role of the given `GtkAccessible` implementation.
    /// 
    /// The accessible role cannot be changed once set.
    var accessibleRole: String?
/// action-name
    var actionName: String?
    /// Whether the size of the button can be made smaller than the natural
    /// size of its contents.
    /// 
    /// For text buttons, setting this property will allow ellipsizing the label.
    /// 
    /// If the contents of a button are an icon or a custom widget, setting this
    /// property has no effect.
    var canShrink: Bool?
    /// The child widget.
    var child:  (() -> Body)?
    /// Whether the button has a frame.
    var hasFrame: Bool?
    /// The name of the icon used to automatically populate the button.
    var iconName: String?
    /// Text of the label inside the button, if the button contains a label widget.
    var label: String?
    /// The URI bound to this button.
    var uri: String
    /// If set, an underline in the text indicates that the following character is
    /// to be used as mnemonic.
    var useUnderline: Bool?
    /// The 'visited' state of this button.
    /// 
    /// A visited link is drawn in a different color.
    var visited: Bool?
    /// Emitted to animate press then release.
    /// 
    /// This is an action signal. Applications should never connect
    /// to this signal, but use the [signal@Gtk.Button::clicked] signal.
    /// 
    /// The default bindings for this signal are all forms of the
    /// <kbd>␣</kbd> and <kbd>Enter</kbd> keys.
    var activate: (() -> Void)?
    /// Emitted when the button has been activated (pressed and released).
    var clicked: (() -> Void)?
    /// The application.
    var app: GTUIApp?
    /// The window.
    var window: GTUIApplicationWindow?

    /// The debug tree parameters.
    public var debugTreeParameters: [(String, value: CustomStringConvertible)] {
        [("accessibleRole", value: "\(accessibleRole)"), ("actionName", value: "\(actionName)"), ("canShrink", value: "\(canShrink)"), ("hasFrame", value: "\(hasFrame)"), ("iconName", value: "\(iconName)"), ("label", value: "\(label)"), ("uri", value: "\(uri)"), ("useUnderline", value: "\(useUnderline)"), ("visited", value: "\(visited)"), ("activate", value: "\(activate)"), ("clicked", value: "\(clicked)"), ("app", value: "\(app)"), ("window", value: "\(window)")]
    }

    /// The debug tree's content.
    public var debugTreeContent: [(String, body: Body)] {
        var content: [(String, body: Body)] = [("child", body: self.child?() ?? []),]

        return content
    }

    /// Initialize `LinkButton`.
    public init(uri: String) {
        self.uri = uri
    }

    /// Get the widget's view storage.
    /// - Parameter modifiers: The view modifiers.
    /// - Returns: The view storage.
    public func container(modifiers: [(AnyView) -> AnyView]) -> ViewStorage {
        let storage = ViewStorage(gtk_link_button_new(uri)?.opaque())
        update(storage, modifiers: modifiers, updateProperties: true)
        if let childStorage = child?().widget(modifiers: modifiers).storage(modifiers: modifiers) {
            storage.content["child"] = [childStorage]
            gtk_button_set_child(storage.pointer?.cast(), childStorage.pointer?.cast())
        }

        for function in appearFunctions {
            function(storage, modifiers)
        }
        return storage
    }

    /// Update the widget's view storage.
    /// - Parameters:
    ///     - storage: The view storage.
    ///     - modifiers: The view modifiers.
    ///     - updateProperties: Whether to update the view's properties.
    public func update(_ storage: ViewStorage, modifiers: [(AnyView) -> AnyView], updateProperties: Bool) {
        if let activate {
            storage.connectSignal(name: "activate", argCount: 0) {
                activate()
            }
        }
        if let clicked {
            storage.connectSignal(name: "clicked", argCount: 0) {
                clicked()
            }
        }
        storage.modify { widget in

            if let actionName, updateProperties {
                gtk_actionable_set_action_name(widget, actionName)
            }
            if let canShrink, updateProperties {
                gtk_button_set_can_shrink(widget?.cast(), canShrink.cBool)
            }
            if let widget = storage.content["child"]?.first {
                child?().widget(modifiers: modifiers).update(widget, modifiers: modifiers, updateProperties: updateProperties)
            }
            if let hasFrame, updateProperties {
                gtk_button_set_has_frame(widget?.cast(), hasFrame.cBool)
            }
            if let iconName, updateProperties {
                gtk_button_set_icon_name(widget?.cast(), iconName)
            }
            if let label, storage.content["child"] == nil, updateProperties {
                gtk_button_set_label(widget?.cast(), label)
            }
            if updateProperties {
                gtk_link_button_set_uri(widget, uri)
            }
            if let useUnderline, updateProperties {
                gtk_button_set_use_underline(widget?.cast(), useUnderline.cBool)
            }
            if let visited, updateProperties {
                gtk_link_button_set_visited(widget, visited.cBool)
            }


        }
        for function in updateFunctions {
            function(storage, modifiers, updateProperties)
        }
    }

    /// The accessible role of the given `GtkAccessible` implementation.
    /// 
    /// The accessible role cannot be changed once set.
    public func accessibleRole(_ accessibleRole: String?) -> Self {
        var newSelf = self
        newSelf.accessibleRole = accessibleRole
        
        return newSelf
    }

/// action-name
    public func actionName(_ actionName: String?) -> Self {
        var newSelf = self
        newSelf.actionName = actionName
        
        return newSelf
    }

    /// Whether the size of the button can be made smaller than the natural
    /// size of its contents.
    /// 
    /// For text buttons, setting this property will allow ellipsizing the label.
    /// 
    /// If the contents of a button are an icon or a custom widget, setting this
    /// property has no effect.
    public func canShrink(_ canShrink: Bool? = true) -> Self {
        var newSelf = self
        newSelf.canShrink = canShrink
        
        return newSelf
    }

    /// The child widget.
    public func child(@ViewBuilder _ child: @escaping (() -> Body)) -> Self {
        var newSelf = self
        newSelf.child = child
        
        return newSelf
    }

    /// Whether the button has a frame.
    public func hasFrame(_ hasFrame: Bool? = true) -> Self {
        var newSelf = self
        newSelf.hasFrame = hasFrame
        
        return newSelf
    }

    /// The name of the icon used to automatically populate the button.
    public func iconName(_ iconName: String?) -> Self {
        var newSelf = self
        newSelf.iconName = iconName
        
        return newSelf
    }

    /// Text of the label inside the button, if the button contains a label widget.
    public func label(_ label: String?) -> Self {
        var newSelf = self
        newSelf.label = label
        
        return newSelf
    }

    /// The URI bound to this button.
    public func uri(_ uri: String) -> Self {
        var newSelf = self
        newSelf.uri = uri
        
        return newSelf
    }

    /// If set, an underline in the text indicates that the following character is
    /// to be used as mnemonic.
    public func useUnderline(_ useUnderline: Bool? = true) -> Self {
        var newSelf = self
        newSelf.useUnderline = useUnderline
        
        return newSelf
    }

    /// The 'visited' state of this button.
    /// 
    /// A visited link is drawn in a different color.
    public func visited(_ visited: Bool? = true) -> Self {
        var newSelf = self
        newSelf.visited = visited
        
        return newSelf
    }

    /// Emitted to animate press then release.
    /// 
    /// This is an action signal. Applications should never connect
    /// to this signal, but use the [signal@Gtk.Button::clicked] signal.
    /// 
    /// The default bindings for this signal are all forms of the
    /// <kbd>␣</kbd> and <kbd>Enter</kbd> keys.
    public func activate(_ activate: @escaping () -> Void) -> Self {
        var newSelf = self
        newSelf.activate = activate
        return newSelf
    }

    /// Emitted when the button has been activated (pressed and released).
    public func clicked(_ clicked: @escaping () -> Void) -> Self {
        var newSelf = self
        newSelf.clicked = clicked
        return newSelf
    }

}
